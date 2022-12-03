import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:upcomming/Model.dart/mini_model/baseModel.dart';
import 'package:upcomming/Model.dart/props/detailprops.dart';

import 'package:upcomming/color/colors.dart';
import 'package:upcomming/responce/all_fetch.dart';
import 'package:upcomming/screens/notifications.dart';
import 'package:upcomming/widgets/common.dart';
import 'package:upcomming/Model.dart/mini_model/cat_list.dart';
import 'package:http/http.dart' as http;

import '../home.dart';

class showProrps extends StatefulWidget {
  final PropList data;
  final String cat_name;

  showProrps({this.data, this.cat_name});

  @override
  State<showProrps> createState() => _showProrpsState();
}

class _showProrpsState extends State<showProrps> {
  bool isedit = true;
  TextEditingController prop_name;
  TextEditingController prop_price;
  String imageurl;
  String dropdownvalue;
  List<String> category;
  List<int> category_id;
  File _image;
  int isimage;
  int single_id;
  bool onbutton_Loader = false;
  GlobalKey<FormState> showpropgkey = GlobalKey<FormState>();
  BaseM responcee;
  BaseM deletrespomce;
  bool delete_loading = false;

  @override
  void initState() {
    super.initState();
    prop_name = TextEditingController(text: widget.data.propName);
    prop_price = TextEditingController(text: widget.data.price);
    imageurl = widget.data.thmbnailLink;
    category = List<String>.generate(save_var.insta.props_category.length,
        (index) => save_var.insta.props_category[index].name);
    category_id = List<int>.generate(save_var.insta.props_category.length,
        (index) => save_var.insta.props_category[index].id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
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
      bottomSheet: showdetail(),
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
                // isedit == false
                //     ? Positioned(
                //         left: 320,
                //         top: 180,
                //         child: FloatingActionButton(
                //             onPressed: () {
                //               imagepop(context, (seletedimage) {
                //                 setState(() {
                //                   _image = seletedimage;
                //                 });
                //               });
                //             },
                //             tooltip: 'Add Task',
                //             backgroundColor: Acolors.dark_bround,
                //             foregroundColor: Acolors.white,
                //             child: const Icon(
                //               Icons.add_photo_alternate_outlined,
                //               size: 30,
                //             )),
                //       )
                //     : Container()
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
              //       showProrps();
              //     });
              //   },
              //   icon: Icon(Icons.check),
              // ),
              IconButton(
                onPressed: () {
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
  }

  Widget showdetail() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      width: MediaQuery.of(context).size.width * 1,
      child: Padding(
        padding: const EdgeInsets.only(left: 18, right: 18, top: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
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
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.03,
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      deletsmallbottomsheet(context, 'Prop', () {
                        delete_loading = true;
                        deletprop(widget.data.propId.toString())
                            .whenComplete(() {
                          if (deletrespomce.response.n == 1) {
                            main_toast(deletrespomce.response.msg);
                            delete_loading = false;
                            Navigator.of(context).pop(); //to close the sheet
                            // Navigator.pop(context);
                            Navigator.pop(
                                context); // to navigate to the prevoiuse page
                          } else {
                            delete_loading = false;
                            Navigator.of(context).pop();
                            main_toast(deletrespomce.response.msg);
                          }
                        });
                      });
                    });
                  },
                  icon: Icon(
                    Icons.delete,
                    color: Acolors.dark_bround,
                  ),
                ),
              ],
            ),
            Form(
              key: showpropgkey,
              autovalidateMode: AutovalidateMode.disabled,
              child: Column(
                children: [
                  edittextfiels(isedit, prop_name, "Prop Name",
                      'Enter Prop Name', TextInputType.text),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: DropdownButtonFormField2<String>(
                      itemPadding: EdgeInsets.only(left: 10),
                      dropdownMaxHeight: 200,
                      dropdownDecoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      validator: (value) =>
                          value == null ? 'field required' : null,
                      value: dropdownvalue,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: category.map((String items) {
                        return DropdownMenuItem(
                          value: items,
                          child: Text(items),
                        );
                      }).toList(),
                      isExpanded: true,
                      isDense: true,
                      hint: Text(widget.cat_name,
                          style: TextStyle(color: Acolors.black, fontSize: 15)),
                      onChanged: isedit == false
                          ? (String newValue) {
                              setState(() {
                                dropdownvalue = newValue;
                                for (var i = 0; i < category.length; i++) {
                                  if (category[i] == dropdownvalue) {
                                    log(i.toString());
                                    single_id = category_id[i];
                                  }
                                }
                              });
                            }
                          : null,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: edittextfiels(isedit, prop_price, "Description",
                        'Enter Description', TextInputType.text),
                  ),
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
                        padding: const EdgeInsets.only(bottom: 30),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(400, 50),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                          ),
                          child: onbutton_Loader
                              ? SizedBox(
                                  height: 25,
                                  width: 25,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                        color: Acolors.white, strokeWidth: 2),
                                  ),
                                )
                              : Text('Save'),
                          onPressed: () {
                            setState(() {
                              _image == null ? isimage = 0 : isimage = 1;

                              if (showpropgkey.currentState.validate()) {
                                onbutton_Loader = true;
                                Updatedstaff_detail(
                                        single_id.toString(),
                                        prop_name.text.toString(),
                                        widget.data.propId.toString(),
                                        prop_price.text.toString())
                                    .whenComplete(() {
                                  if (responcee.response.n == 1) {
                                    onbutton_Loader = false;
                                    smallbottomsheet(
                                        context, 'Details Updated Sucessfully',
                                        () {
                                      Navigator.of(context)
                                          .pop(); //to close the sheet
                                      // Navigator.pop(context);
                                      Navigator.pop(context);
                                      // to navigate to the prevoiuse page
                                    });
                                  } else {
                                    main_toast('Some thing went wrong');
                                  }
                                });
                              }
                            });
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

  Future<void> Updatedstaff_detail(
      String propcategoryid, propname, propid, propdisp) async {
    final prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');
    final String id = prefs.getString('id');
    var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://' +
            Fetch.insta.URL1 +
            Fetch.insta.URL2 +
            'StaffUpdatePropsDetails'));
    log(request.url.toString());
    request.headers['Apikey'] = Fetch.insta.Common_apikey;
    request.headers['authToken'] = token + '-' + id;
    request.fields['PropCategoryId'] = propcategoryid;
    request.fields['PropName'] = propname;
    request.fields['StaffId'] = id;
    isimage == 1
        ? (request.files.add(http.MultipartFile.fromBytes(
            'PropImage', File(_image.path).readAsBytesSync(),
            filename: _image.path)))
        : null;
    request.fields['PropId'] = propid;
    request.fields['PropDescription'] = propdisp;

    var res =
        await request.send(); //rest is stream responce converto  responce type
    var response = await http.Response.fromStream(res);
    log(response.body);

    if (response.statusCode == 200) {
      setState(() {
        responcee = BaseM.fromJson(jsonDecode(response.body));
      });
    } else if (response.statusCode == 401) {
      Fetch.insta.expire_dialog(context);
    } else if (response.statusCode == 500) {
      main_toast('Server Not responding ');
    } else {
      main_toast('Something went Wrong');
    }
  }

  Future<void> deletprop(String propid) async {
    final prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');
    final String id = prefs.getString('id');
    final uri = Uri.http(
        Fetch.insta.URL1, Fetch.insta.URL2 + 'StaffDeletePropsDetails');

    final responce = await http.post(uri, headers: {
      'Apikey': Fetch.insta.Common_apikey,
      'authToken': token + '-' + id,
    }, body: {
      "PropId": propid
    });
    log(responce.body);
    if (responce.statusCode == 200) {
      setState(() {
        deletrespomce = BaseM.fromJson(jsonDecode(responce.body));
      });
    } else if (responce.statusCode == 401) {
      Fetch.insta.expire_dialog(context);
    } else if (responce.statusCode == 500) {
      main_toast('Server Not responding ');
    } else {
      main_toast('Something went Wrong');
    }
  }
}
