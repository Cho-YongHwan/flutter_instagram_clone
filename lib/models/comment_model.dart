import 'package:json_annotation/json_annotation.dart';

part 'comment_model.g.dart';

@JsonSerializable()
class Comment {
  final int? id;
  final int? postId;
  final int? userId;
  final String? content;
  final String? createdAt;

  Comment({this.id, this.postId, this.userId, this.content, this.createdAt});

  factory Comment.fromJson(Map<String, dynamic> json) => _$CommentFromJson(json);
  Map<String, dynamic> toJson() => _$CommentToJson(this);

}