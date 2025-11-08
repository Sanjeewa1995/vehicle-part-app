import 'package:json_annotation/json_annotation.dart';

part 'password_reset_response.g.dart';

@JsonSerializable()
class PasswordResetResponse {
  final bool success;
  final String message;
  final PasswordResetData? data;
  @JsonKey(name: 'status_code')
  final int statusCode;

  const PasswordResetResponse({
    required this.success,
    required this.message,
    this.data,
    required this.statusCode,
  });

  factory PasswordResetResponse.fromJson(Map<String, dynamic> json) =>
      _$PasswordResetResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PasswordResetResponseToJson(this);
}

@JsonSerializable()
class PasswordResetData {
  final String email;
  @JsonKey(name: 'expires_in')
  final String expiresIn;

  const PasswordResetData({
    required this.email,
    required this.expiresIn,
  });

  factory PasswordResetData.fromJson(Map<String, dynamic> json) =>
      _$PasswordResetDataFromJson(json);

  Map<String, dynamic> toJson() => _$PasswordResetDataToJson(this);
}

