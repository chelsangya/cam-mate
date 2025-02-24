import 'package:equatable/equatable.dart';

class AuthEntity extends Equatable{
  final String? userId;
  final String email;
  final String? password;
  final String role;
  final bool isActive;
  final bool isStaff;
  final bool isSuperuser;


  const AuthEntity(
      {this.userId,
      required this.email,
      required this.password,
      required this.role,
      required this.isActive,
      required this.isStaff,
      required this.isSuperuser});

  @override
  List<Object?> get props => [userId, email,password, role, isActive, isStaff, isSuperuser];
}