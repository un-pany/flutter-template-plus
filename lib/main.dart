import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_template/common/color.dart';
import 'package:flutter_template/common/init_data.dart';
import 'navigator/my_router_delegate.dart';

void main() {
  // 网格线
  // debugPaintSizeEnabled = true;
  // Flutter 版本 (1.12.13+hotfix.5) 后，初始化插件必须加 ensureInitialized
  // WidgetsFlutterBinding.ensureInitialized();
  // 应用入口
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  MyRouterDelegate _routerDelegate = MyRouterDelegate();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // 进行项目的预初始化
      future: InitData.init(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        Widget widget = snapshot.connectionState == ConnectionState.done
            // 定义 Router（Navigator 2.0 的概念）
            ? Router(routerDelegate: _routerDelegate)
            // 初始化未完成时，显示 loading 动画
            : Scaffold(body: Center(child: CircularProgressIndicator()));

        return MaterialApp(
          title: 'flutter_template',
          theme: ThemeData(
            // 主题
            primarySwatch: primaryColor,
          ),
          localizationsDelegates: [
            // 本地化的代理类
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: [Locale('zh', 'CH')],
          builder: EasyLoading.init(),
          // 设置 Router
          home: widget,
        );
      },
    );
  }
}
