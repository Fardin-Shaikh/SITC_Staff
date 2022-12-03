import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:overlay_support/overlay_support.dart';

class CK {
  static final CK inst = CK._init();
  CK._init();
  Future<void> internet(BuildContext context, ValueSetter maincallback) async {
    var hasinternet = false;
    hasinternet = await InternetConnectionChecker().hasConnection;
    maincallback(hasinternet);
    if (hasinternet == false) {
      showSimpleNotification(Text('check internet conection'),
          background: Colors.red);
      Navigator.of(context).pop();
    }
  }

  Future<void> onhit_internet(
      BuildContext context, ValueSetter maincallback) async {
    var hasinternet = false;
    hasinternet = await InternetConnectionChecker().hasConnection;
    maincallback(hasinternet);
    if (hasinternet == false) {
      showSimpleNotification(Text('No Internet Connection'),
          background: Colors.red);
    }
  }
}
