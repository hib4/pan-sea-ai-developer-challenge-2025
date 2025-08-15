import 'package:kanca/data/data.dart';

mixin StoryRepository {
  Future<StoryModel> createStory(String query);

  Future<StoryModel> getStoryById(String id);
}
