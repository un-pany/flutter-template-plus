enum HttpMethod { GET, POST, DELETE, PUT }

/// 基础请求
abstract class BaseRequest {
  // path 参数
  var pathParams;
  // 是否为 https
  bool useHttps = true;
  // 域名
  String authority() {
    return 'api.devio.org';
  }

  // 设置请求方法
  HttpMethod httpMethod();
  // 设置 path
  String path();
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
    print('url:${uri.toString()}');
    return uri.toString();
  }

  // 接口是否需要登录
  bool needLogin();

  // 查询参数
  Map<String, String> params = Map();
  // 添加查询参数
  BaseRequest add(String k, Object v) {
    params[k] = v.toString();
    return this;
  }

  // header 数据
  Map<String, String> header = Map();
  // 添加 header
  BaseRequest addHeader(String k, Object v) {
    params[k] = v.toString();
    return this;
  }
}
