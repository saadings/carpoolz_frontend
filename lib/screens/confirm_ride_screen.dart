import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/chat_room_provider.dart';
import '../widgets/google_maps.dart';

class ConfirmRideScreen extends StatefulWidget {
  static const routeName = '/confirm-ride';
  const ConfirmRideScreen({super.key});

  @override
  State<ConfirmRideScreen> createState() => _ConfirmRideScreenState();
}

class _ConfirmRideScreenState extends State<ConfirmRideScreen> {
  bool _firstTime = false;

  @override
  void didChangeDependencies() {
    if (!_firstTime) {
      Provider.of<ChatRoomProvider>(context, listen: false)
          .receiveConfirmRide();
      _firstTime = true;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final _startRide = Provider.of<ChatRoomProvider>(context).startRide;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ride Confirmation'),
      ),
      body: Container(
        child: _startRide
            ? Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 20),
                    Text('Waiting for the other user to confirm ride'),
                  ],
                ),
              )
            : Column(
                // mainAxisAlignment: MainAxisAlignment.s,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: GoogleMaps(),
                  ),
                  SizedBox(height: 20),
                  Icon(
                    Icons.check_circle,
                    size: 40,
                    color: Colors.green,
                  ),
                  SizedBox(height: 10),
                  Column(
                    children: [
                      Text(
                        "Your ride has been confirmed!",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "Please wait for your driver to arrive!",
                        style: TextStyle(
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }
}
