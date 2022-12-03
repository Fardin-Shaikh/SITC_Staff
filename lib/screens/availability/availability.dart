import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:upcomming/available/cottage.dart';
import 'package:upcomming/available/fnb.dart';
import 'package:upcomming/available/reportlist.dart';
import 'package:upcomming/color/colors.dart';
import 'package:upcomming/responce/all_fetch.dart';
import 'package:upcomming/widgets/common.dart';
import 'package:http/http.dart' as http;

import '../../responce/internetcheck.dart';

class Avail extends StatefulWidget {
  const Avail();

  @override
  State<Avail> createState() => _AvailState();
}

class _AvailState extends State<Avail> {
  String dropdownvalue;
  Report reportList_repo;
  Cottagereport cottage_repo;
  Food fnd_repon;
  bool cottage_hasdate = false;
  bool fnb_hasdate = false;
  bool report_hasdata = false;
  List<String> report_list;

  @override
  void initState() {
    super.initState();

    CK.inst.internet(context, (val) {
      if (val) {
        log('haseinternet');
        reports('ReportDropDownList').whenComplete(() {
          if (reportList_repo.response.n == 1) {
            report_list =
                List.generate(reportList_repo.reportlist.length, (index) {
              reportList_repo.reportlist[index].reportName;
              log(report_list.length.toString());
            });
          }
        });
        cottage('CottagesReport', '14/11/2022', '14/11/2023');
        fnb(
          'FoodAndBeverageReport',
        );
      }
    });
  }

  Future<void> cottage(String api_name, startdate, enddate) async {
    final prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');
    final String id = prefs.getString('id');

    final uri = Uri.http(Fetch.insta.URL1, Fetch.insta.URL2 + api_name, {
      'FromDate': startdate,
      'EndDate': enddate,
    });
    final responce = await http.get(uri, headers: {
      'Apikey': Fetch.insta.Common_apikey,
      'authToken': token + '-' + id,
    });
    // log(uri.toString());

    if (responce.statusCode == 200) {
      setState(() {
        var fin = Cottagereport.fromJson(jsonDecode(responce.body));
        cottage_repo = fin;
        cottage_repo == null ? cottage_hasdate = false : cottage_hasdate = true;
      });
    } else if (responce.statusCode == 401) {
      Fetch.insta.expire_dialog(context);
    } else if (responce.statusCode == 500) {
      main_toast('Server Not responding ');
    } else {
      main_toast('Something went Wrong');
    }
  }

  Future<void> fnb(
    String api_name,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');
    final String id = prefs.getString('id');
    final String today =
        '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}';
    final uri = Uri.http(Fetch.insta.URL1, Fetch.insta.URL2 + api_name, {
      'FromDate': today,
      'EndDate': today,
    });
    final responce = await http.get(uri, headers: {
      'Apikey': Fetch.insta.Common_apikey,
      'authToken': token + '-' + id,
    });
    // log(uri.toString());
    // log(responce.body);
    if (responce.statusCode == 200) {
      setState(() {
        var fin = Food.fromJson(jsonDecode(responce.body));
        fnd_repon = fin;
        fnd_repon == null ? fnb_hasdate = false : fnb_hasdate = true;
      });
    } else if (responce.statusCode == 401) {
      Fetch.insta.expire_dialog(context);
    } else if (responce.statusCode == 500) {
      main_toast('Server Not responding ');
    } else {
      main_toast('Something went Wrong');
    }
  }

