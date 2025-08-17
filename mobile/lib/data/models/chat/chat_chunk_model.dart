import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_chunk_model.freezed.dart';
part 'chat_chunk_model.g.dart';

@freezed
abstract class ChatChunkModel with _$ChatChunkModel {
  const factory ChatChunkModel({
    String? type,
    String? content,
  }) = _ChatChunkModel;

  factory ChatChunkModel.fromJson(Map<String, dynamic> json) =>
      _$ChatChunkModelFromJson(json);
}
