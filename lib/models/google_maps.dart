import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapsModel {
  // LatLng _currentPosition = LatLng(0, 0);
  LatLng? _destination = LatLng(0, 0);
  String _placeId = '';
  String _description = '';

  GoogleMapsModel(
    // this._currentPosition,
    this._placeId,
    this._destination,
    this._description,
  );
  // LatLng get currentPosition => _currentPosition;
  LatLng? get destination => _destination;
  String get placeId => _placeId;
  String get description => _description;
  // void setCurrentPosition(LatLng position) {
  //   _currentPosition = position;
  // }
  void setDescription(String description) {
    _description = description;
  }

  void setDestination(LatLng position) {
    _destination = position;
  }
}
