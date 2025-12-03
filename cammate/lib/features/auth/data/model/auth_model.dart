import 'package:cammate/features/auth/domain/entity/auth_entity.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class AuthAPIModel {
  @JsonKey(name: 'id')
  final int? userId;
  final String email;
  final String? password;
  final String? role;
  @JsonKey(name: 'is_active')
  final bool? isActive;
  final String? firstName;
  final String? lastName;
  final int? martId;
  final int? createdById;
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  AuthAPIModel({
    this.userId,
    required this.email,
    this.password,
    this.role,
    this.isActive,
    this.firstName,
    this.lastName,
    this.martId,
    this.createdById,
    this.createdAt,
    this.updatedAt,
  });

  factory AuthAPIModel.fromJson(Map<String, dynamic> json) {
    return AuthAPIModel(
      userId: json['id'],
      email: json['email'],
      password: json['hashed_password'],
      role: json['role'],
      isActive: json['is_active'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      martId: json['mart_id'],
      createdById: json['created_by_id'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  Map<String, dynamic> toJson({bool includePassword = false}) {
    final data = {
      'id': userId,
      'email': email,
      'role': role,
      'is_active': isActive,
      'first_name': firstName,
      'last_name': lastName,
      'mart_id': martId,
      'created_by_id': createdById,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
    if (includePassword && password != null) {
      data['hashed_password'] = password;
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
      firstName: entity.firstName,
      lastName: entity.lastName,
      martId: entity.martId,
      createdById: entity.createdById,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  static AuthEntity toEntity(AuthAPIModel model) {
    return AuthEntity(
      userId: model.userId,
      email: model.email,
      password: model.password,
      role: model.role,
      isActive: model.isActive,
      firstName: model.firstName,
      lastName: model.lastName,
      martId: model.martId,
      createdById: model.createdById,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
    );
  }
}
