// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
  userId: (json['id'] as num).toInt(),
  userEmail: json['email'] as String,
  userFirstName: json['first_name'] as String?,
  userLastName: json['last_name'] as String?,
  userFullName: json['full_name'] as String?,
  userPhone: json['phone'] as String?,
  userUserType: json['user_type'] as String,
  userIsActive: json['is_active'] as bool,
  userCreatedAt: json['created_at'] as String,
  userUpdatedAt: json['updated_at'] as String,
);

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
  'id': instance.userId,
  'email': instance.userEmail,
  'first_name': instance.userFirstName,
  'last_name': instance.userLastName,
  'full_name': instance.userFullName,
  'phone': instance.userPhone,
  'user_type': instance.userUserType,
  'is_active': instance.userIsActive,
  'created_at': instance.userCreatedAt,
  'updated_at': instance.userUpdatedAt,
};
