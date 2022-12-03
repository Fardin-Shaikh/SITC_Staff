import 'package:meta/meta.dart';
import 'dart:convert';

Departmnent departmnentFromJson(String str) =>
    Departmnent.fromJson(json.decode(str));

String departmnentToJson(Departmnent data) => json.encode(data.toJson());

class Departmnent {
  Departmnent({
    @required this.departmentbillinglist,
    @required this.response,
  });

  final List<Departmentbillinglist> departmentbillinglist;
  final Response response;

  factory Departmnent.fromJson(Map<String, dynamic> json) => Departmnent(
        departmentbillinglist: List<Departmentbillinglist>.from(
            json["departmentbillinglist"]
                .map((x) => Departmentbillinglist.fromJson(x))),
        response: Response.fromJson(json["response"]),
      );

  Map<String, dynamic> toJson() => {
        "departmentbillinglist":
            List<dynamic>.from(departmentbillinglist.map((x) => x.toJson())),
        "response": response.toJson(),
      };
}

class Departmentbillinglist {
  Departmentbillinglist({
    @required this.departmentId,
    @required this.departmentName,
  });

  final int departmentId;
  final String departmentName;

  factory Departmentbillinglist.fromJson(Map<String, dynamic> json) =>
      Departmentbillinglist(
        departmentId: json["DepartmentId"],
        departmentName: json["DepartmentName"],
      );

  Map<String, dynamic> toJson() => {
        "DepartmentId": departmentId,
        "DepartmentName": departmentName,
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
