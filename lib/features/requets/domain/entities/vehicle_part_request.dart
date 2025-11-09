import 'package:equatable/equatable.dart';
import '../../../auth/domain/entities/user.dart';
import 'product.dart';

class VehiclePartRequest extends Equatable {
  final int id;
  final String vehicleType;
  final String vehicleModel;
  final int vehicleYear;
  final String partName;
  final String? partNumber;
  final String? vehicleImage;
  final String? partImage;
  final String? partVideo;
  final String description;
  final String status;
  final User user;
  final List<Product> products;
  final DateTime createdAt;
  final DateTime updatedAt;

  const VehiclePartRequest({
    required this.id,
    required this.vehicleType,
    required this.vehicleModel,
    required this.vehicleYear,
    required this.partName,
    this.partNumber,
    this.vehicleImage,
    this.partImage,
    this.partVideo,
    required this.description,
    required this.status,
    required this.user,
    required this.products,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        vehicleType,
        vehicleModel,
        vehicleYear,
        partName,
        partNumber,
        vehicleImage,
        partImage,
        partVideo,
        description,
        status,
        user,
        products,
        createdAt,
        updatedAt,
      ];
}

