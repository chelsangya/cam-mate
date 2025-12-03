import 'package:equatable/equatable.dart';

class AuthEntity extends Equatable {
  final int? userId;
  final String username;
  final String? password; // hashed_password
  final String? role;
  final bool? isActive;
  final String? firstName;
  final String? lastName;
  final int? martId;
  final int? createdById;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const AuthEntity({
    this.userId,
    required this.username,
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

  @override
  List<Object?> get props => [
    userId,
    username,
    password,
    role,
    isActive,
    firstName,
    lastName,
    martId,
    createdById,
    createdAt,
    updatedAt,
  ];

  factory AuthEntity.fromJson(Map<String, dynamic> json) => AuthEntity(
    userId: json["userId"],
    username: json["username"],
    password: json["password"],
    role: json["role"],
    isActive: json["isActive"],
    firstName: json["firstName"],
    lastName: json["lastName"],
    martId: json["martId"],
    createdById: json["createdById"],
    createdAt: json["createdAt"] != null ? DateTime.parse(json["createdAt"]) : null,
    updatedAt: json["updatedAt"] != null ? DateTime.parse(json["updatedAt"]) : null,
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "username": username,
    "password": password,
    "role": role,
    "isActive": isActive,
    "firstName": firstName,
    "lastName": lastName,
    "martId": martId,
    "createdById": createdById,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
  };

  @override
  String toString() {
    return 'AuthEntity(userId: $userId, username: $username, password: $password, role: $role, isActive: $isActive, firstName: $firstName, lastName: $lastName, martId: $martId, createdById: $createdById, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}
