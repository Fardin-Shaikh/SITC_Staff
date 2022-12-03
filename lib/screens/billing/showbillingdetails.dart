import 'dart:convert';
import 'dart:developer';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_geofence/geofence.dart';
import 'package:responsive_flutter/responsive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:upcomming/Model.dart/billing/category.dart';
import 'package:upcomming/Model.dart/billing/department.dart';
import 'package:upcomming/Model.dart/mini_model/small.dart';
import 'package:upcomming/color/colors.dart';
import 'package:upcomming/screens/billing/preview.dart';
import 'package:upcomming/widgets/common.dart';
import 'package:upcomming/widgets/loader.dart';
import '../../Model.dart/billing/history.dart';
import '../../Model.dart/shoot/upcomming.dart';
import '../../responce/all_fetch.dart';
import 'package:http/http.dart' as http;
import 'package:form_field_validator/form_field_validator.dart';

import '../../responce/internetcheck.dart';

class detail_billig extends StatefulWidget {
  final Finalorderlist data;
  const detail_billig(this.data);

  @override
  State<detail_billig> createState() => _detail_billigState();
}

class _detail_billigState extends State<detail_billig> {
  String department_drop;
  String inside_drop;
  Departmnent department_resp;
  Categorydropdown cato_resp;
  bool department_bool = false;
  bool cato_bool = false;
  List<String> dep_list;
  List<int> dep_id_list;
  List<String> insidelist = [''];
  List<int> inside_id_list;
  bool do_visible = false;
  TextEditingController amount_cltr = TextEditingController();
  TextEditingController remark_cltr = TextEditingController();
  GlobalKey<FormState> bill_key = GlobalKey<FormState>();
  int dep_single_id;
  int inside_single_id;
  SmallResponce isadded_resp;
  bool show_history = false;
  History history_resp;
  bool history_bool = false;
  SmallResponce isremove_resp;
  bool isremove_bool = false;
  int added_total = 0;
  @override
  void initState() {
    super.initState();
    CK.inst.internet(context, (val) {
      if (val) {
        log('haseinternet');
        dep_fetch('StaffBillingDepartment').whenComplete(() {
          setState(() {
            if (department_resp.response.n == 1) {
              dep_list = List.generate(
                  department_resp.departmentbillinglist.length, (i) {
                return department_resp.departmentbillinglist[i].departmentName;
              });
              dep_id_list = List.generate(
                  department_resp.departmentbillinglist.length, (i) {
                return department_resp.departmentbillinglist[i].departmentId;
              });
              log(dep_list.toString() + 'departnment name list ');
              log(dep_id_list.toString() + 'departnment id list ');
            } else {
              main_toast(department_resp.response.msg);
              Navigator.pop(context);
            }
          });
        });
      }
    });
  }

  Future<void> dep_fetch(String api_name) async {
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

    if (responce.statusCode == 200) {
      setState(() {
        var fast = Departmnent.fromJson(jsonDecode(responce.body));
        department_resp = fast;
        department_resp == null
            ? department_bool = false
            : department_bool = true;
      });
    } else if (responce.statusCode == 401) {
      Fetch.insta.expire_dialog(context);
    } else if (responce.statusCode == 500) {
      main_toast('Server Not responding ');
    } else {
      main_toast('Something went Wrong');
    }
  }

  Future<void> category_fetch(String api_name, department_id) async {
    final prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');
    final String id = prefs.getString('id');
    final uri = Uri.http(Fetch.insta.URL1, Fetch.insta.URL2 + api_name,
        {'DepartmentId': department_id});
    final responce = await http.get(uri, headers: {
      'Apikey': Fetch.insta.Common_apikey,
      'authToken': token + '-' + id,
    });
    log(uri.toString());
    log(responce.body);
    print('herrrrrrrrrrrrrrrrrrrr');
    if (responce.statusCode == 200) {
      setState(() {
        var fast = Categorydropdown.fromJson(jsonDecode(responce.body));
        cato_resp = fast;
        cato_resp == null ? cato_bool = false : cato_bool = true;
      });
    } else if (responce.statusCode == 401) {
      Fetch.insta.expire_dialog(context);
    } else if (responce.statusCode == 500) {
      main_toast('Server Not responding ');
    } else {
      main_toast('Something went Wrong');
    }
  }

