from setting.settings import settings
from . import azure_storage
from . import google_storage

CLOUD_PLATFORM_OPTION = settings.CLOUD_PLATFORM_OPTION

def upload_file(base64_string: str, folder_name: str, blob_filename: str) -> str:
    if CLOUD_PLATFORM_OPTION == "google":
        return google_storage.upload_file_to_google_cloud_storage(base64_string,folder_name,blob_filename)

    # default to use azure
    return azure_storage.upload_file_azure_blob_storage(base64_string,folder_name,blob_filename)
    