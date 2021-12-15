import 'package:flutter/material.dart';
import 'package:flutter_template/pages/detail_page.dart';
import 'package:flutter_template/pages/home_page.dart';
import 'package:flutter_template/pages/login_page.dart';

/// 自定义路由封装，也就是路由状态，unknown 代表未知的页面
enum RouteStatus { login, home, detail, unknown }

/// 创建页面
pageWrap(Widget child) {
  return MaterialPage(
    // key 保持唯一就行
    key: ValueKey(child.hashCode),
    child: child,
  );
}

/// 获取 routeStatus 在页面栈中的位置
int getPageIndex(List<MaterialPage> pages, RouteStatus routeStatus) {
  for (int i = 0; i < pages.length; i++) {
    MaterialPage page = pages[i];
    if (getStatus(page) == routeStatus) {
      return i;
    }
  }
  return -1;
}

/// 获取 page 对应的 RouteStatus
RouteStatus getStatus(MaterialPage page) {
  if (page.child is LoginPage) {
    return RouteStatus.login;
  } else if (page.child is HomePage) {
    return RouteStatus.home;
  } else if (page.child is DetailPage) {
    return RouteStatus.detail;
  } else {
    return RouteStatus.unknown;
  }
}

/// 路由信息
class RouteStatusInfo {
  final RouteStatus routeStatus;
  final Widget page;

  RouteStatusInfo(this.routeStatus, this.page);
}
