import 'dart:convert';
import 'dart:developer';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:upcomming/color/colors.dart';
import 'package:upcomming/hardcore_Data/data.dart';
import 'package:upcomming/responce/all_fetch.dart';
import 'package:upcomming/screens/outfit/Outfits.dart';
import 'package:upcomming/screens/signin.dart';
import 'package:upcomming/widgets/common.dart';
import 'package:upcomming/Model.dart/mini_model/cat_list.dart';
import 'package:http/http.dart' as http;
import 'package:upcomming/widgets/test.dart';

import '../../Model.dart/mini_model/baseModel.dart';

class addProp extends StatefulWidget {
  const addProp();

  @override
  State<addProp> createState() => _addPropState();
}

class _addPropState extends State<addProp> {
  File _image;
  String dropdownvalue;
  TextEditingController propname = TextEditingController();
  TextEditingController discreptioin = TextEditingController();
  List<String> category;
  List<int> category_id;
  int single_id;
  bool onbutton_Loader = false;
  GlobalKey<FormState> addpropgkey = GlobalKey<FormState>();
  bool isimage = false;
  BaseM responcee;
  @override
  void initState() {
    super.initState();
    category = List<String>.generate(save_var.insta.props_category.length,
        (index) => save_var.insta.props_category[index].name);
    category_id = List<int>.generate(save_var.insta.props_category.length,
        (index) => save_var.insta.props_category[index].id);
  }

  @override
  Widget build(BuildContext context) {
    Size mq = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton: Container(
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
      ),
      appBar: noTabAppBar(context, 'Add Props'),
      bottomSheet: addPropbottomsheet(),
      body: Column(
        children: [
          _image != null
              ? Stack(
                  children: [
                    Container(
                      height: mq.height * 0.35,
                      width: mq.width * 1,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: FileImage(_image), fit: BoxFit.cover),
                      ),
                    ),
                  ],
                )
              : GestureDetector(
                  onTap: () async {
                    imagepop(context, (value) {
                      setState(() {
                        _image = value;
                      });
                    });
                  },
                  child: Container(
                    height: mq.height * 0.35,
                    width: mq.width * 1,
                    color: Acolors.addphotogrey,
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_photo_alternate_outlined,
                          size: 170,
                          color: Acolors.icongrey,
                        ),
                        Text("Add Image",
                            style: TextStyle(
                              color: Acolors.icongrey,
                            )),
                      ],
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  Widget addPropbottomsheet() {
    // List of items in our dropdown menu

    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      width: MediaQuery.of(context).size.width * 1,
      // color: Color.fromARGB(255, 211, 151, 195),
      child: Padding(
        padding: const EdgeInsets.only(left: 18, right: 18, top: 25),
        child: Form(
          key: addpropgkey,
          autovalidateMode: AutovalidateMode.disabled,
          child: ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            // mainAxisAlignment: MainAxisAlignment.start,
            children: [
              cltr_text_field("Prop Name", TextInputType.text, propname),

              Padding(
                padding: const EdgeInsets.only(top: 40),
                child: DropdownButtonFormField2<String>(
                  itemPadding: EdgeInsets.only(left: 10),
                  dropdownMaxHeight: 200,
                  dropdownDecoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  validator: (value) => value == null ? 'field required' : null,
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
                  hint: Text("Category",
                      style: TextStyle(color: Acolors.black, fontSize: 15)),
                  onChanged: (String newValue) {
                    setState(() {
                      dropdownvalue = newValue;
                      for (var i = 0; i < category.length; i++) {
                        if (category[i] == dropdownvalue) {
                          log(i.toString());
                          single_id = category_id[i];
                        }
                      }
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 40),
                child: cltr_text_field(
                    "Prop Description", TextInputType.text, discreptioin),
              ),
              // GlobalTextField(Icon(Icons.abc) ,'fieldText', propname),
              Padding(
                  padding: const EdgeInsets.only(top: 60),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(88, 50),
                      padding: EdgeInsets.symmetric(horizontal: 16),
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
                        : Text('Add Prop'),
                    onPressed: () {
                      setState(() {
                        _image == null ? isimage = false : isimage = true;
                        if (isimage == false) {
                          main_toast('Please Select Image');
                        }
                        if (addpropgkey.currentState.validate() &&
                            _image != null) {
                          onbutton_Loader = true;
                          addnewprop(
                                  single_id.toString(),
                                  propname.text.toString(),
                                  discreptioin.text.toString())
                              .whenComplete(() {
                            if (responcee.response.n == 1) {
                              onbutton_Loader = false;
                              smallbottomsheet(
                                  context, 'Details Updated Sucessfully', () {
                                Navigator.of(context)
                                    .pop(); //to close the sheet
                                // Navigator.pop(context);
                                Navigator.pop(context);
                                // to navigate to the prevoiuse page
                              });
                            } else {
                              main_toast(responcee.response.msg);
                              onbutton_Loader = false;
                            }
                          });
                        }
                      });

                      // smallbottomsheet(context, "Prop Added Successfully");
                    },
                  ))
            ],
          ),
        ),
      ),
    );
  }

  Future<void> addnewprop(String propcategoryid, propname, propdisp) async {
    final prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');
    final String id = prefs.getString('id');

    var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://' +
            Fetch.insta.URL1 +
            Fetch.insta.URL2 +
            'StaffAddNewProps'));
    log(request.url.toString());

    log(propcategoryid);
    request.headers['Apikey'] = Fetch.insta.Common_apikey;
    request.headers['authToken'] = token + '-' + id;
    request.fields['PropCategoryId'] = propcategoryid;
    request.fields['PropName'] = propname;
    request.fields['StaffId'] = id;
    (request.files.add(http.MultipartFile.fromBytes(
        'PropImage', File(_image.path).readAsBytesSync(),
        filename: _image.path)));
    request.fields['PropDescription'] = propdisp;

    var res = await request.send();
    var response = await http.Response.fromStream(res);
    log(response.body);

    if (response.statusCode == 200) {
      setState(() {
        responcee = BaseM.fromJson(jsonDecode(response.body));
      });
    } else if (response.statusCode == 401) {
      Fetch.insta.expire_dialog(context);
    } else if(response.statusCode == 500){
        main_toast('Server Not responding ');
       
    }else {
      main_toast('Something went Wrong');
    }
  }
}
