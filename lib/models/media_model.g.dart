// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Media _$MediaFromJson(Map<String, dynamic> json) => Media(
      id: json['id'] as int?,
      postId: json['postId'] as int?,
      contentType: json['contentType'] as String?,
      contentUrl: json['contentUrl'] as String?,
    );

Map<String, dynamic> _$MediaToJson(Media instance) => <String, dynamic>{
      'id': instance.id,
      'postId': instance.postId,
      'contentType': instance.contentType,
      'contentUrl': instance.contentUrl,
    };
