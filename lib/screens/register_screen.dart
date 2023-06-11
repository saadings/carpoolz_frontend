import 'package:flutter/material.dart';

import '../widgets/auth_container.dart';
import '../widgets/register_form.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  static const String routeName = '/register';

  @override
  Widget build(BuildContext context) {
    return const AuthContainer(title: "Register", child: RegisterForm());
  }
}
