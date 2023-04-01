import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/google_maps_provider.dart';
import '../screens/register_driver_screen.dart';
import '../widgets/draggable_sheet.dart';
import '../widgets/google_maps.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/home';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var value = true;

  @override
  Widget build(BuildContext context) {
    AppBar _appBar = AppBar(
      title: const Text(
        "Carpoolz",
      ),
      // foregroundColor: Color.fromRGBO(156, 39, 176, 1),
      elevation: 5,
      // backgroundColor: Color.fromRGBO(156, 39, 176, 0.4),
      actions: [
        // IconButton(
        //   onPressed: () {},
        //   icon: const Icon(Icons.search),
        // ),
        Row(
          children: [
            Text("Switch to Driver"),
            Switch(
              value: value,
              onChanged: (value) {
                setState(() {
                  this.value = value;
                });
              },
            ),
          ],
        ),

        // IconButton(
        //   onPressed: () {},
        //   icon: const Icon(Icons.notifications),
        // ),
      ],
    );

    return Scaffold(
      appBar: _appBar,
      extendBodyBehindAppBar: true,
      drawer: Drawer(
        child: Container(
          child: Column(
            children: [
              Container(
                height: _appBar.preferredSize.height + 23.75,
                color: Theme.of(context).accentColor,
              ),
              ListTile(
                title: Text("Register Driver"),
                onTap: () {
                  Navigator.of(context)
                      .pushNamed(RegisterDriverScreen.routeName);
                },
              ),
              Divider(),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          GoogleMaps(),
          DraggableSheet(
            isDriver: value,
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterTop,
      floatingActionButton: FloatingActionButton(
        mini: true,
        backgroundColor: Theme.of(context).accentColor,
        onPressed: () {
          Provider.of<GoogleMapsProvider>(context, listen: false)
              .getCurrentLocation();
        },
        child: Icon(Icons.my_location, color: Colors.white),
      ),
    );
  }
}
