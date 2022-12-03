import 'package:meta/meta.dart';
import 'dart:convert';

BaseM baseMFromJson(String str) => BaseM.fromJson(json.decode(str));

String baseMToJson(BaseM data) => json.encode(data.toJson());

class BaseM {
  BaseM({
    @required this.response,
  });

  final Response response;

  factory BaseM.fromJson(Map<String, dynamic> json) => BaseM(
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

ClearNotif clearNotifFromJson(String str) =>
    ClearNotif.fromJson(json.decode(str));

String clearNotifToJson(ClearNotif data) => json.encode(data.toJson());

class ClearNotif {
  ClearNotif({
    @required this.n,
    @required this.msg,
    @required this.status,
  });

  final int n;
  final String msg;
  final String status;

  factory ClearNotif.fromJson(Map<String, dynamic> json) => ClearNotif(
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
