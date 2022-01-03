import 'package:flutter/material.dart';
import 'package:instagram_clone/views/feed_screen/widget/story_circle.dart';

import 'package:provider/provider.dart';
import '../../../models/story_model.dart';
import '../../../models/user_data.dart';
import '../../../models/user_model.dart';
import '../../../service/api/stories_service.dart';
import 'blank_story_circle.dart';

class StoriesWidget extends StatefulWidget {
  final List<User> users;
  final Function() goToCameraScreen;
  final User currentUser;
  StoriesWidget({Key? key, required this.users, required this.goToCameraScreen, required this.currentUser}) : super(key: key);

  @override
  _StoriesWidgetState createState() => _StoriesWidgetState();
}

class _StoriesWidgetState extends State<StoriesWidget> {
  bool _isLoading = false;
  List<User> _followingUsers = [];
  List<Story> _stories = [];
  User _currentUser = User();
  bool _isCurrentUserHasStories = false;

  @override
  void initState() {
    super.initState();
    _getStories();
  }

  Future<void> _getStories() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _currentUser = widget.currentUser; //Provider.of<UserData>(context, listen: false).currentUser;
    });

    if (!mounted) return;

    List<User> followingUsersWithStories = [];

    List<Story> stories = [];

    List<Story>? currentUserStories = await StoriesService.getStoriesByUsername(_currentUser.username.toString(), true);

    if (currentUserStories != null) {
      followingUsersWithStories.add(_currentUser);
      stories = currentUserStories;
      if (!mounted) return;
      setState(() => _isCurrentUserHasStories = true);
    }

    for (User user in widget.users) {
      List<Story>? userStories = await StoriesService.getStoriesByUsername(user.username.toString(), true);
      if (!mounted) return;

      if (userStories != null && userStories.isNotEmpty) {
        followingUsersWithStories.add(user);

        for (Story story in userStories) {
          stories.add(story);
        }
      }
    }
    if (!mounted) return;
    setState(() {
      _isLoading = false;
      _followingUsers = followingUsersWithStories;
      _stories = stories;
    });
  }

  @override
  Widget build(BuildContext context) {
    return !_isLoading
        ? Container(
        height: 88.0,
        child: ListView.builder(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.only(left: 5.0),
          scrollDirection: Axis.horizontal,
          itemCount: _isCurrentUserHasStories
              ? _followingUsers.length
              : (_followingUsers.length + 1),
          itemBuilder: (BuildContext context, int index) {
            if (index == 0 && !_isCurrentUserHasStories) {
              return _buildBlankStoryCircle();
            } else if (index > 0 && !_isCurrentUserHasStories) {
              return _buildStoryCircle(index - 1);
            }
            return _buildStoryCircle(index);
          },
        ))
        : Container(
      height: 88,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  BlankStoryCircle _buildBlankStoryCircle() {
    return BlankStoryCircle(
      goToCameraScreen: widget.goToCameraScreen,
      user: _currentUser,
    );
  }

  StoryCircle _buildStoryCircle(int index) {
    User user = _followingUsers[index];
    List<Story> userStories = _stories.where((Story story) => story.username == user.username).toList();

    return StoryCircle(
      currentUserId: _currentUser.username.toString(),
      user: user,
      userStories: userStories,
      size: 60,
    );
  }
}