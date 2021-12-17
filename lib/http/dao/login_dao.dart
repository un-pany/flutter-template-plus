import 'package:flutter_template/common/constants.dart';
import 'package:flutter_template/db/my_cache.dart';
import 'package:flutter_template/http/core/my_net.dart';
import 'package:flutter_template/http/request/login_request.dart';

/// 数据访问对象层，与服务端交互的部分，可以放在 Dao 层

class LoginDao {
  // 登录
  static Future login(String username, String password) async {
    // 创建请求
    LoginRequest request = LoginRequest();
    // 向请求中添加查询参数
    request.add('username', username).add('password', password);
    // 发送请求
    var res = await MyNet.getInstance().fire(request);
    // 保存登录令牌
    setToken(res['data']['accessToken']);
    return res;
  }

  // 保存登录令牌
  static setToken(text) {
    MyCache.getInstance().setString(Constants.token, text);
  }

  // 获取登录令牌
  static String? getToken() {
    return MyCache.getInstance().get<String>(Constants.token);
  }

  // 删除登录令牌
  static removeToken() {
    return MyCache.getInstance().remove(Constants.token);
  }
}
