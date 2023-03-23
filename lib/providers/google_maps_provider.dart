import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_place/google_place.dart';

import '../models/google_maps.dart';
import '../services/api_services/google_service.dart';

class GoogleMapsProvider with ChangeNotifier {
  GoogleMapController? _mapController = null;
  Position? _currentPosition = null;
  List<Marker> _markers = [];
  List<LatLng> _polylineCoordinates = [];
  var _route = null;

  GoogleMapController? get mapController => _mapController;
  Position? get currentPosition => _currentPosition;
  List<Marker> get markers => _markers;
  List<LatLng> get polylineCoordinates => _polylineCoordinates;

  void setMapController(GoogleMapController mapController) {
    _mapController = mapController;
    notifyListeners();
  }

  void setCurrentPosition(Position position) {
    _currentPosition = position;
    notifyListeners();
  }

  Future<List<GoogleMapsModel>> autoCompleteSearch(
      String value, GooglePlace googlePlace, bool mounted) async {
    try {
      var result = await googlePlace.autocomplete.get(
        value,
        region: 'pk',
        radius: 5000,
      );

      print("status: ${result!.status}");

      if (result.predictions != null && mounted) {
        // return result.predictions!.map((e) => e.description!).toList();
        final predictions = result.predictions!.map((e) async {
          return GoogleMapsModel(
            e.placeId!,
            null,
            e.description!,
          );
        }).toList();

        return Future.wait(predictions);
      }
    } catch (e) {
      print(e);
    }

    return [];
  }

  Future<void> addMarker(
    GoogleMapsModel position,
    GooglePlace googlePlace,
  ) async {
    try {
      final placeDetail = await googlePlace.details.get(position.placeId);

      final lat = placeDetail!.result!.geometry!.location!.lat;
      final lng = placeDetail.result!.geometry!.location!.lng;

      position.setDestination(LatLng(lat!, lng!));
      _markers.clear();
      _markers.add(
        Marker(
          markerId: MarkerId(_markers.length.toString()),
          position: position.destination!,
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueViolet,
          ),
          draggable: true,
          onTap: await () async => await _mapController?.animateCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(
                    target: position.destination!,
                    zoom: 18,
                  ),
                ),
              ),
        ),
      );

      await _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(
          position.destination!,
          12.5,
        ),
      );

      notifyListeners();
    } catch (e) {}
  }

  Future<void> getRoutes() async {
    try {
      final Response response = await GoogleService().getRoutes(
        LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
        _markers[0].position,
      );

      _route = response.data['routes'][0];

      List<PointLatLng> pointList = PolylinePoints().decodePolyline(
        response.data['routes'][0]['polyline']['encodedPolyline'],
      );

      _polylineCoordinates = pointList.map((PointLatLng point) {
        return LatLng(point.latitude, point.longitude);
      }).toList();

      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> findRides() async {}
}
