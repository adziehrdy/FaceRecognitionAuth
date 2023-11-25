import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';

import 'attendance.dart';


class Approval {
  int? id;
  int? attendanceId;
  String? employee_id;
  String? employeeName;
  String? checkType;
  late DateTime checkTime;
  String? checkStatus;
  String? approvalNote;
  String? approvalemployee_id;
  String? approvalEmployeeName;
  String? approvalStatus;
  DateTime? approvalDate;
  String? companyId;
  String? location;
  String? address;
  LatLng? latLng;

  Approval.fromMap(Map<String, dynamic> map){
    id = map['id'];
    attendanceId = map['attendance_id'];
    employee_id = map['employee_id'];
    employeeName = map['employee_name'];
    checkType = map['check_type'];
    checkTime = DateFormat('yyyy-MM-dd HH:mm:ss').parse(map['check_time']);
    checkStatus = Attendance().statusNameChange(map['check_status']);
    approvalNote = map['approval_note'];
    approvalemployee_id = map['approval_employee_id'];
    approvalEmployeeName = map['approval_employee_name'];
    approvalStatus = map['approval_status'];
    approvalDate = map['approval_date'] != null ? DateFormat('yyyy-MM-dd HH:mm:ss').parse(map['approval_date']) : null;
    companyId = map['company_id'];
    address = map['address'];
    location = map['location'];
    if(location != null){
      List<String> splits = location!.split(',');
      latLng = LatLng(double.parse(splits[0]), double.parse(splits[1]));
    }
  }

  Map<String, dynamic> toUpdateMap(){
    Map<String, dynamic> map = {};
    map['approval_status'] = approvalStatus;
    map['approval_date'] = DateFormat('yyyy-MM-dd').format(approvalDate!);
    
    return map;
  }
}