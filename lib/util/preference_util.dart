import 'package:shared_preferences/shared_preferences.dart';


class PreferenceUtil{
  static SharedPreferences _sharedPreferences;
  static final PreferenceUtil _singleton = PreferenceUtil.init();

  void _init() async
  {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  PreferenceUtil.init(){
    _init();
  }

  factory PreferenceUtil(){
    return _singleton;
  }

  SharedPreferences getSharedPreference()
  {
      return _sharedPreferences;
  }

}