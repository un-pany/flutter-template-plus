import 'package:flutter/material.dart';

/// 登录输入框
class LoginInput extends StatelessWidget {
  // 提示文字
  final String hintText;
  // 前缀图标
  final Widget? prefixIcon;
  // 控制器
  final TextEditingController controller;
  // 最多输入数，有值后右下角就会有一个计数器
  final int maxLength;
  // 隐藏文本
  final bool obscureText;
  // 键盘类型
  final TextInputType keyboardType;
  // 校验规则
  final FormFieldValidator<String>? validator;

  const LoginInput(
    this.hintText,
    this.prefixIcon,
    this.controller, {
    Key? key,
    this.maxLength = 18,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Form 的子元素必须是 TextFormField，TextFormField 具备 TextField 的所有属性
    return TextFormField(
      controller: controller,
      maxLength: maxLength,
      keyboardType: keyboardType,
      obscureText: obscureText,
      // decoration 设置输入框的样式
      decoration: InputDecoration(
        counterText: '', // 隐藏计数器
        hintText: hintText,
        prefixIcon: prefixIcon,
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
      // 校验
      validator: validator,
    );
  }
}
