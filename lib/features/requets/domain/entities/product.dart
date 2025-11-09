import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final int id;
  final String name;
  final String description;
  final String price;
  final String? image;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.image,
  });

  @override
  List<Object?> get props => [id, name, description, price, image];
}

