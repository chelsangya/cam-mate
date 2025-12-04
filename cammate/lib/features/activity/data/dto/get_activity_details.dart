import 'package:cammate/features/activity/domain/entity/activity_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'get_activity_details.g.dart';


@JsonSerializable()
class GetActivityDetailDTO {
  final bool success;
  final String message;
  final ActivityEntity userDetail;

  GetActivityDetailDTO(
      {required this.success, required this.message,  required this.userDetail});

  factory GetActivityDetailDTO.fromJson(Map<String, dynamic> json) =>
      _$GetActivityDetailDTOFromJson(json);

  Map<String, dynamic> toJson() => _$GetActivityDetailDTOToJson(this);
}
