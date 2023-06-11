import 'package:flutter/material.dart';

import '../widgets/auth_container.dart';
import '../widgets/login_form.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);
  static const String routeName = '/';

  @override
  Widget build(BuildContext context) {
    return const AuthContainer(title: "Login", child: LoginForm());
  }
}
