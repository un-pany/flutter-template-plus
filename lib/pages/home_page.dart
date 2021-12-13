import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  // ValueChanged 和 VoidCallback 都代表回调，前者有参数，后者没有参数
  final ValueChanged onJumpToDetail;

  const HomePage({Key? key, required this.onJumpToDetail}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('首页'),
      ),
      body: Center(
        child: ElevatedButton(
          child: Text("跳转到详情"),
          onPressed: () => widget.onJumpToDetail(9527),
        ),
      ),
    );
  }
}
