import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:upcomming/color/colors.dart';
import 'package:upcomming/widgets/common.dart';

class Parent_AppBar extends StatelessWidget {
  final String head_title;
  const Parent_AppBar({     this.head_title});
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Acolors.dark_bround),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          head_title,
          style: TextStyle(color: Acolors.dark_bround),
        ),
        backgroundColor: Acolors.orange,
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () {
                main_toast('Tap working ');
              },
              icon: Icon(
                Icons.notifications_none_sharp,
                color: Acolors.dark_bround,
                size: 25,
              )),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.02,
          ),
          const Padding(
            padding: EdgeInsets.only(right: 20),
            child: CircleAvatar(
              radius: 17,
              backgroundImage: AssetImage('lib/assets/profile.png'),
            ),
          )
        ],
      ),
    );
  }
}
