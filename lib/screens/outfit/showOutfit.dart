// import 'dart:developer';
// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:upcomming/Model.dart/outfit/filtered_output.dart';
// import 'package:upcomming/color/colors.dart';
// import 'package:upcomming/hardcore_Data/data.dart';
// import 'package:upcomming/screens/outfit/editOutfit.dart';
// import 'package:upcomming/widgets/common.dart';

// class showOutfit extends StatefulWidget {
//   // final WomenOutfit data;
//   final OutFitList data;
//   const showOutfit({this.data});

//   @override
//   State<showOutfit> createState() => _showOutfitState();
// }

// class _showOutfitState extends State<showOutfit> {
//   File _image;
//   @override
//   Widget build(BuildContext context) {
//     Size mq = MediaQuery.of(context).size;
//     return Scaffold(
//       appBar: noTabAppBar(context, 'Add Outfit'),
//       bottomSheet: showoutfitbottomsheet(),
//       body: Column(
//         children: [
//           Stack(
//             children: [
//               Container(
//                 height: mq.height * 0.35,
//                 width: mq.width * 1,
//                 decoration: BoxDecoration(
//                   image: DecorationImage(
//                       image: NetworkImage(widget.data.imageLink),
//                       fit: BoxFit.cover),
//                 ),
//               ),
//             ],
//           )
//         ],
//       ),
//     );
//   }

//   Widget showoutfitbottomsheet() {
//     return Container(
//       height: MediaQuery.of(context).size.height * 0.6,
//       width: MediaQuery.of(context).size.width * 1,
//       // color: Color.fromARGB(255, 211, 151, 195),
//       child: Padding(
//           padding: const EdgeInsets.only(left: 22, right: 22, top: 25),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Column(
//                     // mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       stext("Name ", Acolors.black, FontWeight.w200, 16),
//                       Padding(
//                         padding: const EdgeInsets.only(top: 5),
//                         child: stext(widget.data.productName,
//                             Acolors.dark_bround, FontWeight.w300, 18),
//                       ),
//                     ],
//                   ),
//                   Row(
//                     children: [
//                       CircleAvatar(
//                           radius: 20,
//                           backgroundColor: Acolors.dark_bround,
//                           child: IconButton(
//                               onPressed: () {
//                                 Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                         builder: (context) => editOutfit(
//                                               data: widget.data,
//                                             )));
//                               },
//                               icon: Icon(
//                                 Icons.mode_edit_outlined,
//                                 color: Acolors.white,
//                               ))),
//                       SizedBox(
//                         width: MediaQuery.of(context).size.width * 0.03,
//                       ),
//                       CircleAvatar(
//                           radius: 20,
//                           backgroundColor: Acolors.dark_bround,
//                           child: IconButton(
//                               onPressed: () {
//                                 log(widget.data.outfitId.toString());
//                                 deletsmallbottomsheet(context, 'Outfit', () {
//                                   print("check delete poutfit ");
//                                 });
//                               },
//                               icon: Icon(
//                                 Icons.delete_outline_rounded,
//                                 color: Acolors.white,
//                               )))
//                     ],
//                   )
//                 ],
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(top: 20),
//                 child: stext("Category ", Acolors.black, FontWeight.w200, 16),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(top: 5),
//                 child: stext(widget.data.outfitCategoryName,
//                     Acolors.dark_bround, FontWeight.w300, 18),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(top: 20),
//                 child: stext("Quantity ", Acolors.black, FontWeight.w200, 16),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(top: 5),
//                 child: stext(widget.data.quantity, Acolors.dark_bround,
//                     FontWeight.w300, 18),
//               )
//             ],
//           )),
//     );
//   }

//   pickImage(ImageSource imageSource) async {
//     var image = await ImagePicker()
//         .pickImage(source: imageSource)
//         .then((imgFile) async {
//       if (imgFile == null) return;
//       final imagtemppath = File(imgFile.path);
//       setState(() {
//         this._image = imagtemppath;
//       });
//     });
//   }

