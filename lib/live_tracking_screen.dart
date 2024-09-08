
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LiveTrackingScreen extends StatefulWidget {
  final String tripId;

  LiveTrackingScreen({required this.tripId});

  @override
  _LiveTrackingScreenState createState() => _LiveTrackingScreenState();
}

class _LiveTrackingScreenState extends State<LiveTrackingScreen> {
  late GoogleMapController _mapController;
  LatLng _currentPosition = LatLng(0.0, 0.0);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Track Device ${widget.tripId}"),
      ),
      body: GoogleMap(
        onMapCreated: (GoogleMapController controller) {
          _mapController = controller;
          FirebaseFirestore.instance
              .collection('locations')
              .doc(widget.tripId)
              .snapshots()
              .listen((DocumentSnapshot documentSnapshot) {
            if (documentSnapshot.exists) {
              final data = documentSnapshot.data() as Map<String, dynamic>;
              setState(() {
                _currentPosition = LatLng(data['latitude'], data['longitude']);

                _mapController.animateCamera(
                  CameraUpdate.newCameraPosition(
                    CameraPosition(
                      target: _currentPosition,
                      zoom: 16.0,
                    ),
                  ),
                );
              });
            }
          });
        },

        initialCameraPosition: CameraPosition(
          target: _currentPosition,
          zoom: 16.0,
        ),
        markers: {
          Marker(
            markerId: MarkerId(widget.tripId),
            position: _currentPosition,
          ),
        },
      ),
    );
  }
}
