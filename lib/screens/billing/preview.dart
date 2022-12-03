import 'package:flutter/material.dart';
import 'package:upcomming/Model.dart/shoot/upcomming.dart';
import 'package:upcomming/widgets/common.dart';

class preview extends StatefulWidget {
  final Finalorderlist data;

  const preview({Key key, this.data}) : super(key: key);

  @override
  State<preview> createState() => _previewState();
}

class _previewState extends State<preview> {
  @override
  Widget build(BuildContext context) {
    var data = widget.data;
    return Scaffold(
      appBar: noTabAppBar(context, 'Preview'),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Padding(
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
                            data.cartList.length,
                            (i2) => TableRow(children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    res(context, data.cartList[i2].typeName,
                                        1.8, FontWeight.bold, TextDirection.ltr)
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 15),
                                child: Table(
                                  children: List.generate(
                                      data.cartList[i2].orderItems.length,
                                      (i3) => TableRow(children: [
                                            res(
                                                context,
                                                data.cartList[i2].orderItems[i3]
                                                    .productName,
                                                1.8,
                                                FontWeight.w300,
                                                TextDirection.ltr),
                                            res(
                                                context,
                                                double.parse(data
                                                        .cartList[i2]
                                                        .orderItems[i3]
                                                        .productSellingAmount)
                                                    .toInt()
                                                    .toString(),
                                                1.8,
                                                FontWeight.w300,
                                                TextDirection.rtl),
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
                          res(context, 'Extra Hour Charges', 1.8,
                              FontWeight.bold, TextDirection.ltr),
                          res(
                              context,
                              double.parse(data.todaystafforder.extrahouramount)
                                  .toInt()
                                  .toString(),
                              1.8,
                              FontWeight.w300,
                              TextDirection.rtl),
                        ]),
                        TableRow(children: [
                          res(context, 'Damage Charges', 1.8, FontWeight.bold,
                              TextDirection.ltr),
                          res(
                              context,
                              double.parse(data.todaystafforder.damageCharge)
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
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: Container(
                        child: Table(
                      // border: TableBorder.all(),
                      children: [
                        TableRow(children: [
                          res(context, 'Grand Total', 1.8, FontWeight.bold,
                              TextDirection.ltr),
                          res(
                              context,
                              double.parse(data.todaystafforder.totalAmount)
                                  .toInt()
                                  .toString(),
                              1.8,
                              FontWeight.w300,
                              TextDirection.rtl),
                        ]),
                        TableRow(children: [
                          res(context, 'Discount', 1.8, FontWeight.bold,
                              TextDirection.ltr),
                          res(
                              context,
                              double.parse(
                                      data.todaystafforder.additionalDiscount)
                                  .toInt()
                                  .toString(),
                              1.8,
                              FontWeight.w300,
                              TextDirection.rtl),
                        ]),
                        TableRow(children: [
                          res(context, 'Reward Points', 1.8, FontWeight.bold,
                              TextDirection.ltr),
                          res(
                              context,
                              double.parse(data.todaystafforder.rewards)
                                  .toInt()
                                  .toString(),
                              1.8,
                              FontWeight.w300,
                              TextDirection.rtl),
                        ]),
                        TableRow(children: [
                          res(context, 'Coupon Discount', 1.8, FontWeight.bold,
                              TextDirection.ltr),
                          res(
                              context,
                              double.parse(data.todaystafforder.couponDiscount)
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
                            res(context, 'Net Total', 2.3, FontWeight.bold,
                                TextDirection.ltr),
                            numtxt(
                                context,
                                double.parse(
                                        data.todaystafforder.netTotalAmount)
                                    .toInt()
                                    .toString(),
                                2.3)
                          ]),
                          TableRow(children: [
                            res(context, 'Advance', 2.3, FontWeight.bold,
                                TextDirection.ltr),
                            numtxt(
                                context,
                                double.parse(data.todaystafforder.paidAmount)
                                    .toInt()
                                    .toString(),
                                2.3)
                          ]),
                          TableRow(children: [
                            res(context, 'Balance/Refund', 2.3, FontWeight.bold,
                                TextDirection.ltr),
                            numtxt(
                                context,
                                double.parse(data.todaystafforder.balanceAmount)
                                    .toInt()
                                    .toString(),
                                2.3)
                          ]),
                        ])),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
