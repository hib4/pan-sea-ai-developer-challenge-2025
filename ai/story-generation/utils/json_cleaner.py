# utils/json_cleaner.py
import json
import re
from fastapi import HTTPException

def clean_json_response(content: str) -> dict:
    """
    Clean and parse JSON from LLM response.
    - Strips markdown fences (``` or ```json)
    - Extracts the largest JSON-like block if present
    - Raises a clean HTTPException if parsing fails
    """
    text = content.strip()

    # Remove triple backtick fences if present
    fence_match = re.search(r"```json\s*(.*?)\s*```", text, flags=re.DOTALL | re.IGNORECASE)
    if fence_match:
        text = fence_match.group(1).strip()
    else:
        fence_match_generic = re.search(r"```\s*(.*?)\s*```", text, flags=re.DOTALL)
        if fence_match_generic:
            text = fence_match_generic.group(1).strip()

    # Heuristic: find the first "{" and last "}" to slice JSON region if needed
    if not (text.strip().startswith("{") and text.strip().endswith("}")):
        start = text.find("{")
        end = text.rfind("}")
        if start != -1 and end != -1 and end > start:
            text = text[start : end + 1]

    try:
        return json.loads(text)
    except json.JSONDecodeError as e:
        raise HTTPException(status_code=500, detail=f"Invalid JSON response from AI: {str(e)}")
