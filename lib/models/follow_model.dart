import 'package:json_annotation/json_annotation.dart';

part 'follow_model.g.dart';

@JsonSerializable()
class Follow {
  final int? id;
  final int? userId;
  final int? followingId;

  Follow(this.id, this.userId, this.followingId);

  factory Follow.fromJson(Map<String, dynamic> json) => _$FollowFromJson(json);
  Map<String, dynamic> toJson() => _$FollowToJson(this);

}