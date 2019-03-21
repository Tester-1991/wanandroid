import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:wanandroid/event/event_collect.dart';
import 'package:wanandroid/http/api.dart';
import 'package:wanandroid/manager/app_manager.dart';
import 'package:wanandroid/ui/LoginPage.dart';

///文章详细
class WebViewPage extends StatefulWidget {
  final data;

  final supportCollect;

  WebViewPage(this.data, {this.supportCollect = true});

  @override
  State<StatefulWidget> createState() {
    return _WebViewPageState();
  }
}

class _WebViewPageState extends State<WebViewPage> {
  ///是否加载成功
  bool isLoad = true;

  ///webview插件
  FlutterWebviewPlugin flutterWebviewPlugin;

  @override
  void initState() {
    super.initState();

    flutterWebviewPlugin = FlutterWebviewPlugin();

    flutterWebviewPlugin.onStateChanged.listen((state) {
      if (state.type == WebViewState.finishLoad) {
        ///加载完成
        setState(() {
          isLoad = false;
        });
      } else if (state.type == WebViewState.startLoad) {
        ///开始加载
        setState(() {
          isLoad = true;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();

    flutterWebviewPlugin.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var isCollect = widget.data['collect'] ?? false;

    ///webview插件
    return WebviewScaffold(
      appBar: AppBar(
        title: Text(widget.data['title']),
        actions: <Widget>[
          Offstage(
            offstage: !widget.supportCollect,
            child: IconButton(
              icon: Icon(
                Icons.favorite,
                color: isCollect ? Colors.red : Colors.white,
              ),
              onPressed: () => _collect(),
            ),
          ),
        ],
        bottom: PreferredSize(
          ///进度条
          child: const LinearProgressIndicator(),
          preferredSize: const Size.fromHeight(1.0),
        ),
        bottomOpacity: isLoad ? 1.0 : 0.0,
      ),
      withLocalStorage: true,

      ///缓存，数据存储
      url: widget.data["url"],
      withJavascript: true,
    );
  }

  ///收藏
  _collect() async {
    var result;

    bool isLogin = AppManager.isLogin();

    if (isLogin) {
      if (widget.data['collect']) {
        ///取消收藏
        result = await Api.unCollectArticle(widget.data['id']);
      } else {
        ///收藏
        result = await Api.collectArticle(widget.data['id']);
      }
    } else {
      ///跳转到登录页
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => LoginPage()));
    }

    if (result['errorCode'] == 0) {
      setState(() {
        widget.data['collect'] = !widget.data['collect'];

        ///eventbus进行通知
        AppManager.eventBus
            .fire(CollectEvent(widget.data['id'], widget.data['collect']));
      });
    }
  }
}
