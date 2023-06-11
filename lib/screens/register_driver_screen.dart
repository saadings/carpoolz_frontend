import 'package:flutter/material.dart';

import '../widgets/auth_container.dart';
import '../widgets/register_driver_form.dart';

class RegisterDriverScreen extends StatelessWidget {
  const RegisterDriverScreen({Key? key}) : super(key: key);

  static const String routeName = '/register-driver';

  @override
  Widget build(BuildContext context) {
    return const AuthContainer(
        title: "Register Driver", child: RegisterDriverForm());
  }
}
