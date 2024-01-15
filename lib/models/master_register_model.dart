class master_register_model {
  final int? code;
  final String? message;
  final ApiData? data;

  master_register_model({
    required this.code,
    required this.message,
    required this.data,
  });

  factory master_register_model.fromJson(Map<String, dynamic> json) {
    return master_register_model(
      code: json['code'],
      message: json['message'],
      data: ApiData.fromJson(json['data']),
    );
  }
}

class ApiData {
  // final List<Employee> employee;
  // final List<Role> role;
  final List<Location> location;
  // final List<Division> division;

  ApiData({
    // required this.employee,
    // required this.role,
    required this.location,
    // required this.division,
  });

  factory ApiData.fromJson(Map<String, dynamic> json) {
    return ApiData(
      // employee: (json['employee'] as List)
      //     .map((e) => Employee.fromJson(e))
      //     .toList(),
      // role: (json['role'] as List)
      //     .map((e) => Role.fromJson(e))
      //     .toList(),
      location: (json['location'] as List)
          .map((e) => Location.fromJson(e))
          .toList(),
      // division: (json['division'] as List)
      //     .map((e) => Division.fromJson(e))
      //     .toList(),
    );
  }
}

class Employee {
  final String? employeeId;
  final String? employeeName;

  Employee({
    required this.employeeId,
    required this.employeeName,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      employeeId: json['employee_id'],
      employeeName: json['employee_name'],
    );
  }
}

class Role {
  final String? id;

  Role({required this.id});

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(id: json['id']);
  }
}

class Location {
  final String? branchId;
  final String? branchName;

  Location({
    required this.branchId,
    required this.branchName,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      branchId: json['branch_id'],
      branchName: json['branch_name'],
    );
  }
}

class Division {
  final String? organizationId;
  final String? group;

  Division({
    required this.organizationId,
    required this.group,
  });

  factory Division.fromJson(Map<String, dynamic> json) {
    return Division(
      organizationId: json['organization_id'],
      group: json['group'],
    );
  }
}
