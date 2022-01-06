import 'package:instagram_clone/models/user_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chat_model.g.dart';

@JsonSerializable()
class Chat {
  final int? id;
  final String? recentMessage;
  final String? recentSender;
  final String? recentCreatedAt;
  final List<dynamic>? memberIds;
  final List<User>? memberInfo;
  final dynamic readStatus;

  Chat({this.id, this.recentMessage, this.recentSender, this.recentCreatedAt,
      this.memberIds, this.memberInfo, this.readStatus});

  factory Chat.fromJson(Map<String, dynamic> json) => _$ChatFromJson(json);
  Map<String, dynamic> toJson() => _$ChatToJson(this);
}
