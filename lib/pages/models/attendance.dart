import 'package:face_net_authentication/pages/models/approval.dart';
import 'package:intl/intl.dart';

class Attendance {
  int? attendanceId;
  String? employee_id;
  DateTime? attendanceDate;
  DateTime? checkIn;
  DateTime? checkInActual;
  String? checkInStatus;
  DateTime? checkOut;
  DateTime? checkOutActual;
  String? checkOutStatus;
  //String attendanceType;
  String? attendanceTypeIn;
  String? attendanceLocationIn;
  String? attendanceAddressIn;
  String? attendanceNoteIn;
  String? attendanceTypeOut;
  String? attendanceLocationOut;
  String? attendanceAddressOut;
  String? attendanceNoteOut;
  String? attendancePhotoIn;
  String? attendancePhotoOut;
  String? companyId;
  List<Approval>? approvals;
  String? branchName;
  String? employee_name;
  String? type_absensi;
  String? note_status;
  String? is_uploaded;
  String? approval_employee_id;

  Attendance();
  
  Attendance.fromMap(Map<String, dynamic> map){
attendanceId = map["attendance_id"];
    employee_id = map["employee_id"];
    attendanceDate = map['attendance_date'] != null ? DateFormat('yyyy-MM-dd').parse(map['attendance_date']) : null;
    checkIn = map['check_in'] != null ? DateFormat('yyyy-MM-dd HH:mm:ss').parse(map["check_in"]) : null;
    checkInActual = map['check_in_actual'] != null ? DateFormat('yyyy-MM-dd HH:mm:ss').parse(map["check_in_actual"]) : null;
    checkInStatus = statusNameChange(map['check_in_status']);
    checkOut = map['check_out'] != null ? DateFormat('yyyy-MM-dd HH:mm:ss').parse(map["check_out"]) : null;
    checkOutActual = map['check_out_actual'] != null ? DateFormat('yyyy-MM-dd HH:mm:ss').parse(map["check_out_actual"]) : null;
    checkOutStatus = statusNameChange(map['check_out_status']);
    attendanceTypeIn = map['attendance_type_in'];
    attendanceLocationIn = map['attendance_location_in'];
    attendanceAddressIn = map['attendance_address_in'];
    attendanceNoteIn = map['attendance_note_in'];
    attendanceTypeOut = map['attendance_type_out'];
    attendanceLocationOut = map['attendance_location_out'];
    attendanceAddressOut = map['attendance_address_out'];
    attendanceNoteOut = map['attendance_note_out'];
    attendancePhotoIn = map['attendance_photo_in'];
    attendancePhotoOut = map['attendance_photo_out'];
    companyId = map['company_id'];
    if(map['approvals'] != null){
      // attendanceApproval = map['approvals'];
      List<dynamic> list = map['approvals'];
      approvals = list.map((e) => Approval.fromMap(e)).toList();
    }
    branchName = map['branch_name'];
    employee_name = map['employee_name'];
    type_absensi = map['type_absensi'];
    note_status = map['note_status'];
    is_uploaded = map['is_uploaded'];
    approval_employee_id = map['approval_employee_id'];
  }

