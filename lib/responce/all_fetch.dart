import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:upcomming/Model.dart/LogOut.dart';
import 'package:upcomming/Model.dart/Logindetails.dart';
import 'package:upcomming/Model.dart/mini_model/cat_list.dart';
import 'package:upcomming/Model.dart/otpGenModel.dart';
import 'package:http/http.dart' as http;
import 'package:upcomming/Model.dart/outfit/filtered_output.dart';
import 'package:upcomming/Model.dart/outfit/gender.dart';
import 'package:upcomming/Model.dart/outfit/outfit_category.dart';
import 'package:upcomming/Model.dart/profile/staffdetail.dart';

import 'package:upcomming/screens/signin.dart';
import 'package:upcomming/widgets/common.dart';

class Fetch {
  static final Fetch insta = Fetch._init();
  Fetch._init();
  Staffdetail user;

  final String Common_apikey =
      '7Q8RATBUCWEXFYG2J3K4N6P7Q9SATBVDWEXGZH2J4M5N6Q8R9SBUCVDWFY';
  final String URL1 = 'setscityapi.onerooftechnologies.com';
  final String URL2 = '/Staff/api/v1/';
  String final_image_link = " ";

  Future<OtpGenrate> otpgen(String number) async {
    final uri = Uri.http(
        URL1, URL2 + 'StaffCheckMobileAndSendOtp', {'MobileNo': number});

    final responce = await http.get(uri, headers: {'Apikey': Common_apikey});
    log(responce.body);
    if (responce.statusCode == 200) {
      return OtpGenrate.fromJson(jsonDecode(responce.body));
    } else {
      main_toast('Server Not responding ');
    }
  }

  Future<LoginDetails> getLoginDetails(
    String number,
    otp,
  ) async {
    final uri = Uri.http(URL1, URL2 + 'StaffVerifyOtpAndLogin',
        {'MobileNo': number, 'otp': otp, 'FcmId': ''});

    final responce = await http.get(uri, headers: {'Apikey': Common_apikey});

    if (responce.statusCode == 200) {
      return LoginDetails.fromJson(jsonDecode(responce.body));
    } else if (responce.statusCode == 500) {
      main_toast('Server Not responding ');
    } else {
      main_toast('Something went Wrong');
    }
  }

  Future<void> LogOut(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');
    final String id = prefs.getString('id');
    final uri = Uri.http(URL1, URL2 + 'StaffLogout', {'StaffId': id});

    final responce = await http.get(uri, headers: {
      'Apikey': Common_apikey,
      'authToken': token + '-' + id,
    });

    if (responce.statusCode == 200) {
      var fin = LogOutModel.fromJson(jsonDecode(responce.body));
      if (fin.response.n == 1) {
        main_toast(fin.response.msg);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => SignIn()),
            (route) => false);
        final prefs = await SharedPreferences.getInstance();
        prefs.clear();
        Fetch.insta.final_image_link = null;
      } else {
        main_toast(fin.response.msg);
      }
    } else if (responce.statusCode == 401) {
      Fetch.insta.expire_dialog(context);
    } else if (responce.statusCode == 500) {
      main_toast('Server Not responding ');
    } else {
      main_toast('Something went Wrong');
    }
  }

  Future<Staffdetail> staff_detail(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');
    final String id = prefs.getString('id');

    final uri = Uri.http(URL1, URL2 + 'GetStaffDetails', {'StaffId': id});
    final responce = await http.get(uri, headers: {
      'Apikey': Common_apikey,
      'authToken': token + '-' + id,
    });
    log(responce.body);
    if (responce.statusCode == 200) {
      var fin = Staffdetail.fromJson(jsonDecode(responce.body));
      user = fin;
      return fin;
    } else if (responce.statusCode == 401) {
      Fetch.insta.expire_dialog(context);
    } else if (responce.statusCode == 500) {
      main_toast('Server Not responding ');
    } else {
      main_toast('Something went Wrong');
    }
  }

  Future<Staffdetail> Updatedstaff_detail(String name, email, mob_no, emg_name,
      emg_no, File sel_img, int req_img, BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');
    final String id = prefs.getString('id');
    var request = http.MultipartRequest(
        'POST', Uri.parse('http://' + URL1 + URL2 + 'UpdateStaffDetails'));
    log(request.url.toString());
    request.headers['Apikey'] = Common_apikey;
    request.headers['authToken'] = token + '-' + id;
    request.fields['ID'] = id;
    request.fields['Name'] = name;
    request.fields['EmailId'] = email;
    request.fields['MobileNo'] = mob_no;
    request.fields['StaffEmergencyContactName'] = emg_name;
    request.fields['StaffEmergencyContactNo'] = emg_no;
    req_img == 1
        ? (request.files.add(http.MultipartFile.fromBytes(
            'ProfileImage', File(sel_img.path).readAsBytesSync(),
            filename: sel_img.path)))
        : null;
    var res =
        await request.send(); //rest is stream responce converto  responce type
    var response = await http.Response.fromStream(res);
    if (response.statusCode == 200) {
      var fin = Staffdetail.fromJson(jsonDecode(response.body));
      user = fin;
      return fin;
    } else if (response.statusCode == 401) {
      Fetch.insta.expire_dialog(context);
    } else if (response.statusCode == 500) {
      main_toast('Server Not responding ');
    } else {
      main_toast('Something went Wrong');
    }
  }

  expire_dialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
              title: res(context, 'Sets in the City', 2.3, FontWeight.bold,
                  TextDirection.ltr),
              content: res(context, 'Session expired. Please Login Again', 2,
                  FontWeight.normal, TextDirection.ltr),
              actions: [
                TextButton(
                    onPressed: () {
                      under_clear(context);
                    },
                    child: res(
                        context, 'Ok', 2, FontWeight.bold, TextDirection.ltr)),
              ],
            ));
  }

  go_exit_dialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
              title: res(context, 'Sets in the City', 2.3, FontWeight.bold,
                  TextDirection.ltr),
              content: res(context, 'Are you sure you want to exit ', 2,
                  FontWeight.normal, TextDirection.ltr),
              actions: [
                TextButton(
                    onPressed: () {
                      SystemNavigator.pop();
                    },
                    child: res(
                        context, 'Yes', 2, FontWeight.bold, TextDirection.ltr)),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: res(
                        context, 'No', 2, FontWeight.bold, TextDirection.ltr)),
              ],
            ));
  }

  Future<void> under_clear(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => SignIn()), (route) => false);
  }
}
