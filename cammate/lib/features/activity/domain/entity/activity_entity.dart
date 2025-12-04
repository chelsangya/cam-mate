import 'package:equatable/equatable.dart';

class ActivityEntity extends Equatable {
  final int? id;
  final String email;
  final String firstName;
  final String lastName;
  final String role;
  final bool? isActive;
  final int? martId;
  final int? createdById;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ActivityEntity({
    this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.role,
    this.isActive,
    this.martId,
    this.createdById,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    email,
    firstName,
    lastName,
    role,
    isActive,
    martId,
    createdById,
    createdAt,
    updatedAt,
  ];

  factory ActivityEntity.fromJson(Map<String, dynamic> json) => ActivityEntity(
    id: json['id'] as int?,
    email: json['email'] as String,
    firstName: json['first_name'] as String,
    lastName: json['last_name'] as String,
    role: json['role'] as String,
    isActive: json['is_active'] as bool?,
    martId: json['mart_id'] as int?,
    createdById: json['created_by_id'] as int?,
    createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
    updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'first_name': firstName,
    'last_name': lastName,
    'role': role,
    'is_active': isActive,
    'mart_id': martId,
    'created_by_id': createdById,
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
  };

  @override
  String toString() {
    return 'ActivityEntity(id: $id, email: $email, firstName: $firstName, lastName: $lastName, role: $role, isActive: $isActive, martId: $martId, createdById: $createdById, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}
