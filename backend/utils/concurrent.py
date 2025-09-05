from utils.ai import generate_image
from utils.ai import synthesize_speech
import asyncio

'''
this function used to execute multiple async process simultaneously
to shorten the duration can trim the request lenght ex: commented code below
'''
async def generate_multiple_image_and_voice_concurrently(requests):
    tasks = []

    # uncomment the code line below to save cloud credit for image and voice generation
    # requests = requests[:4]

    for request in requests:
        request_type = request.get("type")

        if request_type == "image" or request_type == "cover_image":
            tasks.append(generate_image(request))

        if request_type == "voice":
            tasks.append(synthesize_speech(request))

    return await asyncio.gather(*tasks)
