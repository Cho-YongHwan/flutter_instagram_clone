// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Comment _$CommentFromJson(Map<String, dynamic> json) => Comment(
      id: json['id'] as int?,
      postId: json['postId'] as int?,
      userId: json['userId'] as int?,
      content: json['content'] as String?,
      createdAt: json['createdAt'] as String?,
    );

Map<String, dynamic> _$CommentToJson(Comment instance) => <String, dynamic>{
      'id': instance.id,
      'postId': instance.postId,
      'userId': instance.userId,
      'content': instance.content,
      'createdAt': instance.createdAt,
    };
