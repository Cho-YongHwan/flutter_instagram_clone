import 'package:flutter/material.dart';
import 'package:instagram_clone/models/post_model.dart';
import 'package:instagram_clone/models/story_model.dart';
import 'package:instagram_clone/models/user_data.dart';
import 'package:instagram_clone/service/api/stories_service.dart';
import 'package:instagram_clone/utils/common_utils.dart';
import 'package:instagram_clone/utils/constants.dart';
import 'package:instagram_clone/views/common_widtgets/post_view.dart';
import 'package:instagram_clone/views/feed_screen/widget/stories_widget.dart';
import 'package:provider/provider.dart';
import '../../models/user_model.dart';
import '../../service/api/database_service.dart';


class FeedScreen extends StatefulWidget {
  static const String id = 'feed_screen';
  final int currentUserId;
  final Function goToDirectMessages;
  final Function goToCameraScreen;

  FeedScreen(
      {Key? key, required this.currentUserId, required this.goToDirectMessages, required this.goToCameraScreen}) : super(key: key);

  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {

  List<Post> _posts = [];
  bool _isLoadingFeed = false;
  bool _isLoadingStories = false;
  List<User> _followingUsersWithStories = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _setupFeed();
  }

  _setupFeed() async {
    _setupStories();

    setState(() => _isLoadingFeed = true);
    List<Post> post = await DatabaseService.getAllFeedPosts();
    //List<Post> post = await DatabaseService.getFeedPosts(widget.currentUserId);

    setState(() {
      _posts = post;
      _isLoadingFeed = false;
    });
  }

  _setupStories() async {
    print("_setupStories");

    setState(() => _isLoadingStories = true);
    // User currentUser =
    //     Provider.of<UserData>(context, listen: false).currentUser;
    int currentUserId =
        Provider.of<UserData>(context, listen: false).currentUserId;

    // Get currentUser followingUsers
    List<User> followingUsers =
    await DatabaseService.getUserFollowingUsers(currentUserId);

    if (!mounted) return;

    if (widget.currentUserId != kAdminUId) {
      bool isFollowingAdmin = false;

      for (User user in followingUsers) {
        if (user.id == kAdminUId) {
          isFollowingAdmin = true;
        }
      }
      // if current user doesn't follow admin
      if (!isFollowingAdmin) {
        // get admin stories
        List<Story> adminStories = await StoriesService.getStoriesByUserId(kAdminUId, true);
        if (!mounted) return;
        // if there is admin stories
        if (adminStories.isNotEmpty) {
          // get admin user
          User adminUser = await DatabaseService.getUserWithId(kAdminUId);
          if (!mounted) return;
          // add admin to story circle list
          followingUsers.insert(0, adminUser);
        }
      }
    }

    if (mounted) {
      setState(() {
        _isLoadingStories = false;
        _followingUsersWithStories = followingUsers;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text('Instatgram Clone Coding', ),
        actions: [
          IconButton(
              onPressed: () {
                FlutterToast('게시물 등록은 준비중입니다.');
              },
              icon: Icon(Icons.add_box_outlined)),
          IconButton(
              onPressed: () {
                FlutterToast('활동페이지는 준비중입니다.');
              },
              icon: Icon(Icons.favorite_outline)),
          IconButton(
              onPressed: () {
                FlutterToast('DM 보내기는 준비중입니다.');
              },
              icon: Icon(Icons.send_outlined)),
        ],
      ),
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
                    : StoriesWidget(_followingUsersWithStories,
                      widget.goToCameraScreen
                  ),
                  SizedBox(height: 5),
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: _posts.isNotEmpty ? _posts.length : 1,
                    itemBuilder: (BuildContext context, int index) {
                      if (_posts.isEmpty) {
                        //If there is no posts
                        return SizedBox(
                          height: MediaQuery.of(context).size.height,
                          child: Center(
                            child:
                            Text('No posts found, Start following users'),
                          ),
                        );
                      }

                      Post post = _posts[index];

                      return FutureBuilder(
                        future: DatabaseService.getUserWithId(post.userId!),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (!snapshot.hasData) {
                            return SizedBox.shrink();
                          }

                          User author = snapshot.data;

                          return PostView(
                            postStatus: PostStatus.feedPost,
                            currentUserId: widget.currentUserId,
                            author: author,
                            post: post,
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          )
        : Center(
         child: CircularProgressIndicator(),
        ),
    );
  }
}
