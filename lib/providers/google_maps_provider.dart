import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_place/google_place.dart';

import '../models/google_maps.dart';
import '../services/api_services/google_service.dart';
import '../services/api_services/ride_service.dart';

class GoogleMapsProvider with ChangeNotifier {
  String userName = "";
  GoogleMapController? _mapController = null;
  Position? _currentPosition = null;
  List<Marker> _markers = [];
  List<LatLng> _polylineCoordinates = [];
  var _route = null;
  bool _loading = true;

  GoogleMapsProvider({
    required this.userName,
  });

  GoogleMapController? get mapController => _mapController;
  Position? get currentPosition => _currentPosition;
  List<Marker> get markers => _markers;
  List<LatLng> get polylineCoordinates => _polylineCoordinates;
  bool get loading => _loading;

  void setMapController(GoogleMapController mapController) {
    _mapController = mapController;
    notifyListeners();
  }

  void setCurrentPosition(Position position) {
    _currentPosition = position;

    notifyListeners();
  }

  Future<void> getCurrentLocation() async {
    if (_currentPosition != null) {
      // await _mapController?.animateCamera(
      //   CameraUpdate.newLatLngZoom(
      //     LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
      //     18,
      //   ),
      // );
      return;
    }

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
    setCurrentPosition(position);

    _loading = false;

    await _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(
        LatLng(position.latitude, position.longitude),
        18,
      ),
    );
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

      LatLngBounds bounds = LatLngBounds(
        southwest: _polylineCoordinates.reduce(
          (value, element) => LatLng(
            min(value.latitude, element.latitude),
            min(value.longitude, element.longitude),
          ),
        ),
        northeast: _polylineCoordinates.reduce(
          (value, element) => LatLng(
            max(value.latitude, element.latitude),
            max(value.longitude, element.longitude),
          ),
        ),
      );

      await _mapController!.animateCamera(
        await CameraUpdate.newLatLngBounds(
          bounds,
          60,
        ),
      );

      // await _mapController?.animateCamera(
      //   CameraUpdate.newLatLngZoom(
      //     position.destination!,
      //     12.5,
      //   ),
      // );

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

  Future<Response> findRidesDriver() async {
    try {
      final Response response = await RideService().getRidesDriver(
        userName,
        LatLng(
          _currentPosition!.latitude,
          _currentPosition!.longitude,
        ),
        _markers[0].position,
        _route,
      );
      return response;
      // print(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> findRidesPassenger() async {
    try {
      final Response response = await RideService().getRidesPassenger(
        userName,
        LatLng(
          _currentPosition!.latitude,
          _currentPosition!.longitude,
        ),
        _markers[0].position,
        _route,
      );
      return response;
      // print(response.data);
    } catch (e) {
      rethrow;
    }
  }
}
