import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:instagram_clone/inc/style/theme.dart';
import 'package:instagram_clone/views/home_screen/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/theme_notifier.dart';
import 'models/user_data.dart';
import 'package:timeago/timeago.dart' as timeago;

void main() {

  timeago.setLocaleMessages('ko', timeago.KoMessages());

  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.getInstance().then((prefs) {
    var darkModeOn = prefs.getBool('darkMode') ?? false;

    //Set Navigation bar color
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: darkModeOn ? Colors.black : Colors.white,
        systemNavigationBarIconBrightness:
        darkModeOn ? Brightness.light : Brightness.dark));

    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<UserData>(create: (context) => UserData()),
          ChangeNotifierProvider<ThemeNotifier>(
              create: (context) =>
                  ThemeNotifier(darkModeOn ? darkTheme : lightTheme))
        ],
        child: MyApp(),
      ),
    );
  });
  //
  // var darkModeOn = false;
  //
  // runApp(
  //   MaterialApp(
  //     theme : theme,
  //     home: MyApp(),
  //   ),
  // );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isTimerDone = false;

  @override
  void initState() {
    Timer(Duration(seconds: 3), () => setState(() => _isTimerDone = true));
    super.initState();
  }

  Widget _getScreenId() {

    Provider.of<UserData>(context, listen: false).currentUserId = 1;

    return HomeScreen(
        currentUserId: 1, cameras: [],
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: themeNotifier.getTheme(),
      home: _getScreenId(),
    );
  }
}

// class MyApp extends StatefulWidget {
//   const MyApp({Key? key}) : super(key: key);
//
//   @override
//   _MyAppState createState() => _MyAppState();
// }
//
// class _MyAppState extends State<MyApp> {
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _children[_currentIndex],
//       bottomNavigationBar: BottomNavBar(
//           setBottomCurrentIndex : setBottomCurrentIndex,
//           currentIndex: _currentIndex
//       ),
//     );
//   }
// }
//
//
