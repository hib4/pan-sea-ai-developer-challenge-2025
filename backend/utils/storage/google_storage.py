import os
from google.cloud import storage
from google.oauth2 import service_account
from setting.settings import settings
import base64

BUCKET_NAME = "pan-sea-kanca"
FILE_DIR = os.path.dirname(os.path.abspath(__file__))
BASE_DIR = os.path.dirname(os.path.dirname(FILE_DIR))
    
KEYS_PATH = os.path.join(BASE_DIR, "keys")
CREDENTIALS_FILE_PATH = os.path.join(
    KEYS_PATH, settings.BUCKET_STORAGE_SERVICE_ACCOUNT_JSON_NAME
)

def upload_file_to_google_cloud_storage(base64_string: str, folder_name: str, blob_filename: str) -> str:
    try:
        gcs_credentials = service_account.Credentials.from_service_account_file(CREDENTIALS_FILE_PATH)
    except FileNotFoundError:
        raise FileNotFoundError(f"Service account key file not found at: {CREDENTIALS_FILE_PATH}")

    storage_client = storage.Client(credentials=gcs_credentials)
    bucket = storage_client.bucket(BUCKET_NAME)
    blob_path = f"{folder_name}/{blob_filename}"
    blob = bucket.blob(blob_path)
    file_bytes = base64.b64decode(base64_string)
    blob.upload_from_string(file_bytes)
    
    return f"https://storage.googleapis.com/{BUCKET_NAME}/{blob_path}"