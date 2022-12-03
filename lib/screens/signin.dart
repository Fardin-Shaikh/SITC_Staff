import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';
import 'package:http/http.dart' as http;
import 'package:upcomming/Model.dart/Logindetails.dart';
import 'package:upcomming/Model.dart/mini_model/cat_list.dart';
import 'package:upcomming/Model.dart/otpGenModel.dart';
import 'package:upcomming/color/colors.dart';
import 'package:upcomming/responce/all_fetch.dart';
import 'package:upcomming/responce/internetcheck.dart';

import 'package:upcomming/screens/home.dart';
import 'package:upcomming/widgets/common.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:upcomming/widgets/loader.dart';

class SignIn extends StatefulWidget {
  const SignIn();

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final Mob_validation = MultiValidator([
    MinLengthValidator(10, errorText: 'Enter valid number'),
  ]);
  final otp_validation = MultiValidator([
    MinLengthValidator(5, errorText: 'Enter valid otp'),
  ]);
  GlobalKey<FormState> mobkey = GlobalKey<FormState>();
  GlobalKey<FormState> otpkey = GlobalKey<FormState>();
  TextEditingController numbercltr = TextEditingController();
  TextEditingController otpcltr = TextEditingController();
  final CountdownController _controller = CountdownController();
  bool show_resendotp = false;
  bool number_read_only = false;
  String image_1;
  OtpGenrate check;
  LoginDetails bypass;
  UserDetails data;
  bool showbutton = false;
  bool readOnly_otp = true;

