import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_status.freezed.dart';

/// Ui status: initial, loading, loadSuccess and loadFailed
@Freezed(fromJson: false, toJson: false)
sealed class UserStatus with _$UserStatus {
  const factory UserStatus.authenticated() = UserAuthenticated;

  const factory UserStatus.authenticating() = UserAuthenticating;

  const factory UserStatus.unauthenticated() = UserUnauthenticated;

  const factory UserStatus.error({
    required String message,
  }) = UserError;

  const factory UserStatus.unknown({
    String? message,
  }) = UserUnknown;
}
