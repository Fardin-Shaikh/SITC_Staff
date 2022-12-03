
import 'package:meta/meta.dart';
import 'dart:convert';

Report reportFromJson(String str) => Report.fromJson(json.decode(str));

String reportToJson(Report data) => json.encode(data.toJson());

class Report {
    Report({
        @required this.reportlist,
        @required this.response,
    });

    final List<Reportlist> reportlist;
    final Response response;

    factory Report.fromJson(Map<String, dynamic> json) => Report(
        reportlist: List<Reportlist>.from(json["reportlist"].map((x) => Reportlist.fromJson(x))),
        response: Response.fromJson(json["response"]),
    );

    Map<String, dynamic> toJson() => {
        "reportlist": List<dynamic>.from(reportlist.map((x) => x.toJson())),
        "response": response.toJson(),
    };
}

class Reportlist {
    Reportlist({
        @required this.reportId,
        @required this.reportName,
    });

    final int reportId;
    final String reportName;

    factory Reportlist.fromJson(Map<String, dynamic> json) => Reportlist(
        reportId: json["ReportId"],
        reportName: json["ReportName"],
    );

    Map<String, dynamic> toJson() => {
        "ReportId": reportId,
        "ReportName": reportName,
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