  Future<void> final_add(
      String api_name,
      String d_id,
      String dname,
      String Prof_id,
      String cottageid,
      String amount,
      String remark,
      String orderid) async {
    final prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');
    final String id = prefs.getString('id');
    final uri = Uri.http(Fetch.insta.URL1, Fetch.insta.URL2 + api_name);
    final responce = await http.post(uri, headers: {
      'Apikey': Fetch.insta.Common_apikey,
      'authToken': token + '-' + id,
    }, body: {
      "UserId": id,
      "DepartmentTypeId": d_id,
      "DepartmentTypeName": dname,
      "ProfessionalCategoryId": Prof_id,
      "CottageId": cottageid,
      "Amount": amount,
      "Remark": remark,
      "Pk_OrderId": orderid
    });
    // log('${id} \n ${d_id} \n ${dname} \n ${ProfessionalCategoryId} \n ${cottageid} \n ${amount} \n ${remark} \n ${orderid}');
    print(api_name +
        '\n' +
        d_id +
        '\n' +
        dname +
        '\n' +
        Prof_id +
        '\n' +
        cottageid +
        '\n' +
        amount +
        '\n' +
        remark +
        '\n' +
        orderid);
    log(responce.body);
    if (responce.statusCode == 200) {
      setState(() {
        var finn = SmallResponce.fromJson(jsonDecode(responce.body));
        isadded_resp = finn;
      });
    } else if (responce.statusCode == 401) {
      Fetch.insta.expire_dialog(context);
    } else if (responce.statusCode == 500) {
      main_toast('Server Not responding ');
    } else {
      main_toast('Something went Wrong');
    }
  }

  Future<void> history_fetch(
      String api_name, String department_id, String order_id) async {
    final prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');
    final String id = prefs.getString('id');
    final uri = Uri.http(Fetch.insta.URL1, Fetch.insta.URL2 + api_name,
        {'DepartmentId': department_id, 'StaffId': id, 'Pk_OrderId': order_id});
    final responce = await http.get(uri, headers: {
      'Apikey': Fetch.insta.Common_apikey,
      'authToken': token + '-' + id,
    });
    log(uri.toString());
    log(responce.body);
    print('herrrrrrrrrrrrrrrrrrrr');
    if (responce.statusCode == 200) {
      setState(() {
        var fast = History.fromJson(jsonDecode(responce.body));
        history_resp = fast;
        history_resp == null ? history_bool = false : history_bool = true;
      });
    } else if (responce.statusCode == 401) {
      Fetch.insta.expire_dialog(context);
    } else {
      main_toast('Server Not responding ');
    }
  }

