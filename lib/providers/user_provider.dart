import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../services/api_services/user_service.dart';
import '../services/local_storage_services/access_token_service.dart';

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

  Future<void> registerDriver(String cnic, String licenseNo) async {
    try {
      await UserService().registerDriver(
        _userName.toLowerCase(),
        cnic,
        licenseNo,
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
      await AccessTokenService().storeToken(
        AccessTokenService.accessTokenKey,
        response.data['accessToken'],
      );
      await AccessTokenService().storeToken(
        AccessTokenService.refreshTokenKey,
        response.data['refreshToken'],
      );

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

  Future<void> resendOtp() async {
    try {
      await UserService().resendOtp(
        userName.toLowerCase(),
      );

      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
}
