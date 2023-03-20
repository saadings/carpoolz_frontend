import 'package:flutter/material.dart';

import '../widgets/google_maps.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMaps(),
    );
  }
}
