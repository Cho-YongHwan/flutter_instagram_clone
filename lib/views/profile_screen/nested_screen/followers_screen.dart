import 'dart:html';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:instagram_clone/models/user_model.dart';
import 'package:instagram_clone/service/api/database_service.dart';
import 'package:instagram_clone/utils/constants.dart';
import 'package:instagram_clone/utils/custom_navigation.dart';
import 'package:instagram_clone/views/common_widtgets/UserBadges.dart';

import 'package:intl/intl.dart';

class FollowersScreen extends StatefulWidget {
  final User? user;
  final int? followersCount;
  final int? followingCount;
  final int? selectedTab; // 0 - Followers / 1 - Following
  final int? currentUserId;
  final Function updateFollowersCount;
  final Function updateFollowingCount;

  FollowersScreen(
      {this.user,
      this.followersCount,
      this.followingCount,
      this.selectedTab,
      this.currentUserId,
      required this.updateFollowersCount,
      required this.updateFollowingCount});

  @override
  _FollowersScreenState createState() => _FollowersScreenState();
}

class _FollowersScreenState extends State<FollowersScreen> {
  List<User> _userFollowers = [];
  List<User> _userFollowing = [];
  bool _isLoading = false;
  List<bool> _userFollowsState = [];
  List<bool> _userFollowersState = [];
  List<bool> _userFollowingState = [];
  int _followingCount = 0;
  int _followersCount = 0;

  @override
  void initState() {
    super.initState();
    setState(() {
      _followersCount = widget.followersCount!;
      _followingCount = widget.followingCount!;
    });
    _setupAll();
  }

  _setupAll() async {
    setState(() {
      _isLoading = true;
    });
    await _setupFollowers();
    await _setupFollowing();
    setState(() {
      _isLoading = false;
    });
  }

  Future _setupFollowers() async {
    List<User> userFollowers = [];
    List<bool> userFollowersState = [];


    List userFollowersIds =
        await DatabaseService.getUserFollowersIds(widget.user!.id!);

    List userFollowingIds =
        await DatabaseService.getUserFollowingIds(widget.user!.id!);

    for (int userId in userFollowersIds) {
      User user = await DatabaseService.getUserWithId(userId);
      bool _followersState = false;
      for (int followingId in userFollowingIds) {
        if (followingId == userId) {
          _followersState = true;
          break;
        }
      }
      userFollowersState.add(_followersState);
      userFollowers.add(user);
    }

    setState(() {
      _userFollowersState = userFollowersState;
      _userFollowers = userFollowers;
      _followersCount = userFollowers.length;
      if (_followersCount != widget.followersCount) {
        widget.updateFollowersCount(_followersCount);
      }
    });
  }

  Future _setupFollowing() async {
    List<bool> userFollowingState = [];
    List<bool> userFollowsState = [];
    List<User> userFollowing =
    await DatabaseService.getUserFollowingUsers(widget.user!.id!);

    List userFollowerIds =
    await DatabaseService.getUserFollowersIds(widget.user!.id!);

    for (User user in userFollowing) {
      bool _followingState = false;
      for (int userId in userFollowerIds) {
        if (userId == user.id) {
          _followingState = true;
          break;
        }
      }
      userFollowsState.add(true);
      userFollowingState.add(_followingState);
    }

    setState(() {
      _userFollowsState = userFollowsState;
      _userFollowingState = userFollowingState;
      _userFollowing = userFollowing;
      _followingCount = userFollowing.length;
      if (_followingCount != widget.followingCount) {
        widget.updateFollowingCount(_followingCount);
      }
    });
  }

