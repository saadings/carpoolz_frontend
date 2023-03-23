import 'package:flutter/material.dart';

import '../widgets/google_maps.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName = '/home';
  const HomeScreen({super.key});

  // Future<void> _loadEnv () async {
  //   await DotEnv().load('.env');
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMaps(),
    );
  }
}
