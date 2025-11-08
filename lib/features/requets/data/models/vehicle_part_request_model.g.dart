// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle_part_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VehiclePartRequestModel _$VehiclePartRequestModelFromJson(
  Map<String, dynamic> json,
) => VehiclePartRequestModel(
  requestId: (json['id'] as num).toInt(),
  requestVehicleType: json['vehicle_type'] as String,
  requestVehicleModel: json['vehicle_model'] as String,
  requestVehicleYear: (json['vehicle_year'] as num).toInt(),
  requestPartName: json['part_name'] as String,
  requestPartNumber: json['part_number'] as String?,
  requestVehicleImage: json['vehicle_image'] as String?,
  requestPartImage: json['part_image'] as String?,
  requestPartVideo: json['part_video'] as String?,
  requestDescription: json['description'] as String,
  requestStatus: json['status'] as String,
  requestUser: UserModel.fromJson(json['user'] as Map<String, dynamic>),
  requestProducts: json['products'] as List<dynamic>,
  requestCreatedAt: json['created_at'] as String,
  requestUpdatedAt: json['updated_at'] as String,
);

Map<String, dynamic> _$VehiclePartRequestModelToJson(
  VehiclePartRequestModel instance,
) => <String, dynamic>{
  'id': instance.requestId,
  'vehicle_type': instance.requestVehicleType,
  'vehicle_model': instance.requestVehicleModel,
  'vehicle_year': instance.requestVehicleYear,
  'part_name': instance.requestPartName,
  'part_number': instance.requestPartNumber,
  'vehicle_image': instance.requestVehicleImage,
  'part_image': instance.requestPartImage,
  'part_video': instance.requestPartVideo,
  'description': instance.requestDescription,
  'status': instance.requestStatus,
  'user': instance.requestUser,
  'products': instance.requestProducts,
  'created_at': instance.requestCreatedAt,
  'updated_at': instance.requestUpdatedAt,
};
