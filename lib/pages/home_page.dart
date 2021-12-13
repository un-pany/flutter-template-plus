import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
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
