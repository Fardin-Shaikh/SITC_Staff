import 'package:meta/meta.dart';
import 'dart:convert';

DetailProps detailPropsFromJson(String str) =>
    DetailProps.fromJson(json.decode(str));

String detailPropsToJson(DetailProps data) => json.encode(data.toJson());

class DetailProps {
  DetailProps({
    @required this.propList,
    @required this.response,
  });

  final List<PropList> propList;
  final Response response;

  factory DetailProps.fromJson(Map<String, dynamic> json) => DetailProps(
        propList: List<PropList>.from(
            json["PropList"].map((x) => PropList.fromJson(x))),
        response: Response.fromJson(json["response"]),
      );

  Map<String, dynamic> toJson() => {
        "PropList": List<dynamic>.from(propList.map((x) => x.toJson())),
        "response": response.toJson(),
      };
}

class PropList {
  PropList({
    @required this.propId,
    @required this.propName,
    @required this.propDescription,
    @required this.price,
    @required this.discountType,
    @required this.discountAmount,
    @required this.thumbnailName,
    @required this.thumbnailType,
    @required this.thmbnailLink,
    @required this.sellingPrice,
    @required this.slugName,
    @required this.propCategoryName,
    @required this.propCategoryId,
    @required this.staffId,
  });

  final int propId;
  final String propName;
  final String propDescription;
  final dynamic price;
  final dynamic discountType;
  final dynamic discountAmount;
  final String thumbnailName;
  final String thumbnailType;
  final String thmbnailLink;
  final dynamic sellingPrice;
  final dynamic slugName;
  final String propCategoryName;
  final String propCategoryId;
  final dynamic staffId;

  factory PropList.fromJson(Map<String, dynamic> json) => PropList(
        propId: json["PropId"],
        propName: json["PropName"],
        propDescription: json["PropDescription"],
        price: json["Price"],
        discountType: json["DiscountType"],
        discountAmount: json["DiscountAmount"],
        thumbnailName: json["ThumbnailName"],
        thumbnailType: json["ThumbnailType"],
        thmbnailLink: json["ThmbnailLink"],
        sellingPrice: json["SellingPrice"],
        slugName: json["SlugName"],
        propCategoryName: json["PropCategoryName"],
        propCategoryId: json["PropCategoryId"],
        staffId: json["StaffId"],
      );

  Map<String, dynamic> toJson() => {
        "PropId": propId,
        "PropName": propName,
        "PropDescription": propDescription,
        "Price": price,
        "DiscountType": discountType,
        "DiscountAmount": discountAmount,
        "ThumbnailName": thumbnailName,
        "ThumbnailType": thumbnailType,
        "ThmbnailLink": thmbnailLink,
        "SellingPrice": sellingPrice,
        "SlugName": slugName,
        "PropCategoryName": propCategoryName,
        "PropCategoryId": propCategoryId,
        "StaffId": staffId,
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
