import 'package:carpoolz_frontend/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/ride_requests.dart';

class RideRequestsScreen extends StatelessWidget {
  static const String routeName = '/ride-requests';

  const RideRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // final _currentType = Provider.of<UserProvider>(context).currentType;

    return Scaffold(
      appBar: AppBar(
        title: Text('Ride Requests'),
        actions: [
          IconButton(
            onPressed: () {
              // Navigator.of(context).pop();
            },
            icon: Icon(Icons.location_on),
          ),
        ],
      ),
      body: RideRequests(),
      // floatingActionButton: _currentType == Type.driver
      //     ? FloatingActionButton.small(
      //         tooltip: "Start Ride",
      //         backgroundColor: Theme.of(context).accentColor,
      //         onPressed: () {
      //           // if (_requestingRide) return;
      //           // Provider.of<ChatRoomProvider>(
      //           //   context,
      //           //   listen: false,
      //           // ).startRideRequest();

      //           // Navigator.of(context)
      //           //     .pushReplacementNamed(ConfirmRideScreen.routeName);
      //         },
      //         child: Text(
      //           'GO',
      //           style:
      //               TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      //         ),
      //         // label: Text('GO', style: TextStyle(color: Colors.white)),
      //       )
      //     : null,
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerTop,
    );
  }
}
