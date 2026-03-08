"""
StoryLine Tool Functions — ADK function tools for media generation.

Each function is automatically intercepted by ADK when the agent makes
a function call. The return dict is sent back to the agent as the tool result.
"""

import os
import time
import logging
from uuid import uuid4

from google import genai
from google.genai import types
from google.cloud import storage

logger = logging.getLogger(__name__)

# ---------------------------------------------------------------------------
# Google GenAI Client & Cloud Storage  (lazy init — .env loaded by main.py)
# ---------------------------------------------------------------------------
_client = None
_storage_client = None
_bucket = None


def _get_client() -> genai.Client:
    """Lazily initialize the GenAI client after env vars are loaded."""
    global _client
    if _client is None:
        use_vertex = os.getenv("GOOGLE_GENAI_USE_VERTEXAI", "").lower() == "true"
        if use_vertex:
            _client = genai.Client(
                vertexai=True,
                project=os.getenv("GOOGLE_CLOUD_PROJECT"),
                location=os.getenv("GOOGLE_CLOUD_LOCATION", "us-central1"),
            )
            logger.info("[GenAI] Initialized Vertex AI client")
        else:
            _client = genai.Client(
                api_key=os.getenv("GOOGLE_API_KEY"),
            )
            logger.info("[GenAI] Initialized API key client")
    return _client


def _get_bucket():
    """Lazily initialize the GCS bucket."""
    global _storage_client, _bucket
    if _storage_client is None:
        bucket_name = os.getenv("GENMEDIA_BUCKET", "storyline-media-bucket")
        try:
            _storage_client = storage.Client()
            _bucket = _storage_client.bucket(bucket_name)
            logger.info(f"[GCS] Connected to bucket: {bucket_name}")
        except Exception as e:
            logger.warning(f"Cloud Storage client init failed — media uploads will use fallback. {e}")
            _storage_client = False  # sentinel to avoid re-init
            _bucket = None
    return _bucket


def upload_to_gcs(data: bytes, content_type: str) -> str:
    """Upload binary data to GCS and return its public URL."""
    bucket = _get_bucket()
    bucket_name = os.getenv("GENMEDIA_BUCKET", "storyline-media-bucket")

    if bucket is None:
        logger.warning("GCS bucket not available, returning placeholder URL.")
        return f"https://storage.googleapis.com/{bucket_name}/storyline/{uuid4()}"

    ext_map = {"image/png": "png", "image/jpeg": "jpg", "video/mp4": "mp4", "audio/mpeg": "mp3"}
    ext = ext_map.get(content_type, "bin")
    blob_name = f"storyline/{uuid4()}.{ext}"
    blob = bucket.blob(blob_name)
    blob.upload_from_string(data, content_type)
    blob.make_public()
    return blob.public_url


# ---------------------------------------------------------------------------
# Tool: generate_storyboard (Imagen 4)
# ---------------------------------------------------------------------------
def generate_storyboard(
    scene_description: str,
    style: str = "cinematic, dramatic lighting, film still",
    aspect_ratio: str = "16:9",
) -> dict:
    """Generates a storyboard image for the current scene.

    Call this tool for EVERY new scene to produce a visual frame that the
    user sees on the Story Canvas.

    Args:
        scene_description: A vivid visual description of the scene to render.
        style: Art style keywords (e.g. cinematic, noir, watercolor, anime).
        aspect_ratio: Image aspect ratio — '16:9', '9:16', '1:1', '4:3', or '3:4'.

    Returns:
        dict with image_url and status.
    """
    prompt = f"{scene_description}. Style: {style}"
    logger.info(f"[Imagen 4] Generating storyboard: {prompt[:120]}...")

    try:
        client = _get_client()
        response = client.models.generate_images(
            model="imagen-4.0-generate-001",
            prompt=prompt,
            config=types.GenerateImagesConfig(
                number_of_images=1,
                aspect_ratio=aspect_ratio,
                safety_filter_level="BLOCK_ONLY_HIGH",
            ),
        )

        image = response.generated_images[0]
        gcs_url = upload_to_gcs(image.image.image_bytes, "image/png")

        return {
            "status": "success",
            "image_url": gcs_url,
            "media_type": "image",
            "description": scene_description,
        }

    except Exception as e:
        logger.error(f"[Imagen 4] Error: {e}")
        return {
            "status": "error",
            "error": str(e),
            "media_type": "image",
        }