  Future<void> remove_item(
      String api_name, String id_h, String order_id, String prod_id) async {
    final prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');
    final String id = prefs.getString('id');
    final uri = Uri.http(Fetch.insta.URL1, Fetch.insta.URL2 + api_name, {
      'Pk_OrderId': order_id,
      'StaffId': id,
      'Id': id_h,
      'ProductId': prod_id
    });
    final responce = await http.get(uri, headers: {
      'Apikey': Fetch.insta.Common_apikey,
      'authToken': token + '-' + id,
    });
    log(uri.toString());
    log(responce.body);
    print('herrrrrrrrrrrrrrrrrrrr');
    if (responce.statusCode == 200) {
      setState(() {
        var fast = SmallResponce.fromJson(jsonDecode(responce.body));
        isremove_resp = fast;
        isremove_resp == null ? isremove_bool = false : isremove_bool = true;
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
    var data = widget.data;
    return department_bool
        ? Scaffold(
            resizeToAvoidBottomInset: false,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: floating_container(data),
            appBar: noTabAppBar(context, 'Billing'),
            body: main_conatainer(widget.data))
        : Loading_screen();
  }

  Widget floating_container(Finalorderlist data) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.12,
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.grey[400], width: 1))),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                deco_text(
                    context, 'Total :', 2.5, Acolors.black, FontWeight.w400),
                deco_text(context, 'INR ${added_total}', 2.5,
                    Acolors.dark_bround, FontWeight.w400),
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.012,
          ),
          ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => preview(
                              data: data,
                            )));
              },
              child: Text('Preview'))
        ],
      ),
    );
  }

  Widget old_w() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
        decoration: BoxDecoration(
            color: Acolors.orange,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              bottomLeft: Radius.circular(20.0),
              topRight: Radius.circular(50.0),
              bottomRight: Radius.circular(50.0),
            )),
        width: MediaQuery.of(context).size.width * 0.65,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                'Total : ${added_total}',
                style: TextStyle(
                    color: Acolors.dark_bround,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
            ),
            Flexible(
              child: FloatingActionButton(
                onPressed: () {
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => preview(
                  //               data: data,
                  //             )));
                },
                child: Icon(
                  Icons.preview_rounded,
                  size: 40,
                ),
                backgroundColor: Acolors.dark_bround,
                foregroundColor: Colors.white,
              ),
            )
            // ElevatedButton(
            //     style: ElevatedButton.styleFrom(
            //       minimumSize: const Size.fromHeight(40), // NEW
            //     ),
            //     onPressed: () {},
            //     child: Text('Preview'))
          ],
        ),
      ),
    );
  }

  Widget main_conatainer(Finalorderlist data) {
    return Container(
      margin: EdgeInsets.all(15),
      child: Form(
        key: bill_key,
        autovalidateMode: AutovalidateMode.disabled,
        child: ListView(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                DropdownButtonFormField2<String>(
                  barrierLabel: 'name s',
                  itemPadding: EdgeInsets.only(left: 10),
                  dropdownMaxHeight: 200,
                  dropdownDecoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  validator: (value) => value == null ? 'field required' : null,
                  value: department_drop,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: dep_list.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(items),
                    );
                  }).toList(),
                  isExpanded: true,
                  // isDense: true,
                  hint: Text("Department  ",
                      style: TextStyle(color: Acolors.black, fontSize: 15)),
                  onChanged: (String newValue) {
                    setState(() {
                      log(data.todaystafforder.orderId.toString() + 'id');
                      show_history = false;
                      inside_drop = null;
                      department_drop = newValue;
                      for (var i = 0; i < dep_list.length; i++) {
                        if (dep_list[i] == department_drop) {
                          log(i.toString());
                          dep_single_id = dep_id_list[i];
                          log(dep_single_id.toString() + 'this is id');
                             Utils(context).startLoading();
                          CK.inst.onhit_internet(context, (value) {
                            history_fetch(
                                    'StaffAddedtoCartList',
                                    dep_single_id.toString(),
                                    data.todaystafforder.orderId.toString())
                                .whenComplete(() {
                              if (history_resp.response.n == 1) {
                                added_total =
                                    double.parse(history_resp.totalAmount)
                                        .toInt();
                              }
                            });
                            
                            category_fetch('StaffBillingProfessionalCategory',
                                    dep_single_id.toString())
                                .whenComplete(() {
                                  Utils(context).stopLoading();
                              if (cato_resp.response.n == 1) {
                                insidelist = List.generate(
                                    cato_resp.professionalcategorylist.length,
                                    (i) {
                                  return cato_resp
                                      .professionalcategorylist[i].name;
                                });
                                inside_id_list = List.generate(
                                    cato_resp.professionalcategorylist.length,
                                    (i) {
                                  return cato_resp
                                      .professionalcategorylist[i].profCatId;
                                });
                                log('${inside_id_list.toString()} inside_id_list ');
                                log('${insidelist.toString()} inside_string list  ');
                                if (insidelist.length != null &&
                                    insidelist.length != 0) {
                                  do_visible = true;
                                } else {
                                  do_visible = false;
                                }
                              } else {
                                do_visible = false;
                              }
                            });
                          });
                        }
                      }
                    });
                  },
                ),
                show_history
                    ? Container()
                    : Column(
                        children: [
                          Visibility(
                            visible: do_visible,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: DropdownButtonFormField2<String>(
                                itemPadding: EdgeInsets.only(left: 10),
                                dropdownMaxHeight: 200,
                                dropdownDecoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                validator: (value) =>
                                    value == null ? 'field required' : null,
                                value: inside_drop,
                                icon: const Icon(Icons.keyboard_arrow_down),
                                items: insidelist.map((String items) {
                                  return DropdownMenuItem(
                                    value: items,
                                    child: Text(items),
                                  );
                                }).toList(),
                                isExpanded: true,
                                // isDense: true,
                                hint: Text("Select",
                                    style: TextStyle(
                                        color: Acolors.black, fontSize: 15)),
                                onChanged: (String newValue) {
                                  setState(() {
                                    inside_drop = newValue;
                                    for (var i = 0;
                                        i < insidelist.length;
                                        i++) {
                                      if (inside_drop == insidelist[i]) {
                                        inside_single_id = inside_id_list[i];
                                        print(
                                            '${inside_single_id} cottage or profession al id ');
                                      }
                                    }
                                  });
                                },
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: TextFormField(
                                autofocus: false,
                                keyboardType: TextInputType.number,
                                controller: amount_cltr,
                                validator:
                                    RequiredValidator(errorText: 'required'),
                                decoration: InputDecoration(
                                    label: Text('Enter Amount'))),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: TextFormField(
                                autofocus: false,
                                validator:
                                    RequiredValidator(errorText: 'required'),
                                controller: remark_cltr,
                                decoration:
                                    InputDecoration(label: Text('Remark'))),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.04,
                          ),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size.fromHeight(40), // NEW
                              ),
                              onPressed: () {
                                // history_fetch('StaffAddedtoCartList', dep_single_id.toString(), data.todaystafforder.orderId.toString());
                                setState(() {
                                  if (bill_key.currentState.validate()) {
                                    Utils(context).startLoading();
                                    CK.inst.onhit_internet(context, (value) {
                                      final_add(
                                              'StaffAddtoCart',
                                              dep_single_id.toString(),
                                              department_drop,
                                              inside_single_id.toString(),
                                              inside_single_id.toString(),
                                              amount_cltr.text.toString(),
                                              remark_cltr.text.toString(),
                                              data.todaystafforder.orderId
                                                  .toString())
                                          .whenComplete(() {
                                        if (isadded_resp.n == 0) {
                                          main_toast("Item added succesfully");
                                          history_fetch(
                                                  'StaffAddedtoCartList',
                                                  dep_single_id.toString(),
                                                  data.todaystafforder.orderId
                                                      .toString())
                                              .whenComplete(() {
                                            if (history_resp.response.n == 1) {
                                              show_history = true;
                                              Utils(context).stopLoading();
                                              added_total = double.parse(
                                                      history_resp.totalAmount)
                                                  .toInt();
                                            }
                                          });
                                        } else {
                                          main_toast(isadded_resp.msg);
                                          Utils(context).stopLoading();
                                        }
                                      });
                                    });
                                  }
                                });
                              },
                              child: Text("Add")),
                        ],
                      )
              ],
            ),
            history_bool
                ? history_widget(
                    history_resp, data.todaystafforder.orderId.toString())
                : Container(),
            Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.25,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget history_widget(History data, String whole_id) {
    if (data.stafforderlists.length == 0) {
      return Container();
    }
    return Container(
      margin: EdgeInsets.only(top: 15),
      child: Column(
        children: [
          Container(
              width: double.infinity,
              alignment: Alignment.centerLeft,
              child:
                  //  res(context, 'History', 3, FontWeight.bold, TextDirection.ltr)
                  deco_text(context, 'History', 2.6, Acolors.dark_bround,
                      FontWeight.bold)),
          Container(
            width: double.infinity,
            child: ListView.builder(
                shrinkWrap: true,
                primary: false,
                itemCount: data.stafforderlists.length,
                itemBuilder: ((context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: ListTile(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        selected: true,
                        selectedTileColor: Colors.grey[200],
                        title: Container(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height * 0.05,
                          // color: Colors.red,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                // color: Colors.blue ,
                                width: MediaQuery.of(context).size.width * 0.34,
                                child: deco_text(
                                    context,
                                    data.stafforderlists[index]
                                        .departmentTypeName,
                                    2.3,
                                    Acolors.black,
                                    FontWeight.w500),
                              ),
                              Container(
                                alignment: Alignment.topCenter,
                                // color: Colors.red,
                                width: MediaQuery.of(context).size.width * 0.5,
                                height:
                                    MediaQuery.of(context).size.height * 0.09,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    deco_text(
                                        context,
                                        'INR ' +
                                            double.parse(data
                                                    .stafforderlists[index]
                                                    .amount)
                                                .toInt()
                                                .toString(),
                                        2,
                                        Acolors.black,
                                        FontWeight.w500),
                                    Flexible(
                                      child: TextButton(
                                          onPressed: () {
                                            log(data.stafforderlists[index].id
                                                .toString());
                                            log(data.stafforderlists[index]
                                                .productId
                                                .toString());
                                            Utils(context).startLoading();
                                            CK.inst.onhit_internet(context,
                                                (value) {
                                              remove_item(
                                                'StaffRemoveFromCart',
                                                data.stafforderlists[index].id
                                                    .toString(),
                                                whole_id,
                                                data.stafforderlists[index]
                                                    .productId
                                                    .toString(),
                                              ).whenComplete(() {
                                                if (isremove_resp.n == 1) {
                                                  main_toast(isremove_resp.msg);
                                                  Utils(context).stopLoading();
                                                  CK.inst.onhit_internet(
                                                      context, (value) {
                                                    history_fetch(
                                                            'StaffAddedtoCartList',
                                                            dep_single_id
                                                                .toString(),
                                                            whole_id.toString())
                                                        .whenComplete(() {
                                                      if (history_resp
                                                              .response.n ==
                                                          1) {
                                                        added_total = double.parse(
                                                                history_resp
                                                                    .totalAmount)
                                                            .toInt();
                                                        show_history = true;
                                                      }
                                                    });
                                                  });
                                                } else {
                                                  main_toast(isremove_resp.msg);
                                                  Utils(context).stopLoading();
                                                }
                                              });
                                            });
                                          },
                                          child: const Text(
                                            'Remove',
                                            overflow: TextOverflow.ellipsis,
                                          )),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),

                        //you have comment out herre check this
                        // title: deco_text(
                        //     context,
                        //     data.stafforderlists[index].departmentTypeName,
                        //     2.3,
                        //     Acolors.black,
                        //     FontWeight.w500),
                        // trailing: Container(
                        //   alignment: Alignment.topCenter,
                        //   // color: Colors.red,
                        //   width: MediaQuery.of(context).size.width * 0.5,
                        //   height: MediaQuery.of(context).size.height * 0.07,
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //     children: [
                        //       deco_text(
                        //           context,
                        //           'INR ' +
                        //               double.parse(data
                        //                       .stafforderlists[index].amount)
                        //                   .toInt()
                        //                   .toString(),
                        //           2,
                        //           Acolors.black,
                        //           FontWeight.w500),
                        //       Flexible(
                        //         child: TextButton(
                        //             onPressed: () {
                        //               log(data.stafforderlists[index].id
                        //                   .toString());
                        //               log(data.stafforderlists[index].productId
                        //                   .toString());
                        //               Utils(context).startLoading();
                        //               CK.inst.onhit_internet(context, (value) {
                        //                 remove_item(
                        //                   'StaffRemoveFromCart',
                        //                   data.stafforderlists[index].id
                        //                       .toString(),
                        //                   whole_id,
                        //                   data.stafforderlists[index].productId
                        //                       .toString(),
                        //                 ).whenComplete(() {
                        //                   if (isremove_resp.n == 1) {
                        //                     main_toast(isremove_resp.msg);
                        //                     Utils(context).stopLoading();
                        //                     CK.inst.onhit_internet(context,
                        //                         (value) {
                        //                       history_fetch(
                        //                               'StaffAddedtoCartList',
                        //                               dep_single_id.toString(),
                        //                               whole_id.toString())
                        //                           .whenComplete(() {
                        //                         if (history_resp.response.n ==
                        //                             1) {
                        //                           added_total = double.parse(
                        //                                   history_resp
                        //                                       .totalAmount)
                        //                               .toInt();
                        //                           show_history = true;
                        //                         }
                        //                       });
                        //                     });
                        //                   } else {
                        //                     main_toast(isremove_resp.msg);
                        //                     Utils(context).stopLoading();
                        //                   }
                        //                 });
                        //               });
                        //             },
                        //             child: Text(
                        //               'Remove',
                        //               overflow: TextOverflow.ellipsis,
                        //             )),
                        //       ),
                        //     ],
                        //   ),
                        // ),

                        // Text(data.stafforderlists[index].remark),,

                        subtitle: deco_text(
                            context,
                            data.stafforderlists[index].remark,
                            1.8,
                            Acolors.grey,
                            FontWeight.normal)),
                  );
                })),
          )
        ],
      ),
    );
  }

  Text deco_text(BuildContext context, String cnt, double size, Color col,
      FontWeight weight) {
    return Text(
      cnt,
      overflow: TextOverflow.ellipsis,
      softWrap: true,
      style: TextStyle(
        fontSize: ResponsiveFlutter.of(context).fontSize(size),
        fontWeight: weight,
        color: col,
      ),
    );
  }

  Widget bottomsheet() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.25,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total'),
                Text(' 3000'),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.06,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(40), // NEW
                ),
                onPressed: () {},
                child: Text('Preview'))
          ],
        )
      ],
    );
  }
}

//PREVIEW
// SizedBox(
//               height: MediaQuery.of(context).size.height * 0.25,
//             ),
//             Column(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text('Total'),
//                     Text(' 3000'),
//                   ],
//                 ),
//                 SizedBox(
//                   height: MediaQuery.of(context).size.height * 0.06,
//                 ),
//                 ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       minimumSize: const Size.fromHeight(40), // NEW
//                     ),
//                     onPressed: () {},
//                     child: Text('Preview'))
//               ],
//             )
