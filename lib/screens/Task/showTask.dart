import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:upcomming/Model.dart/task/mytask.dart';
import 'package:upcomming/color/colors.dart';
import 'package:upcomming/hardcore_Data/data.dart';
import 'package:upcomming/responce/all_fetch.dart';
import 'package:upcomming/screens/outfit/editOutfit.dart';
import 'package:upcomming/screens/props/insideProp.dart';
import 'package:upcomming/widgets/common.dart';
import 'package:http/http.dart' as http;

import '../../Model.dart/mini_model/small.dart';

class showTask extends StatefulWidget {
  final Taskdetailslist data;
  const showTask({this.data});

  @override
  State<showTask> createState() => _showTaskState();
}

class _showTaskState extends State<showTask> {
  File _image;
  SmallResponce close_respoce;
  bool isimageselected = false;
  @override
  Widget build(BuildContext context) {
    Size mq = MediaQuery.of(context).size;
    return Scaffold(
      appBar: noTabAppBar(context, 'Close Task'),
      bottomSheet: showTaskbottomsheet(),
      body: Column(
        children: [
          Container(
            height: mq.height * 0.35,
            width: mq.width * 1,
            child: Image.network(
              widget.data.imageLink ?? '',
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }

  Widget showTaskbottomsheet() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      width: MediaQuery.of(context).size.width * 1,
      // color: Color.fromARGB(255, 211, 151, 195),
      child: Padding(
        padding: const EdgeInsets.only(left: 22, right: 22, top: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    stext("Name", Acolors.black, FontWeight.w200, 16),
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: stext(widget.data.assignBy ?? '',
                          Acolors.dark_bround, FontWeight.w300, 18),
                    ),
                  ],
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: stext("Subject", Acolors.black, FontWeight.w200, 16),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: stext(widget.data.subject ?? '', Acolors.dark_bround,
                  FontWeight.w300, 18),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: stext("Description", Acolors.black, FontWeight.w200, 16),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: stext(widget.data.description ?? ''.toString(),
                  Acolors.dark_bround, FontWeight.w300, 18),
            ),
            // Padding(
            //   padding: const EdgeInsets.only(top: 10 ),
            //   child: Container(
            //         height: MediaQuery.of(context).size.height*0.2,
            //         width: MediaQuery.of(context).size.width*0.3,
            //         child: Image.file(_image)),
            // ),
            Padding(
              padding: const EdgeInsets.only(top: 85),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(400, 50),
                    padding: EdgeInsets.symmetric(horizontal: 16),
                  ),
                  onPressed: () {
                    if (_image == null) {
                      imagepop(context, (val) {
                        setState(() {
                          _image = val;
                          isimageselected = true;
                        });
                      });
                    }
                    if (_image != null) {
                      log(_image.path);
                      closeTask(widget.data.id.toString()).whenComplete(() {
                        if (close_respoce.n == 1) {
                          main_toast(close_respoce.msg);
                          smallbottomsheet(context, close_respoce.msg, () {
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                          });
                        } else {
                          main_toast(close_respoce.msg);
                        }
                      });
                    }

                    // if (_image != null) {
                    //   print("object");
                    //   closeTask(widget.data.id.toString());
                    // }

                    //  log(widget.data.taskId);
                    //   log(widget.data.imageName);
                    //   smallbottomsheet(context, 'Task Closed Successfully', () {
                    //     Navigator.of(context).pop(); //to close the sheet
                    //     // Navigator.pop(context);
                    //     Navigator.pop(context);
                    //     // to navigate to the prevoiuse page
                    //   });
                  },
                  child: isimageselected
                      ? Text("Image selected Close Task")
                      : Text("Close Task")),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> closeTask(String task_id) async {
    final prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');
    final String id = prefs.getString('id');

    var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://' +
            Fetch.insta.URL1 +
            Fetch.insta.URL2 +
            'SatffCloseTask'));
    log(request.url.toString());

    request.headers['Apikey'] = Fetch.insta.Common_apikey;
    request.headers['authToken'] = token + '-' + id;
    request.fields['TaskId'] = task_id;
    request.fields['StaffId'] = id;

    (request.files.add(http.MultipartFile.fromBytes(
        'Image', File(_image.path).readAsBytesSync(),
        filename: _image.path)));
    log(id);
    log(task_id);
    var res = await request.send();
    var response = await http.Response.fromStream(res);
    log(response.body);
    if (response.statusCode == 200) {
      setState(() {
        close_respoce = SmallResponce.fromJson(jsonDecode(response.body));
      });
    } else if (response.statusCode == 401) {
      Fetch.insta.expire_dialog(context);
    } else if(response.statusCode == 500){
        main_toast('Server Not responding ');
       
    }else {
      main_toast('Something went Wrong');
    }
  }
}
