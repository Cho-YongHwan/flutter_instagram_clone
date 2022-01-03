import 'package:json_annotation/json_annotation.dart';

part 'story_model.g.dart';

@JsonSerializable()
class Story {
  final String? id;
  final String? username;
  final String? imageUrl;
  final String? caption;
  final String? location;
  final String? filter;
  final String? linkUrl;
  final int? duration;
  final String? timeEnd;
  final String? timeStart;


  Story({this.id, this.username, this.imageUrl, this.caption, this.location,
      this.filter, this.linkUrl, this.duration, this.timeEnd, this.timeStart});

  factory Story.fromJson(Map<String, dynamic> json) => _$StoryFromJson(json);
  Map<String, dynamic> toJson() => _$StoryToJson(this);
}
