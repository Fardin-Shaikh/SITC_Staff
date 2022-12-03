// To parse this JSON data, do
//
//     final history = historyFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

History historyFromJson(String str) => History.fromJson(json.decode(str));

String historyToJson(History data) => json.encode(data.toJson());

class History {
  History({
    @required this.stafforderlists,
    @required this.totalAmount,
    @required this.response,
  });

  final List<Stafforderlist> stafforderlists;
  final String totalAmount;
  final Response response;

  factory History.fromJson(Map<String, dynamic> json) => History(
        stafforderlists: List<Stafforderlist>.from(
            json["stafforderlists"].map((x) => Stafforderlist.fromJson(x))),
        totalAmount: json["TotalAmount"],
        response: Response.fromJson(json["response"]),
      );

  Map<String, dynamic> toJson() => {
        "stafforderlists":
            List<dynamic>.from(stafforderlists.map((x) => x.toJson())),
        "TotalAmount": totalAmount,
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

class Stafforderlist {
  Stafforderlist({
    @required this.id,
    @required this.userId,
    @required this.userType,
    @required this.departmentTypeId,
    @required this.departmentTypeName,
    @required this.professionalCategoryId,
    @required this.cottageId,
    @required this.amount,
    @required this.remark,
    @required this.pkOrderId,
    @required this.date,
    @required this.productId,
  });

  final int id;
  final int userId;
  final String userType;
  final int departmentTypeId;
  final String departmentTypeName;
  final int professionalCategoryId;
  final int cottageId;
  final String amount;
  final String remark;
  final int pkOrderId;
  final String date;
  final int productId;

  factory Stafforderlist.fromJson(Map<String, dynamic> json) => Stafforderlist(
        id: json["Id"],
        userId: json["UserId"],
        userType: json["UserType"],
        departmentTypeId: json["DepartmentTypeId"],
        departmentTypeName: json["DepartmentTypeName"],
        professionalCategoryId: json["ProfessionalCategoryId"],
        cottageId: json["CottageId"],
        amount: json["Amount"],
        remark: json["Remark"],
        pkOrderId: json["Pk_OrderId"],
        date: json["Date"],
        productId: json["ProductId"],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "UserId": userId,
        "UserType": userType,
        "DepartmentTypeId": departmentTypeId,
        "DepartmentTypeName": departmentTypeName,
        "ProfessionalCategoryId": professionalCategoryId,
        "CottageId": cottageId,
        "Amount": amount,
        "Remark": remark,
        "Pk_OrderId": pkOrderId,
        "Date": date,
        "ProductId": productId,
      };
}
