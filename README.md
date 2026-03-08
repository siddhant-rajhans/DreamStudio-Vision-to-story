# DreamStudio

https://github.com/siddhant-rajhans/DreamStudio-Vision-to-story/raw/new-feature-branch/Dream%20studio.mp4

An AI-powered cinematic story director that collaborates with you through voice conversation to create visual narratives with generated images, video, and music in real-time.

## How It Works

You speak with StoryLine through your microphone (and optionally camera). The AI director guides you through crafting a story — generating storyboard images (Imagen 4), video clips (Veo 3.1), and background music (Lyria 2) as the narrative unfolds.

## Tech Stack

- **Backend**: FastAPI + Google ADK with bidirectional WebSocket streaming
- **AI Model**: Gemini 2.5 Flash (native audio) via Vertex AI
- **Media Generation**: Imagen 4, Veo 3.1, Lyria 2
- **Storage**: Google Cloud Storage
- **Frontend**: Vanilla JS with Web Audio API
- **Mobile**: Flutter (iOS)

## Setup

1. Copy `.env.example` to `backend/app/.env` and fill in your GCP project details.

2. Enable the required GCP APIs:
   - Vertex AI API
   - Cloud Storage API
   - Generative Language API

3. Authenticate:
   ```bash
   gcloud auth application-default login
   ```

4. Install and run:
   ```bash
   cd backend
   pip install -r requirements.txt
   cd app
   python main.py
   ```

5. Open `http://localhost:8000` in your browser.

## Docker

```bash
cd backend
docker build -t storyline .
docker run -p 8080:8080 storyline
```
