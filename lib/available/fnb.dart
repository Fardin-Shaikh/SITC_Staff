import 'package:meta/meta.dart';
import 'dart:convert';

Food foodFromJson(String str) => Food.fromJson(json.decode(str));

String foodToJson(Food data) => json.encode(data.toJson());

class Food {
    Food({
        @required this.headtitle,
        @required this.reportresponse,
        @required this.response,
    });

    final List<Headtitle> headtitle;
    final List<dynamic> reportresponse;
    final Response response;

    factory Food.fromJson(Map<String, dynamic> json) => Food(
        headtitle: List<Headtitle>.from(json["headtitle"].map((x) => Headtitle.fromJson(x))),
        reportresponse: List<dynamic>.from(json["reportresponse"].map((x) => x)),
        response: Response.fromJson(json["response"]),
    );

    Map<String, dynamic> toJson() => {
        "headtitle": List<dynamic>.from(headtitle.map((x) => x.toJson())),
        "reportresponse": List<dynamic>.from(reportresponse.map((x) => x)),
        "response": response.toJson(),
    };
}

class Headtitle {
    Headtitle({
        @required this.id,
        @required this.title,
        @required this.shortName,
    });

    final int id;
    final String title;
    final String shortName;

    factory Headtitle.fromJson(Map<String, dynamic> json) => Headtitle(
        id: json["Id"],
        title: json["Title"],
        shortName: json["ShortName"],
    );

    Map<String, dynamic> toJson() => {
        "Id": id,
        "Title": title,
        "ShortName": shortName,
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
