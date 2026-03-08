/**
 * StoryLine — Main Application Module
 *
 * Orchestrates the WebSocket connection, routes events between
 * the agent and UI components (StoryCanvas, Camera, AudioPlayer,
 * AudioRecorder), and manages application state.
 */

import { StoryCanvas } from './story-canvas.js';
import { CameraManager } from './camera.js';
import { AudioRecorder } from './audio-recorder.js';
import { AudioPlayerManager } from './audio-player.js';

// ===========================================================================
// State
// ===========================================================================
const state = {
    ws: null,
    sessionId: null,
    connected: false,
    micActive: false,
    cameraActive: false,
    scenes: [],
    currentMood: null,
};

// ===========================================================================
// DOM References
// ===========================================================================
const dom = {
    splash: document.getElementById('splash-screen'),
    app: document.getElementById('app'),
    btnStart: document.getElementById('btn-start'),
    btnMic: document.getElementById('btn-mic'),
    micIcon: document.getElementById('mic-icon'),
    micMutedIcon: document.getElementById('mic-muted-icon'),
    btnCamera: document.getElementById('btn-camera'),
    btnEnd: document.getElementById('btn-end'),
    btnSend: document.getElementById('btn-send'),
    textInput: document.getElementById('text-input'),
    connectionStatus: document.getElementById('connection-status'),
    moodIndicator: document.getElementById('mood-indicator'),
    narrationOverlay: document.getElementById('narration-overlay'),
    narrationText: document.getElementById('narration-text'),
    waveformCanvas: document.getElementById('waveform-canvas'),
    bgMusic: document.getElementById('bg-music'),
};

// ===========================================================================
// Module Instances
// ===========================================================================
const storyCanvas = new StoryCanvas(
    document.getElementById('story-canvas'),
    document.getElementById('canvas-image'),
    document.getElementById('canvas-video'),
    document.getElementById('canvas-placeholder'),
    document.getElementById('timeline-track'),
);

const cameraManager = new CameraManager(
    document.getElementById('camera-preview'),
    document.getElementById('camera-canvas'),
    document.getElementById('camera-pip'),
);

const audioRecorder = new AudioRecorder();
const audioPlayer = new AudioPlayerManager();

// ===========================================================================
// WebSocket Connection
// ===========================================================================
function generateSessionId() {
    return 'sl-' + Math.random().toString(36).substring(2, 10) + Date.now().toString(36);
}

function getWsUrl(sessionId) {
    const proto = location.protocol === 'https:' ? 'wss' : 'ws';
    return `${proto}://${location.host}/ws/${sessionId}`;
}

function setConnectionStatus(status) {
    dom.connectionStatus.className = `status-dot ${status}`;
    state.connected = status === 'connected';
}

function connectWebSocket() {
    state.sessionId = generateSessionId();
    setConnectionStatus('connecting');

    const ws = new WebSocket(getWsUrl(state.sessionId));

    ws.onopen = () => {
        console.log('[WS] Connected');
        setConnectionStatus('connected');
    };

    ws.onclose = (e) => {
        console.log('[WS] Disconnected', e.code, e.reason);
        setConnectionStatus('disconnected');
        state.connected = false;
    };

    ws.onerror = (e) => {
        console.error('[WS] Error', e);
        setConnectionStatus('disconnected');
    };

    ws.onmessage = (event) => {
        if (event.data instanceof Blob) {
            // Binary = agent audio response (PCM 24kHz)
            handleAudioResponse(event.data);
        } else {
            // JSON = ADK event
            try {
                const evt = JSON.parse(event.data);
                handleAgentEvent(evt);
            } catch (err) {
                console.warn('[WS] Failed to parse event:', err);
            }
        }
    };

    state.ws = ws;
}

// ===========================================================================
// Upstream: Send data to agent
// ===========================================================================
function sendAudioChunk(pcmData) {
    if (state.ws && state.ws.readyState === WebSocket.OPEN) {
        state.ws.send(pcmData);
    }
}

