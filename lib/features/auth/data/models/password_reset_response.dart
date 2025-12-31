import 'package:json_annotation/json_annotation.dart';

part 'password_reset_response.g.dart';

@JsonSerializable()
class PasswordResetResponse {
  @JsonKey(defaultValue: false)
  final bool success;
  @JsonKey(defaultValue: '')
  final String message;
  final PasswordResetData? data;
  @JsonKey(name: 'status_code', defaultValue: 0)
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
  @JsonKey(defaultValue: '')
  final String email;
  @JsonKey(name: 'expires_in', defaultValue: '')
  final String expiresIn;

  const PasswordResetData({
    required this.email,
    required this.expiresIn,
  });

  factory PasswordResetData.fromJson(Map<String, dynamic> json) =>
      _$PasswordResetDataFromJson(json);

  Map<String, dynamic> toJson() => _$PasswordResetDataToJson(this);
}

