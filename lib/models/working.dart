
import 'package:intl/intl.dart';

class Working {
  int? id;
  String? employee_id;
  DateTime? workDateTime;
  String? content;
  String? file;
  String? photo;
  String? link;
  String? gambar;
  String? companyId;

  Working();

  Working.fromMap(Map<String, dynamic> map){
    id = map['id'];
    employee_id = map['employee_id'];
    workDateTime = DateFormat('yyyy-MM-dd HH:mm:ss').parse(map['work_datetime']);
    content = map['content'];
    file = map['file'];
    photo = map['photo'];
    link = map['link'];
    gambar = map['gambar'];
    companyId = map['company_id'];
  }

  Map<String, dynamic> toMap(){
    Map<String, dynamic> map = {};
    if(id != null) map['id'] = id;
    if(employee_id != null) map['employee_id'] = employee_id;
    if(workDateTime != null) map['work_datetime'] = DateFormat('yyyy-MM-dd HH:mm:ss').format(workDateTime!);
    if(content != null) map['content'] = content;
    if(link != null) map['link'] = link;
    if(companyId != null) map['company_id'] = companyId;
    return map;
  }
}