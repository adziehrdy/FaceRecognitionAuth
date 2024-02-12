class BranchStatus {
  final String statusBranchId;
  final String branchId;
  final String statusBranch;
  final String duration;
  final Shift shiftPagi;
  final Shift shiftMalam;
  final Shift shiftOncall;

  BranchStatus({
    required this.statusBranchId,
    required this.branchId,
    required this.statusBranch,
    required this.duration,
    required this.shiftPagi,
    required this.shiftMalam,
    required this.shiftOncall,
  });

  factory BranchStatus.fromJson(Map<String, dynamic> json) {
    return BranchStatus(
      statusBranchId: json['status_branch_id'] ?? "",
      branchId: json['branch_id'] ?? "",
      statusBranch: json['status_branch'] ?? "",
      duration: json['duration'] ?? "",
      shiftPagi: Shift.fromJson(json['shift_pagi']),
      shiftMalam: Shift.fromJson(json['shift_malam']),
      shiftOncall: Shift.fromJson(json['shift_oncall']),
    );
  }
}

class Shift {
  final String id;
  final String checkin;
  final String checkout;

  Shift({
    required this.id,
    required this.checkin,
    required this.checkout,
  });

  factory Shift.fromJson(Map<String, dynamic> json) {
    return Shift(
      id: json['id'] ?? "",
      checkin: json['checkin_pagi'] ?? json['oncall_checkin'] ?? json['checkin_malam'] ?? "",
      checkout: json['checkout_pagi'] ?? json['oncall_checkout'] ??  json['checkout_malam'] ?? "",
    );
  }
}
