import 'dart:async';
import 'dart:developer';
import 'package:awr/simulate-trip.dart';
import 'package:awr/widgets/trip_list_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';
import 'firebase_options.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:location/location.dart' as loc;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'models/trip.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AWR Demo',
      theme: ThemeData(
        colorSchemeSeed: const Color(0xff24CD74),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'AWR Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  bool _gpsEnabled = false;
  bool _permissionGranted = false;
  final loc.Location _location = loc.Location();
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  late StreamSubscription subscription;
  final DatabaseReference _databaseReference = FirebaseDatabase.instance
      .ref('trips')
      .limitToLast(100)
      .ref;
  List<Trip> _dataList = [];
  bool _tripStarted = false;

  @override
  void initState() {
    super.initState();

    checkStatus();

    _databaseReference.onValue.listen((event) {
      final data = (event.snapshot.value as Map<dynamic, dynamic>).entries.map((
          e) => Trip.fromJson(e.value)).toList();
      setState(() {
        _dataList =
        data..sort((a, b) => b.startedAt.compareTo(a.startedAt));
      });
    });
  }

  Future<bool> isPermissionGranted() async {
    return await Permission.locationWhenInUse.isGranted;
  }

  Future<bool> isGpsEnabled() async {
    return await Permission.location.serviceStatus.isEnabled;
  }

  void requestEnableGps() async {
    if (_gpsEnabled) {
      log("Already open");
    } else {
      bool isGpsActive = await _location.requestService();
      if (!isGpsActive) {
        setState(() {
          _gpsEnabled = false;
        });
        log("User did not turn on GPS");
      } else {
        log("gave permission to the user and opened it");
        setState(() {
          _gpsEnabled = true;
        });
      }
    }
  }

  void requestLocationPermission() async {
    PermissionStatus permissionStatus =
    await Permission.locationWhenInUse.request();
    if (permissionStatus == PermissionStatus.granted) {
      setState(() {
        _permissionGranted = true;
      });
    } else {
      setState(() {
        _permissionGranted = false;
      });
    }
  }

  void checkStatus() async {
    _permissionGranted = await isPermissionGranted();
    _gpsEnabled = await isGpsEnabled();
    if (!_permissionGranted) {
      requestLocationPermission();
    }
    if (!_gpsEnabled) {
      requestEnableGps();
    }
  }

  void _finishTrip() {
    subscription.cancel();
    setState(() {
      _tripStarted = false;
    });
  }

  void _startTrip() {
    DatabaseReference tripListRef = FirebaseDatabase.instance.ref("trips");
    DatabaseReference newTripRef = tripListRef.push();
    var tripId = const Uuid().v1();
    newTripRef.set({
      "tripId": tripId,
      "startedAt": DateTime.now().millisecondsSinceEpoch
    });
    _startSharingLiveLocation(tripId);
    setState(() {
      _tripStarted = true;
    });
  }

  void _startSharingLiveLocation(String tripId) {
    subscription = _location.onLocationChanged.listen((loc.LocationData currentLocation) {
          _fireStore.collection('locations').doc(tripId).set({
            'latitude': currentLocation.latitude,
            'longitude': currentLocation.longitude,
            'timestamp': FieldValue.serverTimestamp(),
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme
              .of(context)
              .colorScheme
              .inversePrimary,
          title: Text(widget.title),
        ),
        body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>
                          SimulateTrip(),
                      ));
                    }, child: const Text('Simulate a Trip')),
                    ElevatedButton(onPressed: _tripStarted ? null : () {
                      _startTrip();
                    }, child: const Text('Start a Trip')),
                    ElevatedButton(
                        onPressed: _tripStarted ? () {
                          _finishTrip();
                        } : null, child: const Text('Finish Trip')),
                  ],
                ),
                const Text('Trip List'),
                _dataList.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : Expanded(child: ListView.builder(
                  itemCount: _dataList.length,
                  itemBuilder: (context, index) {
                    return TripListItemWidget(trip: _dataList[index]);
                  },
                ),)
              ],
            )));
  }
}