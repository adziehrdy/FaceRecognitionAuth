// To parse this JSON data, do
//
//     final dkListModel = dkListModelFromJson(jsonString);

import 'dart:convert';

DkListModel dkListModelFromJson(String str) =>
    DkListModel.fromJson(json.decode(str));

String dkListModelToJson(DkListModel data) => json.encode(data.toJson());

class DkListModel {
  String? message;
  List<DK_data>? data;

  DkListModel({
    this.message,
    this.data,
  });

  factory DkListModel.fromJson(Map<String, dynamic> json) => DkListModel(
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<DK_data>.from(json["data"]!.map((x) => DK_data.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class DK_data {
  String? id;
  String? dkNum;
  String? employeeId;
  String? branchId;
  DateTime? fromDate;
  DateTime? toDate;
  String? desc;
  dynamic approval;
  String? amount;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic status;
  String? employee_name;
  String? approver_name;

  DK_data(
      {this.id,
      this.dkNum,
      this.employeeId,
      this.branchId,
      this.fromDate,
      this.toDate,
      this.desc,
      this.approval,
      this.amount,
      this.createdAt,
      this.updatedAt,
      this.status,
      this.approver_name,
      this.employee_name});

  factory DK_data.fromJson(Map<String, dynamic> json) => DK_data(
        id: json["id"],
        dkNum: json["dk_num"],
        employeeId: json["employee_id"],
        branchId: json["branch_id"],
        fromDate: json["from_date"] == null
            ? null
            : DateTime.parse(json["from_date"]),
        toDate:
            json["to_date"] == null ? null : DateTime.parse(json["to_date"]),
        desc: json["desc"],
        approval: json["approval"],
        amount: json["amount"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        status: json["status"],
        employee_name: json["employee_name"],
        approver_name: json["approver_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "dk_num": dkNum,
        "employee_id": employeeId,
        "branch_id": branchId,
        "from_date":
            "${fromDate!.year.toString().padLeft(4, '0')}-${fromDate!.month.toString().padLeft(2, '0')}-${fromDate!.day.toString().padLeft(2, '0')}",
        "to_date":
            "${toDate!.year.toString().padLeft(4, '0')}-${toDate!.month.toString().padLeft(2, '0')}-${toDate!.day.toString().padLeft(2, '0')}",
        "desc": desc,
        "approval": approval,
        "amount": amount,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "status": status,
        "employee_name": employee_name,
        "approver_name": approver_name,
      };
}
