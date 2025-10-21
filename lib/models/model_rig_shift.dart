// To parse this JSON data, do
//
//     final rigStatusShift = rigStatusShiftFromJson(jsonString);

import 'dart:convert';

List<RigStatusShift> rigStatusShiftFromJson(String str) =>
    List<RigStatusShift>.from(
        json.decode(str).map((x) => RigStatusShift.fromJson(x)));

String rigStatusShiftToJson(List<RigStatusShift> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RigStatusShift {
  String? statusBranchId;
  String? branchId;
  String? statusBranch;
  // String? duration;
  List<ShiftRig>? shift;

  RigStatusShift({
    this.statusBranchId,
    this.branchId,
    this.statusBranch,
    // this.duration,
    this.shift,
  });

  factory RigStatusShift.fromJson(Map<String, dynamic> json) => RigStatusShift(
        statusBranchId: json["status_branch_id"],
        branchId: json["branch_id"],
        statusBranch: json["status_branch"],
        // duration: json["duration"],
        shift: json["shift"] == null
            ? []
            : List<ShiftRig>.from(
                json["shift"]!.map((x) => ShiftRig.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status_branch_id": statusBranchId,
        "branch_id": branchId,
        "status_branch": statusBranch,
        // "duration": duration,
        "shift": shift == null
            ? []
            : List<dynamic>.from(shift!.map((x) => x.toJson())),
      };
}

class ShiftRig {
  String? id;
  String? checkin;
  String? checkout;

  ShiftRig({
    this.id,
    this.checkin,
    this.checkout,
  });

  factory ShiftRig.fromJson(Map<String, dynamic> json) => ShiftRig(
        id: json["id"],
        checkin: json["checkin"],
        checkout: json["checkout"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "checkin": checkin,
        "checkout": checkout,
      };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
