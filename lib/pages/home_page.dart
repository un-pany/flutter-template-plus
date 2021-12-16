import 'package:flutter/material.dart';
import 'package:flutter_template/navigator/my_navigator.dart';
import 'package:flutter_template/navigator/my_navigator_util.dart';

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
        // 通过 NavigatorPage 的底部 Tab 切换回当前页面时，不会触发
        // 这是因为 底部 Tab 切换时，重新构建了当前页，监听也随之被重新挂载
        // 解决办法是: 可以将 NavigatorPage 页面的 body 修改为 PageView 来渲染，并且将当前页 KeepAlive
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
