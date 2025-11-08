import 'package:json_annotation/json_annotation.dart';

part 'reset_password_response.g.dart';

@JsonSerializable()
class ResetPasswordResponse {
  final bool success;
  final String message;
  @JsonKey(name: 'status_code')
  final int statusCode;

  const ResetPasswordResponse({
    required this.success,
    required this.message,
    required this.statusCode,
  });

  factory ResetPasswordResponse.fromJson(Map<String, dynamic> json) =>
      _$ResetPasswordResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ResetPasswordResponseToJson(this);
}

