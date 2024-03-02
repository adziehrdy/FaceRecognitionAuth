class MasterBranches {
  final String? branchId;
  final String? branchName;
  // final String branchAddress;
  // final String? branchProvince;
  // final String? branchCity;
  // final String? branchDistrict;
  // final String? branchContact;
  // final String? branchPhone;
  // final String branchLocation;
  // final String branchGeofencing;
  // final String branchQrCode;
  // final String branchStatus;
  // final String companyId;
  // final String updatedBy;
  // final String updatedDate;
  // final String branchTimezone;
  // final String? branchGroupId;
  // final String? tolerance;

  MasterBranches({
    required this.branchId,
    required this.branchName,
    // required this.branchAddress,
    // this.branchProvince,
    // this.branchCity,
    // this.branchDistrict,
    // this.branchContact,
    // this.branchPhone,
    // required this.branchLocation,
    // required this.branchGeofencing,
    // required this.branchQrCode,
    // required this.branchStatus,
    // required this.companyId,
    // required this.updatedBy,
    // required this.updatedDate,
    // required this.branchTimezone,
    // this.branchGroupId,
    // this.tolerance,
  });

factory MasterBranches.fromJson(Map<String, dynamic> json) {
    return MasterBranches(
      branchId: json['branch_id'],
      branchName: json['branch_name'],
      // branchAddress: json['branch_address'],
      // branchProvince: json['branch_province'],
      // branchCity: json['branch_city'],
      // branchDistrict: json['branch_district'],
      // branchContact: json['branch_contact'],
      // branchPhone: json['branch_phone'],
      // branchLocation: json['branch_location'],
      // branchGeofencing: json['branch_geofencing'],
      // branchQrCode: json['branch_qrcode'],
      // branchStatus: json['branch_status'],
      // companyId: json['company_id'],
      // updatedBy: json['updated_by'],
      // updatedDate: json['updated_date'],
      // branchTimezone: json['branch_timezone'],
      // branchGroupId: json['branch_group_id'],
      // tolerance: json['tolerance'],
    );
  }

  static List<MasterBranches> listFromJson(List<dynamic> json) {
    return json.map((branch) => MasterBranches.fromJson(branch)).toList();
  }

  Map<String, dynamic> toMap() {
    return {
      'branch_id': branchId,
      'branch_name': branchName,
      // 'branch_address': branchAddress,
      // 'branch_province': branchProvince,
      // 'branch_city': branchCity,
      // 'branch_district': branchDistrict,
      // 'branch_contact': branchContact,
      // 'branch_phone': branchPhone,
      // 'branch_location': branchLocation,
      // 'branch_geofencing': branchGeofencing,
      // 'branch_qrcode': branchQrCode,
      // 'branch_status': branchStatus,
      // 'company_id': companyId,
      // 'updated_by': updatedBy,
      // 'updated_date': updatedDate,
      // 'branch_timezone': branchTimezone,
      // 'branch_group_id': branchGroupId,
      // 'tolerance': tolerance,
    };
  }
}
