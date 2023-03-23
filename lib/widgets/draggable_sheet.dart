import 'package:carpoolz_frontend/screens/ride_requests_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/google_maps_provider.dart';
import '../widgets/google_auto_complete.dart';

class DraggableSheet extends StatelessWidget {
  const DraggableSheet({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.4,
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
                    try {
                      await Provider.of<GoogleMapsProvider>(context,
                              listen: false)
                          .findRidesDriver();
                      Navigator.of(context)
                          .pushNamed(RideRequestsScreen.routeName);
                    } catch (e) {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: Text("Something Went Wrong!"),
                          content: Text(e.toString()),
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
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
    );
  }
}
