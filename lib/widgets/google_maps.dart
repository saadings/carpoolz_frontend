import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../providers/google_maps_provider.dart';

class GoogleMaps extends StatefulWidget {
  @override
  _GoogleMapsState createState() => _GoogleMapsState();
}

class _GoogleMapsState extends State<GoogleMaps> {
  // bool _loading = true;
  String _darkMapStyle = "";
  bool _firstTime = true;

  @override
  void didChangeDependencies() async {
    if (_firstTime) {
      await Provider.of<GoogleMapsProvider>(context).getCurrentLocation();
      _loadMapStyles();
      _firstTime = false;
    }
    super.didChangeDependencies();
  }

  // @override
  // void initState() {
  //   _getCurrentLocation();
  //   _loadMapStyles();
  //   super.initState();
  // }

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

    final _loading = Provider.of<GoogleMapsProvider>(
      context,
    ).loading;

    return _loading || _currentPosition == null
        ? Center(
            child: CircularProgressIndicator(),
          )
        : LayoutBuilder(
            builder: (
              ctx,
              constraints,
            ) =>
                SizedBox(
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
                  target: LatLng(
                      _currentPosition.latitude, _currentPosition.longitude),
                  zoom: 18,
                ),
                onMapCreated: (GoogleMapController controller) {
                  controller.setMapStyle(_darkMapStyle);
                  Provider.of<GoogleMapsProvider>(context, listen: false)
                      .setMapController(controller);
                },
                markers: Set<Marker>.from(_markers),
                mapType: MapType.normal,
              ),
            ),
          );
  }
}
