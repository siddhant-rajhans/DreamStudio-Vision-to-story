/**
 * StoryCanvas — Manages the main visual display area.
 *
 * Renders generated images and videos with cinematic transitions.
 * Also manages the timeline strip of scene thumbnails.
 */

export class StoryCanvas {
    /**
     * @param {HTMLElement} container  - .story-canvas element
     * @param {HTMLImageElement} imgEl - #canvas-image
     * @param {HTMLVideoElement} vidEl - #canvas-video
     * @param {HTMLElement} placeholder - #canvas-placeholder
     * @param {HTMLElement} timelineTrack - #timeline-track
     */
    constructor(container, imgEl, vidEl, placeholder, timelineTrack) {
        this.container = container;
        this.imgEl = imgEl;
        this.vidEl = vidEl;
        this.placeholder = placeholder;
        this.timelineTrack = timelineTrack;
        this.currentMedia = null; // 'image' | 'video' | null
    }

    /**
     * Display a storyboard image on the canvas with a fade-in animation.
     * @param {string} url - Image URL (GCS public URL).
     * @param {string} description - Alt text / description.
     */
    showImage(url, description = '') {
        // Hide placeholder
        this.placeholder.classList.add('hidden');

        // Hide video if showing
        this.vidEl.classList.add('hidden');
        this.vidEl.pause();

        // Load & show image
        this.imgEl.classList.remove('hidden', 'entering');
        this.imgEl.src = url;
        this.imgEl.alt = description;

        // Trigger fade-in animation
        void this.imgEl.offsetWidth; // force reflow
        this.imgEl.classList.add('entering');

        this.currentMedia = 'image';
    }

    /**
     * Display a video clip on the canvas.
     * @param {string} url - Video URL (GCS URI or signed URL).
     */
    showVideo(url) {
        // Hide placeholder
        this.placeholder.classList.add('hidden');

        // Hide image
        this.imgEl.classList.add('hidden');

        // Show video
        this.vidEl.classList.remove('hidden', 'entering');
        this.vidEl.src = url;
        this.vidEl.load();
        this.vidEl.play().catch(err => console.warn('Video autoplay blocked:', err));

        void this.vidEl.offsetWidth;
        this.vidEl.classList.add('entering');

        this.currentMedia = 'video';
    }

    /**
     * Add a scene thumbnail to the timeline strip.
     * @param {string} imageUrl - Thumbnail image URL.
     * @param {string} label - Scene label text.
     * @param {number} index - Scene index.
     */
    addTimelineThumb(imageUrl, label, index) {
        const thumb = document.createElement('div');
        thumb.className = 'scene-thumb';
        thumb.dataset.index = index;

        const img = document.createElement('img');
        img.src = imageUrl;
        img.alt = label;
        img.loading = 'lazy';

        const labelEl = document.createElement('div');
        labelEl.className = 'scene-label';
        labelEl.textContent = label;

        thumb.appendChild(img);
        thumb.appendChild(labelEl);

        // Click to revisit scene
        thumb.addEventListener('click', () => {
            this.showImage(imageUrl, label);
            // Highlight active
            this.timelineTrack.querySelectorAll('.scene-thumb').forEach(t => t.classList.remove('active'));
            thumb.classList.add('active');
        });

        this.timelineTrack.appendChild(thumb);

        // Scroll to the new thumb
        thumb.scrollIntoView({ behavior: 'smooth', inline: 'end' });

        // Mark as active
        this.timelineTrack.querySelectorAll('.scene-thumb').forEach(t => t.classList.remove('active'));
        thumb.classList.add('active');
    }

    /**
     * Reset canvas to initial placeholder state.
     */
    reset() {
        this.imgEl.classList.add('hidden');
        this.vidEl.classList.add('hidden');
        this.vidEl.pause();
        this.placeholder.classList.remove('hidden');
        this.timelineTrack.innerHTML = '';
        this.currentMedia = null;
    }
}
