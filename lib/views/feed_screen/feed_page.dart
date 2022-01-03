import 'package:flutter/material.dart';
import 'package:instagram_clone/utils/common_utils.dart';
import 'package:instagram_clone/views/feed_screen/widget/feed_home.dart';
import '../../models/user_model.dart';
import '../../service/api/database_service.dart';


class FeedPage extends StatefulWidget {
  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {

  User _currentUser = User();
  bool _isLoadingFeed = false;

  void _getCurrentUser() async {
    String currentUserId = 'freddieaddery';
    User currentUser = await DatabaseService.getUserWithId(currentUserId);

    //Provider.of<UserData>(context, listen: false).currentUser = currentUser;

    print('i have the current user now');
    setState(() => _currentUser = currentUser);
  }

  goToCameraScreen () {

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Instatgram Clone Coding'),
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
        ? FeedHome(
          goToCameraScreen : goToCameraScreen,
          currentUserId : _currentUser.username.toString(),
          currentUser : _currentUser
        )
        : Center(
         child: CircularProgressIndicator(),
        ),
    );
  }
}
