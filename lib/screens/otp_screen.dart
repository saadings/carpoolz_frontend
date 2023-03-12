import 'package:flutter/material.dart';

import '../widgets/auth_container.dart';
import '../widgets/otp_form.dart';

class OtpScreen extends StatelessWidget {
  static const routeName = '/otp';

  const OtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AuthContainer(
      title: 'OTP',
      child: OtpForm(),
    );
  }
}
