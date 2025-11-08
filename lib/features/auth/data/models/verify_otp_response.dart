import 'package:json_annotation/json_annotation.dart';

part 'verify_otp_response.g.dart';

@JsonSerializable()
class VerifyOTPResponse {
  final bool success;
  final String message;
  @JsonKey(name: 'status_code')
  final int statusCode;

  const VerifyOTPResponse({
    required this.success,
    required this.message,
    required this.statusCode,
  });

  factory VerifyOTPResponse.fromJson(Map<String, dynamic> json) =>
      _$VerifyOTPResponseFromJson(json);

  Map<String, dynamic> toJson() => _$VerifyOTPResponseToJson(this);
}

