import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';
//initate stat outside the attendance class ----- initate it in fence class in
import 'package:easy_geofencing/easy_geofencing.dart';
import 'package:easy_geofencing/enums/geofence_status.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:one_clock/one_clock.dart';
import 'package:responsive_flutter/responsive_flutter.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:upcomming/Model.dart/attendance/att_staff_detail.dart';
import 'package:upcomming/color/colors.dart';
import 'package:upcomming/screens/home.dart';

import 'package:upcomming/screens/notifications.dart';
import 'package:upcomming/screens/profile.dart';
import 'package:upcomming/widgets/common.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:upcomming/widgets/loader.dart';

import '../../Model.dart/attendance/attendencelist.dart';
import '../../responce/all_fetch.dart';
import 'package:http/http.dart' as http;

import '../../responce/internetcheck.dart';

bool islistning = false;

class Attendance extends StatefulWidget {
  const Attendance();

  @override
  State<Attendance> createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  bool click = false;
  DateTime now = DateTime.now();
  String _timeString;
  String _dataString;
  String inn_select = '--/--';
  String out_select = '--/--';
  Position position;
  bool checkout = false;
  bool checkin = false;
  int count = 0;
  bool checkIn_done = false;
  bool checkout_done = false;
  String geofenceStatus = 'Started Services';
  String tdata = DateFormat("hh : mm : ss a").format(DateTime.now());
  GeofenceStatus status_main;
  StreamSubscription<GeofenceStatus> geofenceStatusStream;
  AllAttendence all_att_respo;
  AttStaffdetail att_detail_responce;
  bool has_data = false;
  bool has_coordinates = false;
  AttStaffdetail checkin_out_resp;
  String login_time = ' ';
  String logout_time = ' ';

