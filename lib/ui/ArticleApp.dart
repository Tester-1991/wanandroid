import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:wanandroid/ui/ArticlePage.dart';
import 'package:wanandroid/ui/MainDrawer.dart';

class ArticleApp extends StatefulWidget {
  @override
  _ArticleAppState createState() => _ArticleAppState();
}

class _ArticleAppState extends State<ArticleApp> {

  @override
  void initState() {
    super.initState();
    Toast.show("initState", context,duration: Toast.LENGTH_SHORT);
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            "文章",
            style: const TextStyle(color: Colors.white),
          ),
        ),
        body: ArticlePage(),
        drawer: Drawer(
          child: Container(
            width: 120.0,
            child: MainDrawer(),
          ),
        ),
      ),
    );
  }
}
