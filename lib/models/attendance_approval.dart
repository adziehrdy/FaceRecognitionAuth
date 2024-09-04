import 'package:intl/intl.dart';

class AttendanceApproval {
  int? id;
  int? attendanceId;
  String? employee_id;
  String? employeeName;
  DateTime? checkInActual;
  String? checkInStatus;
  DateTime? checkOutActual;
  String? checkOutStatus;
  String? approvalNote;
  String? approvalemployee_id;
  String? approvalEmployeeName;
  String? approvalStatus;
  DateTime? approvalDate;
  String? companyId;

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    if (id != null) map['id'] = id;
    if (attendanceId != null) map['attendance_id'] = attendanceId;
    if (employee_id != null) map['employee_id'] = employee_id;
    if (employeeName != null) map['employee_name'] = employeeName;
    if (checkInActual != null)
      map['check_in_actual'] =
          DateFormat('yyyy-MM-dd HH:mm:ss').format(checkInActual!);
    if (checkInStatus != null) map['check_in_status'] = checkInStatus;
    if (checkOutActual != null)
      map['check_out_actual'] =
          DateFormat('yyyy-MM-dd HH:mm:ss').format(checkOutActual!);
    if (checkOutStatus != null) map['check_out_status'] = checkOutStatus;
    if (approvalNote != null) map['approval_note'] = approvalNote;
    if (approvalemployee_id != null)
      map['approval_employee_id'] = approvalemployee_id;
    if (approvalEmployeeName != null)
      map['approval_employee_name'] = approvalEmployeeName;
    if (approvalStatus != null) map['approval_status'] = approvalStatus;
    if (companyId != null) map['company_id'] = companyId;
    return map;
  }
}
