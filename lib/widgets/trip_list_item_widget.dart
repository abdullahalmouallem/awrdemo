
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../live_tracking_screen.dart';
import '../models/trip.dart';

class TripListItemWidget extends StatelessWidget{

  final Trip trip;

  const TripListItemWidget({super.key, required this.trip});

  String _beautifyTimestamp(int timestamp) {
    var dt = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return DateFormat('dd/MM/yyyy, HH:mm').format(dt);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Text('Trip ID: ${trip.tripId}'),
          Text('Started At: ${_beautifyTimestamp(trip.startedAt)}'),
          ElevatedButton(
            style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.orangeAccent)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>
                      LiveTrackingScreen(tripId: trip.tripId)),
                );
              } , child: const Text('Live Tracking'))
        ],
      ),
    );
  }

}