import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:toast/toast.dart';
import 'package:wanandroid/http/api.dart';
import 'package:wanandroid/ui/WebsiteAddPage.dart';

///网址收藏
class WebsiteCollectPage extends StatefulWidget {
  @override
  _WebsiteCollectPageState createState() => _WebsiteCollectPageState();
}

class _WebsiteCollectPageState extends State<WebsiteCollectPage>
    with AutomaticKeepAliveClientMixin {
  bool _isHidden = false;

  ///收藏数据
  var _collects = [];

  @override
  void initState() {
    super.initState();

    ///获取网址收藏列表
    _getCollects();
  }

  _getCollects() async {
    var result = await Api.getWebsiteCollectionList();
    if (result != null) {
      var data = result['data'];
      _collects.clear();
      _collects.addAll(data);
      _isHidden = true;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        ///进度条
        Offstage(
          offstage: _isHidden,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),

        ///数据不为空就隐藏
        Offstage(
          offstage: _collects.isNotEmpty || !_isHidden,
          child: Center(
            child: Text("(＞﹏＜) 你还没有收藏任何内容......"),
          ),
        ),

        ///为空就隐藏
        Offstage(
          offstage: _collects.isEmpty,
          child: ListView.separated(
            padding: EdgeInsets.all(22.0),
            physics: AlwaysScrollableScrollPhysics(),
            itemBuilder: (context, i) => _buildItem(context, i),
            separatorBuilder: (context, i) {
              return Padding(
                padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                child: Divider(
                  color: Colors.grey,
                ),
              );
            },
            itemCount: _collects.length,
          ),
        ),

        ///添加按钮
        Positioned(
          bottom: 18.0,
          right: 18.0,
          child: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: _addCollect,
          ),
        ),
      ],
    );
  }

  ///构建item
  _buildItem(BuildContext context, int i) {
    var item = _collects[i];

    ///侧滑删除
    return Slidable(
      delegate: SlidableDrawerDelegate(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            item['name'],
            style: TextStyle(
              fontSize: 22.0,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Text(
              item['link'],
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
          ),
        ],
      ),

      ///右侧的action
      secondaryActions: <Widget>[
        IconSlideAction(
          icon: Icons.delete,
          caption: "删除",
          color: Colors.red,
          onTap: () => _delCollect(item),
        ),
      ],
    );
  }

  ///删除收藏
  _delCollect(item) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return Center(
            child: CircularProgressIndicator(),
          );
        });

    var result = await Api.unCollectWebsite(item['id']);

    Navigator.pop(context);

    if (result['errorCode'] != 0) {
      Toast.show(result['errorMsg'], context, gravity: Toast.CENTER);
    } else {
      setState(() {
        _collects.remove(item);
      });
    }
  }

  ///添加收藏
  _addCollect() async {
    var result = await Navigator.push(context, MaterialPageRoute(builder: (_) {
      return WebsiteAddPage();
    }));

    if (result != null) {
      _collects.add(result);
    }
  }

  @override
  bool get wantKeepAlive => true;
}
