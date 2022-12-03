import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:responsive_flutter/responsive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:upcomming/Model.dart/mini_model/baseModel.dart';
import 'package:upcomming/Model.dart/notification/nofit.dart';
import 'package:upcomming/color/colors.dart';
import 'package:upcomming/responce/all_fetch.dart';
import 'package:upcomming/responce/internetcheck.dart';
import 'package:upcomming/screens/profile.dart';
import 'package:upcomming/widgets/common.dart';
import 'package:http/http.dart' as http;

class Notif extends StatefulWidget {
  const Notif();

  @override
  State<Notif> createState() => _NotifState();
}

class _NotifState extends State<Notif> {
  NotifModel notif_responce;
  ClearNotif clear_notif_responce;
  bool hasdata_notif = false;
  @override
  void initState() {
    super.initState();

    CK.inst.internet(context, (val) {
      if (val) {
        log('haseinternet');
        get_notification();
      }
    });
  }

  Future<void> get_notification() async {
    final prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');
    final String id = prefs.getString('id');
    // check uri for error
    final uri = Uri.http(
        Fetch.insta.URL1,
        Fetch.insta.URL2 + 'StaffNotificationList',
        {'StaffId': id, 'PageNumber': '1'});
    final responce = await http.get(uri, headers: {
      'Apikey': Fetch.insta.Common_apikey,
      'authToken': token + '-' + id,
    });
    log(uri.toString());
    log(responce.body);
    if (responce.statusCode == 200) {
      setState(() {
        var fin = NotifModel.fromJson(jsonDecode(responce.body));
        notif_responce = fin;
        notif_responce == null ? hasdata_notif = false : hasdata_notif = true;
      });
    } else if (responce.statusCode == 401) {
      Fetch.insta.expire_dialog(context);
    } else {
      main_toast('Server Not responding ');
    }
  }

