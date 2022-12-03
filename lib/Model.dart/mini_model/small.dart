// To parse this JSON data, do
//
//     final smallResponce = smallResponceFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

SmallResponce smallResponceFromJson(String str) => SmallResponce.fromJson(json.decode(str));

String smallResponceToJson(SmallResponce data) => json.encode(data.toJson());

class SmallResponce {
    SmallResponce({
        @required this.n,
        @required this.msg,
        @required this.status,
    });

    final int n;
    final String msg;
    final String status;

    factory SmallResponce.fromJson(Map<String, dynamic> json) => SmallResponce(
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