//   void imagepop() {
//     showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//               title: const Text("From where do you want to take photo"),
//               actions: [
//                 TextButton(
//                   onPressed: () {
//                     pickImage(ImageSource.gallery);
//                     Navigator.of(context).pop();
//                   },
//                   child: const Text("Gallery"),
//                 ),
//                 TextButton(
//                   onPressed: () {
//                     pickImage(ImageSource.camera);
//                     Navigator.of(context).pop();
//                   },
//                   child: const Text("Camera"),
//                 )
//               ],
//             ));
//     ;
//   }
// }

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:responsive_flutter/responsive_flutter.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:upcomming/Model.dart/mini_model/baseModel.dart';
import 'package:upcomming/Model.dart/outfit/filtered_output.dart';
import 'package:upcomming/Model.dart/props/detailprops.dart';

import 'package:upcomming/color/colors.dart';
import 'package:upcomming/responce/all_fetch.dart';
import 'package:upcomming/screens/notifications.dart';
import 'package:upcomming/widgets/common.dart';
import 'package:upcomming/Model.dart/mini_model/cat_list.dart';
import 'package:http/http.dart' as http;
import 'package:upcomming/widgets/loader.dart';

import '../../Model.dart/outfit/outfit_category.dart';
import '../home.dart';

class showOutfit extends StatefulWidget {
  final OutFitList data;
//  final String cat_name;
  final List<String> gender;
  final List<String> gender_short;

  showOutfit({this.data, this.gender, this.gender_short});

  @override
  State<showOutfit> createState() => _showOutfitState();
}

class _showOutfitState extends State<showOutfit> {
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

  /////
  Category all_category_resp;
  List<String> catego_name = [''];
  List<int> catego_name_id = [0];
  bool all_category_bool = false;
  String dropdownvalue_gender;
  String dropdownvalue_category;
  int single_cat_id;
  String gender_drop;
  String single_gender_short;
  bool show_category = false;

