import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_templete/common/color.dart';

/// 登录输入框
class LoginInput extends StatefulWidget {
  // 提示文字
  final String hint;
  // 前缀图标
  final Widget? prefixIcon;
  // 隐藏文本
  final bool obscureText;
  // 键盘类型
  final TextInputType keyboardType;

  const LoginInput(
    this.hint,
    this.prefixIcon, {
    Key? key,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
  }) : super(key: key);

  @override
  _LoginInputState createState() => _LoginInputState();
}

class _LoginInputState extends State<LoginInput> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 30,
        right: 30,
      ),
      child: TextField(
        keyboardType: widget.keyboardType,
        obscureText: widget.obscureText,
        // decoration 设置输入框的样式
        decoration: InputDecoration(
          hintText: widget.hint,
          prefixIcon: widget.prefixIcon,
          // 背景颜色，结合 filled: true，才有效
          fillColor: Colors.grey[200],
          filled: true,
          border: OutlineInputBorder(
            // 圆角形
            borderRadius: BorderRadius.all(
              Radius.circular(32),
            ),
            // 去除边框
            borderSide: BorderSide.none,
          ),
          // 内容内边距
          contentPadding: EdgeInsets.only(
            top: 0,
            bottom: 0,
          ),
        ),
      ),
    );
  }
}
