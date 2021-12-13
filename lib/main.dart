import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_templete/common/color.dart';
import 'package:flutter_templete/http/dao/login_dao.dart';
import 'package:flutter_templete/pages/detail_page.dart';
import 'package:flutter_templete/pages/home_page.dart';
import 'package:flutter_templete/pages/login_page.dart';

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
  MyRouteInformationParser _routeInformationParser = MyRouteInformationParser();
  @override
  Widget build(BuildContext context) {
    // 定义 route
    var widget = Router(
      routeInformationParser: _routeInformationParser,
      routerDelegate: _routerDelegate,
      // routeInformationParser 不为空时，必须设置 routeInformationProvider
      routeInformationProvider: PlatformRouteInformationProvider(
        initialRouteInformation: RouteInformation(location: '/'),
      ),
    );
    return MaterialApp(
      title: 'flutter_templete',
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
      // 定义 route
      home: widget,
    );
  }
}

/// 路由代理
class MyRouterDelegate extends RouterDelegate<MyRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<MyRoutePath> {
  MyRouterDelegate() : navigatorKey = GlobalKey<NavigatorState>();
  // 为 Navigator 设置一个 key，必要时可以通过 navigatorKey.currentState 来获取到 navigatorState 对象
  final GlobalKey<NavigatorState> navigatorKey;
  // pages 存放所有页面
  List<MaterialPage> pages = [];
  // path
  MyRoutePath? path;
  //
  int? id;

  @override
  Widget build(BuildContext context) {
    // 构建路由栈
    pages = [
      pageWrap(
        HomePage(
          onJumpToDetail: (id) {
            this.id = id;
            // notifyListeners 通知数据变化，和 setState 效果一样
            notifyListeners();
          },
        ),
      ),
      if (id != null) pageWrap(DetailPage(id: id!)),
    ];
    // 返回整个路由堆栈信息
    return Navigator(
      key: navigatorKey,
      pages: pages,
      // 返回上一页时触犯（在这里可以控制是否返回）
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          // 不可以返回
          return false;
        }
        return true;
      },
    );
  }

  @override
  Future<void> setNewRoutePath(MyRoutePath path) async {
    this.path = path;
  }
}

/// RouteInformationParser 路由数据解析，主要应用于 Web，可缺省
class MyRouteInformationParser extends RouteInformationParser<MyRoutePath> {
  @override
  Future<MyRoutePath> parseRouteInformation(
      RouteInformation routeInformation) async {
    // 解析出 uri
    final uri = Uri.parse(routeInformation.location ?? '');
    print('uri:$uri');
    if (uri.pathSegments.length == 0) {
      // 长度为 0，我们认为是首页
      return MyRoutePath.home();
    }
    return MyRoutePath.detail();
  }
}

/// 定义路由数据，path
class MyRoutePath {
  final String location;
  MyRoutePath.home() : location = '/';
  MyRoutePath.detail() : location = '/detail';
}

/// 创建页面
pageWrap(Widget child) {
  return MaterialPage(
    // key 保持唯一就行
    key: ValueKey(child.hashCode),
    child: child,
  );
}

// class MyApp extends StatelessWidget {
//   MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     // 配置 EasyLoading 单例
//     EasyLoading.instance
//       ..displayDuration = const Duration(milliseconds: 2000)
//       ..userInteractions = false // 期间是否允许用户操作
//       ..dismissOnTap = false // 点击背景是否关闭
//       ..maskType = EasyLoadingMaskType.black; // 遮蔽层

//     return MaterialApp(
//       title: 'flutter_templete',
//       theme: ThemeData(
//         primarySwatch: primaryColor, // 主题
//       ),
//       initialRoute: "home",
//       onGenerateRoute: onGenerateRoute,
//       localizationsDelegates: [
//         // 本地化的代理类
//         GlobalMaterialLocalizations.delegate,
//         GlobalWidgetsLocalizations.delegate,
//       ],
//       supportedLocales: [Locale('zh', 'CH')],
//       builder: EasyLoading.init(),
//     );
//   }

//   // 路由钩子
//   Route<dynamic> onGenerateRoute(RouteSettings settings) {
//     String? routeName;
//     routeName = routeBeforeHook(settings);
//     return MaterialPageRoute(builder: (context) {
//       /// 注意：如果路由的形式为: '/a/b/c'
//       /// 那么将依次检索 '/' -> '/a' -> '/a/b' -> '/a/b/c'
//       /// 所以，这里的路由命名最好避免使用 '/xxx' 形式
//       switch (routeName) {
//         case "login":
//           return LoginPage();
//         default:
//           return Scaffold(
//             body: Center(
//               child: Text("页面不存在"),
//             ),
//           );
//       }
//     });
//   }

//   // 路由拦截器
//   String? routeBeforeHook(RouteSettings settings) {
//     final token = LoginDao.getToken();
//     if (token != null) {
//       if (settings.name == 'login') {
//         return 'home';
//       }
//       return settings.name;
//     }
//     return 'login';
//   }
// }
