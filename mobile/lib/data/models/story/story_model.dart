import 'package:freezed_annotation/freezed_annotation.dart';

part 'story_model.freezed.dart';
part 'story_model.g.dart';

@freezed
abstract class StoryModel with _$StoryModel {
  const factory StoryModel({
    required String title,
    required String description,
    @JsonKey(name: 'theme') required List<String> themes,
    @JsonKey(name: 'scene') required List<Scene> scenes,
    @JsonKey(name: 'current_scene') required int currentScene,
    @JsonKey(name: 'total_scenes') int? totalScenes,
    @JsonKey(name: '_id') String? id,
    @JsonKey(name: 'user_id') String? userId,
    @JsonKey(name: 'cover_img_url') String? coverImgUrl,
    String? language,
    String? status,
    @JsonKey(name: 'age_group') int? ageGroup,
    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(name: 'finished_at') String? finishedAt,
    @JsonKey(name: 'maximum_point') int? maximumPoint,
    @JsonKey(name: 'story_flow') StoryFlow? storyFlow,
    List<Character>? characters,
    @JsonKey(name: 'user_story') UserStory? userStory,
    @JsonKey(name: 'estimated_reading_time') int? estimatedReadingTime,
  }) = _StoryModel;

  factory StoryModel.fromJson(Map<String, dynamic> json) =>
      _$StoryModelFromJson(json);
}

@freezed
abstract class StoryFlow with _$StoryFlow {
  const factory StoryFlow({
    @JsonKey(name: 'total_scene') required int totalScene,
    @JsonKey(name: 'decision_point') required List<int> decisionPoint,
    required List<int> ending,
  }) = _StoryFlow;

  factory StoryFlow.fromJson(Map<String, dynamic> json) =>
      _$StoryFlowFromJson(json);
}

@freezed
abstract class Character with _$Character {
  const factory Character({
    required String name,
    required String description,
  }) = _Character;

  factory Character.fromJson(Map<String, dynamic> json) =>
      _$CharacterFromJson(json);
}

@freezed
abstract class UserStory with _$UserStory {
  const factory UserStory({
    @JsonKey(name: 'visited_scene') required List<int> visitedScene,
    required List<String> choices,
    @JsonKey(name: 'total_point') required int totalPoint,
    @JsonKey(name: 'finished_time') required int finishedTime,
  }) = _UserStory;

  factory UserStory.fromJson(Map<String, dynamic> json) =>
      _$UserStoryFromJson(json);
}

@freezed
abstract class Scene with _$Scene {
  const factory Scene({
    @JsonKey(name: 'scene_id') required int sceneId,
    required String type,
    @JsonKey(name: 'img_description') required String imgDescription,
    required String content,
    @JsonKey(name: 'img_url') String? imgUrl,
    @JsonKey(name: 'voice_url') String? voiceUrl,
    @JsonKey(name: 'next_scene') int? nextScene,
    List<SceneChoice>? branch,
    @JsonKey(name: 'lesson_learned') String? lessonLearned,
    @JsonKey(name: 'selected_choice') String? selectedChoice,
    @JsonKey(name: 'ending_type') String? endingType,
    @JsonKey(name: 'moral_value') String? moralValue,
    String? meaning,
    String? example,
  }) = _Scene;

  factory Scene.fromJson(Map<String, dynamic> json) => _$SceneFromJson(json);
}

@freezed
abstract class SceneChoice with _$SceneChoice {
  const factory SceneChoice({
    required String choice,
    required String content,
    @JsonKey(name: 'moral_value') required String moralValue,
    required int point,
    @JsonKey(name: 'next_scene') required int nextScene,
  }) = _SceneChoice;

  factory SceneChoice.fromJson(Map<String, dynamic> json) =>
      _$SceneChoiceFromJson(json);
}
