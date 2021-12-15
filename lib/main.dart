import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_template/common/color.dart';
import 'package:flutter_template/db/my_cache.dart';
import 'package:flutter_template/http/dao/login_dao.dart';
import 'package:flutter_template/navigator/bottom_navigator.dart';
import 'package:flutter_template/navigator/my_navigator.dart';
import 'package:flutter_template/pages/detail_page.dart';
import 'package:flutter_template/pages/home_page.dart';
import 'package:flutter_template/pages/login_page.dart';

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
    // 配置 EasyLoading 单例
    EasyLoading.instance
      ..displayDuration = const Duration(milliseconds: 2000)
      ..userInteractions = false // 期间是否允许用户操作
      ..dismissOnTap = false // 点击背景是否关闭
      ..maskType = EasyLoadingMaskType.black; // 遮蔽层

    return FutureBuilder<MyCache>(
      // 进行项目的预初始化
      future: MyCache.preInit(),
      builder: (BuildContext context, AsyncSnapshot<MyCache> snapshot) {
        // 定义 router
        var widget = snapshot.connectionState == ConnectionState.done
            ? Router(
                routerDelegate: _routerDelegate,
              )
            : Scaffold(
                body: Center(
                  // 初始化未完成时，显示 loading 动画
                  child: CircularProgressIndicator(),
                ),
              );

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
          // 设置 router
          home: widget,
        );
      },
    );
  }
}

/// 路由代理
class MyRouterDelegate extends RouterDelegate<MyRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<MyRoutePath> {
  MyRouterDelegate() : navigatorKey = GlobalKey<NavigatorState>() {
    // 实现路由跳转逻辑
    MyNavigator.getInstance().registerRouteJump(
      RouteJumpListener(
        onJumpTo: (RouteStatus routeStatus, {Map? args}) {
          _routeStatus = routeStatus;
          if (routeStatus == RouteStatus.detail) {
            this.id = args!['id'];
          }
          notifyListeners();
        },
      ),
    );
  }
  // 为 Navigator 设置一个 key，必要时可以通过 navigatorKey.currentState 来获取到 navigatorState 对象
  final GlobalKey<NavigatorState> navigatorKey;
  // pages 存放所有页面
  List<MaterialPage> pages = [];
  // 路由状态
  RouteStatus _routeStatus = RouteStatus.home;
  //
  int? id;

  // 是否登录
  bool get hasLogin => LoginDao.getToken() != null;
  // 路由拦截
  RouteStatus get routeStatus {
    if (!hasLogin) {
      return _routeStatus = RouteStatus.login;
    } else if (id != null) {
      return _routeStatus = RouteStatus.detail;
    } else {
      return _routeStatus;
    }
  }

  // 管理路由堆栈（ Navigator 2.0 的优势之一就在这个 pages 栈，能够一次导入多个页面；当前显示的页面，要将那些页面出栈等等操作都在这里管理）
  @override
  Widget build(BuildContext context) {
    var index = getPageIndex(pages, routeStatus);
    // 临时变量 tempPages
    List<MaterialPage> tempPages = pages;
    if (index != -1) {
      // 要打开的页面在栈中已存在，则将该页面和它上面的所有页面进行出栈
      // 具体的规则可以根据需要自行进行调整，脚手架这里只要求栈中只允许有一个同样的页面的实例
      tempPages = tempPages.sublist(0, index);
    }
    var page;
    if (routeStatus == RouteStatus.login) {
      page = pageWrap(
        LoginPage(),
      );
    } else if (routeStatus == RouteStatus.home) {
      // 跳转首页时将栈中其它页面进行出栈，因为首页不可回退
      pages.clear();
      page = pageWrap(BottomNavigator());
    } else if (routeStatus == RouteStatus.detail) {
      page = pageWrap(DetailPage(id: id!));
    }
    // 重新创建一个数组，否则 pages 因引用没有改变，路由不会生效
    tempPages = [...tempPages, page];
    // 通知路由发生变化
    MyNavigator.getInstance().notify(tempPages, pages);
    pages = tempPages;

    // 返回整个路由堆栈信息
    return WillPopScope(
      // fix: Android 物理返回键，无法返回上一页问题 @https://github.com/flutter/flutter/issues/66349
      // WillPopScope + onWillPop 就是解决这个问题的关键
      onWillPop: () async =>
          !(await navigatorKey.currentState?.maybePop() ?? false),
      child: Navigator(
        key: navigatorKey,
        pages: pages,
        // 返回上一页时触犯（在这里可以控制是否返回）
        onPopPage: (route, result) {
          if (route.settings is MaterialPage) {
            // login 页未登录时，做一下返回拦截（是防御性编程，该脚手架其实不会出现从 login 页返回其他需要登录的页面的情况）
            if ((route.settings as MaterialPage).child is LoginPage) {
              if (!hasLogin) {
                EasyLoading.showInfo("请先登录");
                return false;
              }
            }
          }
          // 执行返回操作
          if (!route.didPop(result)) {
            // 不可以返回
            return false;
          }
          var tempPages = [...pages];
          pages.removeLast();
          // 通知路由发生变化
          MyNavigator.getInstance().notify(pages, tempPages);
          return true;
        },
      ),
    );
  }

  @override
  Future<void> setNewRoutePath(MyRoutePath path) async {}
}

/// 定义路由数据 path，由于没有配置 RouteInformationParser，所以该对象暂时没有实际作用
class MyRoutePath {
  final String location;
  MyRoutePath.home() : location = '/';
  MyRoutePath.detail() : location = '/detail';
}
