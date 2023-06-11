import 'package:flutter/material.dart';

import '../services/api_services/vendor_services.dart';

class VendorProvider with ChangeNotifier {
  final userName;
  final cnic;


  VendorProvider({
    required this.userName,
    this.cnic,
  });

  Future<void> registerVendor(String cnic) async {
    try {
      await VendorService().registerVendor(
        userName.toLowerCase(),
        cnic
      );

      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
}
