import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:responsive_flutter/responsive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:upcomming/responce/all_fetch.dart';
import 'package:upcomming/screens/checkout/checkout.dart';
import 'package:upcomming/widgets/common.dart';

import '../../Model.dart/mini_model/small.dart';
import '../../Model.dart/shoot/upcomming.dart';
import '../../color/colors.dart';
import 'package:http/http.dart' as http;

class show_checkout extends StatefulWidget {
  final Finalorderlist data;
  const show_checkout({this.data});

  @override
  State<show_checkout> createState() => _show_checkoutState();
}

class _show_checkoutState extends State<show_checkout> {
  SmallResponce check_rep;
  bool check_bool = false;

  Future<void> CheckOut(
    String api_name,
    String pkorderid,
    String total_amt,
    String reward_amt,
    String discount_amt,
    String grandtotal,
    String adv_paid,
    String bal_amt,
    String refund_amt,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');
    final String id = prefs.getString('id');
    final uri = Uri.http(Fetch.insta.URL1, Fetch.insta.URL2 + api_name);

    final responce = await http.post(uri, headers: {
      'Apikey': Fetch.insta.Common_apikey,
      'authToken': token + '-' + id,
    }, body: {
      "Pk_OrderId": pkorderid,
      "TotalAmount": total_amt,
      "RewardAmount": reward_amt,
      "DiscountAmount": discount_amt,
      "GrantTotal": grandtotal,
      "AmountPaid": adv_paid,
      "BalanceAmount": bal_amt,
      "RefundAmount": refund_amt,
      "UserId": id
    });
    log(responce.body);
    if (responce.statusCode == 200) {
      setState(() {
        var boo = SmallResponce.fromJson(jsonDecode(responce.body));
        check_rep = boo;
        check_rep == null ? check_bool = true : check_bool = false;
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
    var mq = MediaQuery.of(context).size;
    var data = widget.data;
    return Scaffold(
        appBar: noTabAppBar(context, 'Checkout'),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: ListView(
            children: [
              ListView.builder(
                primary: false,
                shrinkWrap: true,
                itemCount: data.cartList.length,
                itemBuilder: (BuildContext ctxt, int index) => Card(
                  elevation: 2,
                  child: DataTable(
                      dataRowHeight: 30,
                      headingRowHeight: 30,
                      headingRowColor: MaterialStateColor.resolveWith(
                          (states) => Colors.orange[100]),
                      columnSpacing: 20,
                      columns: [
                        DataColumn(
                          label: Text(data.cartList[index].typeName,
                              style: TextStyle(
                                  fontSize: ResponsiveFlutter.of(context)
                                      .fontSize(2.5),
                                  fontWeight: FontWeight.bold)),
                        ),
                        DataColumn(
                            numeric: true,
                            label: Container(
                              child: Text(
                                  double.parse(data.todaystafforder.amountPaid).toInt()
                                      .toString(),
                                  style: TextStyle(
                                      fontSize: ResponsiveFlutter.of(context)
                                          .fontSize(2.5),
                                      fontWeight: FontWeight.bold)),
                            )),
                      ],
                      rows: List.generate(
                        data.cartList[index].orderItems.length,
                        (i) => DataRow(cells: [
                          DataCell(Text(
                              data.cartList[index].orderItems[i].productName)),
                          DataCell(Text(double.parse(data.cartList[index]
                                  .orderItems[i].productSellingAmount).toInt()
                              .toString())),
                        ]),
                      )),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 5, vertical: 20),
                child: Column(
                  children: [
                    Container(
                        child: Table(
                      children: [
                        TableRow(children: [
                          res(context, 'Grand Total', 2.5, FontWeight.bold,
                              TextDirection.ltr),
                          res(
                              context,
                              double.parse(data.todaystafforder.totalAmount).toInt()
                                  .toString(),
                              2.5,
                              FontWeight.bold,
                              TextDirection.rtl),
                        ]),
                        TableRow(children: [
                          res(context, 'Discount', 2.5, FontWeight.bold,
                              TextDirection.ltr),
                          res(
                              context,
                              double.parse(
                                      data.todaystafforder.additionalDiscount).toInt()
                                  .toString(),
                              2.5,
                              FontWeight.bold,
                              TextDirection.rtl),
                        ]),
                        TableRow(children: [
                          res(context, 'Reward Points', 2.5, FontWeight.bold,
                              TextDirection.ltr),
                          res(
                              context,
                              double.parse(data.todaystafforder.rewards).toInt()
                                  .toString(),
                              2.5,
                              FontWeight.bold,
                              TextDirection.rtl),
                        ]),
                        TableRow(children: [
                          res(context, 'Coupon Discount', 2.5, FontWeight.bold,
                              TextDirection.ltr),
                          res(
                              context,
                              double.parse(data.todaystafforder.couponDiscount).toInt()
                                  .toString(),
                              2.5,
                              FontWeight.bold,
                              TextDirection.rtl),
                        ]),
                      ],
                    )),
                    Divider(
                      color: Colors.black,
                      thickness: 0.3,
                      height: 45,
                    ),
                    Container(
                      child: Table(
                          defaultVerticalAlignment:
                              TableCellVerticalAlignment.middle,
                          // border: TableBorder.all(),
                          children: [
                            TableRow(children: [
                              res(context, 'Net Total', 2.5, FontWeight.w900,
                                  TextDirection.ltr),
                              numtxt(
                                  context,
                                  double.parse(data
                                          .todaystafforder.netTotalAmount
                                          .toString())
                                      .toInt()
                                      .toString(),
                                  2.5)
                            ]),
                            TableRow(children: [
                              res(context, 'Advance', 2.5, FontWeight.w900,
                                  TextDirection.ltr),
                              numtxt(
                                  context,
                                  double.parse(data.todaystafforder.paidAmount).toInt()
                                      .toString(),
                                  2.5)
                            ]),
                            TableRow(children: [
                              res(context, 'Balance/Refund', 2.5,
                                  FontWeight.w900, TextDirection.ltr),
                              numtxt(
                                  context,
                                  double.parse(
                                          data.todaystafforder.balanceAmount).toInt()
                                      .toString(),
                                  2.5)
                            ]),
                          ]),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: mq.height * 0.13,
              ),
              ElevatedButton(
                  onPressed: () {
                    CheckOut(
                            'StaffSaveCheckOutDetails',
                            data.todaystafforder.orderId.toString(),
                            data.todaystafforder.netTotalAmount,
                            data.todaystafforder.rewards,
                            data.todaystafforder.couponDiscount,
                            data.todaystafforder.totalAmount,
                            data.todaystafforder.paidAmount,
                            data.todaystafforder.balanceAmount,
                            data.todaystafforder.rewards)
                        .whenComplete(() {
                      if (check_rep.n == 1) {
                        main_toast(check_rep.msg);
                        smallbottomsheet(context, check_rep.msg, () {
                          Navigator.of(context).pop();
                          Navigator.pop(context);
                        });
                      } else {
                        main_toast(check_rep.msg);
                      }
                    });
                  },
                  child: Text('checkout '))
            ],
          ),
        ));
  }
}
