import 'package:cammate/features/mart/domain/entity/mart_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'get_mart_details.g.dart';


@JsonSerializable()
class GetMartDetailDTO {
  final bool success;
  final String message;
  final MartEntity martDetail;

  GetMartDetailDTO(
      {required this.success, required this.message,  required this.martDetail});

  factory GetMartDetailDTO.fromJson(Map<String, dynamic> json) =>
      _$GetMartDetailDTOFromJson(json);

  Map<String, dynamic> toJson() => _$GetMartDetailDTOToJson(this);
}
