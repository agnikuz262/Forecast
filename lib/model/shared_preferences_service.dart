import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  SharedPreferences prefs;
  List<String> list;

  Future<bool> saveList() async {
    return await prefs.setStringList("key", list);
  }
  List<String> getList()  {
    return prefs.getStringList("key");
  }
}
