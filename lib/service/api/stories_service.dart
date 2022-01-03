import 'dart:convert';

import 'package:instagram_clone/models/post_model.dart';
import 'package:http/http.dart' as http;

import '../../models/story_model.dart';

class StoriesService {

  static Future<bool> didLikePost({required String currentUserId, int? postId}) async {
    var response = await http.post(Uri.parse('http://localhost:3000/api/posts'),body: { "postId" : postId, "userId" : currentUserId});
    return true;
  }

  static Future<List<Story>?> getStoriesByUsername(
      String username, bool checkDate) async {

    List<Story> userStories = [];

    var response;

    if (checkDate) {
      response = await http.get(Uri.parse('http://localhost:3000/api/story/${username}'));
    } else {
      response = await http.get(Uri.parse('http://localhost:3000/api/story/${username}'));
    }

    if (response.body.isNotEmpty) {
      var converted = json.decode(response.body);
      for (var data in converted) {
        Story story = Story.fromJson(data);
        userStories.add(story);
      }
      return userStories;
    }
    return null;
  }
}