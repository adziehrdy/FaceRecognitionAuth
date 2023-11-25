class Atasan {
  String? employee_id;
  String? employeeName;

  Atasan.fromMap(Map<String, dynamic> map){
    employee_id = map['employee_id'];
    employeeName = map['employee_name'];
  }
}