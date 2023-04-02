import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/ride_requests_provider.dart';
import '../screens/confirm_ride_screen.dart';

class RideRequests extends StatefulWidget {
  const RideRequests({super.key});

  @override
  State<RideRequests> createState() => _RideRequestsState();
}

class _RideRequestsState extends State<RideRequests> {
  final rideRequests = [];

  @override
  Widget build(BuildContext context) {
    final rideRequests = Provider.of<RideRequestProvider>(context).rideRequests;

    return Container(
      child: ListView.builder(
        itemBuilder: (ctx, index) => ListTile(
          onTap: () async {
            await showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: Text("Ride Request"),
                content: Text("Do you want to accept this ride request?"),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("No"),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context)
                          .pushNamed(ConfirmRideScreen.routeName);
                    },
                    child: Text("Yes"),
                  ),
                ],
              ),
            );
          },
          title: Text(rideRequests[index]['userName'].toString()),
          subtitle: Text(rideRequests[index]['origin'].toString()),
        ),
        itemCount: rideRequests.length,
      ),
    );
  }
}
