class LoginModel {
  final String? accessToken;
  final Branch? branch;
  final List<SuperIntendent> superAttendence;

  LoginModel({
    required this.accessToken,
    required this.branch,
    required this.superAttendence,
  });

  Map<String, dynamic> toMap() {
    return {
      'access_token': accessToken,
      'branch': branch?.toMap(),
      'super_attendence': superAttendence.map((sa) => sa.toMap()).toList(),
    };
  }

  factory LoginModel.fromMap(Map<String, dynamic> map) {
    var superAttendenceList = map['super_attendence'] as List<dynamic>;
    List<SuperIntendent> superAttendence = superAttendenceList.map((e) => SuperIntendent.fromJson(e)).toList();

    return LoginModel(
      accessToken: map['access_token'],
      branch: map['branch'] != null ? Branch.fromMap(map['branch']) : null,
      superAttendence: superAttendence,
    );
  }
}

class SuperIntendent {
  final String id;
  final String name;

  SuperIntendent({
    required this.id,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  factory SuperIntendent.fromJson(Map<String, dynamic> json) {
    return SuperIntendent(
      id: json['id'],
      name: json['name'],
    );
  }
}

class Branch {
  final String branchId;
  final String branchName;
  final String branchLocation;
  final String branchGeofencing;
  final String? tolerance;

  Branch({
    required this.branchId,
    required this.branchName,
    required this.branchLocation,
    required this.branchGeofencing,
    required this.tolerance
  });

  Map<String, dynamic> toMap() {
    return {
      'branch_id': branchId,
      'branch_name': branchName,
      'branch_location': branchLocation,
      'branch_geofencing': branchGeofencing,
      'tolerance' : tolerance ?? "0"
    };
  }

  factory Branch.fromMap(Map<String, dynamic> map) {
    return Branch(
      branchId: map['branch_id'],
      branchName: map['branch_name'],
      branchLocation: map['branch_location'],
      branchGeofencing: map['branch_geofencing'],
      tolerance : map['tolerance']
    );
  }
}
