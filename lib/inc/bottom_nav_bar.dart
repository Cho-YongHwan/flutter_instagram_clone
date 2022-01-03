import 'package:flutter/material.dart';

class BottomNavBar extends StatefulWidget {
  final setBottomCurrentIndex;
  final currentIndex;
  const BottomNavBar({Key? key, this.setBottomCurrentIndex, this.currentIndex}) : super(key: key);

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      showUnselectedLabels: false,
      showSelectedLabels: false,
      currentIndex: widget.currentIndex,
      onTap: (index) {
        widget.setBottomCurrentIndex(index);
      },
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.grey,
      items: [
        BottomNavigationBarItem(
            label : '홈',
            icon: Icon(Icons.home),
            activeIcon: Icon(Icons.home)
        ),
        BottomNavigationBarItem(
            label : '검색',
            icon: Icon(Icons.search),
            activeIcon: Icon(Icons.search)
        ),
        BottomNavigationBarItem(
            label : '릴스',
            icon: Icon(Icons.play_circle_fill),
            activeIcon: Icon(Icons.play_circle_fill)
        ),
        BottomNavigationBarItem(
            label : '쇼핑',
            icon: Icon(Icons.shopping_bag),
            activeIcon: Icon(Icons.shopping_bag)
        ),
        BottomNavigationBarItem(
            label : '내정보',
            icon: Icon(Icons.person),
            activeIcon: Icon(Icons.person)
        ),
      ],
    );
  }
}
