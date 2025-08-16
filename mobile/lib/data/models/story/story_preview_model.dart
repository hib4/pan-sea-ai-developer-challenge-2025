import 'package:freezed_annotation/freezed_annotation.dart';

part 'story_preview_model.freezed.dart';
part 'story_preview_model.g.dart';

@freezed
abstract class StoryPreviewModel with _$StoryPreviewModel {
  const factory StoryPreviewModel({
    required List<Data> data,
  }) = _StoryPreviewModel;

  factory StoryPreviewModel.fromJson(Map<String, dynamic> json) =>
      _$StoryPreviewModelFromJson(json);
}

@freezed
abstract class Data with _$Data {
  const factory Data({
    required String id,
    required String title,
    required String language,
    required String description,
    @JsonKey(name: 'estimation_time_to_read')
    required String estimationTimeToRead,
    @JsonKey(name: 'cover_img_url') required String coverImgUrl,
    @JsonKey(name: 'created_at') required String createdAt,
  }) = _Data;

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);
}
