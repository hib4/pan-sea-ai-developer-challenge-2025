import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kanca/core/core.dart';
import 'package:kanca/data/data.dart';

part 'story_bloc.freezed.dart';
part 'story_event.dart';
part 'story_state.dart';

class StoryBloc extends Bloc<StoryEvent, StoryState> {
  StoryBloc({
    required StoryRepository repository,
  }) : super(
         const StoryState(
           story: AsyncValue.initial(),
           storyPreviews: AsyncValue.initial(),
         ),
       ) {
    _repository = repository;

    on<_CreateStory>(_createStory);
    on<_GetStoryById>(_getStoryById);
    on<_GetStories>(_getStories);
  }

  late final StoryRepository _repository;

  Future<void> _createStory(
    _CreateStory event,
    Emitter<StoryState> emit,
  ) async {
    emit(state.copyWith(story: const AsyncValue.loading()));
    try {
      final story = await _repository.createStory(event.query);
      emit(state.copyWith(story: AsyncValue.data(story)));
    } catch (e) {
      emit(state.copyWith(story: AsyncValue.error(e.toString())));
    }
  }

  Future<void> _getStoryById(
    _GetStoryById event,
    Emitter<StoryState> emit,
  ) async {
    emit(state.copyWith(story: const AsyncValue.loading()));
    try {
      final story = await _repository.getStoryById(event.id);
      emit(state.copyWith(story: AsyncValue.data(story)));
    } catch (e) {
      emit(state.copyWith(story: AsyncValue.error(e.toString())));
    }
  }

  Future<void> _getStories(
    _GetStories event,
    Emitter<StoryState> emit,
  ) async {
    emit(state.copyWith(storyPreviews: const AsyncValue.loading()));
    try {
      final storyPreviews = await _repository.getStories();
      emit(state.copyWith(storyPreviews: AsyncValue.data(storyPreviews)));
    } catch (e) {
      emit(state.copyWith(storyPreviews: AsyncValue.error(e.toString())));
    }
  }
}
