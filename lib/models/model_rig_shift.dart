import 'dart:convert';

List<BranchStatus> branchStatusFromJson(String str) => List<BranchStatus>.from(json.decode(str).map((x) => BranchStatus.fromJson(x)));

String branchStatusToJson(List<BranchStatus> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BranchStatus {
    BranchStatus({
        required this.statusBranchId,
        required this.branchId,
        required this.statusBranch,
        required this.duration,
        required this.shift,
    });

    String? statusBranchId;
    String? branchId;
    String? statusBranch;
    String? duration;
    List<ShiftBranch> shift;

    factory BranchStatus.fromJson(Map<String, dynamic> json) => BranchStatus(
        statusBranchId: json["status_branch_id"],
        branchId: json["branch_id"],
        statusBranch: json["status_branch"],
        duration: json["duration"],
        shift: List<ShiftBranch>.from(json["shift"].map((x) => ShiftBranch.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status_branch_id": statusBranchId,
        "branch_id": branchId,
        "status_branch": statusBranch,
        "duration": duration,
        "shift": List<dynamic>.from(shift.map((x) => x.toJson())),
    };
}

class ShiftBranch {
    ShiftBranch({
        required this.id,
        required this.checkin,
        required this.checkout,
    });

    String id;
    String checkin;
    String checkout;

    factory ShiftBranch.fromJson(Map<String, dynamic> json) => ShiftBranch(
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
