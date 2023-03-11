import 'package:flutter/material.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../services/user_service.dart';

class UserProvider with ChangeNotifier {
  String _userName = "";
  String _email = "";
  String _password = "";
  String _accessToken = "";
  String _refreshToken = "";

  // UserProvider(
  //   this._userName,
  //   this._email,
  //   this._password,
  // );

  String get userName => _userName;

  // Future<void> storeToken(String key, String value) async {
  //   final storage = new FlutterSecureStorage();
  //   await storage.write(key: key, value: value);
  // }

  // Future<String> getToken(String key) async {
  //   final storage = new FlutterSecureStorage();
  //   return await storage.read(key: key);
  // }

  Future<void> login(String userName, String password) async {
    _userName = userName;
    _password = password;

    try {
      final response = await UserService().login(userName, password);
      print(response.data);
      _accessToken = response.data['accessToken'];
      _refreshToken = response.data['refreshToken'];
      // await storeToken('accessToken', _accessToken);
      // await storeToken('refreshToken', _refreshToken);
      // print(await getToken('accessToken'));
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }
}
