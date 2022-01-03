// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Post _$PostFromJson(Map<String, dynamic> json) => Post(
      id: json['id'] as int?,
      userId: json['userId'] as String?,
      textcontent: json['textcontent'] as String?,
      createdAt: json['createdAt'] as String?,
      commentsAllowed: json['commentsAllowed'] as bool?,
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      media: (json['media'] as List<dynamic>)
          .map((e) => Media.fromJson(e as Map<String, dynamic>))
          .toList(),
      comment: (json['comment'] as List<dynamic>)
          .map((e) => Comment.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PostToJson(Post instance) => <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'textcontent': instance.textcontent,
      'createdAt': instance.createdAt,
      'commentsAllowed': instance.commentsAllowed,
      'user': instance.user,
      'media': instance.media,
      'comment': instance.comment,
    };
