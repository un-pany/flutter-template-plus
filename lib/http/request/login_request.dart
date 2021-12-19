import 'package:flutter_template_plus/http/core/my_base_request.dart';

class LoginRequest extends MyBaseRequest {

  // 请求类型
  @override
  HttpMethod httpMethod() {
    return HttpMethod.POST;
  }

  // 访问该接口是否需要先登录
  @override
  bool needLogin() {
    return false;
  }

  // 该接口 path
  @override
  String path() {
    return '/mock-api/v1/users/login';
  }
}
