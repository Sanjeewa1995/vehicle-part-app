// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'password_reset_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PasswordResetResponse _$PasswordResetResponseFromJson(
  Map<String, dynamic> json,
) => PasswordResetResponse(
  success: json['success'] as bool,
  message: json['message'] as String,
  data: json['data'] == null
      ? null
      : PasswordResetData.fromJson(json['data'] as Map<String, dynamic>),
  statusCode: (json['status_code'] as num).toInt(),
);

Map<String, dynamic> _$PasswordResetResponseToJson(
  PasswordResetResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': instance.data,
  'status_code': instance.statusCode,
};

PasswordResetData _$PasswordResetDataFromJson(Map<String, dynamic> json) =>
    PasswordResetData(
      email: json['email'] as String,
      expiresIn: json['expires_in'] as String,
    );

Map<String, dynamic> _$PasswordResetDataToJson(PasswordResetData instance) =>
    <String, dynamic>{
      'email': instance.email,
      'expires_in': instance.expiresIn,
    };
