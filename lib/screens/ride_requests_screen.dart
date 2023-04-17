import 'package:flutter/material.dart';

import '../widgets/ride_requests.dart';

class RideRequestsScreen extends StatelessWidget {
  static const String routeName = '/ride-requests';

  const RideRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Driver Requests'),
      ),
      body: RideRequests(),
    );
  }
}
