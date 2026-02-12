import 'package:equatable/equatable.dart';

class MartEntity extends Equatable {
  final int? id;
  final String name;
  final String? description;
  final String? address;
  final String? password;
  final String? contact_email;
  final String? contact_phone;
  final bool? isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const MartEntity({
    this.id,
    required this.name,
    this.description,
    this.address,
    this.password,
    this.contact_email,
    this.contact_phone,
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
        password,
        contact_email,
        contact_phone,
        isActive,
        createdAt,
        updatedAt,
      ];

  factory MartEntity.fromJson(Map<String, dynamic> json) => MartEntity(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        address: json["address"],
        contact_email: json["contact_email"],
        contact_phone: json["contact_phone"],
        password: json["password"],
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
        "contact_email": contact_email,
        "contact_phone": contact_phone,
        "password": password,
        "is_active": isActive,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };

  @override
  String toString() {
    return 'MartEntity(id: $id, name: $name, description: $description, address: $address, contact_email: $contact_email, contact_phone: $contact_phone, password: $password, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}
