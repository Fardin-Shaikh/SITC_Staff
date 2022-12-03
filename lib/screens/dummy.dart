import 'dart:async';

import 'package:flutter/material.dart';
import 'package:upcomming/widgets/common.dart';

import '../widgets/loader.dart';

class CommingSoon extends StatefulWidget {
  final String title;

  const CommingSoon({this.title});

  @override
  State<CommingSoon> createState() => _CommingSoonState();
}

class _CommingSoonState extends State<CommingSoon> {
  @override
  void initState() {
    super.initState();
    
  }

  Widget build(BuildContext context) {
    
    return Scaffold(
        backgroundColor: Colors.amber,
        // bottomSheet: Container(

        //   child: Container(
        //     height: MediaQuery.of(context).size.height*0.3,
        //     child: Column(
        //       mainAxisAlignment: MainAxisAlignment.end,
        //       children: [
        //         Text('fardin'),
        //       ],
        //     ),
        //   ),
        // ),
        appBar: noTabAppBar(context, widget.title),
        body: Center(
          child: ElevatedButton(
              onPressed: () {
                Utils(context).startLoading();
                Timer(Duration(seconds: 3), () {
                  Utils(context).stopLoading();
                });
              },
              child: Text('check')),
        ));
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String dropdownvalue = 'Apple';

  var items = [
    'Apple',
    'Banana',
    'Grapes',
    'Orange',
    'watermelon',
    'Pineapple'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("DropDownButton"),
                Container(
                  height: 40,
                  padding: EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.0),
                    border: Border.all(
                        color: Colors.grey,
                        style: BorderStyle.solid,
                        width: 0.80),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                      elevation: 0,
                      value: dropdownvalue,
                      icon: Icon(Icons.keyboard_arrow_down),
                      items: items.map((String items) {
                        return DropdownMenuItem(
                            value: items, child: Text(items));
                      }).toList(),
                      onChanged: (String newValue) {
                        setState(() {
                          dropdownvalue = newValue;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
