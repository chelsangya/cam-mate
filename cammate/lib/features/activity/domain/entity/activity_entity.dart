import 'package:equatable/equatable.dart';

class ActivityEntity extends Equatable {
  final int? id;
  final int cameraId;
  final String activityType;
  final String? description;
  final double confidence;
  final String? status;
  final String? videoClip;
  final String? imageUrl;
  final String? assignedTo;
  final String? priority;
  final int? martId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ActivityEntity({
    this.id,
    required this.cameraId,
    required this.activityType,
    this.description,
    required this.confidence,
    this.status,
    this.videoClip,
    this.imageUrl,
    this.assignedTo,
    this.priority,
    this.martId,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    cameraId,
    activityType,
    description,
    confidence,
    status,
    videoClip,
    imageUrl,
    assignedTo,
    priority,
    martId,
    createdAt,
    updatedAt,
  ];

  factory ActivityEntity.fromJson(Map<String, dynamic> json) => ActivityEntity(
    id: json['id'] as int?,
    cameraId: json['camera_id'] as int,
    activityType: json['activity_type'] as String,
    description: json['description'] as String?,
    confidence:
        (json['confidence'] is int)
            ? (json['confidence'] as int).toDouble()
            : (json['confidence'] as double),
    status: json['status'] as String?,
    videoClip: json['video_clip'] as String?,
    imageUrl: json['image_url'] as String?,
    assignedTo: json['assigned_to'] as String?,
    priority: json['priority'] as String?,
    martId: json['mart_id'] as int?,
    createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
    updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'camera_id': cameraId,
    'activity_type': activityType,
    'description': description,
    'confidence': confidence,
    'status': status,
    'video_clip': videoClip,
    'image_url': imageUrl,
    'assigned_to': assignedTo,
    'priority': priority,
    'mart_id': martId,
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
  };

  @override
  String toString() {
    return 'ActivityEntity(id: $id, cameraId: $cameraId, activityType: $activityType, description: $description, confidence: $confidence, status: $status, assignedTo: $assignedTo, priority: $priority, martId: $martId, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}
