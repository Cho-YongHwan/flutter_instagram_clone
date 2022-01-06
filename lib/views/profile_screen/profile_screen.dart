import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/inc/style/theme.dart';
import 'package:instagram_clone/models/post_model.dart';
import 'package:instagram_clone/models/story_model.dart';
import 'package:instagram_clone/models/user_data.dart';
import 'package:instagram_clone/models/user_model.dart';
import 'package:instagram_clone/service/api/database_service.dart';
import 'package:instagram_clone/service/api/stories_service.dart';
import 'package:instagram_clone/utils/constants.dart';
import 'package:instagram_clone/views/common_widtgets/post_view.dart';
import 'package:instagram_clone/views/feed_screen/widget/blank_story_circle.dart';
import 'package:instagram_clone/views/feed_screen/widget/story_circle.dart';
import 'package:instagram_clone/views/profile_screen/nested_screen/followers_screen.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  final int userId;
  final int currentUserId;
  final Function onProfileEdited;
  final bool isCameFromBottomNavigation;
  final Function goToCameraScreen;

  ProfileScreen({Key? key,
    required this.userId,
    required this.currentUserId,
    required this.onProfileEdited,
    required this.goToCameraScreen,
    required this.isCameFromBottomNavigation,
  }) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isFollowing = false;
  int _followersCount = 0;
  int _followingCount = 0;
  List<Post> _posts = [];
  int _displayPosts = 0; // 0 - grid, 1 - column
  User _profileUser = User();
  List<Story>? _userStories;

  @override
  initState() {
    super.initState();
    _setupUserStories();

    if (widget.userId != widget.currentUserId) {
      _setupIsFollowing();
    }

    _setupFollowers();
    _setupFollowing();
    _setupPosts();
    _setupProfileUser();
  }

  _setupIsFollowing() async {
    bool isFollowingUser = await DatabaseService.isFollowingUser(
      userId: widget.currentUserId,
      followingId: widget.userId,
    );

    if (!mounted) return;
    setState(() {
      _isFollowing = isFollowingUser;
    });
  }

  _setupFollowers() async {
    int userFollowersCount = await DatabaseService.numFollowers(widget.userId);
    if (!mounted) return;
    setState(() {
      _followersCount = userFollowersCount;
    });
  }

  _setupFollowing() async {
    int userFollowingCount = await DatabaseService.numFollowing(widget.userId);
    if (!mounted) return;
    setState(() {
      _followingCount = userFollowingCount;
    });
  }

  _setupPosts() async {
    List<Post> posts = await DatabaseService.getFeedPosts(widget.userId);
    if (!mounted) return;
    setState(() {
      _posts = posts;
    });
  }

  _setupProfileUser() async {
    User profileUser = await DatabaseService.getUserWithId(widget.userId);
    if (!mounted) return;
    setState(() => _profileUser = profileUser);
    if (profileUser.id ==
        Provider.of<UserData>(context, listen: false).currentUserId) {
      //TODO 인증관련 작업해야함
      //AuthService.updateTokenWithUser(profileUser);
      Provider.of<UserData>(context, listen: false).currentUser = profileUser;
    }
  }

  _setupUserStories() async {
    List<Story> userStories =
    await StoriesService.getStoriesByUserId(widget.userId, true);
    if (!mounted) return;

    if (userStories != null) {
      setState(() {
        _userStories = userStories;
      });
    }
  }

  _followOrUnfollow() {
    if (_isFollowing) {
      _unfollowUser();
    } else {
      _followUser();
    }
  }

  _unfollowUser() {
    DatabaseService.unfollowUser(userId: widget.currentUserId, followingId: widget.userId);
    setState(() {
      _isFollowing = false;
      _followersCount--;
    });
  }

  void _followUser() {
    DatabaseService.followUser(userId: widget.currentUserId,followingId: widget.userId,
      //receiverToken: _profileUser.token,
    );
    if (!mounted) return;
    setState(() {
      _isFollowing = true;
      _followersCount++;
    });
  }

  Widget _displayButton(User user) {
    return user.id == widget.currentUserId
      ? SizedBox(
          width: double.infinity,
          child: OutlinedButton(
              onPressed: () {},
              // onPressed: () => Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (_) => EditProfileScreen(
              //         user: user,
              //         updateUser: (User updateUser) {
              //           User updatedUser = User(
              //             id: updateUser.id,
              //             name: updateUser.name,
              //             email: user.email,
              //             profileImageUrl: updateUser.profileImageUrl,
              //             bio: updateUser.bio,
              //             isVerified: updateUser.isVerified,
              //             role: updateUser.role,
              //             website: updateUser.website,
              //           );
              //
              //           setState(() {
              //             Provider.of<UserData>(context, listen: false)
              //                 .currentUser = updatedUser;
              //             _profileUser = updatedUser;
              //           });
              //           //AuthService.updateTokenWithUser(updatedUser);
              //           widget.onProfileEdited();
              //         }),
              //   ),
              // ),
            child: Text('프로필 편집', style: TextStyle(
                color: Theme.of(context).colorScheme.secondary),
            )
          ),
      )
      : Row(
          children: <Widget>[
            Expanded(
              child: _isFollowing
                ? OutlinedButton(
                    onPressed: _followOrUnfollow,
                    child: Text('팔로잉', style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary),
                    )
                )
                : ElevatedButton(
                    onPressed: _followOrUnfollow,
                    child: Text('팔로우', style: TextStyle(
                        color: Theme.of(context).primaryColor),
                    )
                )
            ),
            SizedBox(
              width: 5,
            ),
            Expanded(
              child: OutlinedButton(
                onPressed: () {},
                // onPressed: () => Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (_) => ChatScreen(
                //           receiverUser: _profileUser,
                //         ))),
                child: Text('메시지', style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary),
                ),
              ),
            ),
          ],
      );
  }

  Column _buildProfileInfo(User user) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 0),
          child: Row(
            children: <Widget>[
              // CircleAvatar(
              //   radius: 40.0,
              //   backgroundColor: Colors.grey,
              //   backgroundImage: user.profileImageUrl!.isEmpty
              //       ? AssetImage(placeHolderImageRef)
              //       : CachedNetworkImageProvider(user.profileImageUrl.toString()) as ImageProvider,
              // ),
              SizedBox(
                width: 110,
                height: 110,
                child: _userStories == null
                    ? BlankStoryCircle(
                  user: user,
                  goToCameraScreen: widget.goToCameraScreen,
                  size: 90,
                  showUserName: false,
                )
                    : StoryCircle(
                  userStories: _userStories!,
                  user: _profileUser,
                  currentUserId: widget.currentUserId,
                  showUserName: false,
                  size: 90,
                ),
              ),
              Expanded(
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Text(
                              NumberFormat.compact().format(_posts.length),
                              style: kFontSize18FontWeight600TextStyle,
                            ),
                            Text(
                              '게시물',
                              style: kHintColorStyle(context),
                            )
                          ],
                        ),
                        GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => FollowersScreen(
                                currentUserId: widget.currentUserId,
                                user: user,
                                followersCount: _followersCount,
                                followingCount: _followingCount,
                                selectedTab: 0,
                                updateFollowersCount: (count) {
                                  setState(() => _followersCount = count);
                                },
                                updateFollowingCount: (count) {
                                  setState(() => _followingCount = count);
                                },
                              ),
                            ),
                          ),
                          child: Column(
                            children: <Widget>[
                              Text(
                                NumberFormat.compact().format(_followersCount),
                                style: kFontSize18FontWeight600TextStyle,
                              ),
                              Text(
                                '팔로워',
                                style: kHintColorStyle(context),
                              )
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => FollowersScreen(
                                currentUserId: widget.currentUserId,
                                user: user,
                                followersCount: _followersCount,
                                followingCount: _followingCount,
                                selectedTab: 1,
                                updateFollowersCount: (count) {
                                  setState(() => _followersCount = count);
                                },
                                updateFollowingCount: (count) {
                                  setState(() => _followingCount = count);
                                },
                              ),
                            ),
                          ),
                          child: Column(
                            children: <Widget>[
                              Text(
                                NumberFormat.compact().format(_followingCount),
                                style: kFontSize18FontWeight600TextStyle,
                              ),
                              Text(
                                '팔로잉',
                                style: kHintColorStyle(context),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                user.name.toString(),
                style: kFontSize18FontWeight600TextStyle.copyWith(
                    fontWeight: FontWeight.bold),
              ),
              //TODO 웹사이트 주소 표시 관련 부위
              // if (user.website != '') SizedBox(height: 5.0),
              // if (user.website != '')
              //   GestureDetector(
              //     onTap: () => _goToUrl(user.website),
              //     child: Container(
              //       height: 18,
              //       width: double.infinity,
              //       child: Text(
              //         user.website
              //             .replaceAll('https://', '')
              //             .replaceAll('http://', '')
              //             .replaceAll('www.', ''),
              //         style: kBlueColorTextStyle,
              //       ),
              //     ),
              //   ),
              //TODO 웹사이트 주소 표시 관련 부위
              SizedBox(height: 5.0),
              Text(
                user.bio.toString(),
                style: TextStyle(fontSize: 15.0),
              ),
              SizedBox(height: 10.0),
              _displayButton(user),
            ],
          ),
        )
      ],
    );
  }

  void _goToUrl(String url) async {
    // if (await canLaunch(url)) {
    //   await launch(
    //     url,
    //     forceSafariVC: true,
    //     forceWebView: true,
    //     enableJavaScript: true,
    //   );
    // } else {
    //   ShowErrorDialog.showAlertDialog(
    //       errorMessage: 'Could not launch $url', context: context);
    // }
  }

  Row _buildToggleButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.grid_on),
          iconSize: 30.0,
          color: _displayPosts == 0
              ? Theme.of(context).colorScheme.secondary
              : Theme.of(context).hintColor,
          onPressed: () => setState(() {
            _displayPosts = 0;
          }),
        ),
        IconButton(
          icon: Icon(Icons.list),
          iconSize: 30.0,
          color: _displayPosts == 1
              ? Theme.of(context).colorScheme.secondary
              : Theme.of(context).hintColor,
          onPressed: () => setState(() {
            _displayPosts = 1;
          }),
        )
      ],
    );
  }

  GridTile _buildTilePost(Post post) {
    return GridTile(
        child: GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute<bool>(
              builder: (BuildContext context) {
                return Center(
                  child: Scaffold(
                      appBar: AppBar(
                        title: Text(
                          'Photo',
                        ),
                      ),
                      body: ListView(
                        children: <Widget>[
                          Container(
                            child: PostView(
                              postStatus: PostStatus.feedPost,
                              currentUserId: widget.currentUserId,
                              post: post,
                              author: _profileUser,
                            ),
                          ),
                        ],
                      )),
                );
              },
            ),
          ),
          child: Image(
            image: CachedNetworkImageProvider(post.media[0].contentUrl.toString()),
            fit: BoxFit.cover,
          ),
        ));
  }

  Widget _buildDisplayPosts() {
    if (_displayPosts == 0) {
      // Grid
      List<GridTile> tiles = [];
      _posts.forEach((post) => tiles.add(_buildTilePost(post)));
      return GridView.count(
        crossAxisCount: 3,
        childAspectRatio: 1.0,
        mainAxisSpacing: 2.0,
        crossAxisSpacing: 2.0,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: tiles,
      );
    } else {
      // Column
      List<PostView> postViews = [];
      _posts.forEach((post) {
        postViews.add(PostView(
          postStatus: PostStatus.feedPost,
          currentUserId: widget.currentUserId,
          post: post,
          author: _profileUser,
        ));
      });
      return Column(
        children: postViews,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.color,

        // automaticallyImplyLeading:
        //     widget.userId == widget.currentUserId ? false : true,
        automaticallyImplyLeading:
        widget.isCameFromBottomNavigation ? false : true,

        title: _profileUser != null
            ? Container(
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                child: Text(
                  _profileUser.username.toString(),
                  overflow: TextOverflow.clip,
                ),
              ),
              //UserBadges(user: _profileUser, size: 20),
            ],
          ),
        )
            : SizedBox.shrink(),
      ),
      endDrawer: widget.userId == widget.currentUserId
          ? null //ProfileScreenDrawer(user: _profileUser)
          : null,
      body: FutureBuilder(
        future: DatabaseService.getUserWithId(widget.userId),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          User user = snapshot.data;
          return ListView(
            physics: AlwaysScrollableScrollPhysics(),
            children: <Widget>[
              _buildProfileInfo(user),
              _buildToggleButtons(),
              Divider(color: Theme.of(context).dividerColor),
              _buildDisplayPosts(),
            ],
          );
        },
      ),
    );
  }
}
