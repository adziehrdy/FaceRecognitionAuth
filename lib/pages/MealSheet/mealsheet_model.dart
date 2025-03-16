class MealSheetModel {
  final int? id;
  final String employee_id;
  final String employeeName;
  final DateTime? initDate;
  final String? bFast;
  final DateTime? bFastTime;
  final String? lunch;
  final DateTime? lunchTime;
  final String? dinner;
  final DateTime? dinnerTime;
  final String? supper;
  final DateTime? supperTime;
  final String? sahur;
  final DateTime? sahur_time;
  final String? accommodation;
  final String? type;
  final int person_count;
  final int isUploaded;

  MealSheetModel({
    this.id,
    required this.employee_id,
    required this.employeeName,
    this.initDate,
    this.bFast,
    this.bFastTime,
    this.lunch,
    this.lunchTime,
    this.dinner,
    this.dinnerTime,
    this.supper,
    this.supperTime,
    this.sahur,
    this.sahur_time,
    this.accommodation,
    this.type,
    required this.person_count,
    this.isUploaded = 0,
  });

  factory MealSheetModel.fromMap(Map<String, dynamic> map) {
    return MealSheetModel(
      id: map['id'],
      employee_id: map['employee_id'],
      employeeName: map['employee_name'],
      initDate:
          map['init_date'] != null ? DateTime.parse(map['init_date']) : null,
      bFast: map['b_fast'],
      bFastTime: map['b_fast_time'] != null
          ? DateTime.parse(map['b_fast_time'])
          : null,
      lunch: map['lunch'],
      lunchTime:
          map['lunch_time'] != null ? DateTime.parse(map['lunch_time']) : null,
      dinner: map['dinner'],
      dinnerTime: map['dinner_time'] != null
          ? DateTime.parse(map['dinner_time'])
          : null,
      supper: map['supper'],
      supperTime: map['supper_time'] != null
          ? DateTime.parse(map['supper_time'])
          : null,
      sahur: map['sahur'],
      sahur_time:
          map['sahur_time'] != null ? DateTime.parse(map['supper_time']) : null,
      accommodation: map['accommodation'],
      type: map['type'],
      person_count: map['person_count'],
      isUploaded: map['is_uploaded'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'employee_id': employee_id,
      'employee_name': employeeName,
      'init_date': initDate?.toIso8601String(),
      'b_fast': bFast,
      'b_fast_time': bFastTime?.toIso8601String(),
      'lunch': lunch,
      'lunch_time': lunchTime?.toIso8601String(),
      'dinner': dinner,
      'dinner_time': dinnerTime?.toIso8601String(),
      'supper': supper,
      'supper_time': supperTime?.toIso8601String(),
      'sahur': sahur,
      'sahur_time': sahur_time?.toIso8601String(),
      'accommodation': accommodation,
      'type': type,
      'person_count': person_count,
      'is_uploaded': isUploaded,
    };
  }
}

class MealSheetVisitorModel {
  final int? id;
  final String? employee_id;
  final String? employeeName;
  final String? company;
  final DateTime? initDate;
  final String? bFast;
  final DateTime? bFastTime;
  final String? lunch;
  final DateTime? lunchTime;
  final String? dinner;
  final DateTime? dinnerTime;
  final String? supper;
  final DateTime? supperTime;
  final String? sahur;
  final DateTime? sahurTime;
  final String? accommodation;
  final String guestType;
  final String type;
  final String brachID;
  final String department;
  final String constCenter;
  final int person_count;
  final String? notes;
  final int isUploaded;

  MealSheetVisitorModel({
    this.id,
    this.employee_id,
    this.employeeName,
    this.company,
    this.initDate,
    this.bFast,
    this.bFastTime,
    this.lunch,
    this.lunchTime,
    this.dinner,
    this.dinnerTime,
    this.supper,
    this.supperTime,
    this.sahur,
    this.sahurTime,
    required this.guestType,
    this.accommodation,
    required this.brachID,
    required this.department,
    required this.constCenter,
    required this.type,
    required this.person_count,
    this.notes,
    this.isUploaded = 0,
  });

  factory MealSheetVisitorModel.fromMap(Map<String, dynamic> map) {
    return MealSheetVisitorModel(
      id: map['id'],
      employee_id: map['employee_id'],
      employeeName: map['employee_name'],
      company: map['company'],
      initDate:
          map['init_date'] != null ? DateTime.parse(map['init_date']) : null,
      bFast: map['b_fast'],
      bFastTime: map['b_fast_time'] != null
          ? DateTime.parse(map['b_fast_time'])
          : null,
      lunch: map['lunch'],
      lunchTime:
          map['lunch_time'] != null ? DateTime.parse(map['lunch_time']) : null,
      dinner: map['dinner'],
      dinnerTime: map['dinner_time'] != null
          ? DateTime.parse(map['dinner_time'])
          : null,
      supper: map['supper'],
      supperTime: map['supper_time'] != null
          ? DateTime.parse(map['supper_time'])
          : null,
      sahur: map['sahur'],
      sahurTime:
          map['sahur_time'] != null ? DateTime.parse(map['sahur_time']) : null,
      accommodation: map['accommodation'],
      type: map['type'],
      guestType: map['guest_type'],
      brachID: map['branch_id'],
      department: map['department'],
      constCenter: map['cost_center'],
      person_count: map['person_count'],
      notes: map['notes'],
      isUploaded: map['is_uploaded'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'employee_id': employee_id,
      'employee_name': employeeName,
      'company': company,
      'init_date': initDate?.toIso8601String(),
      'b_fast': bFast,
      'b_fast_time': bFastTime?.toIso8601String(),
      'lunch': lunch,
      'lunch_time': lunchTime?.toIso8601String(),
      'dinner': dinner,
      'dinner_time': dinnerTime?.toIso8601String(),
      'supper': supper,
      'supper_time': supperTime?.toIso8601String(),
      'sahur': sahur,
      'sahur_time': sahurTime?.toIso8601String(),
      'accommodation': accommodation,
      'guest_type': guestType,
      'type': type,
      'branch_id': brachID,
      'department': department,
      'cost_center': constCenter,
      'person_count': person_count,
      'notes': notes,
      'is_uploaded': isUploaded,
    };
  }
}

class MealSchedule {
  final String name;
  final String startTime;
  final String endTime;

  MealSchedule({
    required this.name,
    required this.startTime,
    required this.endTime,
  });

  // Factory method untuk membuat instance dari Map
  factory MealSchedule.fromMap(String key, List<String> value) {
    return MealSchedule(
      name: key,
      startTime: value[0],
      endTime: value[1],
    );
  }

  // Convert object ke Map
  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "startTime": startTime,
      "endTime": endTime,
    };
  }
}

// Convert Map ke List<MealSchedule>
List<MealSchedule> parseMealSchedule(Map<String, List<String>> data) {
  return data.entries
      .map((entry) => MealSchedule.fromMap(entry.key, entry.value))
      .toList();
}
