// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_activity_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetActivityDetailDTO _$GetActivityDetailDTOFromJson(
  Map<String, dynamic> json,
) => GetActivityDetailDTO(
  success: json['success'] as bool,
  message: json['message'] as String,
  userDetail: ActivityEntity.fromJson(
    json['userDetail'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$GetActivityDetailDTOToJson(
  GetActivityDetailDTO instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'userDetail': instance.userDetail,
};
