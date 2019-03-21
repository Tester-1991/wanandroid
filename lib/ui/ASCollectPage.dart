import 'package:flutter/material.dart';
import 'package:wanandroid/common/res/icons.dart';
import 'package:wanandroid/ui/ArticleCollectPage.dart';
import 'package:wanandroid/ui/WebsiteCollectPage.dart';

///我的收藏
class ASCollectPage extends StatefulWidget {
  @override
  _ASCollectPageState createState() => _ASCollectPageState();
}

class _ASCollectPageState extends State<ASCollectPage> {
  final tabs = ["文章", "网站"];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text("我的收藏"),
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                icon: Icon(
                  article,
                  size: 32.0,
                ),
                text: "文章",
              ),
              Tab(
                icon: Icon(
                  website,
                  size: 32.0,
                ),
                text: "网站",
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            ArticleCollectPage(),
            WebsiteCollectPage(),
          ],
        ),
      ),
    );
  }
}
