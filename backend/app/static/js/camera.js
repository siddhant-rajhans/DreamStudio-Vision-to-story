/**
 * CameraManager — Handles getUserMedia camera capture and JPEG frame sending.
 *
 * Captures frames at ~2-4 fps, downscales to ~512px width,
 * encodes as JPEG, and sends base64-encoded frames to the server.
 */

export class CameraManager {
    /**
     * @param {HTMLVideoElement} videoEl - #camera-preview
     * @param {HTMLCanvasElement} canvasEl - #camera-canvas (hidden, for JPEG encoding)
     * @param {HTMLElement} pipContainer - #camera-pip
     */
    constructor(videoEl, canvasEl, pipContainer) {
        this.videoEl = videoEl;
        this.canvasEl = canvasEl;
        this.pipContainer = pipContainer;
        this.ctx = canvasEl.getContext('2d');
        this.stream = null;
        this.intervalId = null;
        this.sendFrame = null;

        // Target capture settings
        this.TARGET_WIDTH = 512;
        this.FPS = 3; // frames per second
    }

    /**
     * Start camera capture and frame sending.
     * @param {Function} onFrame - Callback receiving base64 JPEG string (no data: prefix).
     */
    async start(onFrame) {
        this.sendFrame = onFrame;

        try {
            this.stream = await navigator.mediaDevices.getUserMedia({
                video: {
                    width: { ideal: 640 },
                    height: { ideal: 480 },
                    facingMode: 'environment', // prefer rear camera on mobile
                },
                audio: false,
            });

            this.videoEl.srcObject = this.stream;
            this.pipContainer.classList.remove('hidden');

            // Wait for video to be ready
            await new Promise((resolve) => {
                this.videoEl.onloadedmetadata = resolve;
            });

            // Configure canvas for downscaled capture
            const aspect = this.videoEl.videoHeight / this.videoEl.videoWidth;
            this.canvasEl.width = this.TARGET_WIDTH;
            this.canvasEl.height = Math.round(this.TARGET_WIDTH * aspect);

            // Start periodic frame capture
            this.intervalId = setInterval(() => {
                this._captureAndSend();
            }, 1000 / this.FPS);

        } catch (err) {
            console.error('[Camera] Access denied or unavailable:', err);
            throw err;
        }
    }

    /**
     * Stop camera capture and release resources.
     */
    stop() {
        if (this.intervalId) {
            clearInterval(this.intervalId);
            this.intervalId = null;
        }

        if (this.stream) {
            this.stream.getTracks().forEach(track => track.stop());
            this.stream = null;
        }

        this.videoEl.srcObject = null;
        this.pipContainer.classList.add('hidden');
        this.sendFrame = null;
    }

    /**
     * Capture a single frame, encode as JPEG, and send via callback.
     * @private
     */
    _captureAndSend() {
        if (!this.stream || !this.sendFrame) return;

        try {
            // Draw video frame to canvas (downscaled)
            this.ctx.drawImage(
                this.videoEl,
                0, 0,
                this.canvasEl.width,
                this.canvasEl.height
            );

            // Encode as JPEG (quality 0.7)
            const dataUrl = this.canvasEl.toDataURL('image/jpeg', 0.7);

            // Extract base64 portion (remove "data:image/jpeg;base64,")
            const base64 = dataUrl.split(',')[1];

            if (base64) {
                this.sendFrame(base64);
            }
        } catch (err) {
            console.warn('[Camera] Frame capture error:', err);
        }
    }
}
