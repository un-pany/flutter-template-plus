import 'package:flutter/material.dart';
import 'package:flutter_templete/http/core/my_net_error.dart';
import 'package:flutter_templete/http/dao/login_dao.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          child: Text("发送请求"),
          onPressed: () async {
            try {
              var res = await LoginDao.login('admin', '123456');
              print('page层收到的数据:$res');
            } on NeedLogin catch (e) {
              print(e);
            } on NeedAuth catch (e) {
              print(e);
            } on MyNetError catch (e) {
              print(e);
            }
          },
        ),
      ),
    );
  }
}
