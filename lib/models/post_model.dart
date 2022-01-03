import 'package:instagram_clone/models/comment_model.dart';
import 'package:instagram_clone/models/media_model.dart';
import 'package:instagram_clone/models/user_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'post_model.g.dart';

@JsonSerializable()
class Post {
  final int? id;
  final String? userId;
  final String? textcontent;
  final String? createdAt;
  final bool? commentsAllowed;

  final User user;

  final List<Media> media;
  final List<Comment> comment;

  Post({this.id, this.userId, this.textcontent, this.createdAt, this.commentsAllowed, required this.user, required this.media, required this.comment});

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);

  int get likeCount => media.length;

  get comments => comment.length;

  Map<String, dynamic> toJson() => _$PostToJson(this);
}
