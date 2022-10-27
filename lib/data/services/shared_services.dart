import 'package:shared_preferences/shared_preferences.dart';

class SharedServices {
  void setSharedUID(String uid) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('UID', uid);
  }

  Future<String?> getSharedUID() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('UID');
  }

  void removeSharedServices() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
