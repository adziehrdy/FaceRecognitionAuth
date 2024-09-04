class RigStatusHistoryModel {
  final String? id;
  final String branchId;
  final String branchStatusId;
  final String? requester;
  final String? approver; // approver can be nullable
  final String status;
  final String date;
  final String? shift;
  final String? api_flag;

  RigStatusHistoryModel({
    this.id,
    required this.branchId,
    required this.branchStatusId,
    required this.requester,
    this.approver,
    required this.status,
    required this.date,
    required this.api_flag,
    required this.shift,
  });

  factory RigStatusHistoryModel.fromMap(Map<String, dynamic> map) {
    return RigStatusHistoryModel(
        id: map['id'].toString(),
        branchId: map['branch_id'],
        branchStatusId: map['branch_status_id'],
        requester: map['requester'],
        approver: map['approver'], // handle nullable
        status: map['status']?.toString() ?? '-',
        date: map['date'],
        api_flag: map['api_flag'],
        shift: map['shift']);
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
      'api_flag': api_flag,
      'shift': shift
    };
  }
}
