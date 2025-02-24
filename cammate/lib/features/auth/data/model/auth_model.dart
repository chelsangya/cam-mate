import 'package:cammate/features/auth/domain/entity/auth_entity.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class AuthAPIModel {
  @JsonKey(name: '_id')
  final String? userId;
  final String email;
  final String? password;
  final String role;
  @JsonKey(name: 'is_active')
  final bool isActive;
  @JsonKey(name: 'is_staff')
  final bool isStaff;
  @JsonKey(name: 'is_superuser')
  final bool isSuperuser;

  AuthAPIModel({
    this.userId,
    required this.email,
    this.password,
    required this.role,
    required this.isActive,
    required this.isStaff,
    required this.isSuperuser,
  });

  factory AuthAPIModel.fromJson(Map<String, dynamic> json) {
    return AuthAPIModel(
      userId: json['_id'],
      email: json['email'],
      password: null, // Django does not return passwords
      role: json['role'],
      isActive: json['is_active'],
      isStaff: json['is_staff'],
      isSuperuser: json['is_superuser'],
    );
  }

  Map<String, dynamic> toJson({bool includePassword = false}) {
    final data = {
      '_id': userId,
      'email': email,
      'role': role,
      'is_active': isActive,
      'is_staff': isStaff,
      'is_superuser': isSuperuser,
    };
    if (includePassword && password != null) {
      data['password'] = password;
    }

    return data;
  }

  factory AuthAPIModel.fromEntity(AuthEntity entity) {
    return AuthAPIModel(
      userId: entity.userId,
      email: entity.email,
      password: entity.password,
      role: entity.role,
      isActive: entity.isActive,
      isStaff: entity.isStaff,
      isSuperuser: entity.isSuperuser,
    );
  }

  static AuthEntity toEntity(AuthAPIModel model) {
    return AuthEntity(
      userId: model.userId,
      email: model.email,
      password: model.password,
      role: model.role,
      isActive: model.isActive,
      isStaff: model.isStaff,
      isSuperuser: model.isSuperuser,
    );
  }
}
