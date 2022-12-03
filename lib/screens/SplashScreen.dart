import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:upcomming/color/colors.dart';
import 'package:upcomming/screens/signin.dart';
import 'package:upcomming/widgets/common.dart';
import 'package:upcomming/Model.dart/mini_model/cat_list.dart';
import 'home.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen();

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    timer_redirect();
    // splash();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[BlendImageBG(), Overlap(context)],
      ),
    );
  }

  Widget BlendImageBG() {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('lib/assets/splashscreen.png'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(Colors.black45, BlendMode.darken)),
      ),
    );
  }

  Widget Overlap(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 110),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.2,
                width: MediaQuery.of(context).size.width * 0.5,
                // color: Acolors.grey,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('lib/assets/logo.png'))),
              ),
            ),
            Container(
                child: Center(
                    child: Text(
              'Version : 1.0.1',
              style: TextStyle(color: Acolors.white, fontSize: 16),
            )))
          ],
        ),
      ),
    );
  }

  timer_redirect() async {
    final getpref = await SharedPreferences.getInstance();
    var token = await getpref.getString('token');

    Timer(Duration(seconds: 2), () {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => token == null ? SignIn() : Home()));
    });
  }
}
