import 'package:json_annotation/json_annotation.dart';

part 'register_request.g.dart';

@JsonSerializable()
class RegisterRequest {
  final String email;
  @JsonKey(name: 'first_name')
  final String firstName;
  @JsonKey(name: 'last_name')
  final String lastName;
  final String phone;
  final String password;
  @JsonKey(name: 'password_confirm')
  final String passwordConfirm;
  @JsonKey(name: 'user_type')
  final String userType;

  RegisterRequest({
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.password,
    required this.passwordConfirm,
    this.userType = 'user',
  });

  factory RegisterRequest.fromJson(Map<String, dynamic> json) =>
      _$RegisterRequestFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterRequestToJson(this);
}