  @override
  void initState() {
    super.initState();
    prop_name = TextEditingController(text: widget.data.productName);
    prop_price = TextEditingController(text: widget.data.price);
    imageurl = widget.data.imageLink;
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
    } else if (responce.statusCode == 401) {
      Fetch.insta.expire_dialog(context);
    } else if (responce.statusCode == 500) {
      main_toast('Server Not responding ');
    } else {
      main_toast('Something went Wrong');
    }
  }

  @override
  Widget build(BuildContext context) {
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
      // resizeToAvoidBottomInset: false,
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
                      Utils(context).startLoading();
                      deletsmallbottomsheet(context, 'Outfit', () {
                        delete_loading = true;
                        deletoutfit(widget.data.outfitId.toString())
                            .whenComplete(() {
                          if (deletrespomce.response.n == 1) {
                            main_toast(deletrespomce.response.msg);
                            delete_loading = false;
                            Navigator.of(context).pop(); //to close the sheet
                            // Navigator.pop(context);
                            Navigator.pop(
                                context); // to navigate to the prevoiuse page
                            Utils(context).stopLoading();
                          } else {
                            delete_loading = false;
                            Navigator.of(context).pop();
                            main_toast(deletrespomce.response.msg);
                            Utils(context).stopLoading();
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
                  edittextfiels(isedit, prop_name, "Outfit Name",
                      'Enter Outfit Name ', TextInputType.text),
                  Padding(
                    padding: const EdgeInsets.only(top: 25),
                    child: DropdownButtonFormField2<String>(
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 0, vertical: 10)),
                      itemPadding: EdgeInsets.only(left: 10),
                      dropdownMaxHeight: 200,
                      dropdownDecoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      validator: (value) =>
                          value == null ? 'field required' : null,
                      value: gender_drop,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: widget.gender.map((String items) {
                        return DropdownMenuItem(
                          value: items,
                          child: Text(items),
                        );
                      }).toList(),
                      isExpanded: true,
                      hint: Text("Gender",
                          style: TextStyle(color: Acolors.black, fontSize: 15)),
                      onChanged: isedit == false
                          ? (String newValue) {
                              setState(() {
                                gender_drop = newValue;
                                dropdownvalue_category = null;
                                for (var i = 0; i < widget.gender.length; i++) {
                                  if (widget.gender[i] == gender_drop) {
                                    log(i.toString());
                                    single_gender_short =
                                        widget.gender_short[i];
                                    log(single_gender_short +
                                        'this is string id ');
                                    outfit_category('StaffOutfitCategory',
                                            single_gender_short)
                                        .whenComplete(() {
                                      if (all_category_resp.response.n == 1) {
                                        show_category = true;
                                        catego_name = List.generate(
                                            all_category_resp
                                                .outfitcategorylist.length,
                                            (i) => all_category_resp
                                                .outfitcategorylist[i]
                                                .outfitCategoryName);
                                        catego_name_id = List.generate(
                                            all_category_resp
                                                .outfitcategorylist.length,
                                            (i) => all_category_resp
                                                .outfitcategorylist[i]
                                                .outfitCategoryId);
                                      }
                                    });
                                  }
                                }
                              });
                            }
                          : null,
                    ),
                  ),
                  Visibility(
                    visible: show_category,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 25),
                      child: DropdownButtonFormField2<String>(
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 0, vertical: 10)),
                        itemPadding: EdgeInsets.only(left: 10),
                        dropdownMaxHeight: 200,
                        dropdownDecoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        validator: (value) =>
                            value == null ? 'field required' : null,
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
                            style:
                                TextStyle(color: Acolors.black, fontSize: 15)),
                        onChanged: isedit == false
                            ? (String newValue) {
                                setState(() {
                                  dropdownvalue_category = newValue;
                                  for (var i = 0; i < catego_name.length; i++) {
                                    if (catego_name[i] ==
                                        dropdownvalue_category) {
                                      log(i.toString());
                                      single_cat_id = catego_name_id[i];
                                      print(single_cat_id);
                                      print(i);
                                    }
                                  }
                                });
                              }
                            : null,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: edittextfiels(isedit, prop_price, "Price",
                        'Enter Price', TextInputType.number),
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
                                print(widget.data.outfitId.toString() +
                                    prop_name.text +
                                    prop_price.text +
                                    single_gender_short);

                                Update_detail(
                                        widget.data.outfitId.toString(),
                                        prop_name.text,
                                        prop_price.text,
                                        single_gender_short,
                                        single_cat_id.toString())
                                    .whenComplete(() {
                                  if (responcee.response.n == 1) {
                                    main_toast(responcee.response.msg);
                                    Navigator.of(context).pop();
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

  Future<void> Update_detail(String unq_ot_id, String product_name,
      String price, String gender, String outfitcat_id) async {
    final prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');
    final String id = prefs.getString('id');
    var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://' +
            Fetch.insta.URL1 +
            Fetch.insta.URL2 +
            'StaffUpdateOutfitsDetails'));
    log(request.url.toString());
    request.headers['Apikey'] = Fetch.insta.Common_apikey;
    request.headers['authToken'] = token + '-' + id;
    request.fields['OutfitID'] = unq_ot_id;
    request.fields['ProductName'] = product_name;
    request.fields['Price'] = price;
    request.fields['Gender'] = gender;
    request.fields['StaffId'] = id;
    request.fields['OutfitCategoryId'] = outfitcat_id;
    isimage == 1
        ? (request.files.add(http.MultipartFile.fromBytes(
            'OutfitImage', File(_image.path).readAsBytesSync(),
            filename: _image.path)))
        : null;
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

  Future<void> deletoutfit(String propid) async {
    final prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');
    final String id = prefs.getString('id');
    final uri = Uri.http(
        Fetch.insta.URL1, Fetch.insta.URL2 + 'StaffDeleteOutfitsDetails');

    final responce = await http.post(uri, headers: {
      'Apikey': Fetch.insta.Common_apikey,
      'authToken': token + '-' + id,
    }, body: {
      "OutfitID": propid
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
