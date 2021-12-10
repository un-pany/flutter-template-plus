import 'dart:convert';
import 'package:flutter_templete/http/core/base_request.dart';

/// 网络请求抽象类
abstract class HiNetAdapter {
  Future<HiNetResponse<T>> send<T>(BaseRequest request);
}

/// 统一网络返回格式
class HiNetResponse<T> {
  HiNetResponse({
    this.data,
    this.request,
    this.statusCode,
    this.statusMessage,
    this.extra,
  });

  T? data;
  // 请求
  BaseRequest? request;
  // http 状态码
  int? statusCode;
  // http Message
  String? statusMessage;
  // 其他
  dynamic extra;

  @override
  String toString() {
    if (data is Map) {
      return json.encode(data);
    }
    return data.toString();
  }
}
