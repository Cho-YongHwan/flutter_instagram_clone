// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: json['id'] as int?,
      username: json['username'] as String?,
      name: json['name'] as String?,
      email: json['email'] as String?,
      password: json['password'] as String?,
      bio: json['bio'] as String? ?? '',
      profileImageUrl: json['profileImageUrl'] as String? ?? '',
      createdAt: json['createdAt'] as String?,
      follow: (json['follow'] as List<dynamic>)
          .map((e) => Follow.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'name': instance.name,
      'email': instance.email,
      'password': instance.password,
      'bio': instance.bio,
      'profileImageUrl': instance.profileImageUrl,
      'createdAt': instance.createdAt,
      'follow': instance.follow,
    };
