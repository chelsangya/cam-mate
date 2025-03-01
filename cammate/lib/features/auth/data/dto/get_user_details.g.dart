// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_user_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetUserDetailDTO _$GetUserDetailDTOFromJson(Map<String, dynamic> json) =>
    GetUserDetailDTO(
      success: json['success'] as bool,
      message: json['message'] as String,
      userDetail: AuthEntity.fromJson(
        json['userDetail'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$GetUserDetailDTOToJson(GetUserDetailDTO instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'userDetail': instance.userDetail,
    };
