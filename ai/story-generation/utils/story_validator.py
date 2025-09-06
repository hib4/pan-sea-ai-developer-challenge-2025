# utils/story_validator.py
from typing import Dict, Any, List
from fastapi import HTTPException


class StoryValidator:
    @staticmethod
    def validate(story_data: Dict[str, Any], user_id: str, age: int) -> Dict[str, Any]:
        """
        Comprehensive validation and standardization of story content
        (Refactored from your app.py to a reusable class method)
        """
        # 1. Ensure all top-level required fields exist
        required_top_level_fields = {
            "user_id": user_id,
            "title": "Untitled Story",
            "theme": [],
            "language": "indonesian",
            "status": "in_progress",
            "age_group": age,
            "current_scene": 1,
            "created_at": None,
            "finished_at": None,
            "maximum_point": 10,
            "characters": [],
            "scene": [],
            "cover_img_url": None,
            "cover_img_description": "",
            "description": "A story about moral value for children.",
            "estimated_reading_time": 3600,
        }

        for field, default_value in required_top_level_fields.items():
            if field not in story_data:
                if field == "user_id":
                    story_data[field] = user_id
                elif field == "age_group":
                    story_data[field] = age
                else:
                    story_data[field] = default_value

        # 2. Ensure story_flow structure
        if "story_flow" not in story_data:
            story_data["story_flow"] = {"total_scene": 0, "decision_point": [], "ending": []}

        # 3. Ensure user_story structure
        if "user_story" not in story_data:
            story_data["user_story"] = {
                "visited_scene": [],
                "choices": [],
                "total_point": 0,
                "finished_time": 0,
            }

        # 4. Validate and standardize scenes
        scenes: List[Dict[str, Any]] = story_data.get("scene", [])
        if not scenes:
            raise HTTPException(status_code=500, detail="No scenes found in story")

        decision_points: List[int] = []
        endings: List[int] = []

        for i, scene in enumerate(scenes):
            # Ensure required scene fields
            scene_required_fields = {
                "scene_id": i + 1,
                "type": "narrative",
                "img_url": None,
                "img_description": "",
                "voice_url": None,
                "content": "",
            }
            for field, default_value in scene_required_fields.items():
                if field not in scene:
                    scene[field] = default_value

            scene_type = scene.get("type", "narrative")

            if scene_type == "narrative":
                # must have next_scene; must NOT have branch/lesson_learned/selected_choice
                for extra in ("branch", "lesson_learned", "selected_choice"):
                    if extra in scene:
                        scene.pop(extra, None)
                if "next_scene" not in scene:
                    scene["next_scene"] = scene["scene_id"] + 1 if i < len(scenes) - 1 else None

            elif scene_type == "decision_point":
                # must have branch (2 choices); no next_scene/lesson_learned
                for extra in ("next_scene", "lesson_learned"):
                    if extra in scene:
                        scene.pop(extra, None)

                if "branch" not in scene or not isinstance(scene["branch"], list) or len(scene["branch"]) != 2:
                    raise HTTPException(
                        status_code=500,
                        detail=f"Decision point scene {scene['scene_id']} must have exactly 2 choices",
                    )

                # normalize branch choices
                for j, choice in enumerate(scene["branch"]):
                    choice_required_fields = {
                        "choice": "baik" if j == 0 else "buruk",
                        "content": "",
                        "moral_value": "",
                        "point": 0,
                        "next_scene": scene["scene_id"] + 1,
                    }
                    for field, default_value in choice_required_fields.items():
                        if field not in choice:
                            choice[field] = default_value

                decision_points.append(scene["scene_id"])
                scene.setdefault("selected_choice", None)

            elif scene_type == "ending":
                # must have lesson_learned; no next_scene/branch/selected_choice
                for extra in ("next_scene", "branch", "selected_choice"):
                    if extra in scene:
                        scene.pop(extra, None)

                scene.setdefault("lesson_learned", "Pelajaran penting tentang moral.")
                scene.setdefault("moral_value", "Nilai moral yang relevan.")
                scene.setdefault("meaning", "Penjelasan singkat tentang nilai moral.")
                scene.setdefault("example", "Contoh nyata dari nilai moral dalam kehidupan sehari-hari.")

                et = scene.get("ending_type", "")
                et_lower = str(et).lower()
                if "bad" in et_lower:
                    scene["ending_type"] = "bad"
                elif "good" in et_lower:
                    scene["ending_type"] = "good"

                endings.append(scene["scene_id"])

            else:
                raise HTTPException(status_code=500, detail=f"Invalid scene type: {scene_type}")

        # 5. Update story_flow
        story_data["story_flow"]["total_scene"] = len(scenes)
        story_data["story_flow"]["decision_point"] = decision_points
        story_data["story_flow"]["ending"] = endings

        # 6. Validate characters
        for character in story_data.get("characters", []):
            character.setdefault("name", "Character")
            character.setdefault("description", "A character in the story")

        # 7. Ensure maximum_point is int; compute from positive choice points if needed
        if not isinstance(story_data.get("maximum_point"), int):
            max_points = 0
            for scene in scenes:
                if scene.get("type") == "decision_point" and "branch" in scene:
                    for choice in scene["branch"]:
                        point = choice.get("point", 0)
                        if isinstance(point, int) and point > 0:
                            max_points += point
            story_data["maximum_point"] = max_points if max_points > 0 else 10

        return story_data
