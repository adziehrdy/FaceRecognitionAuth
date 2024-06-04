class catering_exception_model {
  final String? id;
  final String branchId;
  final String employee_id;
  final String employee_name;
  final String? requester_id;
  final String? approver_id; // approver can be nullable
  final String status;
  final String date;
  final String? notes;
  final String? shift;
  final String? api_key;

  catering_exception_model(
      {this.id,
      required this.branchId,
      required this.shift,
      required this.employee_id,
      required this.employee_name,
      required this.requester_id,
      this.approver_id,
      required this.status,
      required this.date,
      required this.notes,
      this.api_key});

  factory catering_exception_model.fromMap(Map<String, dynamic> map) {
    return catering_exception_model(
        id: map['id'].toString(),
        branchId: map['branch_id'],
        employee_id: map['employee_id'],
        employee_name: map['employee_name'],
        requester_id: map['requester_id'],
        approver_id: map['approver_id'], // handle nullable
        status: map['status'],
        date: map['date'],
        notes: map['notes'],
        shift: map['shift'],
        api_key: map['api_key']);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'branch_id': branchId,
      'employee_id': employee_id,
      'employee_name': employee_name,
      'requester_id': requester_id,
      'approver_id': approver_id, // handle nullable
      'status': status,
      'date': date,
      'notes': notes,
      'shift': shift,
      'api_key': api_key
    };
  }
}
