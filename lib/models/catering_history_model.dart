class CateringHistoryModel {
  final String? id;
  final String branchId;
  final String? requester;
  final String? approver; // approver can be nullable
  final String status;
  final String date;
  final String? api_flag;
  final String? shift;

  CateringHistoryModel(
      {this.id,
      required this.branchId,
      required this.requester,
      this.approver,
      required this.status,
      required this.date,
      required this.api_flag,
      required this.shift});

  factory CateringHistoryModel.fromMap(Map<String, dynamic> map) {
    return CateringHistoryModel(
        id: map['id'].toString(),
        branchId: map['branch_id'],
        requester: map['requester'],
        approver: map['approver'], // handle nullable
        status: map['status'],
        date: map['date'],
        api_flag: map['api_flag'],
        shift: map['shift']);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'branch_id': branchId,
      'requester': requester,
      'approver': approver, // handle nullable
      'status': status,
      'date': date,
      'api_flag': api_flag,
      'shift': shift
    };
  }
}