  Future<void> clearAll_notif() async {
    final prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');
    final String id = prefs.getString('id');
    // check uri for error
    final uri = Uri.http(Fetch.insta.URL1,
        Fetch.insta.URL2 + 'StaffDeleteNotification', {'StaffId': id});
    final responce = await http.get(uri, headers: {
      'Apikey': Fetch.insta.Common_apikey,
      'authToken': token + '-' + id,
    });
    log(uri.toString());
    log(responce.body);
    if (responce.statusCode == 200) {
      setState(() {
        var pin = ClearNotif.fromJson(jsonDecode(responce.body));
        clear_notif_responce = pin;
        // clear_notif_responce == null ? hasdata_notif = false : hasdata_notif = true;
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
    return hasdata_notif
        ? Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios, color: Acolors.dark_bround),
                  onPressed: () => Navigator.pop(context)),
              title: Text(
                'Notification',
                style: TextStyle(color: Acolors.dark_bround),
              ),
              backgroundColor: Acolors.orange,
              elevation: 1,
              actions: [
                IconButton(
                    onPressed: () {
                      // Navigator.of(context).pop();
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.home_outlined,
                      color: Acolors.dark_bround,
                      size: 25,
                    )),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.02,
                ),
                Padding(
                  padding: EdgeInsets.only(right: 20),
                  child: GestureDetector(
                    onTap: (() => Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Profile()))),
                    child: CircleAvatar(
                      radius: 17,
                      backgroundImage: Fetch.insta.final_image_link == " "
                          ? NetworkImage(
                              'https://cdn-icons-png.flaticon.com/128/1144/1144709.png')
                          : NetworkImage(Fetch.insta.final_image_link),
                    ),
                  ),
                )
              ],
            ),
            body: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                        onPressed: () {
                          clearAll_notif().whenComplete(() {
                            print("object");
                            if (clear_notif_responce.n == 1) {
                              CK.inst.internet(context, (val) {
                                if (val) {
                                  log('haseinternet');
                                  get_notification();
                                }
                              });
                            }
                          });
                        },
                        child: stext('clear All', Acolors.dark_bround,
                            FontWeight.bold, 17)),
                  ),
                ),
                notif_responce.notificationlist.length == 0
                    ? Center(
                        child: stext('No Notification ', Acolors.dark_bround,
                            FontWeight.bold, 17),
                      )
                    : ListView.builder(
                        itemCount: notif_responce.notificationlist.length,
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        shrinkWrap: true,
                        primary: false,
                        itemBuilder: (BuildContext ctxt, int index) {
                          var data = notif_responce.notificationlist;
                          return Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: widgereceivetask(
                                data[index].notificationType,
                                data[index].notificationText,
                                data[index].subject,
                                data[index].category,
                                data[index].imageLink,
                                Colors.green),
                          );
                          // switch (2) {
                          //   case 0:
                          //     return Padding(
                          //         padding: const EdgeInsets.only(top: 15),
                          //         child: widgetnotif(
                          //             CircleAvatar(
                          //                 radius: 15,
                          //                 backgroundColor: Colors.green,
                          //                 child: Center(
                          //                   child: Icon(
                          //                     Icons.done_rounded,
                          //                     color: Acolors.white,
                          //                     size: 20,
                          //                   ),
                          //                 )),
                          //             "Props Added Successfully"));

                          //   case 1:
                          //     return Padding(
                          //         padding: const EdgeInsets.only(top: 25),
                          //         child: widgetnotif(
                          //             CircleAvatar(
                          //                 radius: 15,
                          //                 backgroundColor: Colors.red,
                          //                 child: Icon(
                          //                   Icons.delete_outline_rounded,
                          //                   color: Acolors.white,
                          //                   size: 16,
                          //                 )),
                          //             "Props Deleted Successfully"));

                          //   case 2:
                          //     return Padding(
                          //       padding: const EdgeInsets.only(top: 10),
                          //       child: widgereceivetask(
                          //           data[index].notificationType,
                          //           data[index].notificationText,
                          //           data[index].subject,
                          //           data[index].category,
                          //           data[index].imageLink,
                          //           Colors.green),
                          //     );
                          //   default:
                          //     return Container();
                          // }
                        },
                      ),
              ],
            ))
        : Loading_screen();
  }

  Widget widgetnotif(CircleAvatar mark, String title) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1.0, color: Acolors.grey),
        ),
        // color: Acolors.light_pink,
      ),
      // height: MediaQuery.of(context).size.height * 0.12,
      child:
          // Text(notif_responce.notificationlist[0].notificationText)
          Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                mark,
                Padding(
                  padding: const EdgeInsets.only(left: 18),
                  child: stext(title, Acolors.dark_bround, FontWeight.bold, 17),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 13),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.06,
                    width: MediaQuery.of(context).size.width * 0.13,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image:
                                AssetImage('lib/assets/temp_asset/prop1.png'),
                            fit: BoxFit.cover),
                        borderRadius: BorderRadius.all(Radius.circular(6.0))),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      stext('Name', Acolors.black, FontWeight.w500, 15),
                      stext('Lorem Ip...', Acolors.dark_bround, FontWeight.w500,
                          17),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      stext('Category', Acolors.black, FontWeight.w500, 15),
                      stext('Lamp', Acolors.dark_bround, FontWeight.w500, 17),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      stext('Quantity', Acolors.black, FontWeight.w500, 15),
                      stext('2', Acolors.dark_bround, FontWeight.w500, 17),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget widgereceivetask(
    String heading,
    String subheading,
    String subject,
    String category,
    String image,
    Color color,
  ) {
    print(subject);
    log('subject');
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 3,
      // color: Acolors.light_pink,
      child: Column(
        children: [
          ListTile(
            contentPadding:
                EdgeInsets.only(left: 12, right: 12, top: 0, bottom: 0),
            // leading: Column(
            //   children: [
            //     Container(
            //       height: MediaQuery.of(context).size.height * 0.07,
            //       width: MediaQuery.of(context).size.width * 0.14,
            //       decoration: BoxDecoration(
            //           image: DecorationImage(
            //               image: NetworkImage(image), fit: BoxFit.cover),
            //           borderRadius: BorderRadius.all(Radius.circular(6.0))),
            //     )
            //   ],
            // ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                stext(heading, Acolors.dark_bround, FontWeight.bold, 17),
                CircleAvatar(
                    radius: 10,
                    backgroundColor: color,
                    child: Center(
                      child: Icon(
                        Icons.done_rounded,
                        color: Acolors.white,
                        size: 10,
                      ),
                    ))
              ],
            ),
            subtitle: stext(subheading, Acolors.black, FontWeight.normal, 15),
          ),
          ListTile(
            // selected: true,
            // selectedColor: Colors.red,
            contentPadding:
                EdgeInsets.only(left: 12, right: 12, top: 5, bottom: 5),
            leading: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.07,
                  width: MediaQuery.of(context).size.width * 0.14,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(image), fit: BoxFit.cover),
                      borderRadius: BorderRadius.all(Radius.circular(6.0))),
                )
              ],
            ),
            title: Row(
              children: [
                Flexible(
                  child: Container(
                    width: double.infinity,
                    // color: Colors.blue,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        stext('Category', Acolors.black, FontWeight.w500, 15),
                        stext(
                            category, Acolors.dark_bround, FontWeight.w500, 17),
                      ],
                    ),
                  ),
                ),
                subject == ' '
                    ? Flexible(
                        child: Container(
                          // color: Colors.red,
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              stext('Subject', Acolors.black, FontWeight.w500,
                                  15),
                              stext(subject,
                                  Acolors.dark_bround, FontWeight.w500, 17),
                            ],
                          ),
                        ),
                      )
                    : Container()
              ],
            ),

            
          ),

        ],
      ),
    );
  }
}
