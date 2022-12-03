// To parse this JSON data, do
//
//     final employdata = employdataFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

Employdata employdataFromJson(String str) => Employdata.fromJson(json.decode(str));

String employdataToJson(Employdata data) => json.encode(data.toJson());

class Employdata {
    Employdata({
        @required this.stafflist,
        @required this.response,
    });

    final List<Stafflist> stafflist;
    final Response response;

    factory Employdata.fromJson(Map<String, dynamic> json) => Employdata(
        stafflist: List<Stafflist>.from(json["stafflist"].map((x) => Stafflist.fromJson(x))),
        response: Response.fromJson(json["response"]),
    );

    Map<String, dynamic> toJson() => {
        "stafflist": List<dynamic>.from(stafflist.map((x) => x.toJson())),
        "response": response.toJson(),
    };
}

class Response {
    Response({
        @required this.n,
        @required this.msg,
        @required this.status,
    });

    final int n;
    final String msg;
    final String status;

    factory Response.fromJson(Map<String, dynamic> json) => Response(
        n: json["n"],
        msg: json["Msg"],
        status: json["Status"],
    );

    Map<String, dynamic> toJson() => {
        "n": n,
        "Msg": msg,
        "Status": status,
    };
}

class Stafflist {
    Stafflist({
        @required this.staffId,
        @required this.staffName,
        @required this.staffMobileNo,
        @required this.staffEmailId,
        @required this.staffImageLink,
        @required this.staffImageName,
        @required this.staffImageExtension,
        @required this.staffPanCard,
        @required this.staffAadharCard,
        @required this.staffEmergencyContactName,
        @required this.staffEmergencyContactNo,
    });

    final int staffId;
    final String staffName;
    final String staffMobileNo;
    final String staffEmailId;
    final String staffImageLink;
    final String staffImageName;
    final String staffImageExtension;
    final String staffPanCard;
    final String staffAadharCard;
    final String staffEmergencyContactName;
    final String staffEmergencyContactNo;

    factory Stafflist.fromJson(Map<String, dynamic> json) => Stafflist(
        staffId: json["StaffId"],
        staffName: json["StaffName"],
        staffMobileNo: json["StaffMobileNo"],
        staffEmailId: json["StaffEmailId"],
        staffImageLink: json["StaffImageLink"],
        staffImageName: json["StaffImageName"],
        staffImageExtension: json["StaffImageExtension"],
        staffPanCard: json["StaffPanCard"],
        staffAadharCard: json["StaffAadharCard"],
        staffEmergencyContactName: json["StaffEmergencyContactName"],
        staffEmergencyContactNo: json["StaffEmergencyContactNo"],
    );

    Map<String, dynamic> toJson() => {
        "StaffId": staffId,
        "StaffName": staffName,
        "StaffMobileNo": staffMobileNo,
        "StaffEmailId": staffEmailId,
        "StaffImageLink": staffImageLink,
        "StaffImageName": staffImageName,
        "StaffImageExtension": staffImageExtension,
        "StaffPanCard": staffPanCard,
        "StaffAadharCard": staffAadharCard,
        "StaffEmergencyContactName": staffEmergencyContactName,
        "StaffEmergencyContactNo": staffEmergencyContactNo,
    };
}
