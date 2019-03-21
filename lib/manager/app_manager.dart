import 'package:event_bus/event_bus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppManager {
  static const String ACCOUNT = "accountName";

  static EventBus eventBus = EventBus();

  static SharedPreferences prefs;

  static initApp() async {
    prefs = await SharedPreferences.getInstance();
  }

  ///是否登录
  static isLogin() {
    return prefs.getString(ACCOUNT) != null;
  }


}
