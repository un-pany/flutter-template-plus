import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 登录输入框
class LoginInput extends StatefulWidget {
  // 提示文字
  final String hintText;
  // 前缀图标
  final Widget? prefixIcon;
  // 最多输入数，有值后右下角就会有一个计数器
  final int maxLength;
  // 隐藏文本
  final bool obscureText;
  // 键盘类型
  final TextInputType keyboardType;

  const LoginInput(
    this.hintText,
    this.prefixIcon, {
    Key? key,
    this.maxLength = 18,
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
        maxLength: widget.maxLength,
        keyboardType: widget.keyboardType,
        obscureText: widget.obscureText,
        // decoration 设置输入框的样式
        decoration: InputDecoration(
          counterText: '', // 隐藏计数器
          hintText: widget.hintText,
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
