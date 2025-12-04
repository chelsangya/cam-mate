import 'package:cammate/features/user/domain/entity/user_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'get_user_details.g.dart';


@JsonSerializable()
class GetUserDetailDTO {
  final bool success;
  final String message;
  final UserEntity userDetail;

  GetUserDetailDTO(
      {required this.success, required this.message,  required this.userDetail});

  factory GetUserDetailDTO.fromJson(Map<String, dynamic> json) =>
      _$GetUserDetailDTOFromJson(json);

  Map<String, dynamic> toJson() => _$GetUserDetailDTOToJson(this);
}