  Future<void> reports(String api_name) async {
    final prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');
    final String id = prefs.getString('id');

    final uri =
        Uri.http(Fetch.insta.URL1, Fetch.insta.URL2 + api_name, {'UserId': id});
    final responce = await http.get(uri, headers: {
      'Apikey': Fetch.insta.Common_apikey,
      'authToken': token + '-' + id,
    });
    log(uri.toString());
    log(responce.body);
    if (responce.statusCode == 200) {
      setState(() {
        var fin = Report.fromJson(jsonDecode(responce.body));
        reportList_repo = fin;
        reportList_repo == null
            ? report_hasdata = false
            : report_hasdata = true;
      });
    } else if (responce.statusCode == 401) {
      Fetch.insta.expire_dialog(context);
    } else if (responce.statusCode == 500) {
      main_toast('Server Not responding ');
    } else {
      main_toast('Something went Wrong');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: noTabAppBar(context, 'Availability'),
      body: cottage_hasdate && fnb_hasdate && report_hasdata
          ? Padding(
              padding: const EdgeInsets.all(13.0),
              child: ListView(
                // mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  DropdownButtonFormField<String>(
                    validator: (value) =>
                        value == null ? 'field required' : null,
                    value: dropdownvalue,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: ['Cottage', 'Food and Beverage'].map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),
                    isExpanded: true,
                    isDense: true,
                    hint: Text("Select",
                        style: TextStyle(color: Acolors.black, fontSize: 15)),
                    onChanged: (String newValue) {
                      setState(() {
                        dropdownvalue = newValue;
                      });
                    },
                  ),
                  Visibility(
                      visible: dropdownvalue == 'Cottage' ||
                          dropdownvalue == 'Food and Beverage',
                      child: dropdownvalue == 'Cottage'
                          ? Cottage()
                          : food_beverage())
                ],
              ),
            )
          : Loading_screen(),
    );
  }

  Widget Cottage() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 15),
          child: Container(
            width: MediaQuery.of(context).size.width * 1,
            child: Text(
              'Cottage Report  :',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            top: 30,
          ),
          child: DataTable(
              // decoration: Decoration(),
              border: TableBorder.all(color: Acolors.black, width: 1.5),
              dataRowHeight: 70,
              columnSpacing: 30,
              columns: [
                DataColumn(
                    // numeric: true,
                    label: res(context, 'Date', 2.3, FontWeight.bold,
                        TextDirection.ltr)),
                DataColumn(
                    label: res(context, 'Day', 2.3, FontWeight.bold,
                        TextDirection.ltr)),
                DataColumn(
                    numeric: true,
                    label: res(context, 'LR', 2.3, FontWeight.bold,
                        TextDirection.rtl)),
                DataColumn(
                    numeric: true,
                    label: res(context, 'GR', 2.3, FontWeight.bold,
                        TextDirection.rtl)),
              ],
              rows: List.generate(
                  cottage_repo.cottagesreportlist.length,
                  (i1) => DataRow(
                          onLongPress: () {
                            showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) => AlertDialog(
                                      title: res(context, 'Details', 2.5,
                                          FontWeight.bold, TextDirection.ltr),
                                      content: Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.25,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            dialog_roe(
                                                "Date",
                                                cottage_repo
                                                    .cottagesreportlist[i1]
                                                    .dates),
                                            dialog_roe(
                                                "Day",
                                                cottage_repo
                                                    .cottagesreportlist[i1]
                                                    .dayName),
                                            dialog_roe(
                                              "LR",
                                              cottage_repo
                                                  .cottagesreportlist[i1]
                                                  .totalGreenRoomStay
                                                  .toString(),
                                            ),
                                            dialog_roe(
                                              "GR",
                                              cottage_repo
                                                  .cottagesreportlist[i1]
                                                  .totalGreenRoomStay
                                                  .toString(),
                                            ),
                                          ],
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: res(
                                                context,
                                                'Ok',
                                                2,
                                                FontWeight.bold,
                                                TextDirection.ltr)),
                                      ],
                                    ));
                          },
                          cells: [
                            DataCell(res(
                                context,
                                cottage_repo.cottagesreportlist[i1].dates,
                                2,
                                FontWeight.normal,
                                TextDirection.ltr)),
                            DataCell(res(
                                context,
                                cottage_repo.cottagesreportlist[i1].dayName
                                    .toString(),
                                2,
                                FontWeight.normal,
                                TextDirection.ltr)),
                            DataCell(res(
                                context,
                                cottage_repo
                                    .cottagesreportlist[i1].totalLuxuryStay
                                    .toString(),
                                2,
                                FontWeight.normal,
                                TextDirection.ltr)),
                            DataCell(res(
                                context,
                                cottage_repo
                                    .cottagesreportlist[i1].totalGreenRoomStay
                                    .toString(),
                                2,
                                FontWeight.normal,
                                TextDirection.ltr))
                          ]))),
        )
      ],
    );
  }

  Widget dialog_roe(String title, String content) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          res(context, title, 2.2, FontWeight.bold, TextDirection.ltr),
          res(context, content, 2.5, FontWeight.bold, TextDirection.ltr)
        ],
      ),
    );
  }

  Widget food_beverage() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 15),
          child: Container(
            // color: Colors.amber,
            width: MediaQuery.of(context).size.width * 1,
            child: Text(
              'Food and Beverage Report:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 30),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
                // decoration: Decoration(),
                border: TableBorder.all(color: Acolors.black, width: 1.5),
                dataRowHeight: 60,
                columnSpacing: 20,
                columns: List.generate(
                    fnd_repon.headtitle.length,
                    (index) => DataColumn(
                        // numeric: true,
                        label: res(context, fnd_repon.headtitle[index].title,
                            2.3, FontWeight.bold, TextDirection.ltr))),
                rows: [
                  DataRow(
                      cells: List.generate(
                          fnd_repon.headtitle.length,
                          (index) => DataCell(res(context, 'No record', 2,
                              FontWeight.normal, TextDirection.ltr))))
                ]),
          ),
        )
      ],
    );
  }
}