  _removeFollowerDialog(User user, int index) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return Wrap(
          children: [
            ListTile(
              leading: CircleAvatar(
                radius: 25.0,
                backgroundColor: Colors.grey,
                backgroundImage: user.profileImageUrl!.isEmpty
                    ? AssetImage(placeHolderImageRef)
                    : CachedNetworkImageProvider(user.profileImageUrl.toString()) as ImageProvider,
              ),
              title: Text('팔로워를 삭제하시겠어요?',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              ),
              subtitle: Text('${user.username.toString()}님은 회원님을 팔로워 리스트에서 삭제된 사실을 알 수 없습니다.',
                  style: TextStyle(fontSize: 13)
              ),
            ),
            Divider(height: 1),
            SizedBox(
              height: 40,
              child: TextButton(
                child: Text('삭제', style: TextStyle(color: Colors.red, fontSize: 16)),
                onPressed: () {
                  // Unfollow User
                  // 팔로워에서 삭제를 누를경우기때문에 followingId와 userId 넘기는값은 반대로 해야 한다.
                  DatabaseService.unfollowUser(
                      userId: user.id, followingId: widget.currentUserId);
                  setState(() {
                    _userFollowers.removeAt(index);
                    _followersCount--;
                  });
                  widget.updateFollowersCount(_followingCount);
                  Navigator.pop(context);
                }
              ),
            ),
          ],
        );
      },
    );
  }

  _buildFollowerButton(User user, int index) {
    return OutlinedButton(
      onPressed: () {
        _removeFollowerDialog(user, index);
      },
      child: Text('삭제',
        style: TextStyle(
            color: Theme.of(context).colorScheme.secondary
        ),
      ),
    );
  }

  _goToUserProfile(BuildContext context, User user) {
    CustomNavigation.navigateToUserProfile(
        context: context,
        currentUserId: widget.currentUserId,
        userId: user.id,
        isCameFromBottomNavigation: false);
  }

  _buildFollower(User user, int index) {
    return ListTile(
      leading: CircleAvatar(
        radius: 25.0,
        backgroundColor: Colors.grey,
        backgroundImage: user.profileImageUrl!.isEmpty
            ? AssetImage(placeHolderImageRef)
            : CachedNetworkImageProvider(user.profileImageUrl.toString()) as ImageProvider,
      ),
      title: Row(
        children: [
          Text(user.username.toString()),
          _userFollowersState[index] == false
          ? TextButton(
              onPressed: () {},
              child: Text('팔로우',
              style: TextStyle(fontSize: 14),
              ),
          )
          : SizedBox.shrink(),
          //UserBadges(user: user, size: 15),
        ],
      ),
      subtitle: Text(user.name.toString()),
      trailing: widget.user!.id == widget.currentUserId
          ? _buildFollowerButton(user, index)
          : SizedBox.shrink(),
      onTap: () => _goToUserProfile(context, user),
    );
  }

  _buildFollowingButton(User user, int index) {
    return _userFollowsState[index] == true
      ? OutlinedButton(
          onPressed: () {
            // Unfollow User
            DatabaseService.unfollowUser(userId: widget.currentUserId, followingId: user.id);
            setState(() {
              _userFollowsState[index] = false;
              _followingCount--;
            });
            widget.updateFollowingCount(_followingCount);
          },
          child: Text('팔로잉',
            style: TextStyle(
              color: Theme.of(context).colorScheme.secondary
            ),
          )
      )
      : ElevatedButton(
          onPressed: () {
            // Follow User
            DatabaseService.followUser(userId: widget.currentUserId,followingId: user.id,
            //    receiverToken: user.token
            );
            setState(() {
              _userFollowsState[index] = true;
              _followingCount++;
            });
            widget.updateFollowingCount(_followingCount);
          },
          child: Text('팔로우',
            style: TextStyle(
                color: Theme.of(context).primaryColor
            ),
          )
      );
  }

  _buildFollowing(User user, int index) {
    return ListTile(
      leading: CircleAvatar(
        radius: 25.0,
        backgroundColor: Colors.grey,
        backgroundImage: user.profileImageUrl!.isEmpty
            ? AssetImage(placeHolderImageRef)
            : CachedNetworkImageProvider(user.profileImageUrl.toString()) as ImageProvider,
      ),
      title: Row(
        children: [
          Text(user.username.toString()),
          !_userFollowingState[index]
              ? Image.asset(
                  'images/verified_user_badge.png',
                  height: 10,
                  width: 10,
              )
              : SizedBox.shrink(),
          //UserBadges(user: user, size: 15),
        ],
      ),
      subtitle: Text(user.name.toString()),
      trailing:widget.user!.id == widget.currentUserId
          ? _buildFollowingButton(user, index)
          : SizedBox.shrink(),
      onTap: () => _goToUserProfile(context, user),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: widget.selectedTab!,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: Theme.of(context).appBarTheme.color,
            title: Row(
              children: [
                Text(widget.user!.username.toString()),
                //UserBadges(user: widget.user, size: 15),
              ],
            ),
            bottom: TabBar(
              tabs: [
                Tab(
                  text:
                      '팔로워 ${NumberFormat.compact().format(_followersCount)}명',
                ),
                Tab(
                  text:
                      '팔로잉 ${NumberFormat.compact().format(_followingCount)}명',
                ),
              ],
            )),
        body: !_isLoading
            ? TabBarView(
                children: [
                  RefreshIndicator(
                    onRefresh: () async {
                      setState(() {
                        _isLoading = true;
                      });
                      await _setupFollowers();
                      setState(() {
                        _isLoading = false;
                      });
                    },
                    child: ListView.builder(
                      itemCount: _userFollowers.length,
                      itemBuilder: (BuildContext context, int index) {
                        User follower = _userFollowers[index];
                        return _buildFollower(follower, index);
                      },
                    ),
                  ),
                  RefreshIndicator(
                    onRefresh: () async {
                      setState(() {
                        _isLoading = true;
                      });
                      await _setupFollowing();
                      setState(() {
                        _isLoading = false;
                      });
                    },
                    child: ListView.builder(
                      itemCount: _userFollowing.length,
                      itemBuilder: (BuildContext context, int index) {
                        User follower = _userFollowing[index];
                        return _buildFollowing(follower, index);
                      },
                    ),
                  ),
                ],
              )
            : Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
