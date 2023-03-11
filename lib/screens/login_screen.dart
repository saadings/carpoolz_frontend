import 'package:flutter/material.dart';

import '../widgets/auth_container.dart';
import '../widgets/login_form.dart';

class LoginScreen extends StatelessWidget {
  static const String routeName = '/';

  @override
  Widget build(BuildContext context) {
    return AuthContainer(title: "Login", child: LoginForm());
  }
}
