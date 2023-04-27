import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

import '../providers/ride_requests_provider.dart';
import '../providers/user_provider.dart';
import '../providers/google_maps_provider.dart';

class RideRequests extends StatefulWidget {
  const RideRequests({super.key});

  @override
  State<RideRequests> createState() => _RideRequestsState();
}

class _RideRequestsState extends State<RideRequests> {
  // var rideRequests = [];
  bool _firstTime = false;

  @override
  void didChangeDependencies() {
    if (!_firstTime) {
      final _userName = Provider.of<RideRequestProvider>(
        context,
        listen: false,
      ).userName;

      Provider.of<RideRequestProvider>(
        context,
        listen: false,
      ).getRideRequests(_userName);

      _firstTime = true;
    }
    super.didChangeDependencies();
  }

  Future<void> _showPassengerDialog(var rideRequests) async {
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Driver Request"),
        content: Text("Do you want to contact this driver?"),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
            },
            child: Text("No"),
          ),
          TextButton(
            onPressed: () async {
              // print(rideRequests[0].toString());
              try {
                final userName = Provider.of<UserProvider>(
                  context,
                  listen: false,
                ).userName;

                Position? userPosition =
                    Provider.of<GoogleMapsProvider>(context, listen: false)
                        .currentPosition;

                Map<String, dynamic> userData = {
                  "userName": userName,
                  "origin": {
                    "latitude": {"\$numberDecimal": userPosition?.latitude},
                    "longitude": {"\$numberDecimal": userPosition?.longitude},
                  },
                };

                // print("USER DATA: $userData");

                await Provider.of<RideRequestProvider>(context, listen: false)
                    .emitRideRequest(
                  rideRequests[0]['userName'].toString(),
                  userData,
                );

                // Navigator.of(context).pop();
                final snackBar = SnackBar(
                  content: const Text(
                    "Ride Request Sent!",
                    textAlign: TextAlign.center,
                  ),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              } catch (e) {
                print(e.toString());
              } finally {
                Navigator.of(context).pop();
              }
              // Navigator.of(context).pushNamed(ConfirmRideScreen.routeName);
            },
            child: Text("Yes"),
          ),
        ],
      ),
    );
  }

  Future<void> _showDriverDialog() async {
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Passenger Request"),
        content: Text("Do you want to contact this passenger?"),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
            },
            child: Text("No"),
          ),
          TextButton(
            onPressed: () async {
              try {
                // await Provider.of<RideRequestProvider>(context, listen: false)
                //     .emitRideRequest(
                //   rideRequests[0]['userName'].toString(),
                //   rideRequests[0],
                // );
                final snackBar = SnackBar(
                  content: const Text(
                    'Ride Request Sent!',
                    textAlign: TextAlign.center,
                  ),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              } catch (e) {
                print(e.toString());
              } finally {
                Navigator.of(context).pop();
              }
              // Navigator.of(context).pushNamed(ConfirmRideScreen.routeName);
            },
            child: Text("Yes"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final rideRequests = Provider.of<RideRequestProvider>(context).rideRequests;

    return Container(
      padding: EdgeInsets.only(top: 7.5),
      child: rideRequests.isEmpty
          ? Center(
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.hourglass_bottom_rounded,
                  size: 50,
                  color: Colors.white70,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Waiting for Ride Requests",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 20,
                  ),
                ),
              ],
            ))
          : ListView.builder(
              itemBuilder: (ctx, index) => Column(
                children: [
                  ListTile(
                    onTap: () async {
                      Provider.of<UserProvider>(context, listen: false)
                                  .currentType ==
                              Type.passenger
                          ? await _showPassengerDialog(rideRequests)
                          : await _showDriverDialog();
                    },
                    // enableFeedback: true,
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white70,
                    ),
                    leading: CircleAvatar(
                      child: Text(
                        rideRequests[index]['userName'][0]
                            .toString()
                            .toUpperCase(),
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      backgroundColor: Theme.of(context).accentColor,
                    ),
                    title: Text(rideRequests[index]['userName'].toString()),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Longitude: ${rideRequests[index]['origin']['longitude']['\$numberDecimal']}",
                        ),
                        Text(
                          "Latitude: ${rideRequests[index]['origin']['latitude']['\$numberDecimal']}",
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                ],
              ),
              itemCount: rideRequests.length,
            ),
    );
  }
}
