import 'package:meta/meta.dart';
import 'dart:convert';

FilteredOt filteredOtFromJson(String str) =>
    FilteredOt.fromJson(json.decode(str));

String filteredOtToJson(FilteredOt data) => json.encode(data.toJson());

class FilteredOt {
  FilteredOt({
    @required this.outFitList,
    @required this.response,
  });

  final List<OutFitList> outFitList;
  final Response response;

  factory FilteredOt.fromJson(Map<String, dynamic> json) => FilteredOt(
        outFitList: List<OutFitList>.from(
            json["OutFitList"].map((x) => OutFitList.fromJson(x))),
        response: Response.fromJson(json["response"]),
      );

  Map<String, dynamic> toJson() => {
        "OutFitList": List<dynamic>.from(outFitList.map((x) => x.toJson())),
        "response": response.toJson(),
      };
}

class OutFitList {
  OutFitList({
    @required this.outfitId,
    @required this.productName,
    @required this.outfitCategoryId,
    @required this.outfitCategoryName,
    @required this.description,
    @required this.price,
    @required this.discountAmount,
    @required this.discountType,
    @required this.gender,
    @required this.imageLink,
    @required this.imageName,
    @required this.imageExtension,
    @required this.priority,
    @required this.slugName,
    @required this.sellingPrice,
    @required this.addedinCart,
    @required this.quantity,
    @required this.staffId,
  });

  final int outfitId;
  final String productName;
  final int outfitCategoryId;
  final String outfitCategoryName;
  final String description;
  final String price;
  final String discountAmount;
  final String discountType;
  final String gender;
  final String imageLink;
  final String imageName;
  final String imageExtension;
  final String priority;
  final String slugName;
  final String sellingPrice;
  final String addedinCart;
  final String quantity;
  final String staffId;

  factory OutFitList.fromJson(Map<String, dynamic> json) => OutFitList(
        outfitId: json["OutfitID"],
        productName: json["ProductName"],
        outfitCategoryId: json["OutfitCategoryId"],
        outfitCategoryName: json["OutfitCategoryName"],
        description: json["Description"],
        price: json["Price"],
        discountAmount: json["DiscountAmount"],
        discountType: json["DiscountType"],
        gender: json["Gender"],
        imageLink: json["ImageLink"],
        imageName: json["ImageName"],
        imageExtension: json["ImageExtension"],
        priority: json["Priority"],
        slugName: json["SlugName"],
        sellingPrice: json["SellingPrice"],
        addedinCart: json["AddedinCart"],
        quantity: json["Quantity"],
        staffId: json["StaffId"],
      );

  Map<String, dynamic> toJson() => {
        "OutfitID": outfitId,
        "ProductName": productName,
        "OutfitCategoryId": outfitCategoryId,
        "OutfitCategoryName": outfitCategoryName,
        "Description": description,
        "Price": price,
        "DiscountAmount": discountAmount,
        "DiscountType": discountType,
        "Gender": gender,
        "ImageLink": imageLink,
        "ImageName": imageName,
        "ImageExtension": imageExtension,
        "Priority": priority,
        "SlugName": slugName,
        "SellingPrice": sellingPrice,
        "AddedinCart": addedinCart,
        "Quantity": quantity,
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
