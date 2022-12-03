import 'dart:convert';
import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';

import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:upcomming/Model.dart/shoot/upcomming.dart';
import 'package:upcomming/color/colors.dart';
import 'package:upcomming/screens/home.dart';
import 'package:upcomming/screens/notifications.dart';
import 'package:upcomming/widgets/common.dart';
import 'package:responsive_flutter/responsive_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:upcomming/widgets/loader.dart';
import '../Model.dart/mini_model/small.dart';
import '../responce/all_fetch.dart';
import '../responce/internetcheck.dart';

class Shoots extends StatefulWidget {
  const Shoots();

  @override
  State<Shoots> createState() => SshootsState();
}

class SshootsState extends State<Shoots> {
  List<bool> click = [];
  int select;
  int inn = 1;
  int n = 1;
  List<bool> show_detail = [];
  UpcommingRecord upcomming_respo;
  UpcommingRecord shoot_respo;
  UpcommingRecord booking_respo;
  bool upcomming_bool = false;
  bool shoot_bool = false;
  bool booking_bool = false;
  double heightOfModalBottomSheet = 200;
  TextEditingController extra_people_cltr = TextEditingController();
  TextEditingController depost_amount_cltr = TextEditingController();
  int addedamount = 0;
  bool show_bottom_sheet = false;
  int ext_charge = 0;
  // PersistentBottomSheetController _controller;
  // final _scaffoldKey = GlobalKey<ScaffoldState>();
  SmallResponce cehckin_resp;
  bool hasinternet = false;
  List<List<int>> addonlist = [];
  String Dummy_string = '0';

  @override
  void initState() {
    super.initState();
    CK.inst.internet(context, (val) {
      if (val) {
        log('haseinternet');
        upcomming('StaffUpcoimgOrder');
        booking('StaffBookingOrderList');
        shoot('StaffTodayOrder');
      }
    });
  }

  Future<void> upcomming(String api_name) async {
    final prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');
    final String id = prefs.getString('id');
    final uri = Uri.http(
        Fetch.insta.URL1, Fetch.insta.URL2 + api_name, {'StaffId': id});
    final responce = await http.get(uri, headers: {
      'Apikey': Fetch.insta.Common_apikey,
      'authToken': token + '-' + id,
    });
    log(uri.toString());
    log(responce.body);
    if (responce.statusCode == 200) {
      setState(() {
        upcomming_respo = UpcommingRecord.fromJson(jsonDecode(responce.body));

        upcomming_respo == null
            ? upcomming_bool = false
            : upcomming_bool = true;
      });
    } else if (responce.statusCode == 401) {
      Fetch.insta.expire_dialog(context);
    } else if (responce.statusCode == 500) {
      main_toast('Server Not responding ');
    } else {
      main_toast('Something went Wrong');
    }
  }

  Future<void> shoot(String api_name) async {
    final prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');
    final String id = prefs.getString('id');

    final uri = Uri.http(
        Fetch.insta.URL1, Fetch.insta.URL2 + api_name, {'StaffId': id});
    final responce = await http.get(uri, headers: {
      'Apikey': Fetch.insta.Common_apikey,
      'authToken': token + '-' + id,
    });
    log(uri.toString());
    // log(responce.body);
    if (responce.statusCode == 200) {
      setState(() {
        shoot_respo = UpcommingRecord.fromJson(jsonDecode(responce.body));

        shoot_respo == null ? shoot_bool = false : shoot_bool = true;
      });
    } else if (responce.statusCode == 401) {
      Fetch.insta.expire_dialog(context);
    } else if (responce.statusCode == 500) {
      main_toast('Server Not responding ');
    } else {
      main_toast('Something went Wrong');
    }
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
    print('booking_responce');
    if (responce.statusCode == 200) {
      setState(() {
        booking_respo = UpcommingRecord.fromJson(jsonDecode(responce.body));
        booking_respo == null ? booking_bool = false : booking_bool = true;
      });
    } else if (responce.statusCode == 401) {
      Fetch.insta.expire_dialog(context);
    } else if (responce.statusCode == 500) {
      main_toast('Server Not responding ');
    } else {
      main_toast('Something went Wrong');
    }
  }

