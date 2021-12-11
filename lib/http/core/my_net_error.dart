/// 网络异常统一格式类
class MyNetError implements Exception {
  MyNetError(this.code, this.message, {this.data});
  // 异常码
  final int code;
  // 异常消息
  final String message;
  // 异常数据
  final dynamic data;
}

/// 需要登录的异常
class NeedLogin extends MyNetError {
  NeedLogin({int code: 401, String message: '请先登录'}) : super(code, message);
}

/// 需要授权的异常
class NeedAuth extends MyNetError {
  NeedAuth(String message, {int code: 403, dynamic data})
      : super(code, message, data: data);
}
