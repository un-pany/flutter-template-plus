import 'package:flutter/material.dart';
import 'package:flutter_templete/http/request/test_request.dart';
import 'package:flutter_templete/http/core/hi_net.dart';
import 'package:flutter_templete/http/core/hi_net_error.dart';

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
            TestRequest request = TestRequest();
            request.add('aaa', '111').add('requestPrams', '222');
            try {
              var res = await HiNet.getInstance().fire(request);
              print(res);
            } on NeedLogin catch (e) {
              print(e);
            } on NeedAuth catch (e) {
              print(e);
            } on HiNetError  catch (e) {
              print(e);
            }
          },
        ),
      ),
    );
  }
}
