import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wanandroid/http/api.dart';
import 'package:wanandroid/manager/app_manager.dart';
import 'package:wanandroid/ui/ASCollectPage.dart';
import 'package:wanandroid/ui/CollectPage.dart';
import 'package:wanandroid/ui/LoginPage.dart';
import 'package:wanandroid/event/event_login.dart';

///主页面左侧抽屉
class MainDrawer extends StatefulWidget {
  @override
  _MainDrawerState createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  String _username;

  StreamSubscription loginSubscription;

  @override
  void initState() {
    super.initState();

    ///eventbus监听
    loginSubscription = AppManager.eventBus.on<LoginEvent>().listen((event) {
      setState(() {
        _username = event.username;
      });
    });

    _username = AppManager.prefs.getString(AppManager.ACCOUNT);
  }

  @override
  void dispose() {
    super.dispose();

    if (loginSubscription != null) {
      loginSubscription.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    ///用户头像
    Widget userHeader = DrawerHeader(
      decoration: BoxDecoration(
        color: Colors.blue,
      ),
      child: InkWell(
        onTap: () {
          _itemClick(null);
        },
        child: Column(
          children: <Widget>[
            CircleAvatar(
              backgroundImage: AssetImage("assets/images/logo.png"),
              radius: 38.0,
            ),
            Padding(
              padding: EdgeInsets.only(top: 18.0),
              child: Text(
                _username ?? "请先登录",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );

    return ListView(
      ///不设置会导致状态栏灰色
      padding: EdgeInsets.zero,
      children: <Widget>[
        ///用户头像
        userHeader,

        ///收藏
        InkWell(
          child: ListTile(
            leading: Icon(Icons.favorite),
            title: Text(
              "收藏列表",
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
          ),
          onTap: () {
            _itemClick(ASCollectPage());
          },
        ),

        Padding(
          padding: EdgeInsets.symmetric(horizontal: 18.0),
          child: Divider(
            color: Colors.grey,
          ),
        ),

        ///退出登录
        Offstage(
          offstage: _username == null,
          child: InkWell(
            child: ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text(
                "退出登录",
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
            ),
            onTap: () {
              setState(() {
                AppManager.prefs.setString(AppManager.ACCOUNT, null);
                Api.clearCookie();
                _username = null;
              });
              Navigator.of(context).pop();
            },
          ),
        )
      ],
    );
  }

  ///头像点击事件
  _itemClick(Widget page) {
    ///如果未登录，则进入登录页面
    var dstPage = _username == null ? LoginPage() : page;
    if (dstPage != null) {
      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return dstPage;
      }));
    }
  }
}
