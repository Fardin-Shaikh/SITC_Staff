// To parse this JSON data, do
//
//     final cottagereport = cottagereportFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

Cottagereport cottagereportFromJson(String str) => Cottagereport.fromJson(json.decode(str));

String cottagereportToJson(Cottagereport data) => json.encode(data.toJson());

class Cottagereport {
    Cottagereport({
        @required this.cottagesreportlist,
        @required this.response,
    });

    final List<Cottagesreportlist> cottagesreportlist;
    final Response response;

    factory Cottagereport.fromJson(Map<String, dynamic> json) => Cottagereport(
        cottagesreportlist: List<Cottagesreportlist>.from(json["cottagesreportlist"].map((x) => Cottagesreportlist.fromJson(x))),
        response: Response.fromJson(json["response"]),
    );

    Map<String, dynamic> toJson() => {
        "cottagesreportlist": List<dynamic>.from(cottagesreportlist.map((x) => x.toJson())),
        "response": response.toJson(),
    };
}

class Cottagesreportlist {
    Cottagesreportlist({
        @required this.srNo,
        @required this.dates,
        @required this.dayName,
        @required this.totalLuxuryStay,
        @required this.totalGreenRoomStay,
        @required this.luxuryStayBooked,
        @required this.greenRoomBooked,
        @required this.day,
        @required this.dayNight,
        @required this.firstHalf,
        @required this.secondHalf,
        @required this.fullDay,
    });

    final int srNo;
    final String dates;
    final String dayName;
    final int totalLuxuryStay;
    final int totalGreenRoomStay;
    final int luxuryStayBooked;
    final int greenRoomBooked;
    final int day;
    final int dayNight;
    final int firstHalf;
    final int secondHalf;
    final int fullDay;

    factory Cottagesreportlist.fromJson(Map<String, dynamic> json) => Cottagesreportlist(
        srNo: json["SrNo"],
        dates: json["Dates"],
        dayName: json["DayName"],
        totalLuxuryStay: json["TotalLuxuryStay"],
        totalGreenRoomStay: json["TotalGreenRoomStay"],
        luxuryStayBooked: json["LuxuryStayBooked"],
        greenRoomBooked: json["GreenRoomBooked"],
        day: json["Day"],
        dayNight: json["DayNight"],
        firstHalf: json["FirstHalf"],
        secondHalf: json["SecondHalf"],
        fullDay: json["FullDay"],
    );

    Map<String, dynamic> toJson() => {
        "SrNo": srNo,
        "Dates": dates,
        "DayName": dayName,
        "TotalLuxuryStay": totalLuxuryStay,
        "TotalGreenRoomStay": totalGreenRoomStay,
        "LuxuryStayBooked": luxuryStayBooked,
        "GreenRoomBooked": greenRoomBooked,
        "Day": day,
        "DayNight": dayNight,
        "FirstHalf": firstHalf,
        "SecondHalf": secondHalf,
        "FullDay": fullDay,
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
