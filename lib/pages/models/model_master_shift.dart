class model_master_shift {
  final int code;
  final String message;
  final List<ShiftData> data;

  model_master_shift({required this.code, required this.message, required this.data});

  factory model_master_shift.fromJson(Map<String, dynamic> json) {
    var dataList = json['data'] as List;
    List<ShiftData> shiftDataList =
        dataList.map((e) => ShiftData.fromJson(e)).toList();

    return model_master_shift(
      code: json['code'],
      message: json['message'],
      data: shiftDataList,
    );
  }
}

class ShiftData {
  final String shiftId;
  final String shiftName;
  final String? shiftNote;
  final String? checkIn;
  final String? checkOut;
  final String attendanceType;
  final String companyId;
  final String updatedBy;
  final String updatedDate;

  ShiftData({
    required this.shiftId,
    required this.shiftName,
    this.shiftNote,
    this.checkIn,
    this.checkOut,
    required this.attendanceType,
    required this.companyId,
    required this.updatedBy,
    required this.updatedDate,
  });

  factory ShiftData.fromJson(Map<String, dynamic> json) {
    return ShiftData(
      shiftId: json['shift_id'],
      shiftName: json['shift_name'],
      shiftNote: json['shift_note'],
      checkIn: json['check_in'],
      checkOut: json['check_out'],
      attendanceType: json['attendance_type'],
      companyId: json['company_id'],
      updatedBy: json['updated_by'],
      updatedDate: json['updated_date'],
    );
  }
}
