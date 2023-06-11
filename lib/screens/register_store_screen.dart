import 'package:flutter/material.dart';

import '../widgets/auth_container.dart';
import '../widgets/register_store_form.dart';

class RegisterStoreScreen extends StatelessWidget {
  const RegisterStoreScreen({Key? key}) : super(key: key);

  static const String routeName = '/register-store';

  @override
  Widget build(BuildContext context) {
    return const AuthContainer(
        title: "Register Store", child: RegisterStoreForm());
  }
}
