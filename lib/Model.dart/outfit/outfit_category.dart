import 'package:meta/meta.dart';
import 'dart:convert';

Category categoryFromJson(String str) => Category.fromJson(json.decode(str));

String categoryToJson(Category data) => json.encode(data.toJson());

class Category {
  Category({
    @required this.outfitcategorylist,
    @required this.price,
    @required this.response,
  });

  final List<Outfitcategorylist> outfitcategorylist;
  final dynamic price;
  final Response response;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        outfitcategorylist: List<Outfitcategorylist>.from(
            json["Outfitcategorylist"]
                .map((x) => Outfitcategorylist.fromJson(x))),
        price: json["Price"],
        response: Response.fromJson(json["Response"]),
      );

  Map<String, dynamic> toJson() => {
        "Outfitcategorylist":
            List<dynamic>.from(outfitcategorylist.map((x) => x.toJson())),
        "Price": price,
        "Response": response.toJson(),
      };
}

class Outfitcategorylist {
  Outfitcategorylist({
    @required this.outfitCategoryId,
    @required this.outfitCategoryName,
    @required this.outfitCategoryDescription,
    @required this.type,
    @required this.priority,
    @required this.slugName,
  });

  final int outfitCategoryId;
  final String outfitCategoryName;
  final String outfitCategoryDescription;
  final String type;
  final String priority;
  final String slugName;

  factory Outfitcategorylist.fromJson(Map<String, dynamic> json) =>
      Outfitcategorylist(
        outfitCategoryId: json["OutfitCategoryId"],
        outfitCategoryName: json["OutfitCategoryName"],
        outfitCategoryDescription: json["OutfitCategoryDescription"] == null
            ? null
            : json["OutfitCategoryDescription"],
        type: json["Type"],
        priority: json["Priority"],
        slugName: json["SlugName"],
      );

  Map<String, dynamic> toJson() => {
        "OutfitCategoryId": outfitCategoryId,
        "OutfitCategoryName": outfitCategoryName,
        "OutfitCategoryDescription": outfitCategoryDescription == null
            ? null
            : outfitCategoryDescription,
        "Type": type,
        "Priority": priority,
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
