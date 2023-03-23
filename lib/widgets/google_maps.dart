import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

import '../providers/google_maps_provider.dart';
import '../widgets/draggable_sheet.dart';

class GoogleMaps extends StatefulWidget {
  @override
  _GoogleMapsState createState() => _GoogleMapsState();
}

class _GoogleMapsState extends State<GoogleMaps> {
  bool _loading = true;
  String _darkMapStyle = "";

  @override
  void initState() {
    _getCurrentLocation();
    _loadMapStyles();
    super.initState();
  }

  Future<void> _loadMapStyles() async {
    _darkMapStyle = await rootBundle.loadString(
      'assets/google_maps_styles/dark_style.json',
    );
  }

  @override
  Widget build(BuildContext context) {
    final _currentPosition = Provider.of<GoogleMapsProvider>(
      context,
    ).currentPosition;

    final _markers = Provider.of<GoogleMapsProvider>(
      context,
    ).markers;

    final List<LatLng> _polylineCoordinates = Provider.of<GoogleMapsProvider>(
      context,
    ).polylineCoordinates;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Carpoolz",
        ),
        // foregroundColor: Color.fromRGBO(156, 39, 176, 1),
        elevation: 5,
        // backgroundColor: Color.fromRGBO(156, 39, 176, 0.4),
        // actions: [
        //   IconButton(
        //     onPressed: () {},
        //     icon: const Icon(Icons.search),
        //   ),
        //   IconButton(
        //     onPressed: () {},
        //     icon: const Icon(Icons.notifications),
        //   ),
        // ],
      ),
      extendBodyBehindAppBar: true,
      body: _loading || _currentPosition == null
          ? Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                LayoutBuilder(
                  builder: (ctx, constraints) => SizedBox(
                    height: constraints.maxHeight / 1.25,
                    child: GoogleMap(
                      myLocationEnabled: true,
                      myLocationButtonEnabled: false,
                      zoomControlsEnabled: false,
                      compassEnabled: false,
                      rotateGesturesEnabled: true,
                      // buildingsEnabled: true,
                      polylines: Set<Polyline>.from([
                        Polyline(
                          polylineId: PolylineId("1"),
                          color: Colors.purple,
                          points: _polylineCoordinates,
                          onTap: () {},
                          width: 4,
                        ),
                      ]),
                      initialCameraPosition: CameraPosition(
                        target: LatLng(_currentPosition.latitude,
                            _currentPosition.longitude),
                        zoom: 18,
                      ),
                      onMapCreated: (GoogleMapController controller) {
                        // setState(
                        //   () {
                        //     controller.setMapStyle(_darkMapStyle);
                        //     _mapController = controller;
                        //   },
                        // );

                        controller.setMapStyle(_darkMapStyle);
                        Provider.of<GoogleMapsProvider>(context, listen: false)
                            .setMapController(controller);
                      },
                      markers: Set<Marker>.from(_markers),
                      mapType: MapType.normal,
                    ),
                  ),
                ),
                DraggableSheet(),
              ],
            ),
      drawer: Drawer(
        child: Text("I am drawer"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndTop,
      floatingActionButton: FloatingActionButton(
        mini: true,
        backgroundColor: Theme.of(context).accentColor,
        onPressed: () {
          _getCurrentLocation();
        },
        child: Icon(Icons.my_location, color: Colors.white),
      ),
      // bottomSheet: Container(),
    );
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    // return await Geolocator.getCurrentPosition();

    Position position = await Geolocator.getCurrentPosition();
    Provider.of<GoogleMapsProvider>(context, listen: false)
        .setCurrentPosition(position);
    setState(
      () {
        _loading = false;
      },
    );
    final _mapController = Provider.of<GoogleMapsProvider>(
      context,
      listen: false,
    ).mapController;

    _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(
        LatLng(position.latitude, position.longitude),
        18,
      ),
    );
  }
}
