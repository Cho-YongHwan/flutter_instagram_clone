// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Story _$StoryFromJson(Map<String, dynamic> json) => Story(
      id: json['id'] as String?,
      username: json['username'] as String?,
      imageUrl: json['imageUrl'] as String?,
      caption: json['caption'] as String?,
      location: json['location'] as String?,
      filter: json['filter'] as String?,
      linkUrl: json['linkUrl'] as String?,
      duration: json['duration'] as int?,
      timeEnd: json['timeEnd'] as String?,
      timeStart: json['timeStart'] as String?,
    );

Map<String, dynamic> _$StoryToJson(Story instance) => <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'imageUrl': instance.imageUrl,
      'caption': instance.caption,
      'location': instance.location,
      'filter': instance.filter,
      'linkUrl': instance.linkUrl,
      'duration': instance.duration,
      'timeEnd': instance.timeEnd,
      'timeStart': instance.timeStart,
    };
