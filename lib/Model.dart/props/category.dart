import 'package:meta/meta.dart';
import 'dart:convert';

CategoryProps categoryPropsFromJson(String str) =>
    CategoryProps.fromJson(json.decode(str));

String categoryPropsToJson(CategoryProps data) => json.encode(data.toJson());

class CategoryProps {
  CategoryProps({
    @required this.propcategorylist,
    @required this.response,
  });

  final List<Propcategorylist> propcategorylist;
  final Response response;

  factory CategoryProps.fromJson(Map<String, dynamic> json) => CategoryProps(
        propcategorylist: List<Propcategorylist>.from(
            json["propcategorylist"].map((x) => Propcategorylist.fromJson(x))),
        response: Response.fromJson(json["response"]),
      );

  Map<String, dynamic> toJson() => {
        "propcategorylist":
            List<dynamic>.from(propcategorylist.map((x) => x.toJson())),
        "response": response.toJson(),
      };
}

class Propcategorylist {
  Propcategorylist({
    @required this.propCategoryId,
    @required this.propCategoryName,
    @required this.imageLink,
    @required this.imageName,
    @required this.imageExtension,
    @required this.slugName,
  });

  final int propCategoryId;
  final String propCategoryName;
  final String imageLink;
  final String imageName;
  final String imageExtension;
  final String slugName;

  factory Propcategorylist.fromJson(Map<String, dynamic> json) =>
      Propcategorylist(
        propCategoryId: json["PropCategoryId"],
        propCategoryName: json["PropCategoryName"],
        imageLink: json["ImageLink"],
        imageName: json["ImageName"],
        imageExtension: json["ImageExtension"],
        slugName: json["SlugName"],
      );

  Map<String, dynamic> toJson() => {
        "PropCategoryId": propCategoryId,
        "PropCategoryName": propCategoryName,
        "ImageLink": imageLink,
        "ImageName": imageName,
        "ImageExtension": imageExtension,
        "SlugName": slugName,
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
