import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:responsive_flutter/responsive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:upcomming/screens/checkout/insidecheckout.dart';
import 'package:upcomming/widgets/common.dart';
import 'package:upcomming/widgets/loader.dart';

import '../../Model.dart/shoot/upcomming.dart';
import '../../color/colors.dart';
import '../../responce/all_fetch.dart';
import 'package:http/http.dart' as http;

import '../../responce/internetcheck.dart';

class CheckOut extends StatefulWidget {
  @override
  State<CheckOut> createState() => _CheckOutState();
}

class _CheckOutState extends State<CheckOut> {
  List<bool> click = [];
  List<bool> show_detail = [];
  int select;
  UpcommingRecord checkout_resp;
  bool checkout_bool = false;
  @override
  void initState() {
    super.initState();
    CK.inst.internet(context, (val) {
      if (val) {
        log('haseinternet');
        booking('StaffOrderCheckOutList');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: noTabAppBar(context, 'Check Out '),
      body: checkout_bool ? Listview_widget(checkout_resp) : Loading_screen(),
    );
  }

  Future<void> booking(String api_name) async {
    final prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');
    final String id = prefs.getString('id');
    final uri = Uri.http(
      Fetch.insta.URL1,
      Fetch.insta.URL2 + api_name,
    );
    final responce = await http.get(uri, headers: {
      'Apikey': Fetch.insta.Common_apikey,
      'authToken': token + '-' + id,
    });
    log(uri.toString());
    log(responce.body);
    print('check out respone ');
    print('booking_responce');
    if (responce.statusCode == 200) {
      setState(() {
        var fin = UpcommingRecord.fromJson(jsonDecode(responce.body));
        checkout_resp = fin;
        checkout_resp == null ? checkout_bool = false : checkout_bool = true;
      });
    } else if (responce.statusCode == 401) {
      Fetch.insta.expire_dialog(context);
    } else if (responce.statusCode == 500) {
      main_toast('Server Not responding ');
    } else {
      main_toast('Something went Wrong');
    }
  }

  Widget Listview_widget(UpcommingRecord respo) {
    var data = respo.finalorderlist;
    if (data.length == 0) {
      return Container(
        child: Center(
            child: dec_text(context, 'Not CheckOut list ', Acolors.dark_bround,
                FontWeight.bold, 2)),
      );
    }
    return Container(
      child: ListView.builder(
          itemCount: data.length,
          padding:
              const EdgeInsets.only(left: 9, right: 9, top: 10, bottom: 10),
          itemBuilder: (BuildContext ctxt, int index) {
            Size mq = MediaQuery.of(context).size;
            if (click.length < 30) {
              click.add(false);
              show_detail.add(false);
            }
            switch (data[index].todaystafforder.checkingStatus) {
              // case '1':
              //   return main_card(
              //       respo,
              //       index,
              //       ' ',
              //       // :${data[index].todaystafforder.checkInTime}
              //       Acolors.white,
              //       true);
              //   break;
              case '2':
                return main_card(
                    respo,
                    index,
                    'Checked-Out : ${data[index].todaystafforder.checkInTime} - ${data[index].todaystafforder.checkOutTime}',
                    Colors.red,
                    false);
                break;
              default:
                return main_card(respo, index, ' ', Acolors.white, true);
            }
          }),
    );
  }

  Widget main_card(
    UpcommingRecord respo,
    int index,
    String text,
    Color col,
    bool show_button,
  ) {
    var data = respo.finalorderlist;
    var pass_data = respo.finalorderlist[index];
    List<String> alfa = ['C', 'P', 'O', 'F'];
    return Padding(
      padding: const EdgeInsets.only(top: 2, bottom: 2),
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(
          // side: BorderSide(
          //   width: 1.2,
          //   color: col, //<-- SEE HERE
          // ),
          borderRadius: BorderRadius.circular(9),
        ),
        borderOnForeground: false,
        child: Padding(
          // padding: const EdgeInsets.only(left: 16, right: 16, top: 10),
          padding: const EdgeInsets.only(left: 0, right: 0, top: 0),
          child: Column(
            children: [
              Container(
                // color: Colors.red[200],
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      alignment: Alignment.bottomLeft,
                      child: Container(
                          decoration: BoxDecoration(
                              color: col,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20.0),
                                bottomRight: Radius.circular(40.0),
                              )),
                          child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                text,
                                style: TextStyle(
                                    fontSize: ResponsiveFlutter.of(context)
                                        .fontSize(2.3),
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white),
                              ))),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 13, right: 13, top: 8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              res(context, data[index].todaystafforder.fullName,
                                  2, FontWeight.bold, TextDirection.ltr),
                              Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.4,
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        crv(
                                            alfa[0],
                                            data[index]
                                                .todaystafforder
                                                .addedServices
                                                .contains('2')),
                                        crv(
                                            alfa[1],
                                            data[index]
                                                .todaystafforder
                                                .addedServices
                                                .contains('3')),
                                        crv(
                                            alfa[2],
                                            data[index]
                                                .todaystafforder
                                                .addedServices
                                                .contains('4')),
                                        crv(
                                            alfa[3],
                                            data[index]
                                                .todaystafforder
                                                .addedServices
                                                .contains('5')),
                                      ]))
                            ],
                          ),
                          Row(
                            children: [
                              res(
                                  context,
                                  data[index].todaystafforder.packageName,
                                  2,
                                  FontWeight.w400,
                                  TextDirection.ltr)
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                res(
                                    context,
                                    data[index].todaystafforder.bookingDate,
                                    1.7,
                                    FontWeight.w400,
                                    TextDirection.ltr),
                                res(
                                    context,
                                    '${data[index].todaystafforder.startTime} - ${data[index].todaystafforder.endTime}',
                                    1.7,
                                    FontWeight.w400,
                                    TextDirection.ltr),
                              ],
                            ),
                          ),
                          Visibility(
                              visible: select == index,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: Column(
                                  children: [
                                    Container(
                                        color: Colors.white,
                                        // padding: EdgeInsets.all(20.0),
                                        child: Table(
                                            columnWidths: {
                                              0: FlexColumnWidth(3),
                                              1: FlexColumnWidth(4),
                                            },
                                            children: List.generate(
                                              data[index].cartList.length,
                                              (i2) => TableRow(children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 15),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      res(
                                                          context,
                                                          data[index]
                                                              .cartList[i2]
                                                              .typeName,
                                                          1.8,
                                                          FontWeight.bold,
                                                          TextDirection.ltr)
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 15),
                                                  child: Table(
                                                    children: List.generate(
                                                        data[index]
                                                            .cartList[i2]
                                                            .orderItems
                                                            .length,
                                                        (i3) =>
                                                            TableRow(children: [
                                                              res(
                                                                  context,
                                                                  data[index]
                                                                      .cartList[
                                                                          i2]
                                                                      .orderItems[
                                                                          i3]
                                                                      .productName,
                                                                  1.8,
                                                                  FontWeight
                                                                      .w300,
                                                                  TextDirection
                                                                      .ltr),
                                                              res(
                                                                  context,
                                                                  double.parse(data[index]
                                                                          .cartList[
                                                                              i2]
                                                                          .orderItems[
                                                                              i3]
                                                                          .productSellingAmount)
                                                                      .toInt()
                                                                      .toString(),
                                                                  1.8,
                                                                  FontWeight
                                                                      .w300,
                                                                  TextDirection
                                                                      .rtl),
                                                            ])),
                                                  ),
                                                ),
                                              ]),
                                            ))),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 15),
                                      child: Container(
                                          child: Table(
                                        // border: TableBorder.all(),
                                        children: [
                                          TableRow(children: [
                                            res(
                                                context,
                                                'Extra Hour Charges',
                                                1.8,
                                                FontWeight.bold,
                                                TextDirection.ltr),
                                            res(
                                                context,
                                                double.parse(data[index]
                                                        .todaystafforder
                                                        .extrahouramount)
                                                    .toInt()
                                                    .toString(),
                                                1.8,
                                                FontWeight.w300,
                                                TextDirection.rtl),
                                          ]),
                                          TableRow(children: [
                                            res(
                                                context,
                                                'Damage Charges',
                                                1.8,
                                                FontWeight.bold,
                                                TextDirection.ltr),
                                            res(
                                                context,
                                                double.parse(data[index]
                                                        .todaystafforder
                                                        .damageCharge)
                                                    .toInt()
                                                    .toString(),
                                                1.8,
                                                FontWeight.w300,
                                                TextDirection.rtl),
                                          ]),
                                        ],
                                      )),
                                    ),
                                    Divider(
                                      color: Colors.black,
                                      thickness: 0.3,
                                      // height: 2,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 10, bottom: 10),
                                      child: Container(
                                          child: Table(
                                        // border: TableBorder.all(),
                                        children: [
                                          TableRow(children: [
                                            res(
                                                context,
                                                'Grand Total',
                                                1.8,
                                                FontWeight.bold,
                                                TextDirection.ltr),
                                            res(
                                                context,
                                                double.parse(data[index]
                                                        .todaystafforder
                                                        .totalAmount)
                                                    .toInt()
                                                    .toString(),
                                                1.8,
                                                FontWeight.w300,
                                                TextDirection.rtl),
                                          ]),
                                          TableRow(children: [
                                            res(
                                                context,
                                                'Discount',
                                                1.8,
                                                FontWeight.bold,
                                                TextDirection.ltr),
                                            res(
                                                context,
                                                double.parse(data[index]
                                                        .todaystafforder
                                                        .additionalDiscount)
                                                    .toInt()
                                                    .toString(),
                                                1.8,
                                                FontWeight.w300,
                                                TextDirection.rtl),
                                          ]),
                                          TableRow(children: [
                                            res(
                                                context,
                                                'Reward Points',
                                                1.8,
                                                FontWeight.bold,
                                                TextDirection.ltr),
                                            res(
                                                context,
                                                double.parse(data[index]
                                                        .todaystafforder
                                                        .rewards)
                                                    .toInt()
                                                    .toString(),
                                                1.8,
                                                FontWeight.w300,
                                                TextDirection.rtl),
                                          ]),
                                          TableRow(children: [
                                            res(
                                                context,
                                                'Coupon Discount',
                                                1.8,
                                                FontWeight.bold,
                                                TextDirection.ltr),
                                            res(
                                                context,
                                                double.parse(data[index]
                                                        .todaystafforder
                                                        .couponDiscount)
                                                    .toInt()
                                                    .toString(),
                                                1.8,
                                                FontWeight.w300,
                                                TextDirection.rtl),
                                          ]),
                                        ],
                                      )),
                                    ),
                                    Divider(
                                      color: Colors.black,
                                      thickness: 0.3,
                                      // height: 2,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 15),
                                      child: Container(
                                          child: Table(
                                              // border: TableBorder.all(),
                                              children: [
                                            TableRow(children: [
                                              res(
                                                  context,
                                                  'Net Total',
                                                  2,
                                                  FontWeight.normal,
                                                  TextDirection.ltr),
                                              numtxt(
                                                  context,
                                                  double.parse(data[index]
                                                          .todaystafforder
                                                          .netTotalAmount)
                                                      .toInt()
                                                      .toString(),
                                                  2)
                                            ]),
                                            TableRow(children: [
                                              res(
                                                  context,
                                                  'Advance',
                                                  2,
                                                  FontWeight.normal,
                                                  TextDirection.ltr),
                                              numtxt(
                                                  context,
                                                  double.parse(data[index]
                                                          .todaystafforder
                                                          .paidAmount)
                                                      .toInt()
                                                      .toString(),
                                                  2)
                                            ]),
                                            TableRow(children: [
                                              res(
                                                  context,
                                                  'Balance/Refund',
                                                  2,
                                                  FontWeight.normal,
                                                  TextDirection.ltr),
                                              numtxt(
                                                  context,
                                                  double.parse(data[index]
                                                          .todaystafforder
                                                          .balanceAmount)
                                                      .toInt()
                                                      .toString(),
                                                  2)
                                            ]),
                                          ])),
                                    ),
                                    show_button
                                        ? Padding(
                                            padding:
                                                const EdgeInsets.only(top: 15),
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                maximumSize:
                                                    const Size(400, 40),
                                                minimumSize:
                                                    const Size(400, 40),
                                              ),
                                              child: Text('Check Out'),
                                              onPressed: () {
                                                Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                show_checkout(
                                                                    data:
                                                                        pass_data)))
                                                    .then((value) {
                                                  CK.inst.onhit_internet(
                                                      context, (value) {
                                                    Utils(context)
                                                        .startLoading();
                                                    booking('StaffOrderCheckOutList')
                                                        .whenComplete(() {
                                                      Utils(context)
                                                          .stopLoading();
                                                    });
                                                  });
                                                });
                                              },
                                            ),
                                          )
                                        : Container()
                                  ],
                                ),
                              )),
                          InkWell(
                            onTap: () {
                              setState(() {
                                if (show_detail[index] == false) {
                                  select = index;
                                  show_detail[index] = true;
                                  log(show_detail.toString());
                                } else {
                                  select = -1;
                                  show_detail[index] = false;
                                  log(show_detail.toString());
                                }
                              });
                            },
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.04,
                              child: Center(
                                child: select == index
                                    ? Icon(
                                        Icons.keyboard_arrow_up_rounded,
                                        size: 18,
                                      )
                                    : Icon(
                                        Icons.keyboard_arrow_down_rounded,
                                        size: 18,
                                      ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                    //here
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