  @override
  void initState() {
    super.initState();
    CK.inst.internet(context, (val) {
      if (val) {
        log('haseinternet');
        attendance_staff_detail().whenComplete(() {
          getCurrentPosition();
          EasyGeofencing.startGeofenceService(
              pointedLatitude: att_detail_responce.attendancedetails.latitude,
              pointedLongitude: att_detail_responce.attendancedetails.longitude,
              radiusMeter: att_detail_responce.attendancedetails.radius,
              eventPeriodInSeconds: 5);
          if (geofenceStatusStream == null) {
            print('name');
            geofenceStatusStream = EasyGeofencing.getGeofenceStream()
                .listen((GeofenceStatus status) {
              print(status.toString());
              setState(() {
                count++;
                geofenceStatus = status.toString();
                att_detail_responce.response.n == 0
                    ? checkIn_done = false
                    : checkIn_done = true;
              });
            });
          }
        });
        all_attendence();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    print("stop");
    EasyGeofencing.stopGeofenceService();
    geofenceStatusStream.cancel();
    geofenceStatus = 'clear';
  }

  getCurrentPosition() async {
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print("LOCATION => ${position.toJson()}");
  }

  void timerfunation() {
    _timeString = _formatTime(DateTime.now());
    // _dataString = _formatDate(DateTime.now());
    // Timer.periodic(const Duration(seconds: 1), (Timer t) => _getTime());
  }

  // void pref() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final String time = prefs.getString('checkin_time');
  //   setState(() {
  //     Fence.checkin = time;
  //   });
  //   log(Fence.checkin);
  //   log('%%%%%%%%%%%%%%%%');
  // }

  //API FETCH FUNCTIONS
  Future<void> all_attendence() async {
    final prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');
    final String id = prefs.getString('id');
    final uri = Uri.http(
      Fetch.insta.URL1,
      Fetch.insta.URL2 + 'StaffAttendancesList',
    );
    final responce = await http.get(uri, headers: {
      'Apikey': Fetch.insta.Common_apikey,
      'authToken': token + '-' + id,
    });

    if (responce.statusCode == 200) {
      setState(() {
        all_att_respo = AllAttendence.fromJson(jsonDecode(responce.body));
        all_att_respo == null ? has_data == false : has_data = true;
      });
    } else if (responce.statusCode == 401) {
      Fetch.insta.expire_dialog(context);
    } else if (responce.statusCode == 401) {
      Fetch.insta.expire_dialog(context);
    } else if (responce.statusCode == 500) {
      main_toast('Server Not responding ');
    } else {
      main_toast('Something went Wrong');
    }
  }

  Future<void> attendance_staff_detail() async {
    final prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');
    final String id = prefs.getString('id');
    final uri = Uri.http(Fetch.insta.URL1,
        Fetch.insta.URL2 + 'StaffAttendanceStatus', {'StaffId': id});
    final responce = await http.get(uri, headers: {
      'Apikey': Fetch.insta.Common_apikey,
      'authToken': token + '-' + id,
    });
    log(responce.body);
    print('herrrrrrrr');
    if (responce.statusCode == 200) {
      setState(() {
        var boo = AttStaffdetail.fromJson(jsonDecode(responce.body));
        att_detail_responce = boo;
        att_detail_responce == null
            ? has_coordinates == false
            : has_coordinates = true;
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
    Size mq = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            leading: IconButton(
                icon: Icon(Icons.arrow_back_ios, color: Acolors.dark_bround),
                onPressed: () => Navigator.pop(context)),
            title: Text(
              'Attendance',
              style: TextStyle(color: Acolors.dark_bround, fontSize: 17),
            ),
            backgroundColor: Acolors.orange,
            elevation: 1,
            actions: [
              // IconButton(
              //     onPressed: () {
              //       setState(() async {
              //         final prefs = await SharedPreferences.getInstance();
              //         await prefs.remove('checkin_time');
              //         // Fence.checkin = null;
              //         // log(Fence.checkin);
              //       });
              //     },
              //     icon: Icon(
              //       Icons.restore_page,
              //       color: Acolors.dark_bround,
              //       size: 25,
              //     )),
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
          body: has_data
              ? ListView(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  children: [
                      Container(
                          height: MediaQuery.of(context).size.height * 0.4,
                          // color: Colors.lightGreen[200],
                          // alignment: Alignment.center,
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: has_coordinates
                                ? Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        height: mq.height * 0.01,
                                      ),
                                      DigitalClock(
                                          showSeconds: true,
                                          isLive: true,
                                          digitalClockTextColor: Colors.black,
                                          decoration: BoxDecoration(
                                              color: Acolors.light_orange,
                                              shape: BoxShape.rectangle,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5))),
                                          datetime: DateTime.now()),
                                            
                                      dec_text(
                                          context,
                                           DateFormat('d.M.y').format(DateTime.now()),
                                          Acolors.black,
                                          FontWeight.bold,
                                          2),
                                      Text(
                                        "Geofence Status: \n\n" +
                                            geofenceStatus,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              dec_text(
                                                  context,
                                                  'CheckIn',
                                                  Acolors.dark_bround,
                                                  FontWeight.bold,
                                                  2.2),
                                              SizedBox(
                                                height: mq.height * 0.02,
                                              ),
                                              att_detail_responce
                                                          .attendancedetails
                                                          .checkIn ==
                                                      null
                                                  ? dec_text(
                                                      context,
                                                      login_time,
                                                      Acolors.black,
                                                      FontWeight.bold,
                                                      2.5)
                                                  : dec_text(
                                                      context,
                                                      att_detail_responce
                                                          .attendancedetails
                                                          .checkIn,
                                                      Acolors.black,
                                                      FontWeight.bold,
                                                      2.5),
                                            ],
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              dec_text(
                                                  context,
                                                  'CheckOut',
                                                  Acolors.dark_bround,
                                                  FontWeight.bold,
                                                  2.2),
                                              SizedBox(
                                                height: mq.height * 0.02,
                                              ),
                                              att_detail_responce.attendancedetails
                                                          .checkOut ==
                                                      null
                                                  ? dec_text(
                                                      context,
                                                      logout_time,
                                                      Acolors.black,
                                                      FontWeight.bold,
                                                      2.5)
                                                  : dec_text(
                                                      context,
                                                      att_detail_responce
                                                          .attendancedetails
                                                          .checkOut,
                                                      Acolors.black,
                                                      FontWeight.bold,
                                                      2.5),
                                            ],
                                          )
                                        ],
                                      ),
                                      // Container(
                                      //   child: Text(
                                      //       'Geofence service \n latitude - ${att_detail_responce.attendancedetails.latitude} \n longitude - ${att_detail_responce.attendancedetails.longitude}\n ${att_detail_responce.response.msg}'),
                                      // ),
                                      //  GeofenceStatus.exit
                                      //  GeofenceStatus.init
                                      //  GeofenceStatus.enter
                                      // Text(count.toString()),
                                      // Text(
                                      //   "Geofence Status: \n\n\n" + geofenceStatus,
                                      //   textAlign: TextAlign.center,
                                      //   style: TextStyle(
                                      //       fontSize: 20.0,
                                      //       fontWeight: FontWeight.bold),
                                      // ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          ElevatedButton(
                                            child: Text(
                                              'Check-In',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            // style: ButtonStyle(
                                            //   backgroundColor:
                                            //       MaterialStateProperty.all<
                                            //           Color>(Colors.white),
                                            //   shape: MaterialStateProperty.all<
                                            //       RoundedRectangleBorder>(
                                            //     RoundedRectangleBorder(
                                            //       // side: BorderSide(
                                            //       //     color:
                                            //       //         Acolors.dark_bround,
                                            //       //     width: 0.9,
                                            //       //     style: BorderStyle.solid),
                                            //       borderRadius:
                                            //           BorderRadius.circular(5),
                                            //     ),
                                            //   ),
                                            // ),
                                            onPressed: checkIn_done
                                                ? null
                                                : 'GeofenceStatus.enter' == /////hereeeeeee
                                                        geofenceStatus
                                                    ? () async {
                                                        CK.inst.onhit_internet(
                                                            context, (value) {
                                                          Utils(context)
                                                              .startLoading();
                                                          upload_att(
                                                                  'StaffAttendance',
                                                                  'CheckIn')
                                                              .whenComplete(() {
                                                            if (checkin_out_resp
                                                                    .response
                                                                    .n ==
                                                                1) {
                                                              main_toast(
                                                                  checkin_out_resp
                                                                      .response
                                                                      .msg);
                                                              setState(() {
                                                                checkIn_done =
                                                                    true;
                                                                attendance_staff_detail()
                                                                    .whenComplete(() =>
                                                                        Utils(context)
                                                                            .stopLoading());
                                                                login_time =
                                                                    _formatTime(
                                                                        DateTime
                                                                            .now());
                                                              });
                                                            } else {
                                                              main_toast(
                                                                  checkin_out_resp
                                                                      .response
                                                                      .msg);
                                                            }
                                                          });
                                                        });
                                                      }
                                                    : null,
                                          ),
                                          ElevatedButton(
                                            child: Text('Check-Out'),
                                            //  style: ButtonStyle(
                                            //   backgroundColor:
                                            //       MaterialStateProperty.all<
                                            //           Color>(Colors.white),
                                            //   shape: MaterialStateProperty.all<
                                            //       RoundedRectangleBorder>(
                                            //     RoundedRectangleBorder(
                                            //       side: BorderSide(
                                            //           color:
                                            //               Acolors.dark_bround,
                                            //           width: 0.9,
                                            //           style: BorderStyle.solid),
                                            //       borderRadius:
                                            //           BorderRadius.circular(5),
                                            //     ),
                                            //   ),
                                            // ),
                                            onPressed: checkout_done
                                                ? ('GeofenceStatus.exit' ==
                                                        geofenceStatus)
                                                    ? () async {
                                                        CK.inst.onhit_internet(
                                                            context, (value) {
                                                          Utils(context)
                                                              .startLoading();
                                                          upload_att(
                                                                  'StaffAttendance',
                                                                  'Check-Out')
                                                              .whenComplete(() {
                                                            if (checkin_out_resp
                                                                    .response
                                                                    .n ==
                                                                1) {
                                                              main_toast(
                                                                  checkin_out_resp
                                                                      .response
                                                                      .msg);
                                                              setState(() {
                                                                checkout_done =
                                                                    false;
                                                                attendance_staff_detail()
                                                                    .whenComplete(() =>
                                                                        Utils(context)
                                                                            .startLoading());
                                                                logout_time =
                                                                    _formatTime(
                                                                        DateTime
                                                                            .now());
                                                              });
                                                            } else {
                                                              main_toast(
                                                                  checkin_out_resp
                                                                      .response
                                                                      .msg);
                                                            }
                                                          });
                                                        });
                                                      }
                                                    : null
                                                : null,
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: mq.height * 0.01,
                                      ),
                                    ],
                                  )
                                : CircularProgressIndicator(),
                          )),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.04,
                      ),
                      Container(
                        child: stext('Attendance List', Acolors.black,
                            FontWeight.w500, 19),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.03,
                      ),
                      GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        primary: false,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 15,
                                mainAxisSpacing: 15,
                                childAspectRatio: 2.5),
                        itemCount: all_att_respo.staffattendanceslist.length,
                        itemBuilder: (context, index) {
                          var data = all_att_respo.staffattendanceslist[index];
                          return Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Acolors.dark_bround, width: 1.6),
                                borderRadius: BorderRadius.circular(6.0),
                              ),
                              // alignment: Alignment.center,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  stext(data.staffName, Acolors.dark_bround,
                                      FontWeight.w400, 15),
                                  //                   SizedBox(
                                  //   height: MediaQuery.of(context).size.height * 0.01,
                                  // ),

                                  stext('${data.hours} hrs : ${data.mins} min',
                                      Acolors.black, FontWeight.w400, 15),
                                ],
                              ));
                        },
                      ),
                    ])
              : Loading_screen()),
    );
  }

  String _formatTime(DateTime Time) {
    return DateFormat(' hh : mm a').format(Time);
  }

  login() {}

  Future<void> upload_att(String api_name, String status) async {
    final prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');
    final String id = prefs.getString('id');
    final uri = Uri.http(Fetch.insta.URL1, Fetch.insta.URL2 + api_name);
    String date = DateFormat('d MMM y').format(DateTime.now());
    String time = DateFormat('jm').format(DateTime.now());

    final responce = await http.post(uri, headers: {
      'Apikey': Fetch.insta.Common_apikey,
      'authToken': token + '-' + id,
    }, body: {
      "StaffId": id,
      "Date": date,
      "Time": time,
      "Status": status
    });
    log(responce.body);
    if (responce.statusCode == 200) {
      setState(() {
        checkin_out_resp = AttStaffdetail.fromJson(jsonDecode(responce.body));
      });
    } else if (responce.statusCode == 401) {
      Fetch.insta.expire_dialog(context);
    } else if (responce.statusCode == 500) {
      main_toast('Server Not responding ');
    } else {
      main_toast('Something went Wrong');
    }
  }
  // void _getTime() {
  //   final DateTime now = DateTime.now();
  //   final String formattedTime = _formatTime(now);
  //   final String formattedDate = _formatDate(now);
  //   setState(() {
  //     _timeString = formattedTime;
  //     _dataString = formattedDate;
  //     Fence.stat = Fence.main_status;
  //   });
  // }
  // String _formatTime(DateTime Time) {
  //   return DateFormat(' hh : mm : ss a').format(Time);
  // }
  // String _formatDate(DateTime date) {
  //   return DateFormat(' dd/MM/yyyy ').format(date);
  // }
  // void showmain_toast() {
  //   main_toast("Location does'nt Match");
  // }
  // void making_fence() {
  //   // 18.566115925965644, 73.7757569342892
  //   EasyGeofencing.startGeofenceService(
  //       pointedLatitude: "18.566115925965644",
  //       pointedLongitude: "73.7757569342892",
  //       radiusMeter: "100",
  //       eventPeriodInSeconds: 5);
  //   if (geofenceStatusStream == null) {
  //     log('${islistning.toString()} in function');
  //     geofenceStatusStream =
  //         EasyGeofencing.getGeofenceStream().listen((GeofenceStatus status) {
  //       print(status.toString());
  //       setState(() {
  //         geofenceStatus = status.toString();
  //       });
  //     });
  //   }
  // }

}
