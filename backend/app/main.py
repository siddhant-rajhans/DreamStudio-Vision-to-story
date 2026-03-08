"""
StoryLine — FastAPI Backend with WebSocket Handler.

Single WebSocket connection per client handles:
  - Upstream: audio PCM (binary), camera JPEG frames (JSON), text (JSON)
  - Downstream: agent audio (binary), text, tool results, control signals

Uses ADK Runner with LiveRequestQueue for bidirectional streaming
to the Gemini Live API.
"""

import os
import json
import base64
import asyncio
import logging
from uuid import uuid4
from pathlib import Path

# Load .env BEFORE any Google imports (they read env vars at import time)
from dotenv import load_dotenv

# Resolve GOOGLE_APPLICATION_CREDENTIALS to absolute path
_app_dir = Path(__file__).parent
load_dotenv(_app_dir / ".env")
_cred_path = os.getenv("GOOGLE_APPLICATION_CREDENTIALS", "")
if _cred_path and not os.path.isabs(_cred_path):
    os.environ["GOOGLE_APPLICATION_CREDENTIALS"] = str(_app_dir / _cred_path)

from fastapi import FastAPI, WebSocket, WebSocketDisconnect
from fastapi.staticfiles import StaticFiles
from fastapi.responses import FileResponse

from google.adk.runners import Runner
from google.adk.sessions import InMemorySessionService
from google.adk.agents import LiveRequestQueue
from google.adk.agents.run_config import RunConfig, StreamingMode
from google.genai import types as genai_types

from story_director import root_agent

# ---------------------------------------------------------------------------
# Configuration
# ---------------------------------------------------------------------------

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

APP_NAME = "storyline"

# ---------------------------------------------------------------------------
# ADK Session & Runner
# ---------------------------------------------------------------------------
session_service = InMemorySessionService()

runner = Runner(
    agent=root_agent,
    app_name=APP_NAME,
    session_service=session_service,
)

# ---------------------------------------------------------------------------
# FastAPI App
# ---------------------------------------------------------------------------
app = FastAPI(title="StoryLine", version="1.0.0")

# Serve static frontend files
STATIC_DIR = os.path.join(os.path.dirname(__file__), "static")
app.mount("/static", StaticFiles(directory=STATIC_DIR), name="static")


@app.get("/")
async def serve_index():
    """Serve the main frontend HTML."""
    return FileResponse(os.path.join(STATIC_DIR, "index.html"))


@app.get("/health")
async def health_check():
    """Health check endpoint for Cloud Run."""
    return {"status": "ok", "app": APP_NAME}


# ---------------------------------------------------------------------------
# WebSocket Handler
# ---------------------------------------------------------------------------
async def start_session(user_id: str):
    """Create an ADK session and start the live agent loop.

    Returns:
        (live_events, live_request_queue) — the async generator of agent
        events and the queue to push user inputs into.
    """
    session = await session_service.create_session(
        app_name=APP_NAME,
        user_id=user_id,
    )

    live_request_queue = LiveRequestQueue()

    run_config = RunConfig(
        streaming_mode=StreamingMode.BIDI,
        response_modalities=["AUDIO"],
        speech_config=genai_types.SpeechConfig(
            voice_config=genai_types.VoiceConfig(
                prebuilt_voice_config=genai_types.PrebuiltVoiceConfig(
                    voice_name="Kore"  # warm, narrative voice
                )
            )
        ),
    )

    live_events = runner.run_live(
        session=session,
        live_request_queue=live_request_queue,
        run_config=run_config,
    )

    return live_events, live_request_queue


@app.websocket("/ws/{session_id}")
async def websocket_endpoint(websocket: WebSocket, session_id: str):
    """Single WebSocket connection per client.

    Upstream (client -> agent):
      - Binary frames: raw 16-bit PCM audio at 16kHz mono
      - JSON text frames: { type: 'image', data: '<base64>' }
      - JSON text frames: { type: 'text', text: '<message>' }

    Downstream (agent -> client):
      - Serialized ADK LiveEvents as JSON text frames
      - The frontend parses event types and routes to the appropriate handler
    """
    await websocket.accept()
    logger.info(f"[WS] Client connected: session={session_id}")

    user_id = session_id or str(uuid4())

    try:
        live_events, live_queue = await start_session(user_id)
    except Exception as e:
        logger.error(f"[WS] Failed to start session: {e}")
        await websocket.send_text(json.dumps({
            "type": "error",
            "message": f"Failed to start session: {str(e)}",
        }))
        await websocket.close()
        return

    async def upstream_task():
        """Client -> Agent: audio bytes, image JSON, text."""
        try:
            while True:
                msg = await websocket.receive()

                if "bytes" in msg:
                    # Binary = raw PCM audio (16-bit, 16kHz, mono)
                    live_queue.send_realtime(
                        genai_types.Blob(
                            mime_type="audio/pcm",
                            data=msg["bytes"],
                        )
                    )

                elif "text" in msg:
                    data = json.loads(msg["text"])
                    msg_type = data.get("type", "")

                    if msg_type == "image":
                        # Camera JPEG frame (base64-encoded)
                        img_bytes = base64.b64decode(data["data"])
                        live_queue.send_realtime(
                            genai_types.Blob(
                                mime_type="image/jpeg",
                                data=img_bytes,
                            )
                        )

                    elif msg_type == "text":
                        # Text input fallback
                        from google.genai.types import Content, Part
                        content = Content(
                            role="user",
                            parts=[Part(text=data["text"])],
                        )
                        live_queue.send_content(content)

                    elif msg_type == "end":
                        # Client signals session end
                        logger.info(f"[WS] Client ended session: {session_id}")
                        live_queue.close()
                        break

        except WebSocketDisconnect:
            logger.info(f"[WS] Client disconnected (upstream): {session_id}")
            live_queue.close()
        except Exception as e:
            logger.error(f"[WS] Upstream error: {e}")
            live_queue.close()

    async def downstream_task():
        """Agent -> Client: audio, text, tool results, control events."""
        try:
            async for event in live_events:
                try:
                    # Serialize the ADK event to JSON
                    evt_json = event.model_dump_json(
                        exclude_none=True,
                        by_alias=True,
                    )
                    await websocket.send_text(evt_json)
                except Exception as e:
                    logger.error(f"[WS] Failed to send event: {e}")
                    break

        except WebSocketDisconnect:
            logger.info(f"[WS] Client disconnected (downstream): {session_id}")
        except Exception as e:
            logger.error(f"[WS] Downstream error: {e}")

    # Run both directions concurrently
    try:
        await asyncio.gather(upstream_task(), downstream_task())
    except Exception as e:
        logger.error(f"[WS] Session error: {e}")
    finally:
        logger.info(f"[WS] Session closed: {session_id}")


# ---------------------------------------------------------------------------
# Main entry point
# ---------------------------------------------------------------------------
if __name__ == "__main__":
    import uvicorn
    uvicorn.run(
        "main:app",
        host="0.0.0.0",
        port=int(os.getenv("PORT", "8000")),
        reload=True,
        log_level="info",
    )
