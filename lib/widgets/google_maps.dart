import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_place/google_place.dart';
import 'package:dio/dio.dart';

import '../models/google_maps.dart';

class GoogleMaps extends StatefulWidget {
  @override
  _GoogleMapsState createState() => _GoogleMapsState();
}

class _GoogleMapsState extends State<GoogleMaps> {
  GoogleMapController? _mapController = null;
  Position? _currentPosition = null;
  List<Marker> _markers = [];
  bool _loading = true;
  String _darkMapStyle = "";
  late GooglePlace googlePlace;
  String apiKey = 'AIzaSyAXD-Jtq7KNo93Sw7lEdidS-J5zX6NjTrs';

  @override
  void initState() {
    _getCurrentLocation();
    _loadMapStyles();
    googlePlace = GooglePlace(apiKey);
    super.initState();
  }

  Future<void> _loadMapStyles() async {
    _darkMapStyle = await rootBundle
        .loadString('assets/google_maps_styles/dark_style.json');
  }

  Future<List<GoogleMapsModel>> _autoCompleteSearch(String value) async {
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
    return [];
  }

  void _addMarker(GoogleMapsModel position) async {
    final placeDetail = await googlePlace.details.get(position.placeId);
    final lat = placeDetail!.result!.geometry!.location!.lat;
    final lng = placeDetail.result!.geometry!.location!.lng;

    position.setDestination(LatLng(lat!, lng!));

    setState(
      () {
        _markers.clear();
        _markers.add(
          Marker(
            markerId: MarkerId(_markers.length.toString()),
            position: position.destination!,
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueViolet,
            ),
            draggable: true,
            onTap: () => _mapController?.animateCamera(
              CameraUpdate.newCameraPosition(
                CameraPosition(target: position.destination!, zoom: 18),
              ),
            ),
          ),
        );
      },
    );
    _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(
        position.destination!,
        18,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
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
                      initialCameraPosition: CameraPosition(
                        target: LatLng(_currentPosition!.latitude,
                            _currentPosition!.longitude),
                        zoom: 18,
                      ),
                      onMapCreated: (GoogleMapController controller) {
                        setState(
                          () {
                            controller.setMapStyle(_darkMapStyle);
                            _mapController = controller;
                          },
                        );
                      },
                      markers: Set<Marker>.from(_markers),
                      mapType: MapType.normal,
                    ),
                  ),
                ),
                DraggableScrollableSheet(
                  initialChildSize: 0.4,
                  minChildSize: 0.2,
                  maxChildSize: 0.6,
                  builder: (ctx, scrollController) => Container(
                    // height: 10,
                    color: Colors.grey[850],
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          children: [
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 15.0),
                                child: Icon(Icons.maximize),
                              ),
                            ),
                            Autocomplete<GoogleMapsModel>(
                              optionsViewBuilder: (
                                BuildContext context,
                                AutocompleteOnSelected<GoogleMapsModel>
                                    onSelected,
                                Iterable<GoogleMapsModel> options,
                              ) {
                                return Align(
                                  alignment: Alignment.topLeft,
                                  child: Material(
                                    elevation: 6,
                                    child: Container(
                                      height: mediaQuery.height / 2.5,
                                      width: mediaQuery.width - 40,
                                      child: options.length < 1
                                          ? ListView(
                                              children: [
                                                Text('Location not found!'),
                                              ],
                                            )
                                          : ListView(
                                              children: [
                                                Divider(
                                                  height: 0,
                                                ),
                                                ...options.map(
                                                  (GoogleMapsModel option) =>
                                                      Column(
                                                    children: [
                                                      ListTile(
                                                        title: Text(
                                                            option.description),
                                                        onTap: () {
                                                          onSelected(option);
                                                        },
                                                      ),
                                                      Divider(
                                                        height: 0,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                    ),
                                  ),
                                );
                              },
                              onSelected: (GoogleMapsModel selection) {
                                // When the user selects a search result, update the text field with the selection
                                // _destinationController.text = selection;
                                _addMarker(selection);
                              },
                              fieldViewBuilder: (BuildContext context,
                                  TextEditingController controller,
                                  FocusNode focusNode,
                                  VoidCallback onFieldSubmitted) {
                                // Return the text field with the controller and focus node
                                return TextField(
                                  controller: controller,
                                  focusNode: focusNode,
                                  onSubmitted: (String value) {
                                    onFieldSubmitted();
                                  },
                                  decoration: InputDecoration(
                                    hintText: "Destination",
                                    hintStyle: TextStyle(
                                      color: Colors.grey[400],
                                    ),
                                    border: InputBorder.none,
                                    filled: true,
                                    fillColor: Colors.grey[900],
                                    prefixIcon: Icon(
                                      Icons.location_on_outlined,
                                      color: Colors.grey[400],
                                    ),
                                  ),
                                );
                              },
                              optionsBuilder: (
                                TextEditingValue textEditingValue,
                              ) async {
                                if (textEditingValue.text.length < 3 ||
                                    textEditingValue.text.isEmpty) {
                                  return const Iterable<
                                      GoogleMapsModel>.empty();
                                }

                                // if (_debounce?.isActive ?? false)
                                //   _debounce?.cancel();
                                // List<String> options = [];
                                // _debounce = Timer(
                                //   const Duration(milliseconds: 1000),
                                //   () async {
                                //     options = await _autoCompleteSearch(
                                //       textEditingValue.text,
                                //     );
                                //     setState(() {});
                                //   },
                                // );
                                // return await options;
                                return await _autoCompleteSearch(
                                  textEditingValue.text,
                                );
                              },
                              displayStringForOption:
                                  (GoogleMapsModel option) =>
                                      option.description,
                            ),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: () {},
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Go"),
                                  Icon(Icons.arrow_forward),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
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
    setState(() {
      _currentPosition = position;
      _loading = false;
    });
    _mapController?.animateCamera(CameraUpdate.newLatLngZoom(
      LatLng(position.latitude, position.longitude),
      18,
    ));
  }
}


// Autocomplete<String>(
//                               optionsBuilder: (
//                                 TextEditingValue textEditingValue,
//                               ) {
//                                 print(
//                                     "textEditingValue: ${textEditingValue.text}");

//                                 if (textEditingValue.text == '') {
//                                   return const Iterable<String>.empty();
//                                 }

//                                 if (_debounce?.isActive ?? false)
//                                   _debounce?.cancel();

//                                 _debounce = Timer(
//                                   const Duration(milliseconds: 1000),
//                                   () {
//                                     autoCompleteSearch(textEditingValue.text);
//                                   },
//                                 );

//                                 return _predictions.map((e) => e.description!);
//                               },
//                               optionsViewBuilder: (context, onSelected, options) => ,
//                               onSelected: (String selection) {
//                                 debugPrint('You just selected $selection');
//                               },
                              // fieldViewBuilder: (context, textEditingController,
                              //         focusNode, onFieldSubmitted) =>
                              //     TextField(
                              //   // controller: _searchController,
                              //   // onChanged: (value) {
                              //   //   if (_debounce?.isActive ?? false)
                              //   //     _debounce?.cancel();
                              //   //   _debounce = Timer(
                              //   //     const Duration(milliseconds: 1000),
                              //   //     () {
                              //   //       autoCompleteSearch(value);
                              //   //     },
                              //   //   );
                              //   // },
                              //   decoration: InputDecoration(
                              //     hintText: "Destination",
                              //     hintStyle: TextStyle(
                              //       color: Colors.grey[400],
                              //     ),
                              //     border: InputBorder.none,
                              //     filled: true,
                              //     fillColor: Colors.grey[900],
                              //     prefixIcon: Icon(
                              //       Icons.location_on_outlined,
                              //       color: Colors.grey[400],
                              //     ),
                              //   ),
                              // ),
                            // ),

                            // TextField(
                            //   controller: _searchController,
                            //   onChanged: (value) {
                            //     if (_debounce?.isActive ?? false)
                            //       _debounce?.cancel();
                            //     _debounce = Timer(
                            //       const Duration(milliseconds: 1000),
                            //       () {
                            //         autoCompleteSearch(value);
                            //       },
                            //     );
                            //   },
                            //   decoration: InputDecoration(
                            //     hintText: "Destination",
                            //     hintStyle: TextStyle(
                            //       color: Colors.grey[400],
                            //     ),
                            //     border: InputBorder.none,
                            //     filled: true,
                            //     fillColor: Colors.grey[900],
                            //     prefixIcon: Icon(
                            //       Icons.location_on_outlined,
                            //       color: Colors.grey[400],
                            //     ),
                            //   ),
                            // ),
                            // SingleChildScrollView(
                            //   child: Column(
                            //     children: predictions
                            //         .map(
                            //           (e) => ListTile(
                            //             title: Text(e.description!),
                            //           ),
                            //         )
                            //         .toList(),
                            //   ),
                            // ),