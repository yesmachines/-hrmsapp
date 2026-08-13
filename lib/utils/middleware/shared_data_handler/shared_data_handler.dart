import 'package:shared_preferences/shared_preferences.dart';

class SharedDataHandler {
  Future<String> getSharedData({required String key}) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? data = sharedPreferences.getString(key);
    return data ?? "";
  }

  Future<bool> setSharedData(
      {required String key, required String value}) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bool data = await sharedPreferences.setString(key, value);
    return data;
  }


Future<bool> removeData(
      {required String key}) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bool data = await sharedPreferences.remove(key);
    return data;
  }



  Future<bool> clearSharedData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    bool data = await sharedPreferences.clear();
    return data;
  }
}
