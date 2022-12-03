import 'package:meta/meta.dart';
import 'dart:convert';

UpcommingRecord upcommingRecordFromJson(String str) =>
    UpcommingRecord.fromJson(json.decode(str));

String upcommingRecordToJson(UpcommingRecord data) =>
    json.encode(data.toJson());

class UpcommingRecord {
  UpcommingRecord({
    @required this.finalorderlist,
    @required this.response,
  });

  final List<Finalorderlist> finalorderlist;
  final Response response;

  factory UpcommingRecord.fromJson(Map<String, dynamic> json) =>
      UpcommingRecord(
        finalorderlist: List<Finalorderlist>.from(
            json["finalorderlist"].map((x) => Finalorderlist.fromJson(x))),
        response: Response.fromJson(json["response"]),
      );

  Map<String, dynamic> toJson() => {
        "finalorderlist":
            List<dynamic>.from(finalorderlist.map((x) => x.toJson())),
        "response": response.toJson(),
      };
}

class Finalorderlist {
  Finalorderlist({
    @required this.todaystafforder,
    @required this.cartList,
  });

  final Todaystafforder todaystafforder;
  final List<CartList> cartList;

  factory Finalorderlist.fromJson(Map<String, dynamic> json) => Finalorderlist(
        todaystafforder: Todaystafforder.fromJson(json["todaystafforder"]),
        cartList: List<CartList>.from(
            json["CartList"].map((x) => CartList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "todaystafforder": todaystafforder.toJson(),
        "CartList": List<dynamic>.from(cartList.map((x) => x.toJson())),
      };
}

class CartList {
  CartList({
    @required this.typeId,
    @required this.typeName,
    @required this.orderItems,
  });

  final String typeId;
  final String typeName;
  final List<OrderItem> orderItems;

  factory CartList.fromJson(Map<String, dynamic> json) => CartList(
        typeId: json["TypeId"],
        typeName: json["TypeName"],
        orderItems: List<OrderItem>.from(
            json["OrderItems"].map((x) => OrderItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "TypeId": typeId,
        "TypeName": typeName,
        "OrderItems": List<dynamic>.from(orderItems.map((x) => x.toJson())),
      };
}

class OrderItem {
  OrderItem({
    @required this.srNo,
    @required this.orderItemId,
    @required this.pkOrderId,
    @required this.typeId,
    @required this.typeName,
    @required this.productId,
    @required this.bookingDate,
    @required this.quntity,
    @required this.productName,
    @required this.productDescription,
    @required this.productPrice,
    @required this.productDiscountAmount,
    @required this.productSellingAmount,
    @required this.amount,
    @required this.startTime,
    @required this.endTime,
    @required this.productCategory,
    @required this.productPackage,
    @required this.productPackageId,
  });

  final int srNo;
  final int orderItemId;
  final int pkOrderId;
  final int typeId;
  final String typeName;
  final int productId;
  final String bookingDate;
  final int quntity;
  final String productName;
  final String productDescription;
  final String productPrice;
  final String productDiscountAmount;
  final String productSellingAmount;
  final dynamic amount;
  final String startTime;
  final String endTime;
  final String productCategory;
  final String productPackage;
  final dynamic productPackageId;

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
        srNo: json["SrNo"],
        orderItemId: json["OrderItemId"],
        pkOrderId: json["PK_OrderId"],
        typeId: json["TypeId"],
        typeName: json["TypeName"],
        productId: json["ProductId"],
        bookingDate: json["BookingDate"],
        quntity: json["Quntity"],
        productName: json["ProductName"],
        productDescription: json["ProductDescription"],
        productPrice: json["ProductPrice"],
        productDiscountAmount: json["ProductDiscountAmount"],
        productSellingAmount: json["ProductSellingAmount"],
        amount: json["Amount"],
        startTime: json["StartTime"],
        endTime: json["EndTime"],
        productCategory: json["ProductCategory"],
        productPackage: json["ProductPackage"],
        productPackageId: json["ProductPackageId"],
      );

  Map<String, dynamic> toJson() => {
        "SrNo": srNo,
        "OrderItemId": orderItemId,
        "PK_OrderId": pkOrderId,
        "TypeId": typeId,
        "TypeName": typeName,
        "ProductId": productId,
        "BookingDate": bookingDate,
        "Quntity": quntity,
        "ProductName": productName,
        "ProductDescription": productDescription,
        "ProductPrice": productPrice,
        "ProductDiscountAmount": productDiscountAmount,
        "ProductSellingAmount": productSellingAmount,
        "Amount": amount,
        "StartTime": startTime,
        "EndTime": endTime,
        "ProductCategory": productCategory,
        "ProductPackage": productPackage,
        "ProductPackageId": productPackageId,
      };
}

class Todaystafforder {
  Todaystafforder({
    @required this.orderId,
    @required this.bookingDate,
    @required this.fullName,
    @required this.phone,
    @required this.orderNote,
    @required this.orderStatus,
    @required this.staffId,
    @required this.staffName,
    @required this.packageName,
    @required this.startTime,
    @required this.endTime,
    @required this.amountPaid,
    @required this.extraPeopleCharge,
    @required this.minimunDepositAmount,
    @required this.addedServices,
    @required this.checkingStatus,
    @required this.checkInTime,
    @required this.checkOutTime,
    @required this.extrahouramount,
    @required this.damageCharge,
    @required this.extraPeopleAmount,
    @required this.totalAmount,
    @required this.rewards,
    @required this.couponDiscount,
    @required this.additionalDiscount,
    @required this.netTotalAmount,
    @required this.paidAmount,
    @required this.balanceAmount,
  });

  final int orderId;
  final String bookingDate;
  final String fullName;
  final String phone;
  final String orderNote;
  final String orderStatus;
  final String staffId;
  final String staffName;
  final String packageName;
  final String startTime;
  final String endTime;
  final String amountPaid;
  final String extraPeopleCharge;
  final String minimunDepositAmount;
  final String addedServices;
  final String checkingStatus;
  final String checkInTime;
  final String checkOutTime;
  final String extrahouramount;
  final String damageCharge;
  final String extraPeopleAmount;
  final String totalAmount;
  final String rewards;
  final String couponDiscount;
  final String additionalDiscount;
  final String netTotalAmount;
  final String paidAmount;
  final String balanceAmount;

  factory Todaystafforder.fromJson(Map<String, dynamic> json) =>
      Todaystafforder(
        orderId: json["OrderId"],
        bookingDate: json["BookingDate"],
        fullName: json["FullName"],
        phone: json["Phone"],
        orderNote: json["OrderNote"],
        orderStatus: json["OrderStatus"],
        staffId: json["StaffId"],
        staffName: json["StaffName"],
        packageName: json["PackageName"],
        startTime: json["StartTime"],
        endTime: json["EndTime"],
        amountPaid: json["AmountPaid"],
        extraPeopleCharge: json["ExtraPeopleCharge"],
        minimunDepositAmount: json["MinimunDepositAmount"],
        addedServices: json["AddedServices"],
        checkingStatus: json["CheckingStatus"],
        checkInTime: json["CheckInTime"],
        checkOutTime: json["CheckOutTime"],
        extrahouramount: json["Extrahouramount"],
        damageCharge: json["DamageCharge"],
        extraPeopleAmount: json["ExtraPeopleAmount"],
        totalAmount: json["TotalAmount"],
        rewards: json["Rewards"],
        couponDiscount: json["CouponDiscount"],
        additionalDiscount: json["AdditionalDiscount"],
        netTotalAmount: json["NetTotalAmount"],
        paidAmount: json["PaidAmount"],
        balanceAmount: json["BalanceAmount"],
      );

  Map<String, dynamic> toJson() => {
        "OrderId": orderId,
        "BookingDate": bookingDate,
        "FullName": fullName,
        "Phone": phone,
        "OrderNote": orderNote,
        "OrderStatus": orderStatus,
        "StaffId": staffId,
        "StaffName": staffName,
        "PackageName": packageName,
        "StartTime": startTime,
        "EndTime": endTime,
        "AmountPaid": amountPaid,
        "ExtraPeopleCharge": extraPeopleCharge,
        "MinimunDepositAmount": minimunDepositAmount,
        "AddedServices": addedServices,
        "CheckingStatus": checkingStatus,
        "CheckInTime": checkInTime,
        "CheckOutTime": checkOutTime,
        "Extrahouramount": extrahouramount,
        "DamageCharge": damageCharge,
        "ExtraPeopleAmount": extraPeopleAmount,
        "TotalAmount": totalAmount,
        "Rewards": rewards,
        "CouponDiscount": couponDiscount,
        "AdditionalDiscount": additionalDiscount,
        "NetTotalAmount": netTotalAmount,
        "PaidAmount": paidAmount,
        "BalanceAmount": balanceAmount,
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
