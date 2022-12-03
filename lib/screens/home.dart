import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:upcomming/Model.dart/LogOut.dart';
import 'package:upcomming/Model.dart/mini_model/cat_list.dart';
import 'package:upcomming/color/colors.dart';
import 'package:upcomming/hardcore_Data/data.dart';
import 'package:upcomming/responce/all_fetch.dart';
import 'package:upcomming/responce/internetcheck.dart';
import 'package:upcomming/screens/Shoots.dart';
import 'package:upcomming/screens/SplashScreen.dart';
import 'package:upcomming/screens/Task/Task.dart';
import 'package:upcomming/screens/attendance/attendance.dart';
import 'package:upcomming/screens/availability/availability.dart';
import 'package:upcomming/screens/com_appbar.dart';
import 'package:upcomming/screens/notifications.dart';
import 'package:upcomming/screens/profile.dart';
import 'package:upcomming/screens/signin.dart';

import 'package:upcomming/widgets/common.dart';

import '../Model.dart/profile/staffdetail.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home();

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<LogOutModel> logout_mod;
  Staffdetail detail_resp;
  bool detail_bool = false;
  String image_var = " ";

  @override
  void initState() {
    super.initState();
    CK.inst.onhit_internet(context, (val) {
      if (val) {
        log('haseinternet');
        staff_detail();
      }
    });
  }

  Future<void> staff_detail() async {
    final prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');
    final String id = prefs.getString('id');

    final uri = Uri.http(Fetch.insta.URL1, Fetch.insta.URL2 + 'GetStaffDetails',
        {'StaffId': id});
    final responce = await http.get(uri, headers: {
      'Apikey': Fetch.insta.Common_apikey,
      'authToken': token + '-' + id,
    });
    print(responce.body);
    if (responce.statusCode == 200) {
      setState(() {
        detail_resp = Staffdetail.fromJson(jsonDecode(responce.body));
        detail_resp == null ? detail_bool = false : detail_bool = true;
        image_var = detail_resp.staffdetails.staffImageLink;
        Fetch.insta.final_image_link = image_var;
      });
    } else if (responce.statusCode == 401) {
      Fetch.insta.expire_dialog(context);
    } else if (responce.statusCode == 500) {
      main_toast('Server Not responding ');
    } else {
      main_toast('Something went Wrong');
    }
  }

  void name() {
    List<int> this_name = [];
    var chane = ',4,5,6,7,8,9';
    var lakjs = chane.replaceAll(RegExp(','), '');
    lakjs.runes.forEach((int rune) {
      var character = String.fromCharCode(rune);
      if (character != null) {
        this_name.add(double.parse(character).toInt());
      }
    });
    print(this_name);
  }

  @override
  Widget build(BuildContext context) {
    Size mq = MediaQuery.of(context).size;
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            getshareprefvalue();
            // name();
          },
        ),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            'Home',
            style: TextStyle(color: Acolors.dark_bround),
          ),
          backgroundColor: Acolors.orange,
          elevation: 1,
          actions: [
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
            // SizedBox(
            //   width: MediaQuery.of(context).size.width * 0.02,
            // ),
            IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            title: const Text("Are you sure want to log Out ?"),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    Fetch.insta.LogOut(context);
                                  });
                                },
                                child: const Text("Yes"),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text("No"),
                              )
                            ],
                          ));
                },
                icon: Icon(
                  Icons.logout_rounded,
                  color: Acolors.dark_bround,
                  size: 25,
                )),
            Padding(
              padding: EdgeInsets.only(right: 20),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Profile()));
                },
                child: CircleAvatar(
                    radius: 17,
                    backgroundImage: Fetch.insta.final_image_link == " "
                        ? NetworkImage(
                            'https://cdn-icons-png.flaticon.com/128/1144/1144709.png')
                        : NetworkImage(Fetch.insta.final_image_link)),

                // 'https://cdn-icons-png.flaticon.com/128/1144/1144709.png'
              ),
            )
          ],
        ),
        body: WillPopScope(
          onWillPop: () {
            Fetch.insta.go_exit_dialog(context);
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 100),
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 30,
                  mainAxisSpacing: 45,
                  childAspectRatio: 3),
              itemCount: 8,
              itemBuilder: (context, index) {
                var data = cat_list[index];
                var class_data = class_list[index];
                return graid_container(data, mq, class_data);
              },
            ),
          ),
        ));
  }

  Widget graid_container(catogory_data data, Size mq, dynamic moveto) {
    return InkWell(
      onTap: () => Navigator.push(
          context, MaterialPageRoute(builder: (context) => moveto)),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Acolors.dark_bround, width: 1.5),
          borderRadius: BorderRadius.circular(6.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: mq.height * 0.06,
              width: mq.width * 0.06,
              decoration: BoxDecoration(
                  image: DecorationImage(
                image: AssetImage(
                  data.image,
                ),
              )),
            ),
            SizedBox(
              width: mq.width * 0.03,
            ),
            dec_text(
                context, data.title, Acolors.dark_bround, FontWeight.w300, 1.8)
          ],
        ),
      ),
    );
  }

  void sharpreffsave(String id, roleid, mob_no, name, email, rolenname, Token,
      bool isinside) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('id', id);
    await prefs.setString('roleid', roleid);
    await prefs.setString('mob_no', mob_no);

    await prefs.setString('name', name);
    await prefs.setString('email', email);
    await prefs.setString('rolename', rolenname);
    await prefs.setString('token', Token);
    await prefs.setBool('isinside', isinside);
  }

  Future<void> getshareprefvalue() async {
    final prefs = await SharedPreferences.getInstance();

    final String token = prefs.getString('token');
    final String id = prefs.getString('id');
    final String name = prefs.getString('name');
    final String email = prefs.getString('email');
    final String rolenmae = prefs.getString('rolename');
    final String mob = prefs.getString('mob_no');
    final String roleid = prefs.getString('roleid');
    final bool isinside = prefs.getBool('isinside');
    print(token +
        '\n' +
        id +
        '\n' +
        name +
        '\n' +
        email +
        '\n' +
        rolenmae +
        '\n' +
        mob +
        '\n' +
        roleid +
        '\n' +
        isinside.toString());
  }

  removevalue() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('id');
    await prefs.remove('name');
    await prefs.remove('email');
    await prefs.remove('rolename');
    await prefs.remove('mob_no');
    await prefs.remove('roleid');
    await prefs.remove('isinside');

    print(" clear");
    save_var.insta.Men = null;
    save_var.insta.women = null;
    save_var.insta.package = null;
  }
}
