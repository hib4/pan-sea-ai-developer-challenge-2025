import os
import base64
import vertexai
from uuid import uuid4
from fastapi.concurrency import run_in_threadpool
from vertexai.preview.vision_models import ImageGenerationModel
from utils.storage.google_bucket_storage import upload_file_to_gcs
from google.oauth2 import service_account
from setting.settings import settings

IMAGEN_MODEL = "imagen-4.0-fast-generate-001"
IMAGE_FOLDER_NAME = "images"
VERTEX_AI_REGION = "asia-southeast1"
IMAGE_ASPECT_RATIO = "16:9"

file_dir = os.path.dirname(os.path.abspath(__file__))
BASE_DIR = os.path.dirname(os.path.dirname(file_dir))
KEYS_PATH = os.path.join(BASE_DIR, "keys")

CREDENTIALS_FILE_PATH = os.path.join(
    KEYS_PATH, settings.VERTEX_AI_SERVICE_ACCOUNT_JSON_NAME
)
vertex_ai_credentials = service_account.Credentials.from_service_account_file(CREDENTIALS_FILE_PATH)

vertexai.init(
    project=vertex_ai_credentials.project_id,
    location=VERTEX_AI_REGION,
    credentials=vertex_ai_credentials
)

def _generate_image(image_prompt):
    scene_id = image_prompt.get("scene_id") or 1
    prompt = image_prompt.get("prompt")
    image_type = image_prompt.get("type")
    client = ImageGenerationModel.from_pretrained(IMAGEN_MODEL)
    response = client.generate_images(
        prompt=prompt,
        number_of_images=1,
        negative_prompt="unproportional, blur, distorted.",
        aspect_ratio=IMAGE_ASPECT_RATIO,
        person_generation="allow_all",
        safety_filter_level="block_most",
        add_watermark=True,
    )
    image_result = response.images[0]
    b64_string = base64.b64encode(image_result._image_bytes).decode('utf-8')
    url = None

    if b64_string:
        unique_id = str(uuid4())
        url = upload_file_to_gcs(
            base64_string=b64_string,
            folder_name=IMAGE_FOLDER_NAME,
            blob_filename=f"{unique_id}.webp"
        )
    if image_type == "cover_image":
        return {
            "scene_id": scene_id,
            "type": "cover_image",
            "cover_image": url
        }

    return { 
        "scene_id": scene_id,
        "type": "image",
        "image": url
    }

async def generate_image(image_prompt):
    return await run_in_threadpool(_generate_image, image_prompt)