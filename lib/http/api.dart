import 'package:dio/dio.dart';
import 'package:wanandroid/http/http_manager.dart';

class Api {
  static const String baseUrl = "https://www.wanandroid.com/";

  ///首页文章列表
  static const String ARTICLE_LIST = "article/list/";

  ///首页banner
  static const String BANNER = "banner/json";

  ///登录
  static const String LOGIN = "user/login";

  ///注册
  static const String REGISTER = "user/register";

  ///退出
  static const String LOGOUT = "user/logout/json";

  ///收藏文章列表
  static const String COLLECT_ARTICLE_LIST = "lg/collect/list/";

  ///收藏网站列表
  static const String COLLECT_WEBSITE_LIST = "lg/collect/usertools/json";

  ///收藏站内文章
  static const String COLLECT_INTERNAL_ARTICLE = "lg/collect/";

  ///取消收藏站内文章
  static const String UNCOLLECT_INTERNAL_ARTICLE = "lg/uncollect_originId/";

  ///收藏网址
  static const String COLLECT_WEBSITE = "lg/collect/addtool/json";

  ///取消收藏网址
  static const String UNCOLLECT_WEBSITE = "lg/collect/deletetool/json";

  ///获取文章列表
  static getArticleList(int page) async {
    return await HttpManager.getInstance().request("$ARTICLE_LIST$page/json");
  }

  ///获取轮播图数据
  static getBanner() async {
    return await HttpManager.getInstance().request(BANNER);
  }

  ///登录
  static login(String username, String password) async {
    var formData = FormData.from({
      "username": username,
      "password": password,
    });

    return await HttpManager.getInstance()
        .request(LOGIN, data: formData, method: "post");
  }

  ///注册
  static register(String username, String password) async {
    var formData = FormData.from({
      "username": username,
      "password": password,
      "repassword": password,
    });

    return await HttpManager.getInstance()
        .request(REGISTER, data: formData, method: "post");
  }

  ///收藏站内文章
  static collectArticle(int id) async {
    return await HttpManager.getInstance()
        .request("$COLLECT_INTERNAL_ARTICLE$id/json", method: "post");
  }

  ///取消收藏站内文章
  static unCollectArticle(int id) async {
    return await HttpManager.getInstance()
        .request("$UNCOLLECT_INTERNAL_ARTICLE$id/json", method: "post");
  }

  ///收藏网站
  static collectWebsite(String name, String link) async {
    var formdata = FormData.from({
      "name": name,
      "link": link,
    });
    return await HttpManager.getInstance()
        .request(COLLECT_WEBSITE, data: formdata, method: "post");
  }

  ///取消收藏网站
  static unCollectWebsite(int id) async {
    var formData = FormData.from({"id": id});
    return await HttpManager.getInstance()
        .request(UNCOLLECT_WEBSITE, data: formData, method: "post");
  }

  ///文章收藏列表
  static getArticleCollectionList(int page) async {
    return await HttpManager.getInstance()
        .request("$COLLECT_ARTICLE_LIST$page/json");
  }

  ///网站收藏列表
  static getWebsiteCollectionList() async {
    return await HttpManager.getInstance().request(COLLECT_WEBSITE_LIST);
  }

  ///清除cookie
  static clearCookie() {
    HttpManager.getInstance().clearCookie();
  }
}
