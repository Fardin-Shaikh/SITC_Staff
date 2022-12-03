// To parse this JSON data, do
//
//     final categorydropdown = categorydropdownFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

Categorydropdown categorydropdownFromJson(String str) => Categorydropdown.fromJson(json.decode(str));

String categorydropdownToJson(Categorydropdown data) => json.encode(data.toJson());

class Categorydropdown {
    Categorydropdown({
        @required this.professionalcategorylist,
        @required this.response,
    });

    final List<Professionalcategorylist> professionalcategorylist;
    final Response response;

    factory Categorydropdown.fromJson(Map<String, dynamic> json) => Categorydropdown(
        professionalcategorylist: List<Professionalcategorylist>.from(json["professionalcategorylist"].map((x) => Professionalcategorylist.fromJson(x))),
        response: Response.fromJson(json["response"]),
    );

    Map<String, dynamic> toJson() => {
        "professionalcategorylist": List<dynamic>.from(professionalcategorylist.map((x) => x.toJson())),
        "response": response.toJson(),
    };
}

class Professionalcategorylist {
    Professionalcategorylist({
        @required this.profCatId,
        @required this.name,
        @required this.cateogryDescription,
        @required this.imageLink,
        @required this.filename,
        @required this.extension,
        @required this.slugName,
    });

    final int profCatId;
    final String name;
    final dynamic cateogryDescription;
    final dynamic imageLink;
    final dynamic filename;
    final dynamic extension;
    final dynamic slugName;

    factory Professionalcategorylist.fromJson(Map<String, dynamic> json) => Professionalcategorylist(
        profCatId: json["ProfCatId"],
        name: json["Name"],
        cateogryDescription: json["CateogryDescription"],
        imageLink: json["ImageLink"],
        filename: json["Filename"],
        extension: json["Extension"],
        slugName: json["SlugName"],
    );

    Map<String, dynamic> toJson() => {
        "ProfCatId": profCatId,
        "Name": name,
        "CateogryDescription": cateogryDescription,
        "ImageLink": imageLink,
        "Filename": filename,
        "Extension": extension,
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
