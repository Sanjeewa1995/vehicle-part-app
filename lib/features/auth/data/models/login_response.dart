import 'package:json_annotation/json_annotation.dart';
import 'auth_tokens_model.dart';
import 'user_model.dart';

part 'login_response.g.dart';

@JsonSerializable()
class LoginResponse {
  final bool success;
  final String message;
  final LoginResponseData data;
  @JsonKey(name: 'status_code')
  final int statusCode;

  const LoginResponse({
    required this.success,
    required this.message,
    required this.data,
    required this.statusCode,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}

@JsonSerializable()
class LoginResponseData {
  @JsonKey(name: 'tokens')
  final AuthTokensModel tokens;
  @JsonKey(name: 'user')
  final UserModel user;

  const LoginResponseData({
    required this.tokens,
    required this.user,
  });

  factory LoginResponseData.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseDataFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseDataToJson(this);
}
