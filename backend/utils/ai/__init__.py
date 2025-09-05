from setting.settings import settings
from . import azure_text_to_speech
from . import nebius_flux_1_schnell
from . import google_text_to_speech
from . import google_imagen

CLOUD_PLATFORM_OPTION = settings.CLOUD_PLATFORM_OPTION

async def generate_image(image_prompt: str) -> str:
    if CLOUD_PLATFORM_OPTION == "google":
        return await google_imagen.generate_image(image_prompt)
    
    return await nebius_flux_1_schnell.generate_image(image_prompt)

async def synthesize_speech(request: any) -> dict:
    if CLOUD_PLATFORM_OPTION == "google":
        return await google_text_to_speech.synthesize_speech(request)
    
    return await azure_text_to_speech.synthesize_speech(request)

def get_available_voices():
    if CLOUD_PLATFORM_OPTION == "google":
        return google_text_to_speech.AVAILABLE_VOICES
    
    return azure_text_to_speech.AVAILABLE_VOICES

AVAILABLE_VOICES = get_available_voices()