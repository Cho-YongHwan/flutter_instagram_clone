import 'package:flutter/material.dart';

var theme = ThemeData(
  appBarTheme: AppBarTheme(
      color: Colors.white,
      titleTextStyle: TextStyle(
        color: Colors.black,
        fontSize: 20,
        fontWeight: FontWeight.w800,
      ),
      iconTheme: IconThemeData(
        color: Colors.black,
      )
  ),
  textTheme: TextTheme(
    bodyText2: TextStyle(
      fontSize: 18,
      color: Colors.black,
    ),
  ),
  textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        primary: Colors.black,
        backgroundColor: Colors.orange,
      )),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Colors.white,
    elevation: 2,
    selectedItemColor: Colors.black,
  ),
);

const kFontColorRedTextStyle = TextStyle(color: Colors.red);
const kFontSize18FontWeight600TextStyle =
TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600);