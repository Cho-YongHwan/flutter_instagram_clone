import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/service/api/database_service.dart';
import 'package:instagram_clone/views/common_widtgets/heart_anime.dart';
import 'package:ionicons/ionicons.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../inc/style/theme.dart';
import '../../models/post_model.dart';
import '../../utils/constants.dart';

class PostView extends StatefulWidget {
  final String currentUserId;
  final Post post;
  final PostStatus postStatus;

  PostView(
      {required this.currentUserId, required this.post, required this.postStatus});

  @override
  _PostViewState createState() => _PostViewState();
}

class _PostViewState extends State<PostView> {
  int _likeCount = 0;
  bool _isLiked = false;
  bool _heartAnim = false;
  late Post _post;

  @override
  void initState() {
    super.initState();
    _likeCount = widget.post.likeCount;
    _post = widget.post;
    _initPostLiked();
  }

  @override
  didUpdateWidget(PostView oldWidget) {
    // super.didUpdateWidget(oldWidget);
    // if (oldWidget.post.likeCount != _post.likeCount) {
    //   _likeCount = widget.post.likeCount;
    // }
  }

  _goToUserProfile(BuildContext context, Post post) {
    // CustomNavigation.navigateToUserProfile(
    //     context: context,
    //     currentUserId: widget.currentUserId,
    //     userId: post.authorId,
    //     isCameFromBottomNavigation: false);
  }

  _initPostLiked() async {
    bool isLiked = await DatabaseService.didLikePost(
        currentUserId: widget.currentUserId, postId: _post.id);

    if (mounted) {
      setState(() {
        _isLiked = isLiked;
      });
    }
  }

  _likePost() {
    // if (_isLiked) {
    //   // Unlike Post
    //   DatabaseService.unlikePost(
    //       currentUserId: widget.currentUserId, post: _post);
    //   setState(() {
    //     _isLiked = false;
    //     _likeCount--;
    //   });
    // } else {
    //   // Like Post
    //   DatabaseService.likePost(
    //       currentUserId: widget.currentUserId,
    //       post: _post,
    //       receiverToken: widget.author.token);
    //   setState(() {
    //     _heartAnim = true;
    //     _isLiked = true;
    //     _likeCount++;
    //   });
    //   Timer(Duration(milliseconds: 350), () {
    //     setState(() {
    //       _heartAnim = false;
    //     });
    //   });
    // }
  }

  _goToHomeScreen(BuildContext context) {
    //TODO 홈 화면으로 이동 작업
    // Navigator.pushAndRemoveUntil(
    //   context,
    //   MaterialPageRoute(
    //       builder: (_) => HomeScreen(
    //         currentUserId: widget.currentUserId,
    //       )),
    //       (Route<dynamic> route) => false,
    // );
  }

  _showMenuDialog() {
    return Platform.isIOS ? _iosBottomSheet() : _androidDialog();
  }

