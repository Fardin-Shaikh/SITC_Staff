import 'package:meta/meta.dart';
import 'dart:convert';

LoginDetails loginDetailsFromJson(String str) =>
    LoginDetails.fromJson(json.decode(str));

String loginDetailsToJson(LoginDetails data) => json.encode(data.toJson());

class LoginDetails {
  LoginDetails({
    @required this.userDetails,
    @required this.token,
    @required this.response,
  });

  final UserDetails userDetails;
  final String token;
  final Response response;

  factory LoginDetails.fromJson(Map<String, dynamic> json) => LoginDetails(
        userDetails: UserDetails.fromJson(json["UserDetails"]),
        token: json["Token"],
        response: Response.fromJson(json["response"]),
      );

  Map<String, dynamic> toJson() => {
        "UserDetails": userDetails.toJson(),
        "Token": token,
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

class UserDetails {
  UserDetails({
    @required this.id,
    @required this.name,
    @required this.mobile,
    @required this.emailId,
    @required this.gender,
    @required this.isPaymentDone,
    @required this.status,
    @required this.imageLink,
    @required this.imageName,
    @required this.imageExtension,
    @required this.roleId,
    @required this.roleName,
  });

  final int id;
  final String name;
  final String mobile;
  final String emailId;
  final dynamic gender;
  final int isPaymentDone;
  final int status;
  final String imageLink;
  final String imageName;
  final String imageExtension;
  final String roleId;
  final String roleName;

  factory UserDetails.fromJson(Map<String, dynamic> json) => UserDetails(
        id: json["Id"],
        name: json["Name"],
        mobile: json["Mobile"],
        emailId: json["EmailId"],
        gender: json["Gender"],
        isPaymentDone: json["IsPaymentDone"],
        status: json["Status"],
        imageLink: json["ImageLink"],
        imageName: json["ImageName"],
        imageExtension: json["ImageExtension"],
        roleId: json["RoleId"],
        roleName: json["RoleName"],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "Name": name,
        "Mobile": mobile,
        "EmailId": emailId,
        "Gender": gender,
        "IsPaymentDone": isPaymentDone,
        "Status": status,
        "ImageLink": imageLink,
        "ImageName": imageName,
        "ImageExtension": imageExtension,
        "RoleId": roleId,
        "RoleName": roleName,
      };
}
