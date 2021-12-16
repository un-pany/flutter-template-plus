import 'package:flutter/material.dart';
import 'package:flutter_template/http/dao/login_dao.dart';
import 'package:flutter_template/navigator/my_navigator.dart';

class MePage extends StatefulWidget {
  const MePage({Key? key}) : super(key: key);

  @override
  _MePageState createState() => _MePageState();
}

class _MePageState extends State<MePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('我的'),
      ),
      body: Center(
        child: ElevatedButton(
          child: Text("退出登录"),
          onPressed: () {
            LoginDao.removeToken();
            MyNavigator.getInstance().onJumpTo(RouteStatus.login);
          },
        ),
      ),
    );
  }
}
