import 'dart:io';

import 'package:awesome_loader/awesome_loader.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:responsive_flutter/responsive_flutter.dart';
import 'package:upcomming/color/colors.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:upcomming/responce/all_fetch.dart';
import 'package:upcomming/screens/home.dart';
import 'package:upcomming/screens/notifications.dart';
import 'package:upcomming/screens/outfit/addOutfits.dart';
import 'package:upcomming/screens/profile.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:image_picker/image_picker.dart';

TextFormField text_field(
  String hinttext,
  labeltext,
  TextInputType inputType,
  String sufff,
) {
  return TextFormField(
    // readOnly: true,
    keyboardType: inputType,
    textInputAction: TextInputAction.next,
    decoration: InputDecoration(
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Acolors.grey),
      ),
      hintText: hinttext,
      hintStyle: TextStyle(color: Acolors.grey, fontSize: 15),
      labelText: labeltext,
      labelStyle: TextStyle(color: Acolors.black, fontSize: 15),
      suffix: sufff != ''
          ? Text(
              sufff,
              style: TextStyle(fontSize: 13, color: Acolors.dark_bround),
            )
          : null,
      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
    ),
  );
}

main_toast(String msg) {
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Acolors.orange,
      textColor: Colors.white,
      fontSize: 14.0);
}

Widget field(String left, right) {
  return RichText(
    text: TextSpan(
      style: TextStyle(
        color: Colors.black,
        fontSize: 36,
      ),
      children: <TextSpan>[
        TextSpan(
          text: '${left} - ',
          style: GoogleFonts.quicksand(
            textStyle: TextStyle(
                letterSpacing: .5, fontSize: 25, fontWeight: FontWeight.w300),
          ),
        ),
        TextSpan(
            text: right,
            style: GoogleFonts.quicksand(
              textStyle: TextStyle(
                  letterSpacing: .5, fontSize: 25, fontWeight: FontWeight.w600),
            ))
      ],
    ),
    textScaleFactor: 0.5,
  );
}

Widget TextDeco(String left, right) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 2),
    child: Row(
      children: [
        Text(
          '${left} ',
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w300,
          ),
        ),
        Text("-"),
        Text(
          ' ${right}',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        )
      ],
    ),
  );
}

AppBar noTabAppBar(BuildContext context, String heading) {
  return AppBar(
    automaticallyImplyLeading: true,
    leading: IconButton(
        icon: Icon(Icons.arrow_back_ios, color: Acolors.dark_bround),
        onPressed: () => Navigator.pop(context)),
    title: Text(
      heading,
      style: TextStyle(color: Acolors.dark_bround),
    ),
    backgroundColor: Acolors.orange,
    elevation: 1,
    actions: [
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
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Notif()));
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
          onTap: (() => Navigator.push(
              context, MaterialPageRoute(builder: (context) => Profile()))),
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
  );
}

Widget addTaskFloatingbutton(
    BuildContext context, Icon icon, VoidCallback call) {
  return FloatingActionButton(
    onPressed: call,
    tooltip: 'Add Task',
    backgroundColor: Acolors.dark_bround,
    foregroundColor: Acolors.white,
    child: icon,
  );
}

Text stext(String content, Color col, FontWeight weight, double size) {
  return Text(
    content,
    style: TextStyle(color: col, fontSize: size, fontWeight: weight),
    // softWrap: true
    // overflow: TextOverflow.ellipsis,
  );
}

Text dec_text(BuildContext context, String content, Color col,
    FontWeight weight, double size) {
  return Text(
    content,
    style: TextStyle(
        fontWeight: weight,
        fontSize: ResponsiveFlutter.of(context).fontSize(size),
        color: col),
  );
}

void smallbottomsheet(BuildContext context, String msg, VoidCallback callback) {
  showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(10))),
      builder: (context) => SizedBox(
            height: MediaQuery.of(context).size.height * 0.32,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  CircleAvatar(
                      radius: 27,
                      backgroundColor: Colors.green,
                      child: Icon(
                        Icons.done_rounded,
                        color: Acolors.white,
                      )),
                  Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Text(
                      msg,
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.w300),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(400, 45),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                        ),
                        onPressed: callback,
                        child: Text('Done')),
                  )
                ],
              ),
            ),
          ));
}

