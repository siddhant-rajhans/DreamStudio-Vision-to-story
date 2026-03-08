/**
 * AudioPlayerManager — Plays agent audio responses.
 *
 * Handles both raw PCM data (via AudioWorklet) and Blob audio.
 * Uses a playback AudioWorklet processor for PCM at 24kHz (Gemini output rate).
 */

export class AudioPlayerManager {
    constructor() {
        this.audioContext = null;
        this.workletNode = null;
        this.initialized = false;
        this.queue = []; // buffer chunks before worklet is ready
    }

    /**
     * Initialize the playback audio context and worklet.
     * Must be called after a user gesture (browser autoplay policy).
     */
    async init() {
        if (this.initialized) return;

        // Gemini Live API outputs audio at 24kHz
        this.audioContext = new AudioContext({ sampleRate: 24000 });

        await this.audioContext.audioWorklet.addModule('/static/js/pcm-player-processor.js');

        this.workletNode = new AudioWorkletNode(this.audioContext, 'pcm-player-processor');
        this.workletNode.connect(this.audioContext.destination);

        this.initialized = true;

        // Flush any queued chunks
        for (const chunk of this.queue) {
            this.workletNode.port.postMessage(chunk);
        }
        this.queue = [];
    }

    /**
     * Play raw PCM audio from an ArrayBuffer.
     * @param {ArrayBuffer} pcmBuffer - 16-bit PCM audio at 24kHz.
     */
    async playBuffer(pcmBuffer) {
        if (!this.initialized) {
            await this.init();
        }

        if (this.workletNode) {
            this.workletNode.port.postMessage(pcmBuffer);
        } else {
            this.queue.push(pcmBuffer);
        }
    }

    /**
     * Play audio from a Blob (binary WebSocket message).
     * @param {Blob} blob - Audio blob.
     */
    async playBlob(blob) {
        const buffer = await blob.arrayBuffer();
        await this.playBuffer(buffer);
    }

    /**
     * Stop all audio playback (e.g., on barge-in).
     */
    stop() {
        if (this.workletNode) {
            // Send a "flush" command to clear the playback buffer
            this.workletNode.port.postMessage({ command: 'flush' });
        }
    }

    /**
     * Close the audio context and release resources.
     */
    destroy() {
        if (this.workletNode) {
            this.workletNode.disconnect();
            this.workletNode = null;
        }
        if (this.audioContext) {
            this.audioContext.close().catch(() => {});
            this.audioContext = null;
        }
        this.initialized = false;
    }
}
