import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/vehicle_part_request.dart';
import '../../../auth/data/models/user_model.dart';

part 'vehicle_part_request_model.g.dart';

@JsonSerializable()
class VehiclePartRequestModel extends VehiclePartRequest {
  @JsonKey(name: 'id')
  final int requestId;

  @JsonKey(name: 'vehicle_type')
  final String requestVehicleType;

  @JsonKey(name: 'vehicle_model')
  final String requestVehicleModel;

  @JsonKey(name: 'vehicle_year')
  final int requestVehicleYear;

  @JsonKey(name: 'part_name')
  final String requestPartName;

  @JsonKey(name: 'part_number')
  final String? requestPartNumber;

  @JsonKey(name: 'vehicle_image')
  final String? requestVehicleImage;

  @JsonKey(name: 'part_image')
  final String? requestPartImage;

  @JsonKey(name: 'part_video')
  final String? requestPartVideo;

  @JsonKey(name: 'description')
  final String requestDescription;

  @JsonKey(name: 'status')
  final String requestStatus;

  @JsonKey(name: 'user')
  final UserModel requestUser;

  @JsonKey(name: 'products')
  final List<dynamic> requestProducts;

  @JsonKey(name: 'created_at')
  final String requestCreatedAt;

  @JsonKey(name: 'updated_at')
  final String requestUpdatedAt;

  VehiclePartRequestModel({
    required this.requestId,
    required this.requestVehicleType,
    required this.requestVehicleModel,
    required this.requestVehicleYear,
    required this.requestPartName,
    this.requestPartNumber,
    this.requestVehicleImage,
    this.requestPartImage,
    this.requestPartVideo,
    required this.requestDescription,
    required this.requestStatus,
    required this.requestUser,
    required this.requestProducts,
    required this.requestCreatedAt,
    required this.requestUpdatedAt,
  }) : super(
          id: requestId,
          vehicleType: requestVehicleType,
          vehicleModel: requestVehicleModel,
          vehicleYear: requestVehicleYear,
          partName: requestPartName,
          partNumber: requestPartNumber,
          vehicleImage: requestVehicleImage,
          partImage: requestPartImage,
          partVideo: requestPartVideo,
          description: requestDescription,
          status: requestStatus,
          user: requestUser,
          products: requestProducts,
          createdAt: DateTime.parse(requestCreatedAt),
          updatedAt: DateTime.parse(requestUpdatedAt),
        );

  factory VehiclePartRequestModel.fromJson(Map<String, dynamic> json) =>
      _$VehiclePartRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$VehiclePartRequestModelToJson(this);
}