  Future<void> checkin(
      String api_name,
      String pk_orderid,
      String paid_amt,
      String depost_amt,
      String extpeoplecount,
      String extpeople_amt,
      String totle_amt) async {
    final prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');
    final String id = prefs.getString('id');
    final uri = Uri.http(Fetch.insta.URL1, Fetch.insta.URL2 + api_name);

    final responce = await http.post(uri, headers: {
      'Apikey': Fetch.insta.Common_apikey,
      'authToken': token + '-' + id,
    }, body: {
      "Pk_OrderId": pk_orderid,
      "AmountPaid": paid_amt,
      "AdditionalDepositAmount": depost_amt,
      "ExtraPeople": extpeoplecount,
      "ExtraPeopleAmount": extpeople_amt,
      "TotalAmount": totle_amt,
      "UserId": id
    });
    log(responce.body);
    if (responce.statusCode == 200) {
      cehckin_resp = SmallResponce.fromJson(jsonDecode(responce.body));
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
    return DefaultTabController(
      length: 3,
      initialIndex: 0,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Acolors.dark_bround),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            'Shoot',
            style: TextStyle(color: Acolors.dark_bround),
          ),
          backgroundColor: Acolors.orange,
          elevation: 1,
          bottom: TabBar(
            onTap: (value) {
              switch (value) {
                case 0:
                  shoot('StaffTodayOrder');

                  break;
                case 1:
                  booking('StaffBookingOrderList');
                  break;
                case 2:
                  upcomming('StaffUpcoimgOrder');
                  break;
                default:
                  print('go ');
              }
            },
            labelColor: Acolors.dark_bround,
            labelStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            indicatorColor: Acolors.dark_bround,
            unselectedLabelColor: Acolors.offwhite,
            unselectedLabelStyle:
                TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
            tabs: [
              Tab(
                text:
                    'Shoot(${shoot_bool ? shoot_respo.finalorderlist.length : Dummy_string})',
              ),
              Tab(
                text:
                    'Booking(${booking_bool ? booking_respo.finalorderlist.length : Dummy_string})',
              ),
              Tab(
                text:
                    'Upcoming(${upcomming_bool ? upcomming_respo.finalorderlist.length : Dummy_string})',
              ),
            ],
          ),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => Home()),
                      (route) => false);
                },
                icon: Icon(
                  Icons.home_outlined,
                  color: Acolors.dark_bround,
                  size: 25,
                )),
            IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Notif()));
                },
                icon: Icon(
                  Icons.notifications_none_sharp,
                  color: Acolors.dark_bround,
                  size: 25,
                )),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.02,
            ),
            Padding(
              padding: EdgeInsets.only(right: 20),
              child: CircleAvatar(
                radius: 17,
                backgroundImage: Fetch.insta.final_image_link == " "
                    ? const NetworkImage(
                        'https://cdn-icons-png.flaticon.com/128/1144/1144709.png')
                    : NetworkImage(Fetch.insta.final_image_link),
              ),
            )
          ],
        ),
        body: shoot_bool && booking_bool && upcomming_bool
            ? TabBarView(
                children: [
                  shoot_bool ? today_shoot(shoot_respo) : Loading_screen(),
                  booking_bool ? to_shoot(booking_respo) : Loading_screen(),
                  upcomming_bool ? to_shoot(upcomming_respo) : Loading_screen()
                ],
              )
            : Loading_screen(),
      ),
    );
  }

  Widget nolist_widget() {
    return Column(
      children: [
        Container(child: Image.asset('lib/assets/no_shoot.png')),
        Text(
          'No shoot Available',
          style: TextStyle(fontSize: 20),
        )
      ],
    );
  }

  Widget today_shoot(UpcommingRecord respo) {
    var data = respo.finalorderlist;
    if (data.length == 0) {
      return Container(
        child: Center(
          child: Text("No Shoots"),
        ),
      );
    }
    return Container(
      child: ListView.builder(
          itemCount: data.length,
          padding:
              const EdgeInsets.only(left: 9, right: 9, top: 10, bottom: 10),
          itemBuilder: (BuildContext ctxt, int index) {
            Size mq = MediaQuery.of(context).size;
            if (click.length < data.length) {
              click.add(false);
              show_detail.add(false);
            }

            print(data.length);

            switch (data[index].todaystafforder.checkingStatus) {
              case '1':
                return main_card(
                    respo,
                    index,
                    'Checked-In :${data[index].todaystafforder.checkInTime} ',
                    Colors.green,
                    false);
                break;
              case '2':
                return main_card(
                    respo,
                    index,
                    'Checked-Out : ${data[index].todaystafforder.checkInTime} - ${data[index].todaystafforder.checkOutTime}',
                    Colors.red,
                    false);
                break;
              default:
                return main_card(respo, index, '', Acolors.white, true);
            }
          }),
    );
  }

  List<int> convo(String row_text) {
    List<int> this_name = [];
    var remove = row_text;
    var semi_row = remove.replaceAll(RegExp(','), '');
    semi_row.runes.forEach((int rune) {
      var character = String.fromCharCode(rune);
      if (character != null) {
        this_name.add(double.parse(character).toInt());
      }
    });

    return this_name;
  }

  Widget main_card(UpcommingRecord respo, int index, String text, Color col,
      bool show_button) {
    var data = respo.finalorderlist;

    List<String> alfa = ['C', 'P', 'O', 'F'];

    return Padding(
      padding: const EdgeInsets.only(top: 2, bottom: 2),
      child: Card(
        elevation: 8,
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
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    alignment: Alignment.bottomLeft,
                    child: Container(
                        decoration: BoxDecoration(
                            color: col,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20.0),
                              bottomRight: Radius.circular(40.0),
                            )),
                        child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
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
                    padding: const EdgeInsets.only(left: 13, right: 13, top: 8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            res(context, data[index].todaystafforder.fullName,
                                2, FontWeight.bold, TextDirection.ltr),
                            Flexible(
                                child: Container(
                              // color: Colors.blue,
                              width: MediaQuery.of(context).size.width * 0.34,
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                  ]
                                  // List<Widget>.generate(
                                  //   alfa.length,
                                  //   (i) => crv(alfa[i], true),
                                  // )
                                  ),
                            ))
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
                                          columnWidths: const {
                                            0: FlexColumnWidth(3),
                                            1: FlexColumnWidth(4),
                                          },
                                          children: List.generate(
                                            data[index].cartList.length,
                                            (i2) => TableRow(children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 15),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
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
                                                padding: const EdgeInsets.only(
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
                                                                FontWeight.w300,
                                                                TextDirection
                                                                    .ltr),
                                                            res(
                                                                context,
                                                                double.parse(data[
                                                                            index]
                                                                        .cartList[
                                                                            i2]
                                                                        .orderItems[
                                                                            i3]
                                                                        .productSellingAmount
                                                                        .toString())
                                                                    .toInt()
                                                                    .toString(),
                                                                1.8,
                                                                FontWeight.w300,
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
                                              data[index]
                                                  .todaystafforder
                                                  .extrahouramount,
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
                                              data[index]
                                                  .todaystafforder
                                                  .couponDiscount,
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
                                              data[index]
                                                  .todaystafforder
                                                  .damageCharge,
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
                                              data[index]
                                                  .todaystafforder
                                                  .couponDiscount,
                                              1.8,
                                              FontWeight.w300,
                                              TextDirection.rtl),
                                        ]),
                                      ],
                                    )),
                                  ),
                                  Divider(
                                    color: Acolors.black,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 5),
                                    child: Container(

                                        // padding: EdgeInsets.all(20.0),
                                        child: Table(
                                      columnWidths: const {
                                        0: FlexColumnWidth(3),
                                        1: FlexColumnWidth(4),
                                      },
                                      children: [
                                        TableRow(children: [
                                          Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    const Icon(
                                                      Icons.phone,
                                                      size: 20,
                                                    ),
                                                    res(
                                                        context,
                                                        data[index]
                                                            .todaystafforder
                                                            .phone,
                                                        1.8,
                                                        FontWeight.normal,
                                                        TextDirection.ltr)
                                                  ],
                                                ),
                                                res(
                                                    context,
                                                    'Note: ${data[index].todaystafforder.orderNote}',
                                                    1.8,
                                                    FontWeight.normal,
                                                    TextDirection.ltr),
                                              ]),
                                          Table(
                                            // border: TableBorder.all(color: Acolors.orange,
                                            // width: 1
                                            // ),
                                            children: [
                                              TableRow(children: [
                                                res(
                                                    context,
                                                    'Total',
                                                    2,
                                                    FontWeight.normal,
                                                    TextDirection.ltr),
                                                res(
                                                    context,
                                                    double.parse(data[index]
                                                            .todaystafforder
                                                            .totalAmount)
                                                        .toInt()
                                                        .toString(),
                                                    2,
                                                    FontWeight.normal,
                                                    TextDirection.rtl)
                                              ]),
                                              TableRow(children: [
                                                res(
                                                    context,
                                                    'Rewards',
                                                    2,
                                                    FontWeight.normal,
                                                    TextDirection.ltr),
                                                res(
                                                    context,
                                                    double.parse(data[index]
                                                            .todaystafforder
                                                            .rewards)
                                                        .toInt()
                                                        .toString(),
                                                    2,
                                                    FontWeight.normal,
                                                    TextDirection.rtl)
                                              ]),
                                              TableRow(children: [
                                                res(
                                                    context,
                                                    'Paid',
                                                    2,
                                                    FontWeight.normal,
                                                    TextDirection.ltr),
                                                res(
                                                    context,
                                                    double.parse(data[index]
                                                            .todaystafforder
                                                            .paidAmount)
                                                        .toInt()
                                                        .toString(),
                                                    2,
                                                    FontWeight.normal,
                                                    TextDirection.rtl)
                                              ]),
                                              TableRow(children: [
                                                res(
                                                    context,
                                                    'Balance',
                                                    2,
                                                    FontWeight.normal,
                                                    TextDirection.ltr),
                                                res(
                                                    context,
                                                    double.parse(data[index]
                                                            .todaystafforder
                                                            .balanceAmount)
                                                        .toInt()
                                                        .toString(),
                                                    2,
                                                    FontWeight.normal,
                                                    TextDirection.rtl),
                                              ])
                                            ],
                                          )
                                        ])
                                      ],
                                    )),
                                  ),
                                  show_button
                                      ? Padding(
                                          padding:
                                              const EdgeInsets.only(top: 15),
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              maximumSize: const Size(400, 40),
                                              minimumSize: const Size(400, 40),
                                            ),
                                            child: const Text('Check-In'),
                                            onPressed: () {
                                              checkin_cal(data[index]);
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
                                  ? const Icon(
                                      Icons.keyboard_arrow_up_rounded,
                                      size: 18,
                                    )
                                  : const Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                      size: 18,
                                    ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  checkin_cal(Finalorderlist data) {
    var mq = MediaQuery.of(context).size;
    int paid = double.parse(data.todaystafforder.paidAmount).toInt();
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(10))),
        builder: (context) => StatefulBuilder(
              builder: (BuildContext context, StateSetter setstatemodel) {
                return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.7,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 13, vertical: 15),
                        child: Column(
                          // mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Deposit Collectio',
                              style: TextStyle(
                                  fontSize: ResponsiveFlutter.of(context)
                                      .fontSize(2.5),
                                  fontWeight: FontWeight.bold,
                                  color: Acolors.dark_bround),
                            ),
                            Divider(
                              thickness: 1.5,
                              color: Acolors.dark_bround,
                            ),
                            SizedBox(
                              height: mq.height * 0.03,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                res(context, 'Booking Amount ', 2.2,
                                    FontWeight.normal, TextDirection.ltr),
                                res(context, paid.toString(), 2.2,
                                    FontWeight.normal, TextDirection.rtl),
                              ],
                            ),
                            SizedBox(
                              height: mq.height * 0.03,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                res(context, 'Additional Deposit', 2.2,
                                    FontWeight.normal, TextDirection.ltr),
                                SizedBox(
                                  width: mq.width * 0.14,
                                  child: TextFormField(
                                      controller: depost_amount_cltr,
                                      keyboardType: TextInputType.number,
                                      autofocus: true,
                                      onChanged: (value) {
                                        setstatemodel(
                                          () {
                                            var add_extra = double.parse(
                                                    extra_people_cltr.text)
                                                .toInt();

                                            var add_dep = double.parse(
                                                    depost_amount_cltr.text)
                                                .toInt();
                                            addedamount = paid +
                                                (add_extra * 200) +
                                                add_dep;
                                          },
                                        );
                                      },
                                      decoration: InputDecoration(
                                          isDense: true,
                                          contentPadding: EdgeInsets.all(5),
                                          border: new OutlineInputBorder())),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: mq.height * 0.03,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                res(context, 'Number of People', 2.2,
                                    FontWeight.normal, TextDirection.ltr),
                                SizedBox(
                                  width: mq.width * 0.14,
                                  child: TextFormField(
                                      keyboardType: TextInputType.number,
                                      controller: extra_people_cltr,
                                      autofocus: true,
                                      onChanged: (value) {
                                        setstatemodel(
                                          () {
                                            var add_dep = double.parse(
                                                    depost_amount_cltr.text)
                                                .toInt();
                                            var add_extra = double.parse(
                                                    extra_people_cltr.text)
                                                .toInt();
                                            ext_charge = (add_extra * 200);
                                            addedamount =
                                                paid + ext_charge + add_dep;
                                          },
                                        );
                                      },
                                      decoration: const InputDecoration(
                                          isDense: true,
                                          contentPadding: EdgeInsets.all(5),
                                          border: OutlineInputBorder())),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: mq.height * 0.03,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                dec_text(
                                    context,
                                    'Total Amount',
                                    Acolors.dark_bround,
                                    FontWeight.normal,
                                    2.2),
                                dec_text(context, addedamount.toString(),
                                    Acolors.dark_bround, FontWeight.bold, 2.2)
                              ],
                            ),
                            SizedBox(
                              height: mq.height * 0.03,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                maximumSize: const Size(400, 40),
                                minimumSize: const Size(400, 40),
                              ),
                              child: Text('Check-In'),
                              onPressed: () {
                                setstatemodel(() {
                                  Utils(context).startLoading();
                                  checkin(
                                          'StaffBookingDepositCollected',
                                          data.todaystafforder.orderId
                                              .toString(),
                                          paid.toString(),
                                          depost_amount_cltr.text,
                                          extra_people_cltr.text,
                                          ext_charge.toString(),
                                          addedamount.toString())
                                      .whenComplete(() {
                                    if (cehckin_resp.n == 1) {
                                      Utils(context).stopLoading();
                                      main_toast(cehckin_resp.msg);
                                      CK.inst.onhit_internet(context, (value) {
                                        shoot('StaffTodayOrder');
                                      });

                                      Navigator.of(context).pop();
                                      Navigator.of(context).pop();
                                    } else {
                                      main_toast(cehckin_resp.msg);
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pop();
                                    }
                                  });
                                });
                              },
                            ),
                            // Container(
                            //   height: mq.height * 0.3,
                            // )
                          ],
                        ),
                      ),
                    ));
              },
            ));
  }

  Widget to_shoot(UpcommingRecord respo) {
    var data = respo.finalorderlist;
    if (data.length == 0) {
      return nolist_widget();
    }
    List<String> alfa = ['C', 'P', 'O', 'F'];
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
            return Padding(
              padding: const EdgeInsets.only(top: 2, bottom: 2),
              child: Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(9.0),
                  // side: BorderSide(color: Acolors.grey, width: 1)
                ),
                borderOnForeground: false,
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 10),
                  child: Column(
                    children: [
                      Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                res(
                                    context,
                                    data[index].todaystafforder.fullName,
                                    2,
                                    FontWeight.bold,
                                    TextDirection.ltr),
                                Flexible(
                                  child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.34,
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
                                          ])),
                                )
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                              columnWidths: const {
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
                                                          (i3) => TableRow(
                                                                  children: [
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
                                                                        double.parse(data[index].cartList[i2].orderItems[i3].productSellingAmount.toString())
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
                                                  data[index]
                                                      .todaystafforder
                                                      .extrahouramount,
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
                                                  data[index]
                                                      .todaystafforder
                                                      .couponDiscount,
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
                                                  data[index]
                                                      .todaystafforder
                                                      .damageCharge,
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
                                                  data[index]
                                                      .todaystafforder
                                                      .couponDiscount,
                                                  1.8,
                                                  FontWeight.w300,
                                                  TextDirection.rtl),
                                            ]),
                                          ],
                                        )),
                                      ),
                                      Divider(
                                        color: Acolors.black,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 5),
                                        child: Container(

                                            // padding: EdgeInsets.all(20.0),
                                            child: Table(
                                          columnWidths: {
                                            0: FlexColumnWidth(3),
                                            1: FlexColumnWidth(4),
                                          },
                                          children: [
                                            TableRow(children: [
                                              Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    res(
                                                        context,
                                                        'Mobile No: ${data[index].todaystafforder.phone}',
                                                        1.8,
                                                        FontWeight.normal,
                                                        TextDirection.ltr),
                                                    res(
                                                        context,
                                                        'Note: ${data[index].todaystafforder.orderNote}',
                                                        1.8,
                                                        FontWeight.normal,
                                                        TextDirection.ltr),
                                                  ]),
                                              Table(
                                                // border: TableBorder.all(color: Acolors.orange,
                                                // width: 1
                                                // ),
                                                children: [
                                                  TableRow(children: [
                                                    res(
                                                        context,
                                                        'Total',
                                                        2,
                                                        FontWeight.normal,
                                                        TextDirection.ltr),
                                                    res(
                                                        context,
                                                        double.parse(data[index]
                                                                .todaystafforder
                                                                .totalAmount)
                                                            .toInt()
                                                            .toString(),
                                                        2,
                                                        FontWeight.normal,
                                                        TextDirection.rtl)
                                                  ]),
                                                  TableRow(children: [
                                                    res(
                                                        context,
                                                        'Rewards',
                                                        2,
                                                        FontWeight.normal,
                                                        TextDirection.ltr),
                                                    res(
                                                        context,
                                                        double.parse(data[index]
                                                                .todaystafforder
                                                                .rewards)
                                                            .toInt()
                                                            .toString(),
                                                        2,
                                                        FontWeight.normal,
                                                        TextDirection.rtl)
                                                  ]),
                                                  TableRow(children: [
                                                    res(
                                                        context,
                                                        'Paid',
                                                        2,
                                                        FontWeight.normal,
                                                        TextDirection.ltr),
                                                    res(
                                                        context,
                                                        double.parse(data[index]
                                                                .todaystafforder
                                                                .paidAmount)
                                                            .toInt()
                                                            .toString(),
                                                        2,
                                                        FontWeight.normal,
                                                        TextDirection.rtl)
                                                  ]),
                                                  TableRow(children: [
                                                    res(
                                                        context,
                                                        'Balance',
                                                        2,
                                                        FontWeight.normal,
                                                        TextDirection.ltr),
                                                    res(
                                                        context,
                                                        double.parse(data[index]
                                                                .todaystafforder
                                                                .balanceAmount)
                                                            .toInt()
                                                            .toString(),
                                                        2,
                                                        FontWeight.normal,
                                                        TextDirection.rtl),
                                                  ])
                                                ],
                                              )
                                            ])
                                          ],
                                        )),
                                      )
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
                                decoration: BoxDecoration(
                                  color: Acolors.white,
                                  // border: Border(
                                  //   bottom: BorderSide(
                                  //       color: Colors.grey, width: 1),
                                  // )
                                ),
                                height:
                                    MediaQuery.of(context).size.height * 0.04,
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
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}
