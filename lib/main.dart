import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_templete/common/color.dart';
import 'package:flutter_templete/http/dao/login_dao.dart';
import 'package:flutter_templete/pages/login/index.dart';

void main() {
  // 网格线
  // debugPaintSizeEnabled = true;
  // Flutter 版本 (1.12.13+hotfix.5) 后，初始化插件必须加 ensureInitialized
  // WidgetsFlutterBinding.ensureInitialized();
  // 应用入口
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'flutter_templete',
      theme: ThemeData(
        primarySwatch: primaryColor, // 主题
      ),
      initialRoute: "home",
      onGenerateRoute: onGenerateRoute,
      localizationsDelegates: [
        // 本地化的代理类
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [Locale('zh', 'CH')],
    );
  }

  // 路由钩子
  Route<dynamic> onGenerateRoute(RouteSettings settings) {
    String? routeName;
    routeName = routeBeforeHook(settings);
    return MaterialPageRoute(builder: (context) {
      /// 注意：如果路由的形式为: '/a/b/c'
      /// 那么将依次检索 '/' -> '/a' -> '/a/b' -> '/a/b/c'
      /// 所以，这里的路由命名最好避免使用 '/xxx' 形式
      switch (routeName) {
        case "login":
          return LoginPage();
        default:
          return Scaffold(
            body: Center(
              child: Text("页面不存在"),
            ),
          );
      }
    });
  }

  // 路由拦截器
  String? routeBeforeHook(RouteSettings settings) {
    final token = LoginDao.getToken();
    if (token != null) {
      if (settings.name == 'login') {
        return 'home';
      }
      return settings.name;
    }
    return 'login';
  }
}
