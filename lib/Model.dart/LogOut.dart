import 'package:meta/meta.dart';
import 'dart:convert';

LogOutModel logOutModelFromJson(String str) =>
    LogOutModel.fromJson(json.decode(str));

String logOutModelToJson(LogOutModel data) => json.encode(data.toJson());

class LogOutModel {
  LogOutModel({
    @required this.response,
  });

  final Response response;

  factory LogOutModel.fromJson(Map<String, dynamic> json) => LogOutModel(
        response: Response.fromJson(json["response"]),
      );

  Map<String, dynamic> toJson() => {
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
