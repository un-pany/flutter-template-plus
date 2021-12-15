import 'package:flutter/material.dart';

/// 页面状态异常管理
/// 主要解决页面销毁后，调用了 setState 导致控制台警告的问题
/// 该脚手架暂时未用到
abstract class MyState<T extends StatefulWidget> extends State<T> {
  @override
  void setState(fn) {
    if (mounted) {
      // 页面已装载
      super.setState(fn);
    } else {
      print('MyState：页面已销毁，本次 setState 不执行：${toString()}');
    }
  }
}
