class catering_exception_model {
  final int? id;
  final String branchId;
  final String employee_id;
  final String employee_name;
  final String requester;
  final String? approver; // approver can be nullable
  final String status;
  final String date;
  final String notes;

  catering_exception_model(
      {this.id,
      required this.branchId,
      required this.employee_id,
      required this.employee_name,
      required this.requester,
      this.approver,
      required this.status,
      required this.date,
      required this.notes});

  factory catering_exception_model.fromMap(Map<String, dynamic> map) {
    return catering_exception_model(
        id: map['id'],
        branchId: map['branch_id'],
        employee_id: map['employee_id'],
        employee_name: map['employee_name'],
        requester: map['requester'],
        approver: map['approver'], // handle nullable
        status: map['status'],
        date: map['date'],
        notes: map['notes']);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'branch_id': branchId,
      'employee_id': employee_id,
      'employee_name': employee_name,
      'requester': requester,
      'approver': approver, // handle nullable
      'status': status,
      'date': date,
      'notes': notes
    };
  }
}
