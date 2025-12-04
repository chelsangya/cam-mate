import 'package:cammate/features/activity/domain/entity/activity_entity.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class ActivityAPIModel {
  final int? id;
  final String email;
  @JsonKey(name: 'first_name')
  final String firstName;
  @JsonKey(name: 'last_name')
  final String lastName;
  final String role;
  @JsonKey(name: 'is_active')
  final bool? isActive;
  @JsonKey(name: 'mart_id')
  final int? martId;
  @JsonKey(name: 'created_by_id')
  final int? createdById;
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  ActivityAPIModel({
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

  factory ActivityAPIModel.fromJson(Map<String, dynamic> json) {
    return ActivityAPIModel(
      id: json['id'] as int?,
      email: json['email'] as String,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      role: json['role'] as String,
      isActive: json['is_active'] as bool?,
      martId: json['mart_id'] as int?,
      createdById: json['created_by_id'] as int?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toBody({String? password}) {
    return {
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'role': role,
      'is_active': isActive,
      'mart_id': martId,
      if (password != null) 'password': password,
    };
  }

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

  ActivityEntity toEntity() {
    return ActivityEntity(
      id: id,
      email: email,
      firstName: firstName,
      lastName: lastName,
      role: role,
      isActive: isActive,
      martId: martId,
      createdById: createdById,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
