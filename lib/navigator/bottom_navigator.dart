import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_template/navigator/my_navigator.dart';
import 'package:flutter_template/pages/home_page.dart';
import 'package:flutter_template/pages/me_page.dart';
import 'package:flutter_template/common/color.dart';

class BottomNavigator extends StatefulWidget {
  const BottomNavigator({Key? key}) : super(key: key);

  @override
  _BottomNavigatorState createState() => _BottomNavigatorState();
}

class _BottomNavigatorState extends State<BottomNavigator> {
  // 默认的颜色
  final _defaultColor = Colors.grey;
  // 选中后的颜色
  final _activeColor = primaryColor;
  // 当前索引
  int _currentIndex = 0;
  // 页面
  final List<Widget> _pages = [
    HomePage(),
    MePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: _activeColor,
        items: [
          _bottomItem('首页', Icons.home_outlined),
          _bottomItem('我的', Icons.person_outline),
        ],
        onTap: (index) => {
          setState(() {
            _currentIndex = index;
          })
        },
      ),
    );
  }

  // 底部 Item
  BottomNavigationBarItem _bottomItem(String label, IconData icon) {
    return BottomNavigationBarItem(
      label: label,
      icon: Icon(icon, color: _defaultColor),
      activeIcon: Icon(icon, color: _activeColor),
    );
  }
}
