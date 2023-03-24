import 'package:carpoolz_frontend/screens/confirm_ride_screen.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/socket_services/socket_service.dart';
import '../providers/ride_requests_provider.dart';

class RideRequests extends StatefulWidget {
  const RideRequests({super.key});

  @override
  State<RideRequests> createState() => _RideRequestsState();
}

class _RideRequestsState extends State<RideRequests> {
  bool _firstTime = true;
  final rideRequests = [];

  @override
  void initState() {
    // SocketService().init();
    // SocketService().listenToConnectionEvent();
    // SocketService().connect();

    // IO.Socket? socket;

    // try {
    //   socket = IO.io(
    //     'https://carpoolz.herokuapp.com/',
    //     <String, dynamic>{
    //       'transports': ['websocket'],
    //       'autoConnect': false,
    //     },
    //   );

    //   // Connect to websocket
    //   socket.on('laiba111', (data) {
    //     print(data);
    //     // setState(() {
    //     // rideRequests.add(data);
    //     // });
    //   });
    //   socket.on('connect', (_) => print('connect: ${socket!.id}'));
    //   socket.on('disconnect', (_) => print('disconnect'));
    //   socket.connect();
    // } catch (e) {
    //   print("Error ${e.toString()}");
    // }
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_firstTime) {
      final String _userName = "laiba111";
      // final String _userName =
      //     Provider.of<RideRequestProvider>(context).userName;
      // Provider.of<RideRequestProvider>(context, listen: false).getRideRequests(
      //   _userName,
      // );

      _firstTime = false;
    }
    super.didChangeDependencies();
  }

  // void listen() {
  //   socket!.on(
  //     'laiba111',
  //     (data) {
  //       print(data);
  //       // setState(() {
  //       rideRequests.add(data);
  //       // });
  //     },
  //   );
  // }

  @override
  void dispose() {
    // SocketService().disconnect();
    // socket!.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final rideRequests = Provider.of<RideRequestProvider>(context).rideRequests;
    print("ride length: ${rideRequests.length}");
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
