import 'package:freezed_annotation/freezed_annotation.dart';

part 'async_value.freezed.dart';

@freezed
sealed class AsyncValue<T> with _$AsyncValue<T> {
  const factory AsyncValue.initial() = _Initial<T>;
  const factory AsyncValue.loading() = _Loading<T>;
  const factory AsyncValue.data(T data) = _Data<T>;
  const factory AsyncValue.error(String message) = _Error<T>;
}