  @override
  void dispose() {
    super.dispose();
    _controller.isCompleted;
    numbercltr.dispose();
    otpcltr.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // resizeToAvoidBottomInset: false,
        // floatingActionButton: FloatingActionButton(onPressed: () async {
        //   final prefs = await SharedPreferences.getInstance();
        //   final String token = prefs.getString('token');
        //   final String id = prefs.getString('id');
        // }),
        bottomSheet: signinUi(),
        body: Stack(
          children: <Widget>[
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('lib/assets/splashscreen.png'),
                    fit: BoxFit.cover,
                    colorFilter:
                        ColorFilter.mode(Colors.black45, BlendMode.darken)),
              ),
            ),
            Positioned(
              top: 110,
              left: 124,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.17,
                width: MediaQuery.of(context).size.width * 0.35,
                // color: Acolors.grey,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('lib/assets/logo.png'))),
              ),
            )
          ],
        ));
  }

  void show_bottomsheet() {
    Future.delayed(Duration(seconds: 0), () {
      showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          enableDrag: false,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
          builder: (context) => signinUi());
    });
  }

  Widget signinUi() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.65,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 35),
        child: ListView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            Text(
              "Let's Sign In",
              style: TextStyle(
                  color: Acolors.dark_bround,
                  fontWeight: FontWeight.bold,
                  fontSize: 24),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.5,
              child: Divider(
                thickness: 2,
                color: Acolors.dark_bround,
                height: 10,
                endIndent: 20,
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.04,
            ),
            Form(
              autovalidateMode: AutovalidateMode.disabled,
              key: mobkey,
              child: TextFormField(
                inputFormatters: [
                  LengthLimitingTextInputFormatter(10),
                ],
                onChanged: (value) {
                  setState(() {
                    print(value);
                    (value == null || value == '')
                        ? showbutton = false
                        : showbutton = true;
                  });
                },
                readOnly: number_read_only,
                controller: numbercltr,
                validator: Mob_validation,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(0),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Acolors.black, width: 1),
                  ),
                  hintText: 'Enter Mobile Number',
                  hintStyle: TextStyle(color: Acolors.black, fontSize: 15),
                  labelText: 'Mobile Number',
                  labelStyle: TextStyle(color: Acolors.black, fontSize: 15),
                  suffix: (showbutton)
                      ? number_read_only
                          ? null
                          : TextButton(
                              child: Text(
                                'Send OTP',
                                style: TextStyle(
                                    fontSize: 13, color: Acolors.dark_bround),
                              ),
                              onPressed: () {
                                if (mobkey.currentState.validate()) {
                                  CK.inst.onhit_internet(context,
                                      (value) async {
                                    Utils(context).startLoading();
                                    otpgen(numbercltr.text.toString())
                                        .whenComplete(() {
                                      Utils(context).stopLoading();
                                      main_toast(check.response.msg.toString());
                                      if (check.response.n == 1) {
                                        setState(() {
                                          print('start timer ');
                                          number_read_only = true;
                                          readOnly_otp = false;
                                          print('number_read_only = true');
                                        });
                                        _controller.start();
                                      } else {}
                                    });
                                  });
                                } else {
                                  main_toast('Enter Valid Number ');
                                }
                              },
                            )
                      : null,
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.04,
            ),
            Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              key: otpkey,
              child: TextFormField(
                readOnly: readOnly_otp,
                controller: otpcltr,
                validator: otp_validation,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(5),
                ],
                decoration: InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Acolors.grey),
                  ),
                  hintText: 'Enter One Time Password',
                  hintStyle: TextStyle(color: Acolors.grey, fontSize: 15),
                  labelText: 'One Time Password',
                  labelStyle: TextStyle(color: Acolors.black, fontSize: 15),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Container(
                height: MediaQuery.of(context).size.height * 0.04,
                width: MediaQuery.of(context).size.width * 0.9,
                // color:Color.fromARGB(125, 46, 181, 115),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // ElevatedButton.icon(onPressed: (){
                    //   _controller.start();
                    // }, icon: Icon(Icons.abc), label: Text('data'))

                    show_resendotp
                        ? TextButton(
                            child: Text(
                              'Resend OTP',
                              style: TextStyle(
                                  fontSize: 13, color: Acolors.dark_bround),
                            ),
                            onPressed: () {
                              if (mobkey.currentState.validate()) {
                                CK.inst.onhit_internet(context, (value) async {
                                  Utils(context).startLoading();
                                  otpgen(numbercltr.text.toString())
                                      .whenComplete(() {
                                    Utils(context).stopLoading();
                                    main_toast(check.response.msg.toString());
                                    if (check.response.n == 1) {
                                      setState(() {
                                        print('start timer ');
                                        number_read_only = true;
                                        print('number_read_only = true');
                                      });
                                      _controller.restart();
                                    } else {
                                      main_toast(check.response.msg);
                                    }
                                  });
                                });
                              } else {
                                main_toast('Enter Valid Number');
                              }
                            },
                          )
                        : Countdown(
                            controller: _controller,
                            seconds: 60,
                            build: (_, double time) => number_read_only == false
                                ? Container()
                                : Text(
                                    time.toInt().toString() + ' Sec',
                                    style: TextStyle(
                                        // fontSize: 10,
                                        ),
                                  ),
                            interval: const Duration(seconds: 1),
                            onFinished: () {
                              setState(() {
                                show_resendotp = true;
                              });
                            },
                          )
                  ],
                )),
            Padding(
              padding: const EdgeInsets.only(top: 55),
              child: ElevatedButton(
                onPressed: () async {
                  if (mobkey.currentState.validate() &&
                      otpkey.currentState.validate()) {
                    Utils(context).startLoading();
                    CK.inst.onhit_internet(context, (value) async {
                      getLoginDetails(numbercltr.text.toString(),
                              otpcltr.text.toString())
                          .whenComplete(() {
                        Utils(context).stopLoading();
                        if (bypass.response.n == 1) {
                          main_toast(bypass.response.msg);
                          setState(() {
                            _controller.pause();
                            data = bypass.userDetails;
                            sharpreffsave(
                                data.id.toString(),
                                data.roleId,
                                data.mobile,
                                data.name,
                                data.emailId,
                                data.roleName,
                                bypass.token,
                                true);
                            Fetch.insta.final_image_link =
                                bypass.userDetails.imageLink;
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Home()));
                          });
                        } else if (bypass.response.n == 0) {
                          Utils(context).stopLoading();
                          main_toast(bypass.response.msg);
                        } else {
                          main_toast('sdfghjk');
                        }
                      });
                    });
                  }
                },
                child: const Text("Sign In"),
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Acolors.dark_bround),
                    foregroundColor: MaterialStateProperty.all(Acolors.white)),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> getLoginDetails(
    String number,
    String otp,
  ) async {
    final uri = Uri.http(
        Fetch.insta.URL1,
        Fetch.insta.URL2 + 'StaffVerifyOtpAndLogin',
        {'MobileNo': number, 'otp': otp, 'FcmId': ''});
    final responce =
        await http.get(uri, headers: {'Apikey': Fetch.insta.Common_apikey});
    log(responce.body);
    log(responce.statusCode.toString());
    if (responce.statusCode == 200) {
      setState(() {
        bypass = LoginDetails.fromJson(jsonDecode(responce.body));
      });
    } else if (responce.statusCode == 500) {
      main_toast('Server Not responding ');
    } else {
      main_toast('Something went Wrong');
    }
  }

  Future<void> otpgen(String number) async {
    final uri = Uri.http(Fetch.insta.URL1,
        Fetch.insta.URL2 + 'StaffCheckMobileAndSendOtp', {'MobileNo': number});
    final responce =
        await http.get(uri, headers: {'Apikey': Fetch.insta.Common_apikey});
    log(responce.body);
    if (responce.statusCode == 200) {
      setState(() {
        check = OtpGenrate.fromJson(jsonDecode(responce.body));
      });
    } else {
      main_toast('some thing went wrong ');
    }
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

  void getshareprefvalue() async {
    final prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');
    final String id = prefs.getString('id');
    final String name = prefs.getString('name');
    final String email = prefs.getString('email');
    final String rolenmae = prefs.getString('rolename');
    final String mob = prefs.getString('mob_no');
    final String roleid = prefs.getString('roleid');
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
        roleid);
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
    print("clear everyting ");
  }
}