void deletsmallbottomsheet(
    BuildContext context, String msg, final VoidCallback deleteaction) {
  showModalBottomSheet(
      elevation: 3,
      context: context,
      barrierColor: Color.fromARGB(143, 0, 0, 0),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(10))),
      builder: (context) => SizedBox(
            height: MediaQuery.of(context).size.height * 0.32,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                // shrinkWrap: true,
                // physics: const NeverScrollableScrollPhysics(),
                children: [
                  CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.red,
                      child: Icon(
                        Icons.delete_outline_rounded,
                        color: Acolors.white,
                        size: 27,
                      )),
                  Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Text(
                      "Delete ${msg}",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 14),
                    child: Text(
                      "Are you sure you want to delete ${msg}",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w300),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(150, 45),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                            ),
                            onPressed: deleteaction,
                            child: Text(
                              'Delete',
                            )),
                        ElevatedButton(
                            style: OutlinedButton.styleFrom(
                                foregroundColor: Acolors.dark_bround,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                minimumSize: const Size(150, 45),
                                backgroundColor: Acolors.white,
                                side: BorderSide(color: Acolors.dark_bround)),
                            onPressed: () {
                              Navigator.of(context).pop(); //to close the sheet
                              // Navigator.pop(context);
                            },
                            child: Text('Cancel'))
                      ],
                    ),
                  )
                ],
              ),
            ),
          ));
}
//

TextFormField edittextfiels(bool isedit, TextEditingController cont,
    String labetext, hinttext, TextInputType type) {
  return TextFormField(
      keyboardType: type,
      validator: RequiredValidator(errorText: 'required'),
      readOnly: isedit,
      autofocus: true,
      controller: cont,
      decoration: InputDecoration(
        focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Acolors.grey),
      ),
        hintText: hinttext,
        hintStyle: TextStyle(color: Acolors.grey, fontSize: 15),
        labelText: labetext,
        labelStyle: TextStyle(color: Acolors.black, fontSize: 15),
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      ));
}

TextFormField cltr_text_field(
    String txt, TextInputType inputType, final TextEditingController cltr) {
  return TextFormField(
    controller: cltr,
    validator: RequiredValidator(errorText: 'required'),
    keyboardType: inputType,
    textInputAction: TextInputAction.next,
    decoration: InputDecoration(
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Acolors.grey),
      ),
      hintText: txt,
      hintStyle: TextStyle(color: Acolors.grey, fontSize: 15),
      labelText: txt,
      labelStyle: TextStyle(color: Acolors.black, fontSize: 15),
      contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
    ),
  );
}

void imagepop(BuildContext context, ValueSetter callback1) {
  showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: const Text("From where do you want to take photo"),
            actions: [
              TextButton(
                onPressed: () {
                  pickImage(ImageSource.gallery, callback1);
                  Navigator.of(context).pop();
                },
                child: const Text("Gallery"),
              ),
              TextButton(
                onPressed: () {
                  pickImage(ImageSource.camera, callback1);

                  Navigator.of(context).pop();
                },
                child: const Text("Camera"),
              )
            ],
          ));
}

pickImage(ImageSource imageSource, ValueSetter callback2) async {
  var image =
      await ImagePicker().pickImage(source: imageSource).then((imgFile) async {
    if (imgFile == null) return;
    final imagtemppath = File(imgFile.path);
    callback2(imagtemppath);
  });
}

Widget Loading_screen() {
  return Scaffold(
      // backgroundColor: Color.fromARGB(131, 255, 255, 255),
      body: Center(
          child: AwesomeLoader(
    loaderType: AwesomeLoader.AwesomeLoader3,
    color: Acolors.orange,
  )));
  ;
}

Text res(
  BuildContext context,
  String cnt,
  double size,
  FontWeight weight,
  TextDirection dir,
) {
  return Text(
    cnt,
    // textScaleFactor: 1,
    // overflow: TextOverflow.ellipsis,
    textDirection: dir,
    style: TextStyle(
      fontSize: ResponsiveFlutter.of(context).fontSize(size),
      fontWeight: weight,
    ),
  );
}

Text numtxt(
  BuildContext context,
  String cnt,
  double size,
) {
  return Text(
    'INR  ' + cnt,
    textDirection: TextDirection.rtl,
    style: TextStyle(
      fontSize: ResponsiveFlutter.of(context).fontSize(size),
      fontWeight: FontWeight.normal,
      color: Acolors.black,
    ),
  );
}

CircleAvatar crv(String alfa, bool isselected) {
  return CircleAvatar(
    backgroundColor: isselected ?Acolors.light_orange: Acolors.dark_bround,
    radius: 13,
    child: CircleAvatar(
      radius: 12,
      backgroundColor: isselected ? Acolors.light_orange : Acolors.white,

      // backgroundColor: Acolors.white,
      child: Center(
          child: Text(
        alfa,
        style:
            TextStyle(color: isselected ? Acolors.white : Acolors.dark_bround),
      )),
    ),
  );
}
