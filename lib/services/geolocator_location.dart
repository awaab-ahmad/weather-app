// in this file we would be using the geolocator for fetching the coords
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:weather/services/provider.dart';

// making the function for its working

Future<void> locationSetup(BuildContext context) async {
  bool serviceEnabled;
  LocationPermission locationPermission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('The Service is disabled');
  }

  locationPermission = await Geolocator.checkPermission();
  if (locationPermission == LocationPermission.denied) {
    locationPermission = await Geolocator.requestPermission();
    if (locationPermission == LocationPermission.denied) {
      return Future.error('The location permission is denied');
    }
  }

  if (locationPermission == LocationPermission.deniedForever) {
    locationPermission = await Geolocator.requestPermission();
    return Future.error('The Location permission is denied forever');
  }

  if (!context.mounted) {
    return;
  } else {
    if (context.read<MainProvider>().firstTimeSetupDone == false) {
      context.read<MainProvider>().settingFirstTimeData();
      if (kDebugMode) print('First time setup is going to get saved');
    }
  }
}
