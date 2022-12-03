// To parse this JSON data, do
//
//     final mytask = mytaskFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

Mytask mytaskFromJson(String str) => Mytask.fromJson(json.decode(str));

String mytaskToJson(Mytask data) => json.encode(data.toJson());

class Mytask {
    Mytask({
        @required this.taskdetailslist,
        @required this.fcmresponse,
        @required this.response,
    });

    final List<Taskdetailslist> taskdetailslist;
    final dynamic fcmresponse;
    final Response response;

    factory Mytask.fromJson(Map<String, dynamic> json) => Mytask(
        taskdetailslist: List<Taskdetailslist>.from(json["taskdetailslist"].map((x) => Taskdetailslist.fromJson(x))),
        fcmresponse: json["fcmresponse"],
        response: Response.fromJson(json["response"]),
    );

    Map<String, dynamic> toJson() => {
        "taskdetailslist": List<dynamic>.from(taskdetailslist.map((x) => x.toJson())),
        "fcmresponse": fcmresponse,
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

class Taskdetailslist {
    Taskdetailslist({
        @required this.id,
        @required this.staffId,
        @required this.categoryId,
        @required this.assignStaffId,
        @required this.assignBy,
        @required this.taskId,
        @required this.categoryName,
        @required this.date,
        @required this.taskStatus,
        @required this.upcomingTaskStatusId,
        @required this.upcomingTaskStatusName,
        @required this.subject,
        @required this.description,
        @required this.imageLink,
        @required this.imageName,
        @required this.imageExtension,
    });

    final int id;
    final int staffId;
    final int categoryId;
    final int assignStaffId;
    final String assignBy;
    final String taskId;
    final String categoryName;
    final String date;
    final String taskStatus;
    final String upcomingTaskStatusId;
    final String upcomingTaskStatusName;
    final String subject;
    final String description;
    final String imageLink;
    final String imageName;
    final String imageExtension;

    factory Taskdetailslist.fromJson(Map<String, dynamic> json) => Taskdetailslist(
        id: json["Id"],
        staffId: json["StaffId"],
        categoryId: json["CategoryId"],
        assignStaffId: json["AssignStaffId"],
        assignBy: json["AssignBy"],
        taskId: json["TaskId"],
        categoryName: json["CategoryName"],
        date: json["Date"],
        taskStatus: json["TaskStatus"],
        upcomingTaskStatusId: json["UpcomingTaskStatusId"],
        upcomingTaskStatusName: json["UpcomingTaskStatusName"],
        subject: json["Subject"],
        description: json["Description"],
        imageLink: json["ImageLink"],
        imageName: json["ImageName"],
        imageExtension: json["ImageExtension"],
    );

    Map<String, dynamic> toJson() => {
        "Id": id,
        "StaffId": staffId,
        "CategoryId": categoryId,
        "AssignStaffId": assignStaffId,
        "AssignBy": assignBy,
        "TaskId": taskId,
        "CategoryName": categoryName,
        "Date": date,
        "TaskStatus": taskStatus,
        "UpcomingTaskStatusId": upcomingTaskStatusId,
        "UpcomingTaskStatusName": upcomingTaskStatusName,
        "Subject": subject,
        "Description": description,
        "ImageLink": imageLink,
        "ImageName": imageName,
        "ImageExtension": imageExtension,
    };
}
