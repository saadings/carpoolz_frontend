import 'package:flutter/material.dart';

import '../widgets/auth_container.dart';
import '../widgets/register_vendor_form.dart';

class RegisterVendorScreen extends StatelessWidget {
  const RegisterVendorScreen({Key? key}) : super(key: key);

  static const String routeName = '/register-vendor';

  @override
  Widget build(BuildContext context) {
    return const AuthContainer(
        title: "Register Vendor", child: RegisterVendorForm());
  }
}
