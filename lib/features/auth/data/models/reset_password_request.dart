import 'package:json_annotation/json_annotation.dart';

part 'reset_password_request.g.dart';

@JsonSerializable()
class ResetPasswordRequest {
  final String email;
  final String otp;
  @JsonKey(name: 'new_password')
  final String newPassword;
  @JsonKey(name: 'new_password_confirm')
  final String newPasswordConfirm;

  ResetPasswordRequest({
    required this.email,
    required this.otp,
    required this.newPassword,
    required this.newPasswordConfirm,
  });

  factory ResetPasswordRequest.fromJson(Map<String, dynamic> json) =>
      _$ResetPasswordRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ResetPasswordRequestToJson(this);
}

