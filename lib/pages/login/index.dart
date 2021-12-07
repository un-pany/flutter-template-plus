import 'package:flutter/material.dart';
import 'package:flutter_templete/http/api/test_api.dart';
import 'package:flutter_templete/http/core/hi_net.dart';

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
            TestApi api = TestApi();
            api.add('aa', 'ddd').add('bb', '333');
            var res = await HiNet.getInstance().fire(api);
            print(res);
          },
        ),
      ),
    );
  }
}
