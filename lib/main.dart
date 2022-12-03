import 'dart:developer';

import 'package:easy_geofencing/easy_geofencing.dart';
import 'package:easy_geofencing/enums/geofence_status.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:upcomming/color/colors.dart';
import 'package:upcomming/screens/SplashScreen.dart';
import 'package:upcomming/screens/Task/Task.dart';
import 'package:upcomming/screens/Task/assignTask.dart';
import 'package:upcomming/screens/Task/showTask.dart';
import 'package:upcomming/screens/home.dart';
import 'package:upcomming/screens/signin.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:upcomming/screens/testscreen.dart';

Future<void> backgroundHandler(RemoteMessage message) async {
  print(message.data.toString());
  print(message.notification.title);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp();

  @override
  Widget build(BuildContext context) {
    double scale;
    return ScreenUtilInit(
        designSize: Size(360, 760),
        builder: (context, child) {
          return OverlaySupport.global(
            child: MaterialApp(
              title: 'SITC STAFF',
              debugShowCheckedModeBanner: false,
              // initialRoute: '/',
              routes: {
                '/home': (context) => const Home(),
                '/home/task': (context) => const Tasks(),
                '/home/task/add_task': (context) => const AssignTask(),
                '/home/task/show_task': (context) => const showTask(),
                'testPage': (context) => const MyWidget()
              },
              theme: ThemeData(
                // textTheme: GoogleFonts.quicksandTextTheme(),
                bottomSheetTheme: const BottomSheetThemeData(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(30))),
                ),
                colorScheme:
                    ColorScheme.light().copyWith(primary: Acolors.dark_bround),
              ),
              home: SplashScreen(),

              builder: (context, child) {
                return MediaQuery(
                  child: child,
                  data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
                );
              },
            ),
          );
        });
  }
}
