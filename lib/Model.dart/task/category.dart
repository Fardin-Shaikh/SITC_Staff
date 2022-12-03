// To parse this JSON data, do
//
//     final taskcategory = taskcategoryFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

Taskcategory taskcategoryFromJson(String str) => Taskcategory.fromJson(json.decode(str));

String taskcategoryToJson(Taskcategory data) => json.encode(data.toJson());

class Taskcategory {
    Taskcategory({
        @required this.categorylist,
        @required this.response,
    });

    final List<Categorylist> categorylist;
    final Response response;

    factory Taskcategory.fromJson(Map<String, dynamic> json) => Taskcategory(
        categorylist: List<Categorylist>.from(json["categorylist"].map((x) => Categorylist.fromJson(x))),
        response: Response.fromJson(json["response"]),
    );

    Map<String, dynamic> toJson() => {
        "categorylist": List<dynamic>.from(categorylist.map((x) => x.toJson())),
        "response": response.toJson(),
    };
}

class Categorylist {
    Categorylist({
        @required this.categoryId,
        @required this.categoryName,
    });

    final int categoryId;
    final String categoryName;

    factory Categorylist.fromJson(Map<String, dynamic> json) => Categorylist(
        categoryId: json["CategoryId"],
        categoryName: json["CategoryName"],
    );

    Map<String, dynamic> toJson() => {
        "CategoryId": categoryId,
        "CategoryName": categoryName,
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
