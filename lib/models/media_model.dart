
import 'package:json_annotation/json_annotation.dart';

part 'media_model.g.dart';

@JsonSerializable()
class Media {
  final int? id;
  final String? postId;
  final String? contentType;
  final String? contentUrl;

  Media({this.id, this.postId, this.contentType, this.contentUrl});

  factory Media.fromJson(Map<String, dynamic> json) => _$MediaFromJson(json);
  Map<String, dynamic> toJson() => _$MediaToJson(this);

}
