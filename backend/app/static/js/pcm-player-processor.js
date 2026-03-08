/**
 * PCM Player AudioWorklet Processor
 *
 * Receives raw 16-bit PCM audio chunks from the main thread and
 * plays them back through the audio output. Handles buffering and
 * smooth playback of streaming agent audio responses.
 *
 * Input:  Int16 PCM ArrayBuffers via port.postMessage (24kHz)
 * Output: Float32 audio samples to speakers
 */

class PCMPlayerProcessor extends AudioWorkletProcessor {
    constructor() {
        super();
        this.buffer = new Float32Array(0);

        this.port.onmessage = (event) => {
            if (event.data && event.data.command === 'flush') {
                // Clear playback buffer (barge-in / interruption)
                this.buffer = new Float32Array(0);
                return;
            }

            if (event.data instanceof ArrayBuffer) {
                // Convert Int16 PCM to Float32
                const int16 = new Int16Array(event.data);
                const float32 = new Float32Array(int16.length);

                for (let i = 0; i < int16.length; i++) {
                    float32[i] = int16[i] / (int16[i] < 0 ? 0x8000 : 0x7FFF);
                }

                // Append to playback buffer
                const newBuffer = new Float32Array(this.buffer.length + float32.length);
                newBuffer.set(this.buffer);
                newBuffer.set(float32, this.buffer.length);
                this.buffer = newBuffer;
            }
        };
    }

    /**
     * Fill the output with buffered audio samples.
     * AudioWorklet calls this in 128-sample blocks.
     */
    process(inputs, outputs, parameters) {
        const output = outputs[0];
        if (!output || !output[0]) return true;

        const channel = output[0];

        if (this.buffer.length >= channel.length) {
            // Copy from buffer to output
            channel.set(this.buffer.subarray(0, channel.length));
            // Remove consumed samples
            this.buffer = this.buffer.subarray(channel.length);
        } else if (this.buffer.length > 0) {
            // Partial buffer — copy what we have, zero-fill the rest
            channel.set(this.buffer);
            channel.fill(0, this.buffer.length);
            this.buffer = new Float32Array(0);
        } else {
            // No data — output silence
            channel.fill(0);
        }

        return true; // keep processor alive
    }
}

registerProcessor('pcm-player-processor', PCMPlayerProcessor);
