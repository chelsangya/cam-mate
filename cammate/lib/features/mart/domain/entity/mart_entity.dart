import 'package:equatable/equatable.dart';

class MartEntity extends Equatable {
  final int? id;
  final String name;
  final String? description;
  final String? address;
  final String? contactEmail;
  final String? contactPhone;
  final bool? isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const MartEntity({
    this.id,
    required this.name,
    this.description,
    this.address,
    this.contactEmail,
    this.contactPhone,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        address,
        contactEmail,
        contactPhone,
        isActive,
        createdAt,
        updatedAt,
      ];

  factory MartEntity.fromJson(Map<String, dynamic> json) => MartEntity(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        address: json["address"],
        contactEmail: json["contact_email"],
        contactPhone: json["contact_phone"],
        isActive: json["is_active"],
        createdAt: json["created_at"] != null
            ? DateTime.parse(json["created_at"])
            : null,
        updatedAt: json["updated_at"] != null
            ? DateTime.parse(json["updated_at"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "address": address,
        "contact_email": contactEmail,
        "contact_phone": contactPhone,
        "is_active": isActive,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };

  @override
  String toString() {
    return 'MartEntity(id: $id, name: $name, description: $description, address: $address, contactEmail: $contactEmail, contactPhone: $contactPhone, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}
