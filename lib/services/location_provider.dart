

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:quickassitnew/services/location_service.dart';


class LocationProvider with ChangeNotifier {
  Position? _currentPosition;
  Position? get currentPostion => _currentPosition;
  final LocationService _locationService = LocationService();

  Placemark? _currentLocationName;
  Placemark? get currentLocationName => _currentLocationName;

  Future<void> determinePosition() async {
    try {
      bool serviceEnabled;
      LocationPermission permission;

      // Check if location service is enabled
      serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        print('Location service is disabled. Please enable location services.');
        _currentPosition = null;
        _currentLocationName = null;
        notifyListeners();
        return;
      }

      // Check location permission
      permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();

        if (permission == LocationPermission.denied) {
          print('Location permission denied by user.');
          _currentPosition = null;
          _currentLocationName = null;
          notifyListeners();
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        print('Location permission denied forever. Please enable in settings.');
        _currentPosition = null;
        _currentLocationName = null;
        notifyListeners();
        return;
      }

      // Get current position
      _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 10),
      );

      // Get location name
      if (_currentPosition != null) {
        _currentLocationName = await _locationService.getLocationName(_currentPosition);
        print('Location obtained: ${_currentLocationName?.locality ?? 'Unknown'}');
      }

      notifyListeners();
    } catch (e) {
      print('Error getting location: $e');
      _currentPosition = null;
      _currentLocationName = null;
      notifyListeners();
    }
  }

// ask the permission

// get the location

// get the placemark
}
