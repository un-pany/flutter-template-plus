import 'package:flutter_templete/http/dao/login_dao.dart';

/// RESTful 请求
enum HttpMethod { GET, POST, DELETE, PUT }

/// 基础请求
abstract class BaseRequest {
  // path 参数
  var pathParams;
  // 默认查询参数
  Map<String, String> params = Map();
  // 是否为 https，默认为 true
  bool useHttps = true;
  // 默认 header 数据
  Map<String, String> header = Map();

  // 设置请求方法
  HttpMethod httpMethod();
  // 设置 path
  String path();
  // 设置接口是否需要登录
  bool needLogin();

  // 默认域名
  String authority() {
    return 'vue-typescript-admin-mock-server-armour.vercel.app';
  }

  // 生成具体的 url
  String url() {
    Uri uri;
    var pathStr = path();
    // 拼接 path 参数
    if (pathParams != null) {
      if (path().endsWith('/')) {
        pathStr = '${path()}$pathParams';
      } else {
        pathStr = '${path()}/$pathParams';
      }
    }
    // http 和 https 的切换
    if (useHttps) {
      uri = Uri.https(authority(), pathStr, params);
    } else {
      uri = Uri.http(authority(), pathStr, params);
    }
    // 设置 token
    var token = LoginDao.getToken();
    if (needLogin() && token != null) {
      // 给需要登录的接口携带登录令牌
      addHeader(LoginDao.Token, token);
    }
    // print('url:${uri.toString()}');
    return uri.toString();
  }

  // 添加查询参数
  BaseRequest add(String k, Object v) {
    params[k] = v.toString();
    return this;
  }

  // 添加 header 数据
  BaseRequest addHeader(String k, Object v) {
    header[k] = v.toString();
    return this;
  }
}
