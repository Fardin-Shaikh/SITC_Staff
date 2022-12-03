import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:upcomming/Model.dart/profile/staffdetail.dart';
import 'package:upcomming/color/colors.dart';
import 'package:upcomming/responce/all_fetch.dart';
import 'package:upcomming/responce/internetcheck.dart';
import 'package:upcomming/screens/home.dart';
import 'package:upcomming/screens/notifications.dart';
import 'package:upcomming/widgets/common.dart';

// check this
class Profile extends StatefulWidget {
  const Profile();

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool isedit = true;
  TextEditingController name;
  TextEditingController email;
  TextEditingController mobnumber;

  TextEditingController pancard;
  TextEditingController adharcard;
  TextEditingController emg_mob_name;
  TextEditingController emg_mob_no;
  String imageurl;

  Staffdetails detail;
  File _image;
  Future<Staffdetail> Updated_data;
  GlobalKey<FormState> text_key = GlobalKey<FormState>();

  int isimage;

  @override
  void initState() {
    super.initState();
    CK.inst.internet(context, (val) {
      if (val) {
        log('haseinternet');
        Fetch.insta.staff_detail(context).whenComplete(() {
          setState(() {
            var init = Fetch.insta.user;
            if (init.response.n == 1) {
              name = TextEditingController(text: init.staffdetails.staffName);
              email =
                  TextEditingController(text: init.staffdetails.staffEmailId);
              mobnumber =
                  TextEditingController(text: init.staffdetails.staffMobileNo);
              pancard = TextEditingController(
                  text: init.staffdetails.staffPanCard ?? 'No Detail');
              adharcard = TextEditingController(
                  text: init.staffdetails.staffAadharCard ?? 'No Detail');
              emg_mob_name = TextEditingController(
                  text: init.staffdetails.staffEmergencyContactName);
              emg_mob_no = TextEditingController(
                  text: init.staffdetails.staffEmergencyContactNo);
              imageurl = init.staffdetails.staffImageLink;
            } else {
              main_toast(init.response.msg);
            }
          });
        });
      }
    });
  }

