import 'package:json_annotation/json_annotation.dart';

import 'follow_model.dart';

part 'user_model.g.dart';

@JsonSerializable()
class User {
  final int? id;
  final String? username;
  final String? name;
  final String? email;
  final String? password;

  @JsonKey(defaultValue: '')
  final String? bio;
  @JsonKey(defaultValue: '')
  final String? profileImageUrl;
  final String? createdAt;

  final List<Follow> follow;

  User({this.id, this.username, this.name, this.email, this.password, this.bio,
      this.profileImageUrl, this.createdAt, required this.follow});

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
