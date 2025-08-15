part of 'story_bloc.dart';

@freezed
sealed class StoryState with _$StoryState {
  const factory StoryState({
    required AsyncValue<StoryModel> story,
  }) = _StoryState;
}