  _saveAndShareFile() async {
    // final RenderBox box = context.findRenderObject();
    //
    // var response = await get(widget.post.imageUrl);
    // final documentDirectory = (await getExternalStorageDirectory()).path;
    // File imgFile = new File('$documentDirectory/${widget.post.id}.png');
    // imgFile.writeAsBytesSync(response.bodyBytes);
    //
    // Share.shareFiles([imgFile.path],
    //     subject: 'Have a look at ${widget.author.name} post!',
    //     text: '${widget.author.name} : ${widget.post.caption}',
    //     sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }

  _iosBottomSheet() {
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          return CupertinoActionSheet(
            title: Text('Add Photo'),
            actions: <Widget>[
              CupertinoActionSheetAction(
                onPressed: () {},
                child: Text('Take Photo'),
              ),
              CupertinoActionSheetAction(
                onPressed: () {},
                child: Text('Choose From Gallery'),
              )
            ],
            cancelButton: CupertinoActionSheetAction(
              child: Text(
                'Cancel',
                style: kFontColorRedTextStyle,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          );
        });
  }

  _androidDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            // title: Text('Add Photo'),
            children: <Widget>[
              SimpleDialogOption(
                child: Text('Share Post'),
                onPressed: () {
                  _saveAndShareFile();
                  Navigator.pop(context);
                },
              ),
              _post.user.username == widget.currentUserId &&
                  widget.postStatus != PostStatus.archivedPost
                  ? SimpleDialogOption(
                child: Text('Archive Post'),
                onPressed: () {
                  //TODO archivePost 등록
                  // DatabaseService.archivePost(
                  //     widget.post, widget.postStatus);
                  // _goToHomeScreen(context);
                },
              )
                  : SizedBox.shrink(),
              _post.user.username == widget.currentUserId &&
                  widget.postStatus != PostStatus.deletedPost
                  ? SimpleDialogOption(
                child: Text('Delete Post'),
                onPressed: () {
                  //TODO deletePost
                  // DatabaseService.deletePost(_post, widget.postStatus);
                  // _goToHomeScreen(context);
                },
              )
                  : SizedBox.shrink(),
              _post.user.username == widget.currentUserId &&
                  widget.postStatus != PostStatus.feedPost
                  ? SimpleDialogOption(
                child: Text('Show on profile'),
                onPressed: () {
                  //TODO recreatePost
                  // DatabaseService.recreatePost(_post, widget.postStatus);
                  // _goToHomeScreen(context);
                },
              )
                  : SizedBox.shrink(),

              _post.user.username == widget.currentUserId
                  ? SimpleDialogOption(
                child: Text('Edit Post'),
                onPressed: () {
                  //TODO CreatePostScreen
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (_) => CreatePostScreen(
                  //       post: _post,
                  //       postStatus: widget.postStatus,
                  //     ),
                  //   ),
                  // );
                },
              )
                  : SizedBox.shrink(),
              _post.user.username == widget.currentUserId &&
                  widget.postStatus == PostStatus.feedPost
                  ? SimpleDialogOption(
                child: Text(!_post.commentsAllowed!
                    ? 'Turn off commenting'
                    : 'Allow comments'),
                onPressed: () {
                  //TODO allowDisAllowPostComments
                  // DatabaseService.allowDisAllowPostComments(
                  //     _post, !_post.commentsAllowed);
                  // Navigator.pop(context);
                  // setState(() {
                  //   _post = new Post(
                  //       authorId: widget.post.authorId,
                  //       caption: widget.post.caption,
                  //       commentsAllowed: !_post.commentsAllowed,
                  //       id: _post.id,
                  //       imageUrl: _post.imageUrl,
                  //       likeCount: _post.likeCount,
                  //       location: _post.location,
                  //       timestamp: _post.timestamp);
                  // });
                },
              )
                  : SizedBox.shrink(),
              // SimpleDialogOption(
              //   child: Text('Download Image'),
              //   onPressed: () async {
              //     await ImageDownloader.downloadImage(
              //       _post.imageUrl,
              //       outputMimeType: "image/jpg",
              //     );
              //     Navigator.pop(context);
              //   },
              // ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          child: ListTile(
            leading: GestureDetector(
              onTap: () => _goToUserProfile(context, _post),
              child: CircleAvatar(
                backgroundColor: Colors.grey,
                backgroundImage:
                _post.user.profileImageUrl!.isEmpty
                    ? AssetImage(placeHolderImageRef)
                    : CachedNetworkImageProvider(_post.user.profileImageUrl.toString()) as ImageProvider,
              ),
            ),
            title: GestureDetector(
              onTap: () => _goToUserProfile(context, _post),
              child: Row(
                children: [
                  Text(
                    _post.user.name.toString(),
                    style: kFontSize18FontWeight600TextStyle,
                  ),
                  //TODO UserBadges 분석후에 수정
                  //UserBadges(user: _post.user, size: 15)
                ],
              ),
            ),
            //subtitle: _post.location.isNotEmpty ? Text(_post.location) : null,
            trailing: IconButton(
                icon: Icon(Icons.more_vert), onPressed: _showMenuDialog),
          ),
        ),
        GestureDetector(
          onDoubleTap: widget.postStatus == PostStatus.feedPost ? _likePost : () {},
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Container(
                  height: MediaQuery.of(context).size.width,
                  child: CachedNetworkImage(
                      fadeInDuration: Duration(milliseconds: 500),
                      imageUrl: _post.media[0].contentUrl.toString())),
              _heartAnim ? HeartAnime(100.0) : SizedBox.shrink(),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: [
                      IconButton(
                        icon: _isLiked
                            ? Icon(
                                Ionicons.heart_outline,
                                size: 36,
                                color: Colors.red,
                            )
                            : Icon(Ionicons.heart_outline, size: 36),
                        iconSize: 30.0,
                        onPressed: widget.postStatus == PostStatus.feedPost
                            ? _likePost
                            : () {},
                      ),
                      IconButton(
                        icon: Icon(Ionicons.chatbubble_ellipses_outline),
                        iconSize: 28.0,
                        //TODO 코멘트 스크린 작업해야함
                        onPressed: () {},
                        // onPressed: () => Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (_) => CommentsScreen(
                        //       postStatus: widget.postStatus,
                        //       post: _post,
                        //       likeCount: _likeCount,
                        //       author: widget.author,
                        //     ),
                        //   ),
                        // ),
                      ),
                    ],
                  ),
                  // TODO: Favorire Post
                  // IconButton(
                  //   icon: _isLiked
                  //       ? FaIcon(
                  //           FontAwesomeIcons.solidHeart,
                  //           color: Colors.red,
                  //         )
                  //       : FaIcon(FontAwesomeIcons.heart),
                  //   iconSize: 30.0,
                  //   onPressed: _likePost,
                  // ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Text(
                  '124 Likes',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 4.0),
              Row(
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(
                      left: 12.0,
                      right: 6.0,
                    ),
                    child: GestureDetector(
                      onTap: () => _goToUserProfile(context, _post),
                      child: Row(
                        children: [
                          Text(
                            _post.user.username.toString(),
                            style: TextStyle(
                                fontSize: 16.0, fontWeight: FontWeight.bold),
                          ),
                          //TODO UserBadges 확인후 작업
                          // UserBadges(
                          //     user: _post.user,
                          //     size: 15,
                          //     secondSizedBox: false)
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                      child: Text(
                        _post.textcontent.toString(),
                        style: TextStyle(fontSize: 16.0),
                        overflow: TextOverflow.ellipsis,
                      )),
                ],
              ),
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                child: Text(
                  _post.createdAt.toString(),
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12.0,
                  ),
                ),
              ),
              SizedBox(height: 12.0),
            ],
          ),
        )
      ],
    );
  }
}