import 'package:carpoolz_frontend/providers/chat_room_provider.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

import '../providers/ride_requests_provider.dart';
import '../providers/user_provider.dart';
import '../providers/google_maps_provider.dart';

import '../screens/chat_room_screen.dart';

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
    // final requestingRide = Provider.of<RideRequestProvider>(
    //   context,
    //   listen: false,
    // ).requestingRide;

    // if (requestingRide) {
    //   Navigator.of(context).pushNamed(ChatRoomScreen.routeName);
    // }
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

  Future<void> _showPassengerDialog(var rideRequests, int index) async {
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

                await Provider.of<RideRequestProvider>(context, listen: false)
                    .emitRideRequest(
                  rideRequests[index]['userName'].toString(),
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

                Provider.of<ChatRoomProvider>(
                  context,
                  listen: false,
                ).setReceiverName(rideRequests[index]['userName'].toString());

                Provider.of<RideRequestProvider>(
                  context,
                  listen: false,
                ).startChatRequest();

                Provider.of<RideRequestProvider>(
                  context,
                  listen: false,
                ).receiveChatRequest();
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed(ChatRoomScreen.routeName);
              } catch (e) {
                print(e.toString());
              } finally {
                // Navigator.of(context).pop();
              }
              // Navigator.of(context).pushNamed(ConfirmRideScreen.routeName);
            },
            child: Text("Yes"),
          ),
        ],
      ),
    );
  }

  Future<void> _showDriverDialog(var rideRequests, int index) async {
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
                await Provider.of<RideRequestProvider>(context, listen: false)
                    .emitRideRequest(
                  "${rideRequests[index]['userName'].toString()}/chat",
                  {
                    "startChat": true,
                  },
                );
                final snackBar = SnackBar(
                  content: const Text(
                    'Chat Request Sent!',
                    textAlign: TextAlign.center,
                  ),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);

                Provider.of<ChatRoomProvider>(
                  context,
                  listen: false,
                ).setReceiverName(rideRequests[index]['userName'].toString());

                Navigator.of(context).pop();

                Navigator.of(context).pushNamed(ChatRoomScreen.routeName);
              } catch (e) {
                print(e.toString());
              } finally {
                // Navigator.of(context).pop();
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
    // final requestingRide =
    //     Provider.of<RideRequestProvider>(context).requestingRide;
    // final currentType = Provider.of<UserProvider>(context).currentType;
    return Container(
      padding: EdgeInsets.only(top: 7.5),
      child:
          // requestingRide && currentType == Type.passenger
          //     ? CircularProgressIndicator()
          //     :
          rideRequests.isEmpty
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
                              ? await _showPassengerDialog(rideRequests, index)
                              : await _showDriverDialog(rideRequests, index);
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
