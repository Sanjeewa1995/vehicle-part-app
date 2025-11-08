import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/auth_tokens.dart';

part 'auth_tokens_model.g.dart';

@JsonSerializable()
class AuthTokensModel extends AuthTokens {
  @JsonKey(name: 'access')
  final String access;
  @JsonKey(name: 'refresh')
  final String refresh;

  const AuthTokensModel({
    required this.access,
    required this.refresh,
  }) : super(
          accessToken: access,
          refreshToken: refresh,
        );

  factory AuthTokensModel.fromJson(Map<String, dynamic> json) =>
      _$AuthTokensModelFromJson(json);

  Map<String, dynamic> toJson() => _$AuthTokensModelToJson(this);

  factory AuthTokensModel.fromEntity(AuthTokens tokens) {
    return AuthTokensModel(
      access: tokens.accessToken,
      refresh: tokens.refreshToken,
    );
  }
}
