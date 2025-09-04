# In utils/storage/google_bucket_storage.py

import os
from google.cloud import storage
from google.oauth2 import service_account
from setting.settings import settings
import base64

BUCKET_NAME = "pan-sea-kanca"

def upload_file_to_gcs(base64_string, folder_name, blob_filename):
    # Determine the correct project base directory from this file's location
    file_dir = os.path.dirname(os.path.abspath(__file__))
    
    # Go up two directories to reach the 'backend' folder
    BASE_DIR = os.path.dirname(os.path.dirname(file_dir))
    
    KEYS_PATH = os.path.join(BASE_DIR, "keys")
    CREDENTIALS_FILE_PATH = os.path.join(
        KEYS_PATH, settings.BUCKET_STORAGE_SERVICE_ACCOUNT_JSON_NAME
    )
    
    # Load GCS credentials from the service account JSON file
    try:
        gcs_credentials = service_account.Credentials.from_service_account_file(CREDENTIALS_FILE_PATH)
    except FileNotFoundError:
        # Re-raise with a more informative message to help future debugging
        raise FileNotFoundError(f"Service account key file not found at: {CREDENTIALS_FILE_PATH}")
    
    # Initialize the client with the explicit credentials
    storage_client = storage.Client(credentials=gcs_credentials)
    bucket = storage_client.bucket(BUCKET_NAME)
    
    blob_path = f"{folder_name}/{blob_filename}"
    blob = bucket.blob(blob_path)
    
    file_bytes = base64.b64decode(base64_string)
    blob.upload_from_string(file_bytes)
    
    return f"https://storage.googleapis.com/{BUCKET_NAME}/{blob_path}"