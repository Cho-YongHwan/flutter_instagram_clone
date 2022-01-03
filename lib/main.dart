import 'package:flutter/material.dart';
import 'package:instagram_clone/inc/bottom_nav_bar.dart';
import 'package:instagram_clone/inc/style/theme.dart';
import 'package:instagram_clone/service/api/database_service.dart';
import 'package:instagram_clone/utils/themes.dart';
import 'package:instagram_clone/views/feed_screen/feed_page.dart';
import 'package:instagram_clone/views/home_screen/home_page.dart';
import 'package:instagram_clone/views/reels_screen/reels_page.dart';
import 'package:instagram_clone/views/search_screen/search_page.dart';
import 'package:instagram_clone/views/shop_screen/shop_page.dart';
import 'package:provider/provider.dart';

import 'models/theme_notifier.dart';
import 'models/user_data.dart';
import 'models/user_model.dart';

void main() {

  var darkModeOn = false;

  runApp(
    MaterialApp(
      theme : theme,
      home: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  final List<Widget> _children = [
    FeedPage(),
    SearchPage(),
    ReelsPage(),
    ShopPage(),
    HomePage(),
  ];

  var _currentIndex = 0;

  setBottomCurrentIndex(index) {
    print(index);
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavBar(
          setBottomCurrentIndex : setBottomCurrentIndex,
          currentIndex: _currentIndex
      ),
    );
  }
}


