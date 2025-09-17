

import 'dart:async';
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
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        print('Location service is disabled. Falling back to last known position.');
        _currentPosition = await Geolocator.getLastKnownPosition();
        _currentLocationName = await _locationService.getLocationName(_currentPosition);
        notifyListeners();
        return;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print('Location permission denied by user. Falling back to last known.');
          _currentPosition = await Geolocator.getLastKnownPosition();
          _currentLocationName = await _locationService.getLocationName(_currentPosition);
          notifyListeners();
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        print('Location permission denied forever. Falling back to last known.');
        _currentPosition = await Geolocator.getLastKnownPosition();
        _currentLocationName = await _locationService.getLocationName(_currentPosition);
        notifyListeners();
        return;
      }

      // 1) Quick fallback for instant UI update (may be stale)
      _currentPosition = await Geolocator.getLastKnownPosition();

      // 2) Try fresh fix with longer timeout and high accuracy
      const settings = LocationSettings(
        accuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 25),
      );

      try {
        final fresh = await Geolocator.getCurrentPosition(locationSettings: settings);
        _currentPosition = fresh;
      } on TimeoutException {
        print('getCurrentPosition timed out; using last known position if available.');
      } catch (e) {
        print('getCurrentPosition error: $e');
      }

      if (_currentPosition != null) {
        _currentLocationName = await _locationService.getLocationName(_currentPosition);
        print('Location obtained: ${_currentLocationName?.locality ?? 'Unknown'} '
            '(${_currentPosition!.latitude}, ${_currentPosition!.longitude})');
      } else {
        _currentLocationName = null;
      }

      notifyListeners();
    } catch (e) {
      print('Error getting location: $e');
      _currentPosition = await Geolocator.getLastKnownPosition();
      _currentLocationName = await _locationService.getLocationName(_currentPosition);
      notifyListeners();
    }
  }

// ask the permission

// get the location

// get the placemark
}
