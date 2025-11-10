import 'package:equatable/equatable.dart';
import '../../../requets/domain/entities/vehicle_part_request.dart';

class StoreProduct extends Equatable {
  final int id;
  final String name;
  final String description;
  final String price;
  final String? image;
  final VehiclePartRequest? request;
  final DateTime createdAt;
  final DateTime updatedAt;

  const StoreProduct({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.image,
    this.request,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        price,
        image,
        request,
        createdAt,
        updatedAt,
      ];
}

