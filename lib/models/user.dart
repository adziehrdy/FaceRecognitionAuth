import 'dart:convert';
import 'dart:developer';

import 'package:face_net_authentication/globals.dart';
import 'package:flutter/material.dart';

class User {
  String? employee_id;
  String? username;
  String? group_access_id;
  String? company_id;
  String? employee_name;
  String? employee_phone;
  String? employee_email;
  String? employee_status;
  DateTime? employee_birth_date;
  String? employee_position;
  ImageProvider? employee_photo;
  String? branch_id;
  String? branch_name;
  String? attendance_type;
  String? status;
  // List<UserLocation>? userLocation;
  // String user;
  // String password;
  List? face_template;
  String? is_personal;
  String? is_verif_fr;
  String? shift_id;
  String? check_in;
  String? check_out;
  String? employee_fr_image;

//RELIEF
  String? status_relief;
  String? relief_id;
  String? from_branch;
  String? to_branch;
  String? relief_status;
  String? relief_start_date;
  String? relief_end_date;
  String? is_relief_employee;

//DK
  String? dk_start_date;
  String? dk_end_date;
  String? status_dk;

  User({required this.employee_id, required this.employee_name});

  User.fromMap(Map<String, dynamic> map) {
    try {
      print(map['employee_name']);
      employee_id = map['employee_id'];
      username = map['username'];
      group_access_id = map['group_access_id'];
      company_id = map['company_id'];
      employee_name = map['employee_name'];
      employee_phone = map['employee_phone'];
      employee_email = map['employee_email'];
      employee_status = map['employee_status'];
      // employee_birth_date =
      //     DateFormat('yyyy-MM').parse(map['employee_birth_date']);
      employee_position = map['employee_position'];
      if (map['employee_photo'] == null || map['employee_photo'].length == 0) {
        employee_photo = AssetImage('assets/images/blank-profile-pic.png');
      } else {
        employee_photo = NetworkImage(publicUrl + map['employee_photo']);
      }
      branch_id = map['branch_id'];
      branch_name = map['branch_name'];
      attendance_type = map['attendance_type'];
      status = map['status'];

      is_personal = map['is_personal'];
      is_verif_fr = map['is_verif_fr'];

      shift_id = map['shift_id'];
      check_in = map['check_in'];
      check_out = map['check_out'];
      employee_fr_image = map['employee_fr_image'];

      //RELIEF
      status_relief = map['status_relief'];
      relief_id = map['relief_id'];
      from_branch = map['from_branch'];
      to_branch = map['to_branch'];
      relief_status = map['relief_status'];
      relief_start_date = map['relief_start_date'];
      relief_end_date = map['relief_end_date'];
      is_relief_employee = map['is_relief_employee'];

      //DK
      dk_start_date = map['dk_start_date'];
      dk_end_date = map['dk_end_date'];
      status_dk = map['status_dk'];
    } catch (e) {
      log(e.toString());
    }

    if (map['employee_fr_template'] == null ||
        map['employee_fr_template'] == "null") {
    } else {
      if (map['employee_fr_template'] is String) {
        try {
          face_template = decode_FR_FromBase64(map['employee_fr_template']);
        } catch (e) {
          face_template = jsonDecode(map['employee_fr_template']);
        }
      }
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'employee_id': employee_id,
      'username': username,
      'group_access_id': group_access_id,
      'company_id': company_id,
      'employee_name': employee_name,
      'employee_phone': employee_phone,
      'employee_email': employee_email,
      'employee_status': employee_status,
      // 'employee_birth_date':
      //     DateFormat('yyyy-MM').format(employee_birth_date!),
      'employee_position': employee_position,
      // profileImage cannot be directly converted to a map.
      'branch_id': branch_id,
      'branch_name': branch_name,
      'attendance_type': attendance_type,
      'status': status,
      // 'user_location': userLocation.map((location) => location.toString()).toList(),
      'employee_fr_template': jsonEncode(face_template),
      'is_personal': is_personal,
      'is_verif_fr': is_verif_fr,
      'shift_id': shift_id,
      'check_in': check_in,
      'check_out': check_out,
      'employee_fr_image': employee_fr_image,

      //RELIEF
      'status_relief': status_relief,
      'relief_id': relief_id,
      'from_branch': from_branch,
      'to_branch': to_branch,
      'relief_status': relief_status,
      'relief_start_date': relief_start_date,
      'relief_end_date': relief_end_date,
      'is_relief_employee': is_relief_employee,

      //DK
      'dk_start_date': dk_start_date,
      'dk_end_date': dk_end_date,
      'status_dk': status_dk
    };
  }
}

class UserLocation {
  String? locationName;
  String? locationPosition;

  UserLocation.fromMap(Map<String, dynamic> map) {
    locationName = map['branch_name'];
    locationPosition = map['branch_location'];
  }
}
