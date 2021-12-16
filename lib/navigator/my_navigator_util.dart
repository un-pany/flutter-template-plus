import 'package:flutter/material.dart';
import 'package:flutter_template/pages/detail_page.dart';
import 'package:flutter_template/pages/login_page.dart';
import 'package:flutter_template/pages/navigator_page.dart';

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
