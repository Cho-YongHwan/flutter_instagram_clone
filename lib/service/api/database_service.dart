import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:instagram_clone/models/follow_model.dart';
import 'package:instagram_clone/models/post_model.dart';

import '../../models/user_model.dart';

class DatabaseService {

  static Future<bool> didLikePost({int? currentUserId, int? postId}) async {

    bool result = false;

    Map data = {"userId": currentUserId, "targetId": postId};

    var body = json.encode(data);
    http.Response response = await http.post(
        Uri.parse('http://localhost:3000/api/post/didLikePost'),
        headers: {"Content-Type": "application/json"},
        body: body
    );

    if (response.statusCode == 200) {
      if (response.body.isNotEmpty) {
        result = true;
      } else {
        result = false;
      }
    } else {
      throw Exception('commentOnPost Failed!!..');
    }

    return result;

  }

  static void likePost({required int currentUserId, required Post post}) async {

    Map data = {"userId": currentUserId, "targetId": post.id, "targetType": 1};

    var body = json.encode(data);
    http.Response response = await http.post(
        Uri.parse('http://localhost:3000/api/post/likePost'),
        headers: {"Content-Type": "application/json"},
        body: body
    );

    if (response.statusCode == 200) {
      // if (response.body.isNotEmpty) {
      //   result = true;
      // } else {
      //   result = false;
      // }
    } else {
      throw Exception('commentOnPost Failed!!..');
    }

    // addActivityItem(
    //   currentUserId: currentUserId,
    //   post: post,
    //   comment: post.caption ?? null,
    //   isFollowEvent: false,
    //   isLikeMessageEvent: false,
    //   isLikeEvent: true,
    //   isCommentEvent: false,
    //   isMessageEvent: false,
    //   recieverToken: receiverToken,
    // );
  }

  static void unlikePost({required int currentUserId, required Post post}) async {

    Map data = {"userId": currentUserId, "targetId": post.id, "targetType": 1};

    var body = json.encode(data);
    http.Response response = await http.post(
        Uri.parse('http://localhost:3000/api/post/unlikePost'),
        headers: {"Content-Type": "application/json"},
        body: body
    );

    if (response.statusCode == 200) {
      // if (response.body.isNotEmpty) {
      //   result = true;
      // } else {
      //   result = false;
      // }
    } else {
      throw Exception('commentOnPost Failed!!..');
    }


    // deleteActivityItem(
    //   comment: null,
    //   currentUserId: currentUserId,
    //   isFollowEvent: false,
    //   post: post,
    //   isCommentEvent: false,
    //   isLikeMessageEvent: false,
    //   isLikeEvent: true,
    //   isMessageEvent: false,
    // );
  }

  // User 정보 가져오기
  static Future<User> getUserWithId(int userId) async {
    var response = await http.get(Uri.parse('http://localhost:3000/api/user/${userId}'));
    if (response.statusCode == 200) {
      if (response.body.isNotEmpty) {
        var converted = json.decode(utf8.decode(response.bodyBytes));
        return User.fromJson(converted);
      }
    } else {
      throw Exception('Failed to GetUserWithId');
    }
    return User(follow: []);
  }

  static Future<List<Post>> getFeedPosts(int userId) async {
    var response = await http.get(Uri.parse('http://localhost:3000/api/posts/${userId}'));

    List<Post> posts = [];

    if (response.statusCode == 200) {
      if (response.body.isNotEmpty) {
        var converted = json.decode(utf8.decode(response.bodyBytes));
        for (var data in converted['list']['content']) {
          Post post = Post.fromJson(data);
          posts.add(post);
        }
      }
    } else {
      throw Exception('Failed to GetFeedPosts ::: userId : ${userId}');
    }
    return posts;

  }

  static Future<List<Post>> getAllFeedPosts() async {
    var response = await http.get(Uri.parse('http://localhost:3000/api/posts'));

    List<Post> posts = [];

    if (response.statusCode == 200) {
      if (response.body.isNotEmpty) {
        var converted = json.decode(utf8.decode(response.bodyBytes));
        for (var data in converted['list']['content']) {
          Post post = Post.fromJson(data);
          posts.add(post);
        }
      }
    } else {
      throw Exception('Failed to getAllFeedPosts');
    }
    return posts;

  }

  static Future<List<User>> getUserFollowingUsers(List<Follow>? follows) async {
    List<User> followingUsers = [];

    for (var data in follows!) {
      User user = await getUserWithId(data.followingId!);
      followingUsers.add(user);
    }
    return followingUsers;
  }

  static void commentOnPost({required int currentUserId, required Post post, required String comment}) async {

    Map data = {"userId": currentUserId, "postId": post.id, "content" : comment};

    var body = json.encode(data);
    http.Response response = await http.post(
      Uri.parse('http://localhost:3000/api/post/comment'),
      headers: {"Content-Type": "application/json"},
      body: body
    );

    if (response.statusCode == 200) {
      print('commentOnPost success!!..');
    } else {
      throw Exception('commentOnPost Failed!!..');
    }

  }
  //
  // static Future<List<String>> getUserFollowingIds(String username) async {
  //
  //   var response = await http.get(Uri.parse('http://localhost:3000/api/follow/${username}'));
  //
  //   List<String> following = [];
  //
  //   if (response.statusCode == 200) {
  //     if (response.body.isNotEmpty) {
  //       var converted = json.decode(utf8.decode(response.bodyBytes));
  //       for (var data in converted) {
  //         following.add(data);
  //       }
  //     }
  //   } else {
  //     throw Exception('Failed to GetUserFollowingIds');
  //   }
  //
  //   return following;
  //
  // }
}