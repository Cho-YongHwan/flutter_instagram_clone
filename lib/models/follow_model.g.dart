// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'follow_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Follow _$FollowFromJson(Map<String, dynamic> json) => Follow(
      json['id'] as int?,
      json['userId'] as int?,
      json['followingId'] as int?,
    );

Map<String, dynamic> _$FollowToJson(Follow instance) => <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'followingId': instance.followingId,
    };
