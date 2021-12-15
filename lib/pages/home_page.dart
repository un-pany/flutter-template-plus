import 'package:flutter/material.dart';
import 'package:flutter_template/navigator/my_navigator.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  RouteChangeListener? listener;

  @override
  void initState() {
    super.initState();
    // 切换路由时监听当前页面打开与离开
    MyNavigator.getInstance().addListener(listener = (current, pre) {
      if (widget == current.page || current.page is HomePage) {
        print('打开了当前页面，即首页');
      } else if (widget == pre?.page || pre?.page is HomePage) {
        print('离开了当前页面，即首页');
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    // 记得 remove
    MyNavigator.getInstance().removeListener(listener!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('首页'),
      ),
      body: Center(
        child: ElevatedButton(
          child: Text("跳转到详情"),
          onPressed: () {
            MyNavigator.getInstance().onJumpTo(
              RouteStatus.detail,
              args: {'id': 9999},
            );
          },
        ),
      ),
    );
  }
}
