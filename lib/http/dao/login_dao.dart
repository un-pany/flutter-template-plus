import 'package:flutter_templete/http/core/hi_net.dart';
import 'package:flutter_templete/http/request/login_request.dart';

/// 数据访问对象层，与服务端交互的部分，可以放在 Dao 层

class LoginDao {
  static Future login(String username, String password) async {
    LoginRequest request = LoginRequest();
    request.add('username', username).add('password', password);
    var res = await HiNet.getInstance().fire(request);
    return res;
  }
}
