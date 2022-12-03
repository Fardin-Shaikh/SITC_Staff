import 'dart:convert';
import 'dart:developer';
import 'package:animated_widgets/widgets/opacity_animated.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:cool_dropdown/cool_dropdown.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:upcomming/Model.dart/mini_model/cat_list.dart';
import 'package:upcomming/Model.dart/outfit/outfit_category.dart';
import 'package:upcomming/color/colors.dart';
import 'package:upcomming/hardcore_Data/data.dart';
import 'package:upcomming/responce/all_fetch.dart';
import 'package:upcomming/screens/outfit/Outfits.dart';
import 'package:upcomming/screens/signin.dart';
import 'package:upcomming/widgets/common.dart';
import 'package:http/http.dart' as http;
import 'package:upcomming/widgets/loader.dart';

import '../../Model.dart/mini_model/baseModel.dart';
import '../../responce/internetcheck.dart';

class addOutfit extends StatefulWidget {
  final List<String> gender;
  final List<String> gender_short;
  const addOutfit(this.gender, this.gender_short);

  @override
  State<addOutfit> createState() => _addOutfitState();
}

class _addOutfitState extends State<addOutfit> {
  String dropdownvalue_gender;
  String dropdownvalue_category;
  Category all_category_resp;
  bool all_category_bool = false;
  List<String> catego_name = [''];
  List<int> catego_name_id;
  int single_cat_id;
  String single_gender_short;
  BaseM added_resp;
  bool added_bool = false;

  File _image;
  List<String> cat_name;
  List<int> cat_id;
  TextEditingController otname = TextEditingController();
  TextEditingController qty = TextEditingController();
  TextEditingController price = TextEditingController();
  // GlobalKey<FormState> namekey = GlobalKey<FormState>();
  // GlobalKey<FormState> qtykey = GlobalKey<FormState>();
  // GlobalKey<FormState> pricekey = GlobalKey<FormState>();
  // GlobalKey<FormState> cat_dropdown = GlobalKey<FormState>();
  GlobalKey<FormState> add_outfit = GlobalKey<FormState>();
  bool _display = true;

  // _Myformstate(){
  //   String selectedSalutation = cat_name[0];
  // }

  @override
  void initState() {
    super.initState();
    CK.inst.internet(context, (val) {
      if (val) {
        log('haseinternet');
        outfit_category('StaffOutfitCategory', '').whenComplete(() {
          if (all_category_resp.response.n == 1) {
            setState(() {
              catego_name = List.generate(
                  all_category_resp.outfitcategorylist.length,
                  (i) => all_category_resp
                      .outfitcategorylist[i].outfitCategoryName);
              catego_name_id = List.generate(
                  all_category_resp.outfitcategorylist.length,
                  (i) =>
                      all_category_resp.outfitcategorylist[i].outfitCategoryId);
            });
          }
        });
      }
    });
  }

