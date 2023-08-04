import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static SharedPref _instance = SharedPref._();

  factory SharedPref() => _instance;

  SharedPref._();

  SharedPreferences? _prefs;
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> savePrivateKey(String private_key) async {
    await _prefs!.setString('privateKey', private_key);
  }

  Future<String?> getPrivateKey() async {
    return _prefs!.getString('privateKey');
  }

  Future<void> removeData() async {
    await _prefs!.remove('privateKey');
  }
}
