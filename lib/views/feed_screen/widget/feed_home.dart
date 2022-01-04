// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:instagram_clone/models/post_model.dart';
// import 'package:instagram_clone/models/story_model.dart';
// import 'package:instagram_clone/models/user_model.dart';
// import 'package:instagram_clone/service/api/database_service.dart';
// import 'package:instagram_clone/service/api/stories_service.dart';
// import 'package:instagram_clone/views/feed_screen/widget/stories_widget.dart';
//
// import '../../../utils/constants.dart';
// import '../../common_widtgets/post_view.dart';
//
// class FeedHome extends StatefulWidget {
//
//   final Function() goToCameraScreen;
//   final User? currentUser;
//   final currentUserId;
//
//   FeedHome({Key? key, required this.goToCameraScreen, this.currentUserId, this.currentUser}) : super(key: key);
//
//   @override
//   _FeedHomeState createState() => _FeedHomeState();
// }
//
// class _FeedHomeState extends State<FeedHome> {
//
//   List<User> _followingUsersWithStories = [];
//   bool _isLoadingFeed = false;
//   bool _isLoadingStories = false;
//   List<Post> _posts = [];
//   User _currentUser = User(follow: []);
//
//   _setupFeed() async {
//     _setupStories();
//     print('_setupFeed');
//
//     setState(() => _isLoadingFeed = true);
//
//     //List<Post> post = await DatabaseService.getFeedPosts(widget.currentUserId);
//     List<Post> post = await DatabaseService.getAllFeedPosts();
//
//     setState(() {
//       _posts = post;
//       _isLoadingFeed = false;
//     });
//   }
//
//   void _setupStories() async {
//     print("_setupStories");
//
//     setState(() => _isLoadingStories = true);
//     // 기존 유저 정보 가져오기
//
//     if (widget.currentUser == null) {
//       _currentUser = await DatabaseService.getUserWithId(widget.currentUserId);
//     } else {
//       _currentUser = widget.currentUser!;
//     }
//
//     //var response = await http.get(Uri.parse('http://localhost:3000/api/users'));
//
//
//     if (!mounted) return;
//
//     return;
//
//     List<User> followingUsers = await DatabaseService.getUserFollowingUsers(_currentUser.follow);
//
//     //var converted = json.decode(response.body);
//
//     //List<User> followingUsers = [];
//
//     //Provider.of<UserData>(context, listen: false).currentUser;
//
//     if (_currentUser.id != kAdminUId) {
//       bool isFollowingAdmin = false;
//
//       for (User user in followingUsers) {
//         if (user.id == kAdminUId) {
//           isFollowingAdmin = true;
//         }
//       }
//       // if current user doesn't follow admin
//       if (!isFollowingAdmin) {
//         // get admin stories
//         List<Story> adminStories = await StoriesService.getStoriesByUserId(kAdminUId, true);
//         if (!mounted) return;
//         // if there is admin stories
//         if (adminStories.isNotEmpty) {
//           // get admin user
//           User adminUser = await DatabaseService.getUserWithId(kAdminUId);
//           if (!mounted) return;
//           // add admin to story circle list
//           followingUsers.insert(0, adminUser);
//         }
//       }
//     }
//
//     if (mounted) {
//       setState(() {
//         _isLoadingStories = false;
//         _followingUsersWithStories = followingUsers;
//       });
//     }
//   }
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     _setupFeed();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: !_isLoadingFeed
//           ? RefreshIndicator(
//         // If posts finished loading
//         onRefresh: () => _setupFeed(),
//         child: SingleChildScrollView(
//           physics: ScrollPhysics(),
//           child: Column(
//             children: [
//               _isLoadingStories
//                 ? Container(
//                   height: 88,
//                   child: Center(
//                     child: CircularProgressIndicator(),
//                   ),
//                 )
//                 : StoriesWidget(
//                     users : _followingUsersWithStories,
//                     goToCameraScreen : widget.goToCameraScreen,
//                     currentUser : _currentUser
//                 ),
//               SizedBox(height: 5),
//               ListView.builder(
//                 physics: NeverScrollableScrollPhysics(),
//                 shrinkWrap: true,
//                 itemCount: _posts.length > 0 ? _posts.length : 1,
//                 itemBuilder: (BuildContext context, int index) {
//                   if (_posts.length == 0) {
//                     //If there is no posts
//                     return Container(
//                       height: MediaQuery.of(context).size.height,
//                       child: Center(
//                         child:
//                         Text('No posts found, Start following users'),
//                       ),
//                     );
//                   }
//
//                   Post post = _posts[index];
//
//                   return PostView(
//                     postStatus: PostStatus.feedPost,
//                     currentUserId: widget.currentUserId,
//                     post: post,
//                   );
//                 },
//               ),
//             ],
//           ),
//         ),
//       )
//           : Center(
//         // If posts is loading
//         child: CircularProgressIndicator(),
//       ),
//     );
//   }
// }
