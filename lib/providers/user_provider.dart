import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../services/user_service.dart';

class UserProvider with ChangeNotifier {
  String _userName;
  String _email;
  String _password;
  String _accessToken;
  String _refreshToken;

  // UserProvider(
  //   this._userName,
  //   this._email,
  //   this._password,
  // );

  String get userName => _userName;
  String get email => _email;

  Future<void> login(String userName, String password) async {
    _userName = userName;
    _password = password;
    print("userName: $_userName");
    print("password: $_password");
    notifyListeners();

    try {
      final response = await UserService().getUser(1);
    } catch (e) {
      print(e);
    }
  }
}
