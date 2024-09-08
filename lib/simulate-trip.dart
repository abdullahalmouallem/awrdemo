import 'dart:async';
import 'dart:convert';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SimulateTrip extends StatefulWidget {
  @override
  _SimulateTripState createState() => _SimulateTripState();
}

class _SimulateTripState extends State<SimulateTrip> {
  GoogleMapController? _controller;
  Marker? _carMarker;
  Polyline? _routePolyline;
  final LatLng _startPosition = const LatLng(25.197573822030087, 55.279776869887066);
  Timer? _timer;
  List<LatLng> _routePoints = [];
  int _currentIndex = 0;
  PolylinePoints polylinePoints = PolylinePoints();
  int _tripDuration = 0;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Simulated Car Trip")),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _startPosition,
          zoom: 17,
        ),
        onMapCreated: (GoogleMapController controller) {
          _controller = controller;
          _simulateTrip();
        },
        markers: _carMarker != null ? {_carMarker!} : {},
        polylines: _routePolyline != null ? {_routePolyline!} : {},
      ),
    );
  }

  void _simulateTrip() async {
    // Fetch the route points
    _routePoints = await _getRoutePoints();

    // Draw the route on the map
    setState(() {
      _routePolyline = Polyline(
        polylineId: const PolylineId("route"),
        points: _routePoints,
        color: Colors.blue,
        width: 5,
      );
      _carMarker = Marker(
        markerId: const MarkerId("car"),
        position: _routePoints.first,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      );
    });

    // Animate the car marker
    _startAnimatingCar(_routePoints, _tripDuration);
  }

  int getTotalDuration(Map<String, dynamic> directions) {
    return directions['routes'][0]['legs'][0]['duration']['value']; // In seconds
  }

  Future<List<LatLng>> _getRoutePoints() async {
    const String url = 'https://maps.googleapis.com/maps/api/directions/json?origin=25.197573822030087,55.279776869887066&destination=25.11950911628676,55.200321649517534&key=AIzaSyAt-KKREUlm1UTBuJyMqmv7oWMXVV6Zoxc';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data['status'] == 'OK') {
        _tripDuration = getTotalDuration(data);

        return getDetailedRoute(data);
      } else {
        throw Exception('Error in the response: ${data['status']}');
      }
    } else {
      throw Exception('Failed to load directions');
    }
  }

  List<LatLng> getDetailedRoute(Map<String, dynamic> directions) {
    List<LatLng> routePoints = [];

    // Extract the steps from the first leg of the route
    var steps = directions['routes'][0]['legs'][0]['steps'];
    for (var step in steps) {
      String polyline = step['polyline']['points'];
      // Decode polyline for each step and add points to the route
      routePoints.addAll(decodePolyline(polyline));
    }

    return routePoints;
  }

  List<LatLng> decodePolyline(String encodedPolyline) {
    List<PointLatLng> result = polylinePoints.decodePolyline(encodedPolyline);
    return result
        .map((point) => LatLng(point.latitude, point.longitude))
        .toList();
  }

  void _startAnimatingCar(List<LatLng> routePoints, int totalDuration) {
    int totalPoints = routePoints.length;

    // Calculate the time to move between each point (in milliseconds)
    double timePerPoint = (totalDuration * 1000) / totalPoints;

    // Start a timer to move the marker along the route
    Timer.periodic(Duration(milliseconds: timePerPoint.round()), (timer) {
      if (_currentIndex < routePoints.length - 1) {
        _currentIndex++;
        LatLng newPosition = routePoints[_currentIndex];

        // Update marker position
        setState(() {
          _carMarker = _carMarker!.copyWith(positionParam: newPosition);
        });

        // Optionally move camera to follow the marker
        _controller?.animateCamera(CameraUpdate.newLatLng(newPosition));
      } else {
        timer.cancel(); // Trip simulation complete
      }
    });
  }
}
