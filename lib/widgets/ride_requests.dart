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
      padding: EdgeInsets.only(top: 7.5),
      child: ListView.builder(
        itemBuilder: (ctx, index) => Column(
          children: [
            ListTile(
              onTap: () async {
                await showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text("Driver Request"),
                    content: Text("Do you want to contact this driver?"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          print(rideRequests[index].toString());
                          try {
                            Provider.of<RideRequestProvider>(context,
                                    listen: false)
                                .emitRideRequest(
                              rideRequests[index]['userName'].toString(),
                              rideRequests[index],
                            );
                          } catch (e) {
                            print(e.toString());
                          }
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
              // enableFeedback: true,
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: Colors.white70,
              ),
              leading: CircleAvatar(
                child: Text(
                  rideRequests[index]['userName'][0].toString().toUpperCase(),
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
