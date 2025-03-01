import 'package:equatable/equatable.dart';

class AuthEntity extends Equatable {
  final String? userId;
  final String email;
  final String? password;
  final String? role;
  final bool? isActive;
  final bool? isStaff;
  final bool? isSuperuser;

  const AuthEntity({
    this.userId,
    required this.email,
    this.password,
    this.role,
    this.isActive,
    this.isStaff,
    this.isSuperuser,
  });

  @override
  List<Object?> get props => [
    userId,
    email,
    password,
    role,
    isActive,
    isStaff,
    isSuperuser,
  ];
  factory AuthEntity.fromJson(Map<String, dynamic> json) => AuthEntity(
        userId: json["userId"],
        email: json["email"],
        password: json["password"],
        role: json["role"],
        isActive: json["isActive"],
        isStaff: json["isStaff"],
        isSuperuser: json["isSuperuser"],

      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "email": email,
        "password": password,
        "role": role,
        "isActive": isActive,
        "isStaff": isStaff,
        "isSuperuser": isSuperuser,
      };

  @override
  String toString() {
    return 'AuthEntity(userId: $userId, email: $email, password: $password, role: $role, isActive: $isActive, isStaff: $isStaff, isSuperuser: $isSuperuser)';
  }
}
