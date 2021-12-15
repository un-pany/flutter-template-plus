import 'package:flutter_template/http/core/my_base_request.dart';

class LoginRequest extends MyBaseRequest {
  @override
  HttpMethod httpMethod() {
    return HttpMethod.POST;
  }

  @override
  bool needLogin() {
    return false;
  }

  @override
  String path() {
    return '/mock-api/v1/users/login';
  }
}
