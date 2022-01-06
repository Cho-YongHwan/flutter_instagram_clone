import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:auto_direction/auto_direction.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:instagram_clone/inc/style/theme.dart';
import 'package:instagram_clone/models/comment_model.dart';
import 'package:instagram_clone/models/post_model.dart';
import 'package:instagram_clone/models/user_data.dart';
import 'package:instagram_clone/models/user_model.dart';
import 'package:instagram_clone/service/api/database_service.dart';
import 'package:instagram_clone/utils/constants.dart';
import 'package:instagram_clone/utils/custom_navigation.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class CommentsScreen extends StatefulWidget {
  final Post post;
  final int likeCount;
  final User author;
  final PostStatus postStatus;

  CommentsScreen(
      {Key? key, required this.post, required this.likeCount, required this.author, required this.postStatus}) : super(key: key);

  @override
  _CommentsScreenState createState() => _CommentsScreenState();
}

_goToUserProfile(BuildContext context, Comment comment, int currentUserId) {
  CustomNavigation.navigateToUserProfile(
      context: context,
      currentUserId: currentUserId,
      userId: comment.userId!,
      isCameFromBottomNavigation: false);
}

class _CommentsScreenState extends State<CommentsScreen> {

  final TextEditingController _commentController = TextEditingController();
  bool _isCommenting = false;

  final StreamController<List<Comment>> _streamController = StreamController<List<Comment>>();

  Timer? _timer;

  Future getComment() async {
    var response = await http.get(Uri.parse('http://localhost:3000/api/post/comment/${widget.post.id}'));

    List<Comment> _commnets = [];

    if (response.statusCode == 200) {
      if (response.body.isNotEmpty) {
        var converted = json.decode(utf8.decode(response.bodyBytes));
        for (var data in converted['list']['content']) {
          Comment comment = Comment.fromJson(data);
          _commnets.add(comment);
        }
      }
    } else {
      throw Exception('Failed to GetUserWithId');
    }
    _streamController.add(_commnets);
  }

  Future moerComment() async {
    var response = await http.get(Uri.parse('http://localhost:3000/api/post/comment/${widget.post.id}?page=1'));

    List<Comment> _commnets = [];

    if (response.statusCode == 200) {
      if (response.body.isNotEmpty) {
        var converted = json.decode(utf8.decode(response.bodyBytes));
        for (var data in converted['list']['content']) {
          Comment comment = Comment.fromJson(data);
          _commnets.add(comment);
        }
      }
    } else {
      throw Exception('Failed to GetUserWithId');
    }

    _streamController.add(_commnets);
  }

  @override
  void initState() {
    getComment();
    //Check the server every 5 seconds
    _timer = Timer.periodic(Duration(seconds: 20), (timer) => getComment());
    super.initState();
  }

  @override
  void dispose() {
    //cancel the timer
    if (_timer!.isActive) _timer!.cancel();
    super.dispose();
  }

  List<User> _commentUserList = [];

  _buildComment(Comment comment, int currentUserId) {

    bool _isGetUserWithId = true;

    User _user = User();
    for (User data in _commentUserList) {
      if (data.id == comment.userId) {
        _isGetUserWithId = false;
        _user = data;
        break;
      }
    }

    return !_isGetUserWithId
      ? FutureBuilder(
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            return _buildListTile(context, _user, comment, currentUserId);
        }
      )
      : FutureBuilder(
          future: DatabaseService.getUserWithId(comment.userId!),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return SizedBox.shrink();
            }

            bool _isAddUserList = true;
            User author = snapshot.data;

            for (User data in _commentUserList) {
              if (data.id == author.id) {
                _isAddUserList = false;
                break;
              }
            }

            if (_isAddUserList) _commentUserList.add(author);