function sendCameraFrame(base64Jpeg) {
    if (state.ws && state.ws.readyState === WebSocket.OPEN) {
        state.ws.send(JSON.stringify({
            type: 'image',
            data: base64Jpeg,
        }));
    }
}

function sendTextMessage(text) {
    if (!text.trim()) return;
    if (state.ws && state.ws.readyState === WebSocket.OPEN) {
        state.ws.send(JSON.stringify({
            type: 'text',
            text: text.trim(),
        }));
    }
}

function sendEndSession() {
    if (state.ws && state.ws.readyState === WebSocket.OPEN) {
        state.ws.send(JSON.stringify({ type: 'end' }));
    }
}

// ===========================================================================
// Downstream: Handle agent events
// ===========================================================================
function handleAudioResponse(blob) {
    audioPlayer.playBlob(blob);
}

function handleAgentEvent(evt) {
    // ADK LiveEvent structure — events contain `content` with `parts`
    // We inspect parts for text, inline_data (audio), and tool results.

    if (evt.content && evt.content.parts) {
        for (const part of evt.content.parts) {
            // Text response / narration
            if (part.text) {
                showNarration(part.text);
            }

            // Inline audio data (PCM)
            if (part.inline_data && part.inline_data.mime_type?.startsWith('audio/')) {
                const audioBytes = base64ToArrayBuffer(part.inline_data.data);
                audioPlayer.playBuffer(audioBytes);
            }

            // Function call results (media URLs)
            if (part.function_response) {
                handleToolResult(part.function_response);
            }
        }
    }

    // Tool call results may also come as separate events
    if (evt.actions && evt.actions.artifact) {
        handleToolResult(evt.actions.artifact);
    }

    // Transcription event
    if (evt.server_content && evt.server_content.output_transcription) {
        showNarration(evt.server_content.output_transcription.text);
    }

    // Turn complete
    if (evt.server_content && evt.server_content.turn_complete) {
        // Agent finished speaking — could update UI state
    }

    // Interrupted (barge-in)
    if (evt.server_content && evt.server_content.interrupted) {
        audioPlayer.stop();
    }
}

function handleToolResult(result) {
    // Tool results contain media_type and URL fields
    const data = result.response || result;

    if (!data) return;

    const mediaType = data.media_type;

    if (mediaType === 'image' && data.image_url) {
        storyCanvas.showImage(data.image_url, data.description || '');
        addSceneToTimeline(data.image_url, data.description || `Scene ${state.scenes.length + 1}`);
    }

    if (mediaType === 'video' && data.video_url) {
        storyCanvas.showVideo(data.video_url);
    }

    if (mediaType === 'music' && data.music_url) {
        playBackgroundMusic(data.music_url);
    }

    if (mediaType === 'scene_saved' && data.scene) {
        updateMood(data.scene.mood);
    }
}

// ===========================================================================
// UI Helpers
// ===========================================================================
function showNarration(text) {
    if (!text || !text.trim()) return;
    dom.narrationText.textContent = text;
    dom.narrationOverlay.classList.remove('hidden');

    // Auto-hide after 8 seconds
    clearTimeout(showNarration._timer);
    showNarration._timer = setTimeout(() => {
        dom.narrationOverlay.classList.add('hidden');
    }, 8000);
}

function updateMood(mood) {
    if (!mood) return;
    state.currentMood = mood.toLowerCase();
    dom.moodIndicator.textContent = `Mood: ${mood}`;
    dom.moodIndicator.className = `mood-badge ${state.currentMood}`;
}

function addSceneToTimeline(imageUrl, label) {
    state.scenes.push({ imageUrl, label });
    storyCanvas.addTimelineThumb(imageUrl, label, state.scenes.length - 1);
}

