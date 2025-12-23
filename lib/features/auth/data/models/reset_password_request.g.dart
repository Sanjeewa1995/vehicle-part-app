// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reset_password_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResetPasswordRequest _$ResetPasswordRequestFromJson(
  Map<String, dynamic> json,
) => ResetPasswordRequest(
  phone: json['phone'] as String,
  otp: json['otp'] as String,
  newPassword: json['new_password'] as String,
  newPasswordConfirm: json['new_password_confirm'] as String,
);

Map<String, dynamic> _$ResetPasswordRequestToJson(
  ResetPasswordRequest instance,
) => <String, dynamic>{
  'phone': instance.phone,
  'otp': instance.otp,
  'new_password': instance.newPassword,
  'new_password_confirm': instance.newPasswordConfirm,
};
