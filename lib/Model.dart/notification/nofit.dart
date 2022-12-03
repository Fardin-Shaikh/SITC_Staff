import 'package:meta/meta.dart';
import 'dart:convert';

NotifModel notifModelFromJson(String str) => NotifModel.fromJson(json.decode(str));

String notifModelToJson(NotifModel data) => json.encode(data.toJson());

class NotifModel {
    NotifModel({
        @required this.notificationlist,
        @required this.pageCount,
        @required this.response,
    });

    final List<Notificationlist> notificationlist;
    final String pageCount;
    final Response response;

    factory NotifModel.fromJson(Map<String, dynamic> json) => NotifModel(
        notificationlist: List<Notificationlist>.from(json["notificationlist"].map((x) => Notificationlist.fromJson(x))),
        pageCount: json["PageCount"],
        response: Response.fromJson(json["response"]),
    );

    Map<String, dynamic> toJson() => {
        "notificationlist": List<dynamic>.from(notificationlist.map((x) => x.toJson())),
        "PageCount": pageCount,
        "response": response.toJson(),
    };
}

class Notificationlist {
    Notificationlist({
        @required this.id,
        @required this.userId,
        @required this.userType,
        @required this.type,
        @required this.notificationType,
        @required this.notificationText,
        @required this.isRead,
        @required this.fullName,
        @required this.name,
        @required this.category,
        @required this.subject,
        @required this.imageLink,
        @required this.orderId,
    });

    final String id;
    final String userId;
    final String userType;
    final int type;
    final String notificationType;
    final String notificationText;
    final int isRead;
    final String fullName;
    final String name;
    final String category;
    final String subject;
    final String imageLink;
    final String orderId;

    factory Notificationlist.fromJson(Map<String, dynamic> json) => Notificationlist(
        id: json["Id"],
        userId: json["UserId"],
        userType: json["UserType"],
        type: json["Type"],
        notificationType: json["NotificationType"],
        notificationText: json["NotificationText"],
        isRead: json["IsRead"],
        fullName: json["FullName"],
        name: json["Name"],
        category: json["Category"],
        subject: json["Subject"],
        imageLink: json["ImageLink"],
        orderId: json["OrderId"],
    );

    Map<String, dynamic> toJson() => {
        "Id": id,
        "UserId": userId,
        "UserType": userType,
        "Type": type,
        "NotificationType": notificationType,
        "NotificationText": notificationText,
        "IsRead": isRead,
        "FullName": fullName,
        "Name": name,
        "Category": category,
        "Subject": subject,
        "ImageLink": imageLink,
        "OrderId": orderId,
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
