// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Chat _$ChatFromJson(Map<String, dynamic> json) => Chat(
      id: json['id'] as int?,
      recentMessage: json['recentMessage'] as String?,
      recentSender: json['recentSender'] as String?,
      recentCreatedAt: json['recentCreatedAt'] as String?,
      memberIds: json['memberIds'] as List<dynamic>?,
      memberInfo: (json['memberInfo'] as List<dynamic>?)
          ?.map((e) => User.fromJson(e as Map<String, dynamic>))
          .toList(),
      readStatus: json['readStatus'],
    );

Map<String, dynamic> _$ChatToJson(Chat instance) => <String, dynamic>{
      'id': instance.id,
      'recentMessage': instance.recentMessage,
      'recentSender': instance.recentSender,
      'recentCreatedAt': instance.recentCreatedAt,
      'memberIds': instance.memberIds,
      'memberInfo': instance.memberInfo,
      'readStatus': instance.readStatus,
    };
