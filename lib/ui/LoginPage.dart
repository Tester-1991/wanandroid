import 'package:flutter/material.dart';
import 'package:wanandroid/event/event_login.dart';
import 'package:wanandroid/http/api.dart';
import 'package:wanandroid/manager/app_manager.dart';
import 'package:wanandroid/ui/RegisterPage.dart';
import 'package:toast/toast.dart';

///登录页面
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _username;

  String _password;

  FocusNode _pwdNode = FocusNode();

  Color _pwdIconColor;

  bool _isObscure = true;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("登录"),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 22.0),
          children: <Widget>[
            ///用户名
            _buildUesrName(),

            ///密码
            _buildPwd(),

            ///登录
            _buildLogin(),

            ///注册
            _buildRegister(),
          ],
        ),
      ),
    );
  }

  ///输入用户名
  _buildUesrName() {
    return TextFormField(
      ///自动获取焦点
      autofocus: true,
      decoration: InputDecoration(
        labelText: "用户名",
      ),
      initialValue: _username,
      textInputAction: TextInputAction.next,
      onEditingComplete: () {
        FocusScope.of(context).requestFocus(_pwdNode);
      },
      validator: (value) {
        if (value.trim().isEmpty) {
          return "请输入用户名";
        }
        _username = value;
      },
    );
  }

  ///输入密码
  _buildPwd() {
    return TextFormField(
      focusNode: _pwdNode,
      obscureText: _isObscure,
      textInputAction: TextInputAction.done,
      onEditingComplete: _doLogin,
      validator: (value) {
        if (value.trim().toString().isEmpty) {
          return "请输入密码";
        }

        _password = value;
      },
      decoration: InputDecoration(
          labelText: "密码",
          suffixIcon: IconButton(
              icon: Icon(
                Icons.remove_red_eye,
                color: _pwdIconColor,
              ),
              onPressed: () {
                setState(() {
                  _isObscure = !_isObscure;
                  _pwdIconColor = _isObscure
                      ? Colors.grey
                      : Theme.of(context).iconTheme.color;
                });
              })),
    );
  }

  ///登录
  _buildLogin() {
    return Container(
      height: 45.0,
      margin: EdgeInsets.only(left: 8.0, right: 8.0, top: 18.0),
      child: RaisedButton(
        onPressed: _doLogin,
        child: Text(
          "登录",
          style: TextStyle(color: Colors.white, fontSize: 18.0),
        ),
        color: Theme.of(context).primaryColor,
      ),
    );
  }

  ///注册
  _buildRegister() {
    return Padding(
      padding: EdgeInsets.only(top: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("没有账号?"),
          InkWell(
            child: Text(
              "点击注册",
              style: TextStyle(
                color: Colors.green,
              ),
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return RegisterPage();
              }));
            },
          )
        ],
      ),
    );
  }

  ///用户登录
  void _doLogin() async {
    _pwdNode.unfocus();

    ///输入内容验证
    if (_formKey.currentState.validate()) {
      ///登录
      var result = await Api.login(_username, _password);

      if (result['errorCode'] == -1) {
        Toast.show(result['errorMsg'], context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      } else {
        Navigator.pop(context);
        AppManager.prefs.setString(AppManager.ACCOUNT, _username);
        ///eventbus进行通知
        AppManager.eventBus.fire(LoginEvent(_username));
      }
    }
  }

  @override
  void dispose() {
    super.dispose();

    _pwdNode.dispose();
  }
}
