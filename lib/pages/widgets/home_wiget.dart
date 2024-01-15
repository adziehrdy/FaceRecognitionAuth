import 'package:face_net_authentication/pages/widgets/dialog_update_kordinat.dart';
import 'package:face_net_authentication/pages/widgets/pin_input_dialog.dart';
import 'package:face_net_authentication/services/location_service_helper.dart';
import 'package:face_net_authentication/services/shared_preference_helper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// import 'package:location/location.dart' as loc;

class HomeWiget extends StatefulWidget with WidgetsBindingObserver {
  const HomeWiget({Key? key}) : super(key: key);

  @override
  _HomeWigetState createState() => _HomeWigetState();
}

class _HomeWigetState extends State<HomeWiget> {
  // loc.Location lokasi = new loc.Location();

  // StreamSubscription<loc.LocationData>? locationSubscription;

  double lat = 0;
  double log = 0;
  String kordinat = "-";
  String alamat = "-";

  String formattedDate = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    DateTime now = DateTime.now();
    formattedDate = DateFormat('EEEE, dd MMMM yyyy', 'id').format(now);
    update_loc_text();

    //  updateLocation();
  }

  Future<void> update_loc_text() async {
    await GET_LOCATION();
    lat = await SpGetLastLat();
    log = await SpGetLastlong();
    alamat = await SpGetLastAlamat();

    kordinat =
        "Latitude: " + lat.toString() + " | Longitude :" + log.toString();
    setState(() {
      log;
      lat;
      alamat;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Card(
          elevation: 3,
          color: Color(0xffE8FBFF),
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(12), // Adjust the border radius as needed
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Text(
                      formattedDate,
                      style: TextStyle(fontSize: 14),
                    ),
                    Expanded(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(Icons.timer, color: Colors.black, size: 20),
                        Container(
                          width: 5,
                        ),
                        Text("")
                      ],
                    ))
                  ],
                ),
                Container(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            border:
                                Border.all(color: Color(0xff8DD2FF), width: 1),
                            borderRadius: BorderRadius.circular(8)),
                        child: Row(
                          children: [
                            Container(
                              width: 10,
                            ),
                            Icon(
                              Icons.location_city_rounded,
                              size: 26,
                            ),
                            Container(
                              width: 10,
                            ),
                            Container(
                              child: Row(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 10),
                                      Text(
                                        "Lokasi Terakhir",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 2),
                                      Text(
                                        kordinat,
                                        style: TextStyle(
                                          color: Color(0xff0073BD),
                                          fontSize: 11,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      SizedBox(height: 2),
                                      Container(
                                        height: 16,
                                        width:
                                            500, // Sesuaikan tinggi dengan desain Anda
                                        child: Text(
                                          alamat,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 11,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          PinInputDialog.show(context, (p0) {
                            dialog_update_kordinat.show(context, (p0) {
                              
                            },);
                          },);
                        },
                        icon: Icon(
                          Icons.pin_invoke_outlined,
                        ))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Future<void> getLastlocation() async {
  //   loc.LocationData? positionOFFLINE =  await lokasi.getLocation();
  //   log = positionOFFLINE?.longitude ?? 0;
  //   lat = positionOFFLINE?.latitude ?? 0;
  //   setState(() {
  //     kordinat = (lat.toString() + " | " + log.toString());
  //   });

  //   setState(() async {});
  // }

//   void getPlace(double long, double lat) async {
//     List<Placemark> placemarks = await placemarkFromCoordinates(lat, long);

//     try {
//       // this is all you need
//       Placemark placeMark = placemarks[0];
//       String? name = placeMark.street;
//       String? subLocality = placeMark.subLocality;
//       String? locality = placeMark.locality;
//       String? administrativeArea = placeMark.administrativeArea;
//       String? subAdministrative = placeMark.subAdministrativeArea;
//       String address =
//           "${name}, ${subLocality}, ${locality}, ${subAdministrative},${administrativeArea}";

// //     GBLatLng position = GBLatLng(lat: lat,lng: long);
// // GBData data = await GeocoderBuddy.findDetails(position);
// //     String? name = data.address.road;
// //     String? subLocality = data.address.village;
// //     String? locality = data.address.stateDistrict;
// //     String? administrativeArea = data.address.state;
// //     String? subAdministrative = data.address.county;
// //     String address =
// //         "${name}, ${subLocality}, ${locality}, ${subAdministrative},${administrativeArea}";
//       SpSetLastLoc(lat, log, address);
//       setState(() {
//         alamat = address;
//       });
//     } catch (e) {}

//     // update _address
//   }

  // Future<void> requestLocationPermission() async {
  //   loc.Location location = new loc.Location();

  //   bool _serviceEnabled;
  //   loc.PermissionStatus _permissionGranted;

  //   _serviceEnabled = await location.serviceEnabled();
  //   if (!_serviceEnabled) {
  //     _serviceEnabled = await location.requestService();
  //     if (!_serviceEnabled) {
  //       return;
  //     }
  //   }

  //   _permissionGranted = await location.hasPermission();
  //   if (_permissionGranted == loc.PermissionStatus.denied) {
  //     _permissionGranted = await location.requestPermission();
  //     if (_permissionGranted != loc.PermissionStatus.granted) {
  //       return;
  //     }
  //   }
  // }

  // @override
  // void dispose() {
  //   WidgetsBinding.instance.removeObserver(this.widget);
  //   locationSubscription?.cancel();
  //   super.dispose();
  // }

  // Future<void> updateLocation() async {
  //   bool _serviceEnabled;
  //   loc.PermissionStatus _permissionGranted;

  //   _serviceEnabled = await lokasi.serviceEnabled();
  //   if (!_serviceEnabled) {
  //     _serviceEnabled = await lokasi.requestService();
  //     if (!_serviceEnabled) {
  //       return;
  //     }
  //   }

  //   _permissionGranted = await lokasi.hasPermission();
  //   if (_permissionGranted == loc.PermissionStatus.denied ||
  //       _permissionGranted == loc.PermissionStatus.deniedForever) {
  //         // showToast("Aplikasi ini memelukan izin akses lokasi agar dapat digunakan");
  //     _permissionGranted = await lokasi.requestPermission();
  //     if (_permissionGranted != loc.PermissionStatus.granted) {
  //       return;
  //     }
  //   }

  //   locationSubscription = lokasi.onLocationChanged.listen((loc.LocationData currentLocation) {
  //     setState(() {
  //       log = currentLocation.longitude ?? 0;
  //       lat = currentLocation.latitude ?? 0;
  //       kordinat = (lat.toString() + " | " + log.toString());
  //     });
  //     // getPlace(log, lat);
  //   });
  // }
}
