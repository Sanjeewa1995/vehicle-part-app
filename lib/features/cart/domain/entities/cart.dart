import 'package:equatable/equatable.dart';

class Cart extends Equatable {
  final int id;
  final String sessionId;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Cart({
    required this.id,
    required this.sessionId,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [id, sessionId, createdAt, updatedAt];
}

