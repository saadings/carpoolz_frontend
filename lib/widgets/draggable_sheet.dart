import 'package:carpoolz_frontend/screens/ride_requests_screen.dart';
import 'package:carpoolz_frontend/widgets/small_loading.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/google_maps_provider.dart';
import '../widgets/google_auto_complete.dart';

class DraggableSheet extends StatefulWidget {
  final bool isDriver;
  const DraggableSheet({
    required this.isDriver,
    super.key,
  });

  @override
  State<DraggableSheet> createState() => _DraggableSheetState();
}

class _DraggableSheetState extends State<DraggableSheet> {
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.2,
      minChildSize: 0.2,
      maxChildSize: 0.6,
      builder: (ctx, scrollController) => Container(
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
                GoogleAutoComplete(),
                const SizedBox(height: 5),
                ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      _loading = true;
                    });

                    try {
                      if (widget.isDriver) {
                        print(widget.isDriver);
                        await Provider.of<GoogleMapsProvider>(context,
                                listen: false)
                            .findRidesDriver();
                      } else {
                        print(widget.isDriver);
                        await Provider.of<GoogleMapsProvider>(context,
                                listen: false)
                            .findRidesPassenger();
                      }
                      Navigator.of(context)
                          .pushNamed(RideRequestsScreen.routeName);
                    } on DioError catch (e) {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: Text("Something Went Wrong!"),
                          content: Text(e.response!.data['message'].toString()),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(ctx).pop();
                              },
                              child: Text("Okay"),
                            ),
                          ],
                        ),
                      );
                    } finally {
                      setState(
                        () {
                          _loading = false;
                        },
                      );
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Go"),
                      _loading
                          ? const SmallLoading()
                          : Icon(Icons.arrow_forward),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
