import 'package:flutter/material.dart';

class ConfirmRideScreen extends StatelessWidget {
  static const routeName = '/confirm-ride';
  const ConfirmRideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ride Confirmed'),
      ),
      body: Container(
        child: Column(
          children: [
            Icon(
              Icons.check_circle,
              size: 100,
              color: Colors.green,
            ),
            Text(
              "Your Ride has been confirmed!",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
