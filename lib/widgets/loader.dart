import 'package:flutter/material.dart';
import 'package:awesome_loader/awesome_loader.dart';
import 'package:upcomming/color/colors.dart';

class Utils {
  BuildContext context;

  Utils(this.context);

  // this is where you would do your fullscreen loading
  Future<void> startLoading() async {
    return await showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return SimpleDialog(
          elevation: 0.0,
          backgroundColor:
              Colors.transparent, // can change this to your prefered color
          children: [
            AwesomeLoader(
              loaderType: AwesomeLoader.AwesomeLoader3,
              color: Acolors.orange,
            )
          ],
        );
      },
    );
  }

  Future<void> stopLoading() async {
    Navigator.of(context).pop();
  }

  Future<void> showError(Object error) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        action: SnackBarAction(
          label: 'Dismiss',
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
        backgroundColor: Colors.red,
        content: Text(error),
      ),
    );
  }
}
