part of 'story_bloc.dart';

@freezed
sealed class StoryEvent with _$StoryEvent {
  const factory StoryEvent.createStory(String query) = _CreateStory;
  const factory StoryEvent.getStoryById(String id) = _GetStoryById;
  const factory StoryEvent.getStories() = _GetStories;
}
