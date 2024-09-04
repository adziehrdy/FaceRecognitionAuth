import 'package:face_net_authentication/globals.dart';
import 'package:face_net_authentication/services/shared_preference_helper.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

/// Determine the current position of the device.
///
/// When the location services are not enabled or permissions
/// are denied the `Future` will return an error.
Future<void> GET_LOCATION(BuildContext context) async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    showToast("Mohon Aktifkan Akses Lokasi");
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();

  if (permission == LocationPermission.denied) {
    bool? approved = await showLocationPermissionDialog(context);
    if (approved == true) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      await Geolocator.openLocationSettings();
      showToast("Mohon Aktifkan Akses Lokasi");
      return Future.error('Location permissions are denied.');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    bool? granted = await showLocationPermissionDialog(context);
    if (granted == true) {
      await Geolocator.openLocationSettings();
    }
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  try {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    String alamat = await getPlace(position.longitude, position.latitude);
    SpSetLastLoc(position.latitude, position.longitude, alamat);
  } catch (e) {
    print("Error getting location: $e");
    showToast("Gagal mendapatkan lokasi, silakan coba lagi.");
  }
}

Future<String> getPlace(double long, double lat) async {
  showToast("Loading Mendapatkan Lokasi...");
  try {
    List<Placemark> placemarks = await placemarkFromCoordinates(lat, long);
    Placemark placeMark = placemarks[0];
    String? name = placeMark.street;
    String? subLocality = placeMark.subLocality;
    String? locality = placeMark.locality;
    String? administrativeArea = placeMark.administrativeArea;
    String? subAdministrative = placeMark.subAdministrativeArea;
    String address =
        "${name}, ${subLocality}, ${locality}, ${subAdministrative}, ${administrativeArea}";

    return address;
  } catch (e) {
    print("Error getting place: $e");
    return "Lokasi perlu diupdate";
  }
}
