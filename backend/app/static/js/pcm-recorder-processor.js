/**
 * PCM Recorder AudioWorklet Processor
 *
 * Captures audio input as raw 16-bit PCM and sends chunks (~100ms)
 * to the main thread via port.postMessage. The chunks are sent as
 * ArrayBuffer (Int16Array buffer) for efficient WebSocket transmission.
 *
 * Input:  Float32 samples from the microphone ([-1, 1])
 * Output: Int16 PCM chunks (~1600 samples at 16kHz = 100ms)
 */

class PCMRecorderProcessor extends AudioWorkletProcessor {
    constructor() {
        super();
        this.buffer = [];
        this.CHUNK_SIZE = 1600; // 100ms at 16kHz
    }

    /**
     * Process incoming audio frames.
     * AudioWorklet calls this in 128-sample blocks.
     */
    process(inputs, outputs, parameters) {
        const input = inputs[0];
        if (!input || !input[0]) return true;

        const channelData = input[0]; // mono channel

        // Convert Float32 -> Int16 and accumulate
        for (let i = 0; i < channelData.length; i++) {
            // Clamp to [-1, 1] then scale to Int16 range
            const sample = Math.max(-1, Math.min(1, channelData[i]));
            const int16 = sample < 0
                ? sample * 0x8000
                : sample * 0x7FFF;
            this.buffer.push(int16);
        }

        // When we have enough samples, send a chunk
        while (this.buffer.length >= this.CHUNK_SIZE) {
            const chunk = this.buffer.splice(0, this.CHUNK_SIZE);
            const int16Array = new Int16Array(chunk);
            this.port.postMessage(int16Array.buffer);
        }

        return true; // keep processor alive
    }
}

registerProcessor('pcm-recorder-processor', PCMRecorderProcessor);