  Map<String, dynamic> toCreateMap(){
    Map<String, dynamic> map = {};
    
    map["employee_id"] = employee_id;
    if(attendanceDate != null) map["attendance_date"] = DateFormat("yyyy-MM-dd").format(attendanceDate!);
    if(checkIn != null) map["check_in"] = DateFormat("yyyy-MM-dd HH:mm:ss").format(checkIn!);
    if(checkInActual != null) map["check_in_actual"] = DateFormat("yyyy-MM-dd HH:mm:ss").format(checkInActual!);
    if(checkInStatus != null) map["check_in_status"] = checkInStatus;
    if(checkOut != null) map["check_out"] = DateFormat("yyyy-MM-dd HH:mm:ss").format(checkOut!);
    if(checkOutActual != null) map["check_out_actual"] = DateFormat("yyyy-MM-dd HH:mm:ss").format(checkOutActual!);
    if(checkOutStatus != null) map["check_out_status"] = checkOutStatus;
    if(attendanceTypeIn != null) map['attendance_type_in'] = attendanceTypeIn;
    if(attendanceLocationIn != null) map["attendance_location_in"] = attendanceLocationIn;
    if(attendanceAddressIn != null) map["attendance_address_in"] = attendanceAddressIn;
    if(attendanceNoteIn != null) map["attendance_note_in"] = attendanceNoteIn;
    if(attendanceTypeOut != null) map['attendance_type_out'] = attendanceTypeOut;
    if(attendanceLocationOut != null) map["attendance_location_out"] = attendanceLocationOut;
    if(attendanceAddressOut != null) map["attendance_address_out"] = attendanceAddressOut;
    if(attendanceNoteOut != null) map["attendance_note_out"] = attendanceNoteOut;
    if(attendancePhotoIn != null) map["attendance_photo_in"] = attendancePhotoIn;
    if(attendancePhotoOut != null) map["attendance_photo_out"] = attendancePhotoOut;
    if(employee_name != null) map["employee_name"] = employee_name;
    if(type_absensi != null) map["type_absensi"] = type_absensi;
    
    map["company_id"] = companyId;
    map['note_status'] = note_status;
    map['is_uploaded'] = is_uploaded;
    map['approval_employee_id'] = approval_employee_id;
    
    return map;
  }

Map<String, dynamic> toCreateMapForHitAPI(){
    Map<String, dynamic> map = {};
    
    map["employee_id"] = employee_id;
    if(attendanceDate != null) map["attendance_date"] = DateFormat("yyyy-MM-dd").format(attendanceDate!);
    if(checkIn != null) map["check_in"] = DateFormat("yyyy-MM-dd HH:mm:ss").format(checkIn!);
    if(checkInActual != null) map["check_in_actual"] = DateFormat("yyyy-MM-dd HH:mm:ss").format(checkInActual!);
    if(checkInStatus != null) map["check_in_status"] = checkInStatus;
    if(checkOut != null) map["check_out"] = DateFormat("yyyy-MM-dd HH:mm:ss").format(checkOut!);
    if(checkOutActual != null) map["check_out_actual"] = DateFormat("yyyy-MM-dd HH:mm:ss").format(checkOutActual!);
    if(checkOutStatus != null) map["check_out_status"] = checkOutStatus;
    if(attendanceTypeIn != null) map['attendance_type_in'] = attendanceTypeIn;
    if(attendanceLocationIn != null) map["attendance_location_in"] = attendanceLocationIn;
    if(attendanceAddressIn != null) map["attendance_address_in"] = attendanceAddressIn;
    if(attendanceNoteIn != null) map["attendance_note_in"] = attendanceNoteIn;
    if(attendanceTypeOut != null) map['attendance_type_out'] = attendanceTypeOut;
    if(attendanceLocationOut != null) map["attendance_location_out"] = attendanceLocationOut;
    if(attendanceAddressOut != null) map["attendance_address_out"] = attendanceAddressOut;
    if(attendanceNoteOut != null) map["attendance_note_out"] = attendanceNoteOut;
    if(attendancePhotoIn != null) map["attendance_photo_in"] = attendancePhotoIn;
    if(attendancePhotoOut != null) map["attendance_photo_out"] = attendancePhotoOut;
    map["company_id"] = companyId;
    
    return map;
  }


  Map<String, dynamic>? toCreateMapForHit_Approval(){
    Map<String, dynamic> map = {};

    if(approval_employee_id != null){
      map["approval_employee_id"] = approval_employee_id;
       map["employee_id"] = approval_employee_id;

      if(attendanceDate != null) map["approval_date"] = DateFormat("yyyy-MM-dd").format(attendanceDate!);


       map["updated_by"] = approval_employee_id;

       
   
    if(checkInActual != null) map["check_in_actual"] = DateFormat("yyyy-MM-dd HH:mm:ss").format(checkInActual!);
    if(checkOutActual != null) map["check_out_actual"] = DateFormat("yyyy-MM-dd HH:mm:ss").format(checkOutActual!);

     map["company_id"] = companyId;


        if(checkInStatus != null) map["check_in_status"] = checkInStatus;
    if(checkOutStatus != null) map["check_out_status"] = checkOutStatus;

        map["approval_status"] = "APPROVED";
    
    return map;
    }else{
      return null;
    }
    
    
  }

  statusNameChange(String? status){
    if(status == null) return null;
    if(status == "LUPA CO") return "LUPA ABSEN PULANG";
    return status;
  }
}