  void give_val_to_control(Staffdetails detail) {}

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return Scaffold(
        floatingActionButton: isedit == false
            ? Container(
                height: MediaQuery.of(context).size.height * 0.12,
                width: MediaQuery.of(context).size.width * 0.12,
                child: FloatingActionButton(
                  tooltip: 'Add Image',
                  backgroundColor: Acolors.dark_bround,
                  foregroundColor: Acolors.white,
                  child: const Icon(
                    Icons.add_photo_alternate_outlined,
                    size: 25,
                  ),
                  onPressed: () {
                    imagepop(context, (seletedimage) {
                      setState(() {
                        _image = seletedimage;
                      });
                    });
                  },
                ),
              )
            : null,
        resizeToAvoidBottomInset: false,
        bottomSheet: PersonalDetail(),
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Acolors.light_grey,
              expandedHeight: 400,
              floating: true,
              // pinned: true,
              flexibleSpace: Stack(
                children: [
                  FlexibleSpaceBar(
                    background: _image == null
                        ? (imageurl == null
                            ? Image.network(
                                'https://cdn-icons-png.flaticon.com/512/3135/3135715.png',
                                fit: BoxFit.cover,
                              )
                            : Image.network(
                                imageurl,
                                // 'https://source.unsplash.com/random?monochromatic+dark',
                                fit: BoxFit.cover,
                              ))
                        : Image.file(
                            _image,
                            fit: BoxFit.cover,
                          ),
                  ),
                ],
              ),

              leading: IconButton(
                onPressed: () {
                  setState(() {
                    Navigator.of(context).pop();
                  });
                },
                icon: Icon(Icons.arrow_back_ios),
              ),
              actions: [
                // IconButton(
                //   onPressed: () {
                //     setState(() {
                //       Profile();
                //     });
                //   },
                //   icon: Icon(Icons.check),
                // ),
                IconButton(
                  onPressed: () {
                    // Navigator.pushNamed(context, '/home');
                Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => Home()),
            (route) => false);

                  },
                  icon: Icon(Icons.home_outlined),
                ),
                IconButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Notif()));
                    },
                    icon: Icon(Icons.notifications_none_sharp)),
                // SizedBox(width: 25),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget PersonalDetail() {
    return Container(
      // color: Colors.pink[200],
      height: MediaQuery.of(context).size.height * 0.7,
      width: MediaQuery.of(context).size.width * 1,
      // color: Color.fromARGB(255, 211, 151, 195),
      child: Padding(
        padding: const EdgeInsets.only(left: 18, right: 18, top: 25),
        child: ListView(
          // shrinkWrap: true,
          // physics: const NeverScrollableScrollPhysics(),
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                stext("Personal Details", Acolors.dark_bround, FontWeight.w600,
                    16),
                IconButton(
                  onPressed: () {
                    setState(() {
                      isedit = false;
                    });
                  },
                  icon: Icon(
                    Icons.edit_outlined,
                    color: Acolors.dark_bround,
                  ),
                )
              ],
            ),
            Form(
              key: text_key,
              autovalidateMode: AutovalidateMode.disabled,
              child: Column(
                children: [
                  edittextfiels(isedit, name, "Full Name ", 'Enter Name ',
                      TextInputType.text),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: edittextfiels(isedit, email, "Email Id",
                        'Enter Email ', TextInputType.emailAddress),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: edittextfiels(isedit, mobnumber, "Mobile Number",
                          'Enter Number', TextInputType.number)),
                  Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: edittextfiels(isedit, emg_mob_name,
                          "Emergency Name", 'Enter Name', TextInputType.text)),
                  Padding(
                      padding: const EdgeInsets.only(
                        top: 20,
                      ),
                      child: edittextfiels(
                          isedit,
                          emg_mob_no,
                          "Emergency Number",
                          'Enter Number',
                          TextInputType.number)),
                  Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: show_textfield(true, pancard, "Pancard Number",
                          'Enter Pan Number', TextInputType.number)),
                  Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 20),
                      child: show_textfield(true, adharcard, "Aadhar Number",
                          'Enter Number', TextInputType.number)),
                ],
              ),
            ),
            isedit
                ? Container()
                : Expanded(
                    child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20, bottom: 30),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(400, 40),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                          ),
                          child: const Text('Save'),
                          onPressed: () {
                            _image == null ? isimage = 0 : isimage = 1;

                            if (text_key.currentState.validate()) {
                              Updated_data = Fetch.insta.Updatedstaff_detail(
                                  name.text.toString(),
                                  email.text.toString(),
                                  mobnumber.text.toString(),
                                  emg_mob_name.text.toString(),
                                  emg_mob_no.text.toString(),
                                  _image,
                                  isimage,
                                  context);

                              smallbottomsheet(
                                  context, 'Details Updated Sucessfully', () {
                                Navigator.of(context)
                                    .pop(); //to close the sheet
                                // Navigator.pop(context);
                                Navigator.pop(context);
                                // to navigate to the prevoiuse page
                              });
                            }
                          },
                        ),
                      )
                    ],
                  ))
          ],
        ),
      ),
    );
  }

  TextFormField show_textfield(bool isedit, TextEditingController cont,
      String labetext, hinttext, TextInputType type) {
    return TextFormField(
        keyboardType: type,
        readOnly: isedit,
        autofocus: false,
        controller: cont,
        decoration: InputDecoration(
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Acolors.grey),
          ),
          hintText: hinttext,
          hintStyle: TextStyle(color: Acolors.grey, fontSize: 15),
          labelText: labetext,
          labelStyle: TextStyle(color: Acolors.black, fontSize: 15),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
        ));
  }

  @override
  void dispose() {
    super.dispose();
    name.dispose();
    email.dispose();
    emg_mob_name.dispose();
    emg_mob_no.dispose();
  }
}
