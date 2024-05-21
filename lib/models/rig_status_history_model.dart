class RigStatusHistoryModel {
  final int? id;
  final String branchId;
  final String branchStatusId;
  final String requester;
  final String? approver; // approver can be nullable
  final String status;
  final String date;

  RigStatusHistoryModel({
    this.id,
    required this.branchId,
    required this.branchStatusId,
    required this.requester,
    this.approver,
    required this.status,
    required this.date,
  });

  factory RigStatusHistoryModel.fromMap(Map<String, dynamic> map) {
    return RigStatusHistoryModel(
      id: map['id'],
      branchId: map['branch_id'],
      branchStatusId: map['branch_status_id'],
      requester: map['requester'],
      approver: map['approver'], // handle nullable
      status: map['status'],
      date: map['date'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'branch_id': branchId,
      'branch_status_id': branchStatusId,
      'requester': requester,
      'approver': approver, // handle nullable
      'status': status,
      'date': date,
    };
  }
}
