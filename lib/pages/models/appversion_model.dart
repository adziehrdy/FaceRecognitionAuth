import 'dart:convert';

AppversionModel appversionModelFromMap(String str) => AppversionModel.fromMap(json.decode(str));

// String appversionModelToMap(AppversionModel data) => json.encode(data.toMap());

class AppversionModel {
    int code;
    String message;
    Data data;

    AppversionModel({
        required this.code,
        required this.message,
        required this.data,
    });

    factory AppversionModel.fromMap(Map<String, dynamic> json) => AppversionModel(
        code: json["code"],
        message: json["message"],
        data: Data.fromMap(json["data"]),
    );

    Map<String, dynamic> toMap() => {
        "code": code,
        "message": message,
        "data": data.toMap(),
    };
}

class Data {
    List<Multiple> personal;
    List<Multiple> multiple;

    Data({
        required this.personal,
        required this.multiple,
    });

    factory Data.fromMap(Map<String, dynamic> json) => Data(
        personal: List<Multiple>.from(json["personal"].map((x) => Multiple.fromMap(x))),
        multiple: List<Multiple>.from(json["multiple"].map((x) => Multiple.fromMap(x))),
    );

    Map<String, dynamic> toMap() => {
        "personal": List<dynamic>.from(personal.map((x) => x.toMap())),
        "multiple": List<dynamic>.from(multiple.map((x) => x.toMap())),
    };
}

class Multiple {
    String version;
    String active;
    String os;
    String type;

    Multiple({
        required this.version,
        required this.active,
        required this.os,
        required this.type,
    });

    factory Multiple.fromMap(Map<String, dynamic> json) => Multiple(
        version: json["version"],
        active: json["active"],
        os: json["os"],
        type: json["type"],
    );

    Map<String, dynamic> toMap() => {
        "version": version,
        "active": active,
        "os": os,
        "type": type,
    };
}
