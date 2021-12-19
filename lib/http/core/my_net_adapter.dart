import 'dart:convert';
import 'package:flutter_template_plus/http/core/my_base_request.dart';

/// 网络请求抽象类
abstract class MyNetAdapter {
  Future<MyNetResponse<T>> send<T>(MyBaseRequest request);
}

/// 统一网络返回格式
class MyNetResponse<T> {
  T? data;
  // 请求
  MyBaseRequest? request;
  // http 状态码
  int? statusCode;
  // http Message
  String? statusMessage;
  // 其他
  dynamic extra;

  MyNetResponse({
    this.data,
    this.request,
    this.statusCode,
    this.statusMessage,
    this.extra,
  });

  @override
  String toString() {
    if (data is Map) {
      return json.encode(data);
    }
    return data.toString();
  }
}
