// import 'package:face_net_authentication/globals.dart';
// import 'package:face_net_authentication/services/shared_preference_helper.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';

import 'package:face_net_authentication/globals.dart';
import 'package:face_net_authentication/services/shared_preference_helper.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

/// Determine the current position of the device.
///
/// When the location services are not enabled or permissions
/// are denied the `Future` will return an error.
Future<void> GET_LOCATION(context) async {
  bool serviceEnabled;
  LocationPermission permission;
  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
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

      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      showToast("Mohon Aktifkan Akses Lokasi");

      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    bool? granted = await showLocationPermissionDialog(context);

    if (granted == true) {
      await Geolocator.openLocationSettings();
    }
    //  showToast("Mohon Aktifkan Akses Lokasi pada pengaturan perangkat");
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.

  Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);
  String alamat = await getPlace(position.longitude, position.latitude);

  // int distanceInMeters = Geolocator.distanceBetween(position.latitude,position.longitude, position.latitude,position.longitude).round();

  SpSetLastLoc(position.latitude, position.longitude, alamat);
}

Future<String> getPlace(double long, double lat) async {
  try {
    // List<Placemark> placemarks =
    //     await placemarkFromCoordinates(lat, long, localeIdentifier: "ind_id");
    List<Placemark> placemarks = await placemarkFromCoordinates(lat, long);

    Placemark placeMark = placemarks[0];
    String? name = placeMark.street;
    String? subLocality = placeMark.subLocality;
    String? locality = placeMark.locality;
    String? administrativeArea = placeMark.administrativeArea;
    String? subAdministrative = placeMark.subAdministrativeArea;
    String address =
        "${name}, ${subLocality}, ${locality}, ${subAdministrative},${administrativeArea}";

    return address;
  } catch (e) {
    print(e);
    String alamat = await getPlace(long, lat);
    SpSetLastLoc(long, lat, alamat);
    return "Lokasi Perlu di Update";
  }
}
