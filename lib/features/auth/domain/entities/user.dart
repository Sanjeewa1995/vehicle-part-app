import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int id;
  final String email;
  final String? firstName;
  final String? lastName;
  final String? fullName;
  final String? phone;
  final String userType;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const User({
    required this.id,
    required this.email,
    this.firstName,
    this.lastName,
    this.fullName,
    this.phone,
    required this.userType,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        email,
        firstName,
        lastName,
        fullName,
        phone,
        userType,
        isActive,
        createdAt,
        updatedAt,
      ];
}

