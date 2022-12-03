import 'package:meta/meta.dart';
import 'dart:convert';

AttStaffdetail attStaffdetailFromJson(String str) =>
    AttStaffdetail.fromJson(json.decode(str));

String attStaffdetailToJson(AttStaffdetail data) => json.encode(data.toJson());

class AttStaffdetail {
  AttStaffdetail({
    @required this.attendancedetails,
    @required this.response,
  });

  final Attendancedetails attendancedetails;
  final Response response;

  factory AttStaffdetail.fromJson(Map<String, dynamic> json) => AttStaffdetail(
        attendancedetails:
            Attendancedetails.fromJson(json["attendancedetails"]),
        response: Response.fromJson(json["response"]),
      );

  Map<String, dynamic> toJson() => {
        "attendancedetails": attendancedetails.toJson(),
        "response": response.toJson(),
      };
}

class Attendancedetails {
  Attendancedetails({
    @required this.staffId,
    @required this.checkIn,
    @required this.checkOut,
    @required this.hrs,
    @required this.latitude,
    @required this.longitude,
    @required this.radius,
  });

  final int staffId;
  final String checkIn;
  final String checkOut;
  final String hrs;
  final String latitude;
  final String longitude;
  final String radius;

  factory Attendancedetails.fromJson(Map<String, dynamic> json) =>
      Attendancedetails(
        staffId: json["StaffId"],
        checkIn: json["CheckIn"],
        checkOut: json["CheckOut"],
        hrs: json["Hrs"],
        latitude: json["Latitude"],
        longitude: json["Longitude"],
        radius: json["Radius"],
      );

  Map<String, dynamic> toJson() => {
        "StaffId": staffId,
        "CheckIn": checkIn,
        "CheckOut": checkOut,
        "Hrs": hrs,
        "Latitude": latitude,
        "Longitude": longitude,
        "Radius": radius,
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
