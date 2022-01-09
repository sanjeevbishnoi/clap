import 'package:shared_preferences/shared_preferences.dart';

class MyPrefManager {
  static final MyPrefManager myPrefManager = new MyPrefManager._();
  SharedPreferences? prf;

  MyPrefManager._();

  static MyPrefManager prefInstance() {
    return myPrefManager;
  }

  Future<SharedPreferences> getSharedPreference() async {
    return await SharedPreferences.getInstance();
  }

  Future<bool> addData(String addKey, String data) async {
    SharedPreferences pref = await getSharedPreference();
    return pref.setString(addKey, data);
  }

  Future<dynamic> getData(String addKey) async {
    SharedPreferences pref = await getSharedPreference();
    return pref.getString(addKey);
  }

  Future<void> removeData(String key) async {
    SharedPreferences pref = await getSharedPreference();
    pref.remove(key);
  }
}
