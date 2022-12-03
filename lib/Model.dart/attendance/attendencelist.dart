import 'package:meta/meta.dart';
import 'dart:convert';

AllAttendence allAttendenceFromJson(String str) =>
    AllAttendence.fromJson(json.decode(str));

String allAttendenceToJson(AllAttendence data) => json.encode(data.toJson());

class AllAttendence {
  AllAttendence({
    @required this.staffattendanceslist,
    @required this.response,
  });

  final List<Staffattendanceslist> staffattendanceslist;
  final Response response;

  factory AllAttendence.fromJson(Map<String, dynamic> json) => AllAttendence(
        staffattendanceslist: List<Staffattendanceslist>.from(
            json["staffattendanceslist"]
                .map((x) => Staffattendanceslist.fromJson(x))),
        response: Response.fromJson(json["response"]),
      );

  Map<String, dynamic> toJson() => {
        "staffattendanceslist":
            List<dynamic>.from(staffattendanceslist.map((x) => x.toJson())),
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

class Staffattendanceslist {
  Staffattendanceslist({
    @required this.staffId,
    @required this.staffName,
    @required this.date,
    @required this.checkIn,
    @required this.checkOut,
    @required this.hours,
    @required this.mins,
  });

  final int staffId;
  final String staffName;
  final dynamic date;
  final dynamic checkIn;
  final dynamic checkOut;
  final String hours;
  final String mins;

  factory Staffattendanceslist.fromJson(Map<String, dynamic> json) =>
      Staffattendanceslist(
        staffId: json["StaffId"],
        staffName: json["StaffName"],
        date: json["Date"],
        checkIn: json["CheckIn"],
        checkOut: json["CheckOut"],
        hours: json["Hours"],
        mins: json["Mins"],
      );

  Map<String, dynamic> toJson() => {
        "StaffId": staffId,
        "StaffName": staffName,
        "Date": date,
        "CheckIn": checkIn,
        "CheckOut": checkOut,
        "Hours": hours,
        "Mins": mins,
      };
}
