import 'package:flutter/material.dart';

import '../services/api_services/driver_services.dart';

class DriverProvider with ChangeNotifier {
  final userName;
  final cnic;
  final licenseNo;

  DriverProvider({
    required this.userName,
    this.cnic,
    this.licenseNo,
  });

  Future<void> registerDriver(String cnic, String licenseNo) async {
    try {
      await DriverService().registerDriver(
        userName.toLowerCase(),
        cnic,
        licenseNo,
      );

      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
}
