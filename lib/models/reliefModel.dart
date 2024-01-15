class ReliefModel {
  String? employeeName;
  String? reliefId;
  DateTime? reliefStartDate;
  DateTime? reliefEndDate;
  String? reliefStatus;
  String? note;
  String? desc;
  String? totalDays;
  String? fromBranch;
  String? toBranch;
  String? statusRelief;

  ReliefModel({
    required this.employeeName,
    required this.reliefId,
    required this.reliefStartDate,
    required this.reliefEndDate,
    required this.reliefStatus,
    required this.note,
    required this.desc,
    required this.totalDays,
    required this.fromBranch,
    required this.toBranch,
    required this.statusRelief,
  });

  factory ReliefModel.fromMap(Map<String, dynamic> map) {
    return ReliefModel(
      employeeName: map['employee_name'] ?? '',
      reliefId: map['relief_id'] ?? '',
      reliefStartDate: DateTime.parse(map['relief_start_date'] ?? ''),
      reliefEndDate: DateTime.parse(map['relief_end_date'] ?? ''),
      reliefStatus: map['relief_status'] ?? '',
      note: map['note'] ?? '',
      desc: map['desc'] ?? '',
      totalDays: map['total_days'] ?? '',
      fromBranch: map['from_branch'] ?? '',
      toBranch: map['to_branch'] ?? '',
      statusRelief: map['status_relief'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'employee_name': employeeName,
      'relief_id': reliefId,
      'relief_start_date': reliefStartDate!.toIso8601String(),
      'relief_end_date': reliefEndDate!.toIso8601String(),
      'relief_status': reliefStatus,
      'note': note,
      'desc': desc,
      'total_days': totalDays,
      'from_branch': fromBranch,
      'to_branch': toBranch,
      'status_relief': statusRelief,
    };
  }
}