  Future<void> outfit_category(
    String api_name,
    String gender,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');
    final String id = prefs.getString('id');
    final uri = Uri.http(
        Fetch.insta.URL1, Fetch.insta.URL2 + api_name, {'GenderType': gender});

    final responce = await http.get(uri, headers: {
      'Apikey': Fetch.insta.Common_apikey,
      'authToken': token + '-' + id,
    });
    log(uri.toString());
    log(responce.body);

    if (responce.statusCode == 200) {
      setState(() {
        var binod = Category.fromJson(jsonDecode(responce.body));
        all_category_resp = binod;
        all_category_resp == null
            ? all_category_bool = false
            : all_category_bool = true;
      });
    }  else if (responce.statusCode == 401) {
      Fetch.insta.expire_dialog(context);
    } else if(responce.statusCode == 500){
        main_toast('Server Not responding ');
       
    }else {
      main_toast('Something went Wrong');
    }
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
      appBar: noTabAppBar(context, 'Add Outfit'),
      bottomSheet: addoutfitbottomsheet(),
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
                    // Positioned(
                    //   left: 320,
                    //   top: 180,
                    //   child: FloatingActionButton(
                    //       onPressed: () {
                    //         // imagepop(context, () {});
                    //       },
                    //       tooltip: 'Add Task',
                    //       backgroundColor: Acolors.dark_bround,
                    //       foregroundColor: Acolors.white,
                    //       child: const Icon(
                    //         Icons.add_photo_alternate_outlined,
                    //         size: 30,
                    //       )),
                    // )
                  ],
                )
              : InkWell(
                  onTap: () {
                    imagepop(context, (imagtemppath) {
                      setState(() {
                        this._image = imagtemppath;
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

  Widget addoutfitbottomsheet() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      width: MediaQuery.of(context).size.width * 1,
      child: Padding(
        padding: const EdgeInsets.only(left: 22, right: 22, top: 20),
        child: Form(
          key: add_outfit,
          autovalidateMode: AutovalidateMode.disabled,
          child: ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              cltr_text_field("Name", TextInputType.text, otname),
              // AnimatedCrossFade(
              //   duration: const Duration(seconds: 3),
              //   firstChild: Container(), // When you don't want to show menu..
              //   secondChild: Container(
              //     color: Colors.red,
              //     height: 20,
              //     width: 20,
              //   ),
              //   crossFadeState: _display
              //       ? CrossFadeState.showFirst
              //       : CrossFadeState.showSecond,
              // ),
              Padding(
                padding: const EdgeInsets.only(top: 25),
                child: DropdownButtonFormField2<String>(
                  itemPadding: EdgeInsets.only(left: 10),
                  dropdownMaxHeight: 200,
                  dropdownDecoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  validator: (value) => value == null ? 'field required' : null,
                  value: dropdownvalue_gender,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: widget.gender.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(items),
                    );
                  }).toList(),
                  isExpanded: true,
                  isDense: true,
                  hint: Text("Select",
                      style: TextStyle(color: Acolors.black, fontSize: 15)),
                  onChanged: (String newValue) {
                    setState(() {
                      dropdownvalue_gender = newValue;
                      // _display = !_display;
                      log(widget.gender_short.toString());
                      for (var i = 0; i < widget.gender.length; i++) {
                        if (widget.gender[i] == dropdownvalue_gender) {
                          log(i.toString());
                          single_gender_short = widget.gender_short[i];
                          log(single_gender_short);
                          print(i);
                        }
                      }
                    });
                  },
                ),
              ),
             

              Padding(
                padding: const EdgeInsets.only(top: 25),
                child: DropdownButtonFormField2<String>(
                  
                  itemPadding: EdgeInsets.only(left: 10),
                  dropdownMaxHeight: 200,
                  dropdownDecoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  validator: (value) => value == null ? 'field required' : null,
                  value: dropdownvalue_category,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: catego_name.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(items),
                    );
                  }).toList(),
                  isExpanded: true,
                  isDense: true,
                  hint: Text('Category',
                      style: TextStyle(color: Acolors.black, fontSize: 15)),
                  onChanged: (String newValue) {
                    setState(() {
                      dropdownvalue_category = newValue;
                      for (var i = 0; i < catego_name.length; i++) {
                        if (catego_name[i] == dropdownvalue_category) {
                          log(i.toString());
                          single_cat_id = catego_name_id[i];
                          print(single_cat_id);
                          print(i);
                        }
                      }
                    });
                  },
                ),
              ),
              Padding(
                  padding: const EdgeInsets.only(top: 25),
                  child: cltr_text_field("Price", TextInputType.number, price)),
              Padding(
                  padding: const EdgeInsets.only(top: 25),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(88, 50),
                      padding: EdgeInsets.symmetric(horizontal: 16),
                    ),
                    child: const Text("Add Outfit"),
                    onPressed: () {
                      if (_image == null) main_toast('Please Select image');

                      if (add_outfit.currentState.validate() &&
                          _image != null) {
                        log(single_gender_short);
                        Utils(context).startLoading();
                        addoutfit(
                                'StaffAddNewOutfits',
                                single_cat_id.toString(),
                                price.text.toString(),
                                single_gender_short,
                                otname.text.toString())
                            .whenComplete(() {
                          if (added_resp.response.n == 1) {
                            Utils(context).stopLoading();
                            smallbottomsheet(context, added_resp.response.msg,
                                () {
                              Navigator.of(context).pop();
                              Navigator.pop(context);
                            });
                          } else {
                            Utils(context).stopLoading();
                            main_toast(added_resp.response.msg);
                          }
                        });
                      }
                    },
                  ))
            ],
          ),
        ),
      ),
    );
  }

  Future<void> addoutfit(
    String api_name,
    String of_id,
    String price,
    String gender,
    String name,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');
    final String id = prefs.getString('id');
    log(of_id);
    log(price);
    log(gender);
    log(name);
    log(of_id);
    var request = http.MultipartRequest('POST',
        Uri.parse('http://' + Fetch.insta.URL1 + Fetch.insta.URL2 + api_name));
    log(request.url.toString());
    request.headers['Apikey'] = Fetch.insta.Common_apikey;
    request.headers['authToken'] = token + '-' + id;
    request.fields['OutfitCategoryId'] = of_id;
    request.fields['ProductName'] = name;
    request.fields['Price'] = price;
    request.fields['Gender'] = gender;
    request.fields['StaffId'] = id;
    request.files.add(http.MultipartFile.fromBytes(
        'OutfitImage', File(_image.path).readAsBytesSync(),
        filename: _image.path));

    var res = await request.send();
    var response = await http.Response.fromStream(res);
    log(response.body);

    if (response.statusCode == 200) {
      setState(() {
        added_resp = BaseM.fromJson(jsonDecode(response.body));
        added_resp == null ? added_bool = false : added_bool = true;
      });
    }  else if (response.statusCode == 401) {
      Fetch.insta.expire_dialog(context);
    } else if(response.statusCode == 500){
        main_toast('Server Not responding ');
       
    }else {
      main_toast('Something went Wrong');
    }
  }
}
