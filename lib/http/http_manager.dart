import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:path/path.dart';
import 'package:wanandroid/http/api.dart';

import 'package:path_provider/path_provider.dart';

///Http管理者
class HttpManager {
  Dio _dio;

  static HttpManager _instance;

  PersistCookieJar _persistCookieJar;

  factory HttpManager.getInstance() {
    if (null == _instance) {
      _instance = HttpManager._internal();
    }

    return _instance;
  }

  HttpManager._internal() {
    BaseOptions options = BaseOptions(
      baseUrl: Api.baseUrl, //基础地址
      connectTimeout: 5000, //连接服务器超时时间，单位是毫秒
      receiveTimeout: 3000, //读取超时
    );
    _dio = Dio(options);
    _initDio();
  }

  ///初始化配置
  void _initDio() async {
    Directory directory = await getApplicationDocumentsDirectory();
    var path = Directory(join(directory.path, "cookie")).path;
    _persistCookieJar = PersistCookieJar(dir: path);
    _dio.interceptors.add(CookieManager(_persistCookieJar));
  }

  ///发送请求
  request(url, {data, String method = "get"}) async {
    try {

      Options option = Options(method: method);

      Response response = await _dio.request(url, data: data, options: option);
      if (response.request.headers.toString().isNotEmpty) {
        print("请求头:" + response.request.headers.toString());
      }
      print("返回数据:" + response.data.toString());
      return response.data;
    } catch (e) {
      return null;
    }
  }

  ///post请求
  post(String url, {data}) async {
    try {
      Response response = await _dio.post(url, data: data);
      return response.data;
    } catch (e) {
      return null;
    }
  }

  ///清除cookie
  void clearCookie() {
    _persistCookieJar.deleteAll();
  }
}
