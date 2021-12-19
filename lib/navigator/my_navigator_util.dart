import 'package:flutter/material.dart';
import 'package:flutter_template_plus/pages/detail_page.dart';
import 'package:flutter_template_plus/pages/login_page.dart';
import 'package:flutter_template_plus/pages/navigator_page.dart';

/// 路由状态，unknown 代表未知的页面
enum RouteStatus { login, navigator, detail, unknown }

/// 创建 Page
pageWrap(Widget child) {
  return MaterialPage(
    // key 保持唯一就行
    key: ValueKey(child.hashCode),
    child: child,
  );
}

/// 获取 Page 对应的 RouteStatus
RouteStatus getStatus(MaterialPage page) {
  if (page.child is LoginPage) {
    return RouteStatus.login;
  } else if (page.child is NavigatorPage) {
    return RouteStatus.navigator;
  } else if (page.child is DetailPage) {
    return RouteStatus.detail;
  } else {
    return RouteStatus.unknown;
  }
}

/// 获取 routeStatus 在 Page 栈中的位置
int getPageIndex(List<MaterialPage> pages, RouteStatus routeStatus) {
  for (int i = 0; i < pages.length; i++) {
    MaterialPage page = pages[i];
    if (getStatus(page) == routeStatus) {
      return i;
    }
  }
  return -1;
}

/// 路由信息
class RouteStatusInfo {
  final RouteStatus routeStatus;
  final Widget page;
  RouteStatusInfo(this.routeStatus, this.page);
}

/// current 当前页面，pre 上次的页面
typedef RouteChangeListener(RouteStatusInfo current, RouteStatusInfo? pre);

/// 路由跳转方法的类型
typedef OnJumpTo = void Function(RouteStatus routeStatus, {Map? args});

/// 定义路由跳转逻辑要实现的功能
class RouteJumpListener {
  final OnJumpTo onJumpTo;
  RouteJumpListener({required this.onJumpTo});
}

/// 抽象类供 MyNavigator 实现
abstract class AbstractRouteJumpListener {
  // routeStatus 代表要跳转的页面，args 代表要传递的值
  void onJumpTo(RouteStatus routeStatus, {Map args});
}