            return _buildListTile(context, author, comment, currentUserId);
          },
      );
  }

  _buildListTile(BuildContext context, User author, Comment comment,
      int currentUserId) {
    return ListTile(
      leading: GestureDetector(
        onTap: () => _goToUserProfile(context, comment, currentUserId),
        child: CircleAvatar(
          radius: 25.0,
          backgroundColor: Colors.grey,
          backgroundImage: author.profileImageUrl!.isEmpty
              ? AssetImage(placeHolderImageRef)
              : CachedNetworkImageProvider(author.profileImageUrl.toString()) as ImageProvider,
        ),
      ),
      title: GestureDetector(
          onTap: () => _goToUserProfile(context, comment, currentUserId),
          child: Row(
            children: [
              Text(
                author.username.toString(),
                style: kFontWeightBoldTextStyle,
              ),
              //UserBadges(user: widget.author, size: 15)
            ],
          )),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 6.0,
          ),
          Text(comment.content.toString()),
          SizedBox(
            height: 6.0,
          ),
          Text(timeago.format(DateTime.parse(comment.createdAt.toString()), locale: 'ko')),
        ],
      ),
    );
  }

  _buildCommentTF() {
    String hintText;
    if (widget.postStatus == PostStatus.feedPost) {

      if (widget.post.commentsAllowed!) {
        hintText = '댓글 달기...';
      } else {
        hintText = '여기에는 댓글이 허용되지 않습니다....';
      }
    } else if (widget.postStatus == PostStatus.archivedPost) {
      hintText = 'This post was archived...';
    } else {
      hintText = 'This post was deleted...';
    }
    final currentUserId = Provider.of<UserData>(context, listen: false).currentUserId;
    final profileImageUrl = Provider.of<UserData>(context, listen: false).currentUser.profileImageUrl;

    return IconTheme(
      data: IconThemeData(
        color: _isCommenting
            ? Theme.of(context).colorScheme.secondary
            : Theme.of(context).disabledColor,
      ),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            profileImageUrl != null
                ? CircleAvatar(
                    radius: 18.0,
                    backgroundColor: Colors.grey,
                    backgroundImage: profileImageUrl.isEmpty
                        ? AssetImage(placeHolderImageRef)
                        : CachedNetworkImageProvider(profileImageUrl) as ImageProvider,
                  )
                : SizedBox.shrink(),
            SizedBox(width: 20.0),
            Expanded(
              child: AutoDirection(
                text: _commentController.text,
                child: TextField(
                  enabled: widget.post.commentsAllowed == true &&
                      widget.postStatus == PostStatus.feedPost,
                  controller: _commentController,
                  textCapitalization: TextCapitalization.sentences,
                  onChanged: (comment) {
                    setState(() {
                      _isCommenting = comment.length > 0;
                    });
                  },
                  decoration: InputDecoration(
                    isCollapsed: true,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    hintText: hintText,
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              child: IconButton(
                icon: Icon(Icons.send),
                onPressed: widget.postStatus != PostStatus.feedPost ||
                        widget.post.commentsAllowed == false
                    ? null
                    : () {
                        if (_isCommenting) {
                          DatabaseService.commentOnPost(
                            currentUserId: currentUserId,
                            post: widget.post,
                            comment: _commentController.text,
                            getComment: getComment
                            //recieverToken: widget.author.token,
                          );
                          _commentController.clear();
                          setState(() {
                            _isCommenting = false;
                          });
                        }
                      },
                //onPressed: () {},
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final int currentUserId =
        Provider.of<UserData>(context, listen: false).currentUserId;

    Comment postDescription = Comment(
        userId: widget.author.id,
        content: widget.post.textcontent,
        id: widget.post.id,
        createdAt: widget.post.createdAt
    );

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).appBarTheme.color,
          title: Text(
            '댓글',
          ),
        ),
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Column(
            children: <Widget>[
              SizedBox(height: 10.0),
              _buildListTile(
                  context, widget.author, postDescription, currentUserId),
              Divider(),
              StreamBuilder<List>(
                stream: _streamController.stream,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  return Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        Comment comment = snapshot.data[index];
                        return _buildComment(comment, currentUserId);
                      },
                    ),
                  );
                },
              ),
              SizedBox(
                child: TextButton(onPressed: () {
                  moerComment();
                }, child: Text('더보기'))
              ),
              Divider(
                height: 1.0,
              ),
              _buildCommentTF(),
            ],
          ),
        ));
  }
}
