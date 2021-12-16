import 'package:flutter_template/db/my_cache.dart';
import 'package:flutter_template/http/core/my_net.dart';
import 'package:flutter_template/http/request/login_request.dart';

/// 数据访问对象层，与服务端交互的部分，可以放在 Dao 层

class LoginDao {
  // 登录令牌
  static const Token = 'X-Access-Token';
  // 登录
  static Future login(String username, String password) async {
    LoginRequest request = LoginRequest();
    request.add('username', username).add('password', password);
    var res = await MyNet.getInstance().fire(request);
    // 判断业务状态码
    if (res['code'] == 20000 && res['data']['accessToken'] != null) {
      // 保存登录令牌
      MyCache.getInstance()
          .setString(Token, res['data']['accessToken']);
    }
    return res;
  }

  // 获取登录令牌
  static String? getToken() {
    return MyCache.getInstance().get<String>(Token);
  }

  // 删除登录令牌
  static removeToken() {
    return MyCache.getInstance().remove(Token);
  }
}
