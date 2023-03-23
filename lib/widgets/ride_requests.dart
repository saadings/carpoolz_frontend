import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/socket_services/socket_service.dart';
import '../providers/ride_requests_provider.dart';

class RideRequests extends StatefulWidget {
  const RideRequests({super.key});

  @override
  State<RideRequests> createState() => _RideRequestsState();
}

class _RideRequestsState extends State<RideRequests> {
  bool _firstTime = true;

  @override
  void didChangeDependencies() {
    if (_firstTime) {
      SocketService.init();
      final String _userName = "laiba111";
      // final String _userName =
      //     Provider.of<RideRequestProvider>(context).userName;
      Provider.of<RideRequestProvider>(context, listen: false).getRideRequests(
        _userName,
      );
      _firstTime = false;
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    SocketService.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final rideRequests = Provider.of<RideRequestProvider>(context).rideRequests;

    return Container(
      child: ListView.builder(
        itemBuilder: (ctx, index) => ListTile(
          title: Text(rideRequests[index]['userName']),
          subtitle: Text(rideRequests[index]['origin']),
        ),
        itemCount: rideRequests.length,
      ),
    );
  }
}