function playBackgroundMusic(url) {
    dom.bgMusic.src = url;
    dom.bgMusic.volume = 0.25;
    dom.bgMusic.play().catch(err => console.warn('Music autoplay blocked:', err));
}

function base64ToArrayBuffer(base64) {
    const binary = atob(base64);
    const bytes = new Uint8Array(binary.length);
    for (let i = 0; i < binary.length; i++) {
        bytes[i] = binary.charCodeAt(i);
    }
    return bytes.buffer;
}

// ===========================================================================
// Waveform Visualizer
// ===========================================================================
function drawWaveform(analyser) {
    const canvas = dom.waveformCanvas;
    const ctx = canvas.getContext('2d');
    const bufferLength = analyser.fftSize;
    const dataArray = new Uint8Array(bufferLength);

    function draw() {
        if (!state.micActive) {
            ctx.clearRect(0, 0, canvas.width, canvas.height);
            return;
        }
        requestAnimationFrame(draw);
        analyser.getByteTimeDomainData(dataArray);

        ctx.fillStyle = '#12121a';
        ctx.fillRect(0, 0, canvas.width, canvas.height);

        ctx.lineWidth = 2;
        ctx.strokeStyle = '#E8A87C';
        ctx.beginPath();

        const sliceWidth = canvas.width / bufferLength;
        let x = 0;
        for (let i = 0; i < bufferLength; i++) {
            const v = dataArray[i] / 128.0;
            const y = (v * canvas.height) / 2;
            if (i === 0) ctx.moveTo(x, y);
            else ctx.lineTo(x, y);
            x += sliceWidth;
        }
        ctx.lineTo(canvas.width, canvas.height / 2);
        ctx.stroke();
    }

    draw();
}

// ===========================================================================
// Event Listeners
// ===========================================================================

// Start button
dom.btnStart.addEventListener('click', async () => {
    dom.splash.classList.add('fade-out');
    setTimeout(() => {
        dom.splash.classList.add('hidden');
        dom.app.classList.remove('hidden');
    }, 500);

    connectWebSocket();
});

// Microphone toggle
dom.btnMic.addEventListener('click', async () => {
    if (!state.micActive) {
        try {
            const analyser = await audioRecorder.start(sendAudioChunk);
            state.micActive = true;
            dom.btnMic.classList.add('active');
            dom.micIcon.classList.remove('hidden');
            dom.micMutedIcon.classList.add('hidden');
            drawWaveform(analyser);
        } catch (err) {
            console.error('Mic access denied:', err);
            alert('Microphone access is required for voice interaction.');
        }
    } else {
        audioRecorder.stop();
        state.micActive = false;
        dom.btnMic.classList.remove('active');
        dom.micIcon.classList.add('hidden');
        dom.micMutedIcon.classList.remove('hidden');
    }
});

// Camera toggle
dom.btnCamera.addEventListener('click', async () => {
    if (!state.cameraActive) {
        try {
            await cameraManager.start(sendCameraFrame);
            state.cameraActive = true;
        } catch (err) {
            console.error('Camera access denied:', err);
        }
    } else {
        cameraManager.stop();
        state.cameraActive = false;
    }
});

// PIP close button
document.getElementById('btn-toggle-camera')?.addEventListener('click', () => {
    cameraManager.stop();
    state.cameraActive = false;
});

// Text input
dom.textInput.addEventListener('keydown', (e) => {
    if (e.key === 'Enter') {
        sendTextMessage(dom.textInput.value);
        dom.textInput.value = '';
    }
});

dom.btnSend.addEventListener('click', () => {
    sendTextMessage(dom.textInput.value);
    dom.textInput.value = '';
});

// End session
dom.btnEnd.addEventListener('click', () => {
    if (confirm('End the current story session?')) {
        sendEndSession();
        audioRecorder.stop();
        cameraManager.stop();
        state.micActive = false;
        state.cameraActive = false;

        if (state.ws) {
            state.ws.close();
        }
        setConnectionStatus('disconnected');
    }
});
