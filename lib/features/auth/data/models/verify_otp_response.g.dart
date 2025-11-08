// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verify_otp_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VerifyOTPResponse _$VerifyOTPResponseFromJson(Map<String, dynamic> json) =>
    VerifyOTPResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      statusCode: (json['status_code'] as num).toInt(),
    );

Map<String, dynamic> _$VerifyOTPResponseToJson(VerifyOTPResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'status_code': instance.statusCode,
    };
