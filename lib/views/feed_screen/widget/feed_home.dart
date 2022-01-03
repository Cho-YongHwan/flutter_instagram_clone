import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:instagram_clone/models/post_model.dart';
import 'package:instagram_clone/models/user_model.dart';
import 'package:instagram_clone/views/feed_screen/widget/stories_widget.dart';

import '../../../utils/constants.dart';
import '../../common_widtgets/post_view.dart';

class FeedHome extends StatefulWidget {

  final Function() goToCameraScreen;
  final User currentUser;
  final currentUserId;

  FeedHome({Key? key, required this.goToCameraScreen, this.currentUserId, required this.currentUser}) : super(key: key);

  @override
  _FeedHomeState createState() => _FeedHomeState();
}

class _FeedHomeState extends State<FeedHome> {

  List<User> _followingUsersWithStories = [];
  bool _isLoadingFeed = false;
  bool _isLoadingStories = false;
  List<Post> _posts = [];
  User _currentUser = User();

  _setupFeed() async {
    _setupStories();
    print('_setupFeed');

    setState(() => _isLoadingFeed = true);

    var response = await http.get(Uri.parse('http://localhost:3000/api/posts'));
    var converted = json.decode(response.body);

    List<Post> post = [];

    for (var data in converted['list']['content']) {
      print(data);
      post.add(Post.fromJson(data));
    }

    setState(() {
      _posts = post;
      _isLoadingFeed = false;
    });
  }

  void _setupStories() async {
    print("_setupStories");

    setState(() => _isLoadingStories = true);

    var response = await http.get(Uri.parse('http://localhost:3000/api/users'));

    if (!mounted) return;

    var converted = json.decode(response.body);

    List<User> followingUsers = [];

    for (var data in converted) {
      followingUsers.add(User.fromJson(data));
    }

    _currentUser = widget.currentUser; //Provider.of<UserData>(context, listen: false).currentUser;

    setState(() => _isLoadingStories = false);
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _setupFeed();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: !_isLoadingFeed
          ? RefreshIndicator(
        // If posts finished loading
        onRefresh: () => _setupFeed(),
        child: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Column(
            children: [
              _isLoadingStories
                ? Container(
                  height: 88,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
                : StoriesWidget(
                    users : _followingUsersWithStories,
                    goToCameraScreen : widget.goToCameraScreen,
                    currentUser : _currentUser
                ),
              SizedBox(height: 5),
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: _posts.length > 0 ? _posts.length : 1,
                itemBuilder: (BuildContext context, int index) {
                  if (_posts.length == 0) {
                    //If there is no posts
                    return Container(
                      height: MediaQuery.of(context).size.height,
                      child: Center(
                        child:
                        Text('No posts found, Start following users'),
                      ),
                    );
                  }

                  Post post = _posts[index];

                  return PostView(
                    postStatus: PostStatus.feedPost,
                    currentUserId: widget.currentUserId.toString(),
                    post: post,
                  );
                },
              ),
            ],
          ),
        ),
      )
          : Center(
        // If posts is loading
        child: CircularProgressIndicator(),
      ),
    );
  }
}
