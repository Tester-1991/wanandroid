import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:wanandroid/http/api.dart';
import 'package:banner_view/banner_view.dart';
import 'package:wanandroid/ui/ArticleItem.dart';
import 'package:wanandroid/ui/WebViewPage.dart';

///文章页面
class ArticlePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ArticlePageState();
  }
}

class _ArticlePageState extends State<ArticlePage> {
  ///滑动控制器
  ScrollController _controller = ScrollController();

  ///控制进度条显示
  bool _isLoading = true;

  ///请求到的文章数据
  List articles = [];

  ///banner图
  List banners = [];

  ///分页加载 当前页数
  var curPage = 0;

  ///总文章数有多少
  var listTotalSize = 0;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      ///监听控件可以滚动的最大距离
      var maxScroll = _controller.position.maxScrollExtent;

      ///获得当前位置的像素值
      var pixels = _controller.position.pixels;

      if (maxScroll == pixels && articles.length < listTotalSize) {
        ///加载更多
        _getArticlelist();
      }
    });

    _pullToRefresh();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        ///加载进度条
        Offstage(
          offstage: !_isLoading,
          child: Center(child: CircularProgressIndicator()),
        ),

        ///列表(内容)
        Offstage(
          offstage: _isLoading,
          child: RefreshIndicator(
            child: ListView.builder(
              itemCount: articles.length + 1,
              itemBuilder: (context, i) => _buildItem(i),
              controller: _controller,
            ),
            onRefresh: _pullToRefresh,
          ),
        )
      ],
    );
  }

  ///下拉刷新
  Future<void> _pullToRefresh() async {
    curPage = 0;

    Iterable<Future> futures = [_getArticlelist(), _getBanner()];

    await Future.wait(futures);

    _isLoading = false;

    setState(() {});

    return null;
  }

  ///获取文章列表数据
  _getArticlelist([bool update = true]) async {
    ///请求成功是map 失败是null
    var data = await Api.getArticleList(curPage);

    if (data != null) {
      var map = data["data"];

      var datas = map["datas"];

      ///文章总数
      listTotalSize = map["total"];

      if (curPage == 0) {
        articles.clear();
      }

      curPage++;

      articles.addAll(datas);

      if (update) {
        setState(() {});
      }
    }
  }

  ///获取banner数据
  _getBanner([bool update = true]) async {
    var data = await Api.getBanner();

    if (data != null) {
      banners.clear();

      banners.addAll(data['data']);

      if (update) {
        setState(() {});
      }
    }
  }

  ///构建item组件
  Widget _buildItem(int i) {
    if (i == 0) {
      return Container(
        height: 180.0,
        child: _bannerView(),
      );
    }

    var itemData = articles[i - 1];

    return ArticleItem(itemData);
  }

  ///banner图
  Widget _bannerView() {
    var list = banners.map((item) {
      ///自动增加点击水波纹的widget
      return InkWell(
        child: Image.network(item["imagePath"], fit: BoxFit.cover),
        onTap: () {
          ///跳转页面
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return WebViewPage(item);
          }));
        },
      );
    }).toList();

    return list.isNotEmpty
        ? BannerView(list, intervalDuration: const Duration(seconds: 3))
        : null;
  }
}
