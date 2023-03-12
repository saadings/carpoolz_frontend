import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../services/user_service.dart';

enum Gender { male, female }

class UserProvider with ChangeNotifier {
  String _userName = "";
  String _email = "";
  String _password = "";
  String _firstName = "";
  String _lastName = "";
  String _contactNumber = "";
  Gender _gender = Gender.male;
  String _accessToken = "";
  String _refreshToken = "";

  // UserProvider(
  //   this._userName,
  //   this._email,
  //   this._password,
  // );

  String get userName => _userName;

  Future<void> storeToken(String key, String value) async {
    AndroidOptions getAndroidOptions() => const AndroidOptions(
          encryptedSharedPreferences: true,
        );
    final storage = FlutterSecureStorage(aOptions: getAndroidOptions());
    await storage.write(key: key, value: value);
  }

  Future<String?> getToken(String key) async {
    AndroidOptions getAndroidOptions() => const AndroidOptions(
          encryptedSharedPreferences: true,
        );
    final storage = FlutterSecureStorage(aOptions: getAndroidOptions());
    return await storage.read(key: key);
  }

  Future<void> register(
    String userName,
    String email,
    String firstName,
    String lastName,
    String contactNumber,
    Gender gender,
    String password,
  ) async {
    final String userNameFormatted = userName.toLowerCase();
    final String emailFormatted = email.toLowerCase();
    final String genderFormatted = gender == Gender.male ? "Male" : "Female";

    _userName = userNameFormatted;
    _email = emailFormatted;
    _firstName = firstName;
    _lastName = lastName;
    _contactNumber = contactNumber;
    _gender = gender;
    _password = password;

    try {
      await UserService().register(
        userNameFormatted,
        emailFormatted,
        firstName,
        lastName,
        contactNumber,
        genderFormatted,
        password,
      );

      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> login(String userName, String password) async {
    _userName = userName.toLowerCase();
    _password = password;

    try {
      final Response response = await UserService().login(
        userName.toLowerCase(),
        password,
      );
      _accessToken = response.data['accessToken'];
      _refreshToken = response.data['refreshToken'];
      await storeToken('accessToken', _accessToken);
      await storeToken('refreshToken', _refreshToken);

      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> verify(
    String otp,
  ) async {
    try {
      await UserService().verify(
        userName.toLowerCase(),
        otp,
      );

      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
}
