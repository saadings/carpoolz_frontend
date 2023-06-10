import 'package:carpoolz_frontend/providers/driver_provider.dart';
import 'package:carpoolz_frontend/providers/user_provider.dart';
import 'package:carpoolz_frontend/screens/ride_requests_screen.dart';
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
          .receiveConfirmRide(context);
      _firstTime = true;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final _startRide = Provider.of<ChatRoomProvider>(context).startRide;
    final _currentType = Provider.of<UserProvider>(context).currentType;
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
                  _currentType == Type.passenger
                      ? PassengerWidget()
                      : DriverWidget(),
                ],
              ),
      ),
    );
  }
}

class DriverWidget extends StatelessWidget {
  const DriverWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final _startRide = Provider.of<DriverProvider>(context).startRide;
    return Column(
      children: [
        if (!_startRide)
          OutlinedButton(
            onPressed: () {
              Navigator.of(context)
                  .pushReplacementNamed(RideRequestsScreen.routeName);
            },
            child: Text(
              "Add More Passengers",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        _startRide ? EndRideButton() : StartRideButton(),
      ],
    );
  }
}

class StartRideButton extends StatelessWidget {
  const StartRideButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Provider.of<DriverProvider>(context, listen: false).startDriverRide();
        // Navigator.of(context).pushNamed(ChatRoomScreen.routeName);
      },
      child: Text(
        "Start Ride",
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}

class EndRideButton extends StatelessWidget {
  const EndRideButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Provider.of<DriverProvider>(context, listen: false)
        //     .startDriverRide();
        // Navigator.of(context).pushNamed(ChatRoomScreen.routeName);
      },
      style: ButtonStyle(
        backgroundColor: MaterialStatePropertyAll(
          Colors.red,
        ),
      ),
      child: Text(
        "End Ride",
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}

class PassengerWidget extends StatelessWidget {
  const PassengerWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          Icons.check_circle,
          size: 40,
          color: Colors.green,
        ),
        SizedBox(height: 10),
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
    );
  }
}
