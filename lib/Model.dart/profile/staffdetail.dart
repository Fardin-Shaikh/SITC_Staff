import 'package:meta/meta.dart';
import 'dart:convert';

Staffdetail staffdetailFromJson(String str) =>
    Staffdetail.fromJson(json.decode(str));

String staffdetailToJson(Staffdetail data) => json.encode(data.toJson());

class Staffdetail {
  Staffdetail({
    @required this.staffdetails,
    @required this.response,
  });

  final Staffdetails staffdetails;
  final Response response;

  factory Staffdetail.fromJson(Map<String, dynamic> json) => Staffdetail(
        staffdetails: Staffdetails.fromJson(json["staffdetails"]),
        response: Response.fromJson(json["response"]),
      );

  Map<String, dynamic> toJson() => {
        "staffdetails": staffdetails.toJson(),
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

class Staffdetails {
  Staffdetails({
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
  final dynamic staffPanCard;
  final String staffAadharCard;
  final dynamic staffEmergencyContactName;
  final dynamic staffEmergencyContactNo;

  factory Staffdetails.fromJson(Map<String, dynamic> json) => Staffdetails(
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
