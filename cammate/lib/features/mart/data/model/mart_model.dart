import 'package:cammate/features/mart/domain/entity/mart_entity.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class MartAPIModel {
  final int? id;
  final String name;
  final String? description;
  final String? address;
  final String? password;
  @JsonKey(name: 'contact_email')
  final String? contact_email;
  @JsonKey(name: 'contact_phone')
  final String? contact_phone;
  @JsonKey(name: 'is_active')
  final bool? isActive;
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  MartAPIModel({
    this.id,
    required this.name,
    this.description,
    this.address,
    this.contact_email,
    this.contact_phone,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.password,
  });

  factory MartAPIModel.fromJson(Map<String, dynamic> json) {
    return MartAPIModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      address: json['address'],
      contact_email: json['contact_email'],
      contact_phone: json['contact_phone'],
      password: json['password'],
      isActive: json['is_active'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'address': address,
      'contact_email': contact_email,
      'contact_phone': contact_phone,
      'password': password,
      'is_active': isActive,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  factory MartAPIModel.fromEntity(MartEntity entity) {
    return MartAPIModel(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      address: entity.address,
      password: entity.password,
      contact_email: entity.contact_email,
      contact_phone: entity.contact_phone,
      isActive: entity.isActive,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  MartEntity toEntity() {
    return MartEntity(
      id: id,
      name: name,
      description: description,
      address: address,
      password: password,
      contact_email: contact_email,
      contact_phone: contact_phone,
      isActive: isActive,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
