import 'package:flutter/material.dart';
import 'package:wanandroid/http/api.dart';
import 'package:wanandroid/ui/CollectionItem.dart';

///收藏页面
class CollectPage extends StatefulWidget {
  @override
  _CollectPageState createState() => _CollectPageState();
}

class _CollectPageState extends State<CollectPage> {
  bool _isLoading = true;

  ///收藏数据
  List collections = [];

  ///滑动控制器
  ScrollController _controller = ScrollController();

  var curPage = 0;

  ///总收藏数有多少
  var listTotalSize = 0;

  @override
  void initState() {
    super.initState();

    _controller.addListener(() {
      ///监听控件可以滚动的最大距离
      var maxScroll = _controller.position.maxScrollExtent;

      ///获得当前位置的像素值
      var pixels = _controller.position.pixels;

      if (maxScroll == pixels && collections.length < listTotalSize) {
        ///加载更多
        _pullToRefresh(false);
      }
    });

    _pullToRefresh(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("收藏"),
      ),
      body: Stack(
        children: <Widget>[
          Offstage(
            offstage: !_isLoading,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
          Offstage(
            offstage: _isLoading,
            child: RefreshIndicator(
              child: ListView.builder(
                physics: AlwaysScrollableScrollPhysics(),
                itemCount: collections.length,
                itemBuilder: (context, i) {
                  return CollectItem(collections[i]);
                },
                controller: _controller,
              ),
              onRefresh: () => _pullToRefresh(true),
            ),
          ),
        ],
      ),
    );
  }

  ///上拉刷新
  Future<void> _pullToRefresh(bool refresh) async {
    if (refresh) {
      curPage = 0;
    }

    ///获取收藏数据
    var result = await Api.getArticleCollectionList(curPage);

    if (result != null) {
      var data = result['data'];

      listTotalSize = data['total'];

      var datas = data['datas'];

      if (curPage == 0) {
        collections.clear();
      }

      collections.addAll(datas);

      curPage++;
    }

    _isLoading = false;

    setState(() {});

    return null;
  }
}
