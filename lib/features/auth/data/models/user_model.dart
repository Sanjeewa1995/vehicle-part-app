import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/user.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel extends User {
  @JsonKey(name: 'id')
  final int userId;
  @JsonKey(name: 'email')
  final String userEmail;
  @JsonKey(name: 'first_name')
  final String? userFirstName;
  @JsonKey(name: 'last_name')
  final String? userLastName;
  @JsonKey(name: 'full_name')
  final String? userFullName;
  @JsonKey(name: 'phone')
  final String? userPhone;
  @JsonKey(name: 'user_type')
  final String userUserType;
  @JsonKey(name: 'is_active')
  final bool userIsActive;
  @JsonKey(name: 'created_at')
  final String userCreatedAt;
  @JsonKey(name: 'updated_at')
  final String userUpdatedAt;

  UserModel({
    required this.userId,
    required this.userEmail,
    this.userFirstName,
    this.userLastName,
    this.userFullName,
    this.userPhone,
    required this.userUserType,
    required this.userIsActive,
    required this.userCreatedAt,
    required this.userUpdatedAt,
  }) : super(
          id: userId,
          email: userEmail,
          firstName: userFirstName,
          lastName: userLastName,
          fullName: userFullName,
          phone: userPhone,
          userType: userUserType,
          isActive: userIsActive,
          createdAt: DateTime.parse(userCreatedAt),
          updatedAt: DateTime.parse(userUpdatedAt),
        );

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  factory UserModel.fromEntity(User user) {
    return UserModel(
      userId: user.id,
      userEmail: user.email,
      userFirstName: user.firstName,
      userLastName: user.lastName,
      userFullName: user.fullName,
      userPhone: user.phone,
      userUserType: user.userType,
      userIsActive: user.isActive,
      userCreatedAt: user.createdAt.toIso8601String(),
      userUpdatedAt: user.updatedAt.toIso8601String(),
    );
  }
}
