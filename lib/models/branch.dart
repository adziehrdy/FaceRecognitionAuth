class Branch {
  String? branchId;
  String? branchName;
  String? branchLocation;
  late double branchLat;
  late double branchLng;
  String? branchQrCode;
  int? branchGeofencing;
  String? branchTz;

  Branch.fromMap(Map<String, dynamic> map) {
    branchId = map['branch_id'];
    branchName = map['branch_name'];
    branchLocation = map['branch_location'];
    List<String> splits = branchLocation!.split(',');
    branchLat = double.parse(splits[0]);
    branchLng = double.parse(splits[1]);
    branchQrCode = map['branch_qrcode'];
    branchGeofencing = map['branch_geofencing'];
    branchTz = map['branch_timezone'];
  }
}
