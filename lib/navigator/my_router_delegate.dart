import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_template_plus/http/dao/login_dao.dart';
import 'package:flutter_template_plus/navigator/my_navigator_util.dart';
import 'package:flutter_template_plus/pages/navigator_page.dart';
import 'package:flutter_template_plus/navigator/my_navigator.dart';
import 'package:flutter_template_plus/pages/detail_page.dart';
import 'package:flutter_template_plus/pages/login_page.dart';

/// 路由代理
class MyRouterDelegate extends RouterDelegate<dynamic>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<dynamic> {
  // 构造函数
  MyRouterDelegate() : navigatorKey = GlobalKey<NavigatorState>() {
    // 注册路由跳转逻辑
    MyNavigator.getInstance().registerRouteJump(
      RouteJumpListener(
        onJumpTo: (RouteStatus routeStatus, {Map? args}) {
          _routeStatus = routeStatus;
          if (routeStatus == RouteStatus.detail) {
            // 详情页面要传递 id 参数
            id = args!['id'];
          }
          // notifyListeners 通知数据变化，和 setState 效果一样
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
  RouteStatus _routeStatus = RouteStatus.navigator;
  // 要传递给详情页的 id 数据
  int? id;

  // 是否登录
  bool get hasLogin => LoginDao.getToken() != null;
  // 路由拦截
  RouteStatus get getRouteStatus {
    if (!hasLogin) {
      // 如果没有登录则将路由状态设置为 login 页
      return _routeStatus = RouteStatus.login;
    } else if (hasLogin && _routeStatus == RouteStatus.login) {
      // 如果登录了，就不允许跳转到 Login 页，重定向到 NavigatorPage 页
      return _routeStatus = RouteStatus.navigator;
    } else {
      return _routeStatus;
    }
  }

  // 管理 Page 堆栈（ Navigator 2.0 的优势之一就在这个 pages 栈，能够一次导入多个页面；当前显示的页面，要将那些页面出栈等等操作都在这里管理）
  @override
  Widget build(BuildContext context) {
    // 获取 _routeStatus 在 Page 栈中的位置
    int index = getPageIndex(pages, getRouteStatus);
    // 临时变量 tempPages
    List<MaterialPage> tempPages = pages;
    if (index != -1) {
      // 要打开的页面在栈中已存在，则将该页面和它上面的所有页面进行出栈
      // 具体的规则可以根据需要自行进行调整，脚手架这里只要求栈中只允许有一个同样的页面的实例
      tempPages = tempPages.sublist(0, index);
    }
    var page;

    switch (getRouteStatus) {
      case RouteStatus.login:
        // 跳转 LoginPage 时将栈中其它页面进行出栈，因为 LoginPage 不可回退
        pages.clear();
        page = pageWrap(LoginPage());
        break;
      case RouteStatus.navigator:
        // 跳转 NavigatorPage 时将栈中其它页面进行出栈，因为 NavigatorPage 不可回退
        pages.clear();
        page = pageWrap(NavigatorPage());
        break;
      case RouteStatus.detail:
        page = pageWrap(DetailPage(id: id!));
        break;
      case RouteStatus.unknown:
        // 未知页面
        break;
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
      onWillPop: () async {
        return !(await navigatorKey.currentState?.maybePop() ?? false);
      },
      child: Navigator(
        key: navigatorKey,
        pages: pages,
        // 返回上一页时触犯（在这里可以控制是否返回）
        onPopPage: (route, result) {
          if (route.settings is MaterialPage) {
            // login 页未登录时，做一下返回拦截（防御性编程）
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
  Future<void> setNewRoutePath(dynamic path) async {}
}
