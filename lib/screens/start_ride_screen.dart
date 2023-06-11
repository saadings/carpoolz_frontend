import 'package:carpoolz_frontend/providers/chat_room_provider.dart';
import 'package:carpoolz_frontend/screens/display_stores_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StartRideScreen extends StatefulWidget {
  static const routeName = '/start-ride';

  const StartRideScreen({super.key});

  @override
  State<StartRideScreen> createState() => _StartRideScreenState();
}

class _StartRideScreenState extends State<StartRideScreen> {
  bool _firstTime = false;

  @override
  void didChangeDependencies() {
    if (!_firstTime) {
      Provider.of<ChatRoomProvider>(context, listen: false)
          .receiveEndRide(context);

      _firstTime = true;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //     // title: Text('Start Ride'),
      //     ),
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        onPressed: () {
          // Navigator.of(context).pop();
          Navigator.of(context)
              .pushReplacementNamed(DisplayStoresScreen.routeName);
        },
        child: Icon(
          Icons.restaurant,
          size: 30,
          color: Colors.white,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/carpoolz.png',
              // fit: BoxFit.cover,
              height: 80,
            ),
            Image.asset(
              'assets/images/carpoolyn.png',
              // fit: BoxFit.cover,
              height: 200,
            ),
            Text(
              'We hope you have a safe journey!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Text("Don't forget to check out the store deals!"),

            // ElevatedButton(
            //   onPressed: () {
            //     Navigator.of(context).pop();
            //   },
            //   child: Text('End Ride'),
            // ),
          ],
        ),
      ),
    );
  }
}
