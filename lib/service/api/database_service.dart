import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../models/user_model.dart';

class DatabaseService {

  static Future<bool> didLikePost({required String currentUserId, int? postId}) async {
    print(currentUserId);
    print(postId);
    //var response = await http.post(Uri.parse('http://localhost:3000/api/posts'),body: { "postId" : postId, "userId" : currentUserId});
    return true;
  }

  static Future<User> getUserWithId(String username) async {
    var response = await http.get(Uri.parse('http://localhost:3000/api/user/${username}'));
    if (response.body.isNotEmpty) {
       var converted = json.decode(response.body);
       return User.fromJson(converted);
    }
    return User();
  }

}