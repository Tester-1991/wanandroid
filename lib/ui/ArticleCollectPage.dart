import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wanandroid/event/event_collect.dart';
import 'package:wanandroid/http/api.dart';
import 'package:wanandroid/manager/app_manager.dart';
import 'package:wanandroid/ui/ArticleItem.dart';

///文章收藏
class ArticleCollectPage extends StatefulWidget {
  @override
  _ArticleCollectPageState createState() => _ArticleCollectPageState();
}

class _ArticleCollectPageState extends State<ArticleCollectPage>
    with AutomaticKeepAliveClientMixin {
  bool _isHidden = false;

  List _collects = [];

  var curPage = 0;

  var pageCount;

  ///滑动控制器
  ScrollController _controller = ScrollController();

  StreamSubscription collectEventListen;

  @override
  void initState() {
    super.initState();

    ///添加监听器
    _controller.addListener(() {
      ///控件滚动的最大范围
      var maxScroll = _controller.position.maxScrollExtent;

      ///获取当前位置的像素值
      var pixels = _controller.position.pixels;

      if (maxScroll == pixels && curPage < pageCount) {
        ///加载更多数据
        _getCollects();
      }
    });

    ///eventbus事件总线
    collectEventListen = AppManager.eventBus.on<CollectEvent>().listen((event) {
      if (mounted) {
        ///取消收藏
        if (!event.collect) {
          _collects.removeWhere((item) {
            return item['id'] == event.id;
          });
        }
      }
    });

    _getCollects();
  }

  @override
  void dispose() {
    super.dispose();

    collectEventListen?.cancel();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Offstage(
          offstage: _isHidden,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
        Offstage(
          ///不为空就隐藏
          offstage: !_isHidden || _collects.isNotEmpty,
          child: Center(
            child: Text("(＞﹏＜) 你还没有收藏任何内容......"),
          ),
        ),
        Offstage(
          ///为空就隐藏
          offstage: _collects.isEmpty,
          child: RefreshIndicator(
            child: ListView.builder(
              physics: AlwaysScrollableScrollPhysics(),
              itemCount: _collects.length,
              itemBuilder: (context, i) => buildItem(i),
              controller: _controller,
            ),
            onRefresh: () => _getCollects(true),
          ),
        )
      ],
    );
  }

  buildItem(int i) {
    _collects[i]['id'] = _collects[i]['originId'];
    _collects[i]['collect'] = true;
    return ArticleItem(_collects[i]);
  }

  ///获取收藏文章列表
  _getCollects([bool refresh = false]) async {
    if (refresh) {
      curPage = 0;
    }

    var result = await Api.getArticleCollectionList(curPage);

    if (result != null) {
      if (curPage == 0) {
        _collects.clear();
      }

      curPage++;

      var data = result['data'];

      pageCount = data['pageCount'];

      _collects.addAll(data['datas']);
      _isHidden = true;
      setState(() {});
    }
  }

  @override
  bool get wantKeepAlive => true;
}
