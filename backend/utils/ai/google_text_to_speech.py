import os
import base64
import json
from uuid import uuid4
from fastapi.concurrency import run_in_threadpool
from fastapi import HTTPException
from google.cloud import texttospeech_v1beta1 as texttospeech
from google.oauth2 import service_account
from setting.settings import settings
from utils.storage.google_bucket_storage import upload_file_to_gcs

folder_name = "voices"
TEXT_CONTENT_THRESHOLD = 2000
API_ENDPOINT_REGION = "asia-southeast1-texttospeech.googleapis.com"
FILE_DIR = os.path.dirname(os.path.abspath(__file__))
BASE_DIR = os.path.dirname(os.path.dirname(FILE_DIR))
KEYS_PATH = os.path.join(BASE_DIR, "keys")
VOICE_AVAILABILITY_PATH = os.path.join(BASE_DIR, "setting")
VOICE_AVAILABILITY_JSON_FILENAME = "voice_availability.json"
CREDENTIALS_FILE_PATH = os.path.join(
    KEYS_PATH, settings.VERTEX_AI_SERVICE_ACCOUNT_JSON_NAME
)

def load_available_voices():
    available_voices = {}
    try:
        with open(os.path.join(VOICE_AVAILABILITY_PATH, VOICE_AVAILABILITY_JSON_FILENAME), 'r') as f:
            voice_data = json.load(f)
            for language_code, voices in voice_data.items():
                for voice in voices:
                    available_voices[voice['voice_code']] = {
                        "name": voice['name'],
                        "language_code": language_code,
                    }
    except FileNotFoundError:
        print(f"WARNING: Voice availability JSON file not found at {VOICE_AVAILABILITY_PATH}. Using an empty voice list.")
    return available_voices

def load_credentials():
    try:
        credentials = service_account.Credentials.from_service_account_file(CREDENTIALS_FILE_PATH)
    except FileNotFoundError:
        raise RuntimeError(f"Service account key file not found at: {CREDENTIALS_FILE_PATH}")
    return credentials

CHRIP_CREDENTIAL = load_credentials()
AVAILABLE_VOICES = load_available_voices()

def _synthesize_speech(request) -> dict:
    scene_id = request.get("scene_id")
    text_content = request.get("prompt")
    voice_code = request.get("voice_code")
    language_code = request.get("language_code")

    if len(text_content) > TEXT_CONTENT_THRESHOLD:
        raise HTTPException(
            status_code=400,
            detail=f"Text too long. Please limit to {TEXT_CONTENT_THRESHOLD} characters per request."
        )

    voice_info = AVAILABLE_VOICES.get(voice_code)
    if not voice_info or voice_info["language_code"] != language_code:
        raise HTTPException(
            status_code=400,
            detail=f"Invalid voice code '{voice_code}' for language code '{language_code}'."
        )

    client_options = {"api_endpoint": API_ENDPOINT_REGION}
    client = texttospeech.TextToSpeechClient(credentials=CHRIP_CREDENTIAL, client_options=client_options)
    synthesis_input = texttospeech.SynthesisInput(text=text_content)
    
    voice_params = texttospeech.VoiceSelectionParams(
        language_code=language_code,
        name=voice_code,
    )

    audio_config = texttospeech.AudioConfig(
        audio_encoding=texttospeech.AudioEncoding.MP3
    )

    try:
        response = client.synthesize_speech(
            input=synthesis_input,
            voice=voice_params,
            audio_config=audio_config
        )
    except Exception as e:
        raise HTTPException(
            status_code=500,
            detail=f"Google Cloud TTS API error: {e}"
        )

    audio_data = response.audio_content
    base64_audio = base64.b64encode(audio_data).decode("utf-8")
    filename = f"{uuid4()}.mp3"

    blob_url = upload_file_to_gcs(
        base64_string=base64_audio,
        folder_name=folder_name,
        blob_filename=filename
    )

    return {
        "scene_id": scene_id,
        "type": "voice",
        "voice": blob_url
    }

async def synthesize_speech(request):
    return await run_in_threadpool(_synthesize_speech, request)
