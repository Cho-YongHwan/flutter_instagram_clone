import 'dart:convert';

import 'package:instagram_clone/models/post_model.dart';
import 'package:http/http.dart' as http;

import '../../models/story_model.dart';

class StoriesService {

  static Future<bool> didLikePost({int? currentUserId, int? postId}) async {
    var response = await http.post(Uri.parse('http://localhost:3000/api/posts'),body: { "postId" : postId, "userId" : currentUserId});
    return true;
  }

  static Future<List<Story>> getStoriesByUserId(int userId, bool checkDate) async {

    List<Story> userStories = [];
    var response;
    if (checkDate) {
      response = await http.get(Uri.parse('http://localhost:3000/api/story/endTime/${userId}'));
    } else {
      response = await http.get(Uri.parse('http://localhost:3000/api/story/${userId}'));
    }

    if (response.statusCode == 200) {
      if (response.body.isNotEmpty) {
        var converted = json.decode(utf8.decode(response.bodyBytes));
        for (var data in converted) {
          Story story = Story.fromJson(data);
          userStories.add(story);
        }
      }
    } else {
      throw Exception('Failed to GetStoriesByUsername');
    }
    return userStories;
  }
}