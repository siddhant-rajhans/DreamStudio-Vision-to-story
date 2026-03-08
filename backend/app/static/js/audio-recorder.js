/**
 * AudioRecorder — Captures microphone audio as raw 16-bit PCM at 16kHz mono.
 *
 * Uses AudioWorklet (pcm-recorder-processor.js) for low-latency,
 * main-thread-free audio capture. Each ~100ms chunk is sent as an
 * ArrayBuffer to the provided callback.
 */

export class AudioRecorder {
    constructor() {
        this.audioContext = null;
        this.stream = null;
        this.sourceNode = null;
        this.workletNode = null;
        this.analyser = null;
        this.onChunk = null;
    }

    /**
     * Start recording from the microphone.
     * @param {Function} onChunk - Callback receiving ArrayBuffer of PCM data.
     * @returns {AnalyserNode} - For waveform visualization.
     */
    async start(onChunk) {
        this.onChunk = onChunk;

        // Request microphone access
        this.stream = await navigator.mediaDevices.getUserMedia({
            audio: {
                channelCount: 1,
                sampleRate: 16000,
                echoCancellation: true,
                noiseSuppression: true,
                autoGainControl: true,
            },
        });

        // Create audio context at 16kHz (matches Gemini Live API requirement)
        this.audioContext = new AudioContext({ sampleRate: 16000 });

        // Load the AudioWorklet processor
        await this.audioContext.audioWorklet.addModule('/static/js/pcm-recorder-processor.js');

        // Source -> Analyser -> WorkletNode
        this.sourceNode = this.audioContext.createMediaStreamSource(this.stream);

        this.analyser = this.audioContext.createAnalyser();
        this.analyser.fftSize = 256;

        this.workletNode = new AudioWorkletNode(this.audioContext, 'pcm-recorder-processor');

        // Receive PCM chunks from the worklet
        this.workletNode.port.onmessage = (event) => {
            if (this.onChunk && event.data) {
                this.onChunk(event.data);
            }
        };

        // Connect: mic -> analyser -> worklet
        this.sourceNode.connect(this.analyser);
        this.analyser.connect(this.workletNode);
        this.workletNode.connect(this.audioContext.destination); // required for worklet to process

        return this.analyser;
    }

    /**
     * Stop recording and release resources.
     */
    stop() {
        if (this.workletNode) {
            this.workletNode.disconnect();
            this.workletNode = null;
        }
        if (this.analyser) {
            this.analyser.disconnect();
            this.analyser = null;
        }
        if (this.sourceNode) {
            this.sourceNode.disconnect();
            this.sourceNode = null;
        }
        if (this.stream) {
            this.stream.getTracks().forEach(track => track.stop());
            this.stream = null;
        }
        if (this.audioContext) {
            this.audioContext.close().catch(() => {});
            this.audioContext = null;
        }
        this.onChunk = null;
    }
}
