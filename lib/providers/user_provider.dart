import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../services/api_services/user_service.dart';
import '../services/local_storage_services/access_token_service.dart';

enum Gender { male, female }

enum Type { passenger, driver, vendor }

class UserProvider with ChangeNotifier {
  String _userName = "";
  String _email = "";
  String _firstName = "";
  String _lastName = "";
  String _contactNumber = "";
  Gender? _gender = null;
  int _rating = 0;
  bool _active = false;
  List<Type>? _types = [];
  Type _currentType = Type.passenger;

  String _accessToken = "";
  String _refreshToken = "";

  // UserModel(
  //   this._userName,
  //   this._email,
  //   this._firstName,
  //   this._lastName,
  //   this._contactNumber,
  //   this._gender,
  //   this._accessToken,
  //   this._refreshToken,
  // );

  String get userName => _userName;
  String get email => _email;
  String get firstName => _firstName;
  String get lastName => _lastName;
  String get contactNumber => _contactNumber;
  Gender? get gender => _gender;
  String get accessToken => _accessToken;
  String get refreshToken => _refreshToken;
  List<Type>? get types => _types;
  Type get currentType => _currentType;

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
      _userName = "";
      _email = "";
      _firstName = "";
      _lastName = "";
      _contactNumber = "";
      _gender = null;

      notifyListeners();
      rethrow;
    }
  }

  Future<void> login(String userName, String password) async {
    try {
      final Response response = await UserService().login(
        userName.toLowerCase(),
        password,
      );

      await AccessTokenService().storeToken(
        AccessTokenService.accessTokenKey,
        response.data['accessToken'],
      );

      await AccessTokenService().storeToken(
        AccessTokenService.refreshTokenKey,
        response.data['refreshToken'],
      );

      _accessToken = response.data['accessToken'];
      _refreshToken = response.data['refreshToken'];

      final data = response.data['data'];
      _userName = data['userName'];
      _email = data['email'];
      _firstName = data['firstName'];
      _lastName = data['lastName'];
      _contactNumber = data['contactNumber'];
      _gender = data['gender'] == "Male" ? Gender.male : Gender.female;
      _rating = data['rating'];
      _active = data['active'];
      _types = data['types']
          .map<Type>((e) => e == "Driver" ? Type.driver : Type.vendor)
          .toList();

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

      // notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> resendOtp() async {
    try {
      await UserService().resendOtp(
        userName.toLowerCase(),
      );

      // notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  void setType(String userType) {
    // print(userType);
    if (userType == 'Driver')
      _currentType = Type.driver;
    else if (userType == 'Passenger')
      _currentType = Type.passenger;
    else if (userType == 'Vendor') _currentType = Type.vendor;

    notifyListeners();
  }

  void appendTypeList(Type userType) {
    _types!.add(userType);
    notifyListeners();
  }
}