# ---------------------------------------------------------------------------
# Tool: generate_video_clip (Veo 3.1)
# ---------------------------------------------------------------------------
def generate_video_clip(
    scene_description: str,
    aspect_ratio: str = "16:9",
) -> dict:
    """Generates a short cinematic video clip for a story scene.

    This is a long-running operation (~30-90 seconds). The agent should
    continue conversing while the video generates in the background.

    Args:
        scene_description: Description of the video scene to generate.
        aspect_ratio: Video aspect ratio — '16:9' or '9:16'.

    Returns:
        dict with video_url and status.
    """
    logger.info(f"[Veo 3.1] Generating video: {scene_description[:120]}...")
    bucket_name = os.getenv("GENMEDIA_BUCKET", "storyline-media-bucket")

    try:
        client = _get_client()
        operation = client.models.generate_videos(
            model="veo-3.1-generate-preview",
            prompt=scene_description,
            config=types.GenerateVideosConfig(
                aspect_ratio=aspect_ratio,
                output_gcs_uri=f"gs://{bucket_name}/videos/",
            ),
        )

        # Poll until complete
        while not operation.done:
            time.sleep(10)
            operation = client.operations.get(operation)

        video_uri = operation.result.generated_videos[0].video.uri
        return {
            "status": "success",
            "video_url": video_uri,
            "media_type": "video",
            "description": scene_description,
        }

    except Exception as e:
        logger.error(f"[Veo 3.1] Error: {e}")
        return {
            "status": "error",
            "error": str(e),
            "media_type": "video",
        }


# ---------------------------------------------------------------------------
# Tool: generate_music (Lyria 2)
# ---------------------------------------------------------------------------
def generate_music(
    mood_description: str,
    duration_seconds: int = 30,
) -> dict:
    """Generates ambient background music matching the story mood.

    Call this once at the beginning to set the atmosphere, and again
    whenever the mood shifts dramatically.

    Args:
        mood_description: Musical mood description (e.g. 'tense orchestral
            suspense, low strings, distant percussion').
        duration_seconds: Length of music clip in seconds (10-60).

    Returns:
        dict with music_url and status.
    """
    logger.info(f"[Lyria 2] Generating music: {mood_description[:120]}...")

    try:
        client = _get_client()
        operation = client.models.generate_music(
            model="lyria-2.0-generate-001",
            prompt=mood_description,
            config=types.GenerateMusicConfig(
                duration_seconds=duration_seconds,
            ),
        )

        # Poll until complete
        while not operation.done:
            time.sleep(5)
            operation = client.operations.get(operation)

        music_uri = operation.result.generated_musics[0].uri
        return {
            "status": "success",
            "music_url": music_uri,
            "media_type": "music",
            "description": mood_description,
        }

    except Exception as e:
        logger.error(f"[Lyria 2] Error: {e}")
        return {
            "status": "error",
            "error": str(e),
            "media_type": "music",
        }


# ---------------------------------------------------------------------------
# Tool: save_scene (State Management)
# ---------------------------------------------------------------------------
def save_scene(
    scene_number: int,
    title: str,
    summary: str,
    mood: str,
    characters: str = "",
    image_url: str = "",
    video_url: str = "",
    music_url: str = "",
) -> dict:
    """Saves metadata for the current scene to maintain narrative continuity.

    Call this after each scene completes so you can reference previous
    scenes and maintain a coherent story arc.

    Args:
        scene_number: Sequential scene number (1, 2, 3...).
        title: Short title for the scene (e.g. 'The Discovery').
        summary: 1-2 sentence summary of what happened.
        mood: Current emotional mood (tense, joyful, melancholy, etc.).
        characters: Comma-separated list of characters present.
        image_url: URL of the scene's storyboard image (if generated).
        video_url: URL of the scene's video clip (if generated).
        music_url: URL of the scene's background music (if generated).

    Returns:
        dict confirming the scene was saved.
    """
    scene_data = {
        "scene_number": scene_number,
        "title": title,
        "summary": summary,
        "mood": mood,
        "characters": characters,
        "image_url": image_url,
        "video_url": video_url,
        "music_url": music_url,
    }

    logger.info(f"[SaveScene] Scene {scene_number}: {title} (mood: {mood})")

    return {
        "status": "success",
        "media_type": "scene_saved",
        "scene": scene_data,
    }
