import 'package:meta/meta.dart';
import 'dart:convert';

GanderOt ganderOtFromJson(String str) => GanderOt.fromJson(json.decode(str));

String ganderOtToJson(GanderOt data) => json.encode(data.toJson());

class GanderOt {
    GanderOt({
        @required this.outfitcategorylist,
        @required this.price,
        @required this.response,
    });

    final List<Outfitcategorylist> outfitcategorylist;
    final Price price;
    final Response response;

    factory GanderOt.fromJson(Map<String, dynamic> json) => GanderOt(
        outfitcategorylist: List<Outfitcategorylist>.from(json["Outfitcategorylist"].map((x) => Outfitcategorylist.fromJson(x))),
        price: Price.fromJson(json["Price"]),
        response: Response.fromJson(json["Response"]),
    );

    Map<String, dynamic> toJson() => {
        "Outfitcategorylist": List<dynamic>.from(outfitcategorylist.map((x) => x.toJson())),
        "Price": price.toJson(),
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

    factory Outfitcategorylist.fromJson(Map<String, dynamic> json) => Outfitcategorylist(
        outfitCategoryId: json["OutfitCategoryId"],
        outfitCategoryName: json["OutfitCategoryName"],
        outfitCategoryDescription: json["OutfitCategoryDescription"],
        type: json["Type"],
        priority: json["Priority"],
        slugName: json["SlugName"],
    );

    Map<String, dynamic> toJson() => {
        "OutfitCategoryId": outfitCategoryId,
        "OutfitCategoryName": outfitCategoryName,
        "OutfitCategoryDescription": outfitCategoryDescription,
        "Type": type,
        "Priority": priority,
        "SlugName": slugName,
    };
}

class Price {
    Price({
        @required this.minSellingPrice,
        @required this.maxSellingPrice,
    });

    final String minSellingPrice;
    final String maxSellingPrice;

    factory Price.fromJson(Map<String, dynamic> json) => Price(
        minSellingPrice: json["MinSellingPrice"],
        maxSellingPrice: json["MaxSellingPrice"],
    );

    Map<String, dynamic> toJson() => {
        "MinSellingPrice": minSellingPrice,
        "MaxSellingPrice": maxSellingPrice,
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
