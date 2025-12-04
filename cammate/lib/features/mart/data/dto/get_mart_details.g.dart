// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_mart_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetMartDetailDTO _$GetMartDetailDTOFromJson(Map<String, dynamic> json) =>
    GetMartDetailDTO(
      success: json['success'] as bool,
      message: json['message'] as String,
      martDetail: MartEntity.fromJson(
        json['martDetail'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$GetMartDetailDTOToJson(GetMartDetailDTO instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'martDetail': instance.martDetail,
    };
