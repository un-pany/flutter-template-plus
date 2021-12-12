/// 字符串工具类
class StringUtil {
  // 判断字符串是否不为空
  static bool isNotEmpty(String? text) {
    return text?.isNotEmpty ?? false;
  }

  // 判断字符串是否为空
  static bool isEmpty(String? text) {
    return text?.isEmpty ?? true;
  }
}
