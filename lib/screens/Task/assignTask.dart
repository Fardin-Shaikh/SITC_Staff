import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:upcomming/Model.dart/mini_model/baseModel.dart';
import 'package:upcomming/Model.dart/mini_model/small.dart';
import 'package:upcomming/Model.dart/outfit/outfit_category.dart';
import 'package:upcomming/Model.dart/task/category.dart';
import 'package:upcomming/Model.dart/task/taskasignemploy.dart';
import 'package:upcomming/color/colors.dart';
import 'package:upcomming/hardcore_Data/data.dart';
import 'package:upcomming/responce/all_fetch.dart';
import 'package:upcomming/screens/Task/Task.dart';
import 'package:upcomming/widgets/common.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

import '../../Model.dart/task/mytask.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import '../../responce/internetcheck.dart';

class AssignTask extends StatefulWidget {
  const AssignTask();

  @override
  State<AssignTask> createState() => _AssignTaskState();
}

class _AssignTaskState extends State<AssignTask> {
  File _image;
  String dropdownvaluename;
  String dropdownvalueid;

  Taskcategory category_data;
  Employdata data;
  List<String> category_name;
  List<int> category_id;
  List<String> employ_name;
  List<String> employ_name2;

  List<int> employ_id;
  int singelemploy_id;
  int singlecategoryid;
  TextEditingController subject_cltr = TextEditingController();
  TextEditingController disp_cltr = TextEditingController();
  GlobalKey<FormState> addtaskgkey = GlobalKey<FormState>();
  bool isimage = false;

  bool has_cato_data = false;
  bool has_emp_data = false;
  SmallResponce task_resp;
  bool isloader = false;
  bool categorylist_shoe = false;
  bool employeelist_shoe = false;

  @override
  void initState() {
    super.initState();
    CK.inst.internet(context, (val) {
      if (val) {
        log('haseinternet');
        category();
        employes_detail();
      }
    });
  }

  Future<void> category() async {
    final prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');
    final String id = prefs.getString('id');
    final uri = Uri.http(
      Fetch.insta.URL1,
      Fetch.insta.URL2 + 'TaskAssignedToCategory',
    );

    final responce = await http.get(uri, headers: {
      'Apikey': Fetch.insta.Common_apikey,
      'authToken': token + '-' + id,
    });
    log(responce.body);
    if (responce.statusCode == 200) {
      setState(() {
        category_data = Taskcategory.fromJson(jsonDecode(responce.body));
        if (category_data.response.n == 1) {
          category_name = List<String>.generate(
              category_data.categorylist.length,
              (index) => category_data.categorylist[index].categoryName);
          category_id = List<int>.generate(category_data.categorylist.length,
              (index) => category_data.categorylist[index].categoryId);
          category_data == null && category_id == null
              ? has_cato_data = false
              : has_cato_data = true;
        } else {
          main_toast("some thing went wrong");
        }
      });
      return;
    } else if (responce.statusCode == 401) {
      Fetch.insta.expire_dialog(context);
    } else if (responce.statusCode == 500) {
      main_toast('Server Not responding ');
    } else {
      main_toast('Something went Wrong');
    }
  }

  Future<void> employes_detail() async {
    final prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');
    final String id = prefs.getString('id');
    final uri = Uri.http(Fetch.insta.URL1,
        Fetch.insta.URL2 + 'TaskAssignedToStaffList', {'StaffId': id});

    final responce = await http.get(uri, headers: {
      'Apikey': Fetch.insta.Common_apikey,
      'authToken': token + '-' + id,
    });
    log(responce.body);
    if (responce.statusCode == 200) {
      setState(() {
        data = Employdata.fromJson(jsonDecode(responce.body));
        if (data.response.n == 1) {
          employ_name = List<String>.generate(data.stafflist.length,
              (index) => data.stafflist[index].staffName);
          for (var i = 0; i < employ_name.length; i++) {
            employ_name.removeAt(8);
          }

          employ_id = List<int>.generate(
              data.stafflist.length, (index) => data.stafflist[index].staffId);
          category_data == null && category_id == null
              ? has_emp_data = false
              : has_emp_data = true;
        } else {
          main_toast("some thing went wrong");
        }
      });
      return;
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
    Size mq = MediaQuery.of(context).size;
    return has_emp_data && has_cato_data
        ? Scaffold(
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
            appBar: noTabAppBar(context, 'Assign Task'),
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
                        onTap: () {
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
          )
        : Loading_screen();
  }

  Widget addPropbottomsheet() {
    // List of items in our dropdown menu

    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      width: MediaQuery.of(context).size.width * 1,
      // color: Color.fromARGB(255, 211, 151, 195),
      child: Padding(
        padding: const EdgeInsets.only(left: 22, right: 22, top: 15),
        child: Container(
          child: Form(
            key: addtaskgkey,
            autovalidateMode: AutovalidateMode.disabled,
            child: ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              // mainAxisAlignment: MainAxisAlignment.start,
              children: [
                cltr_text_field('Subject', TextInputType.text, subject_cltr),
                // SizedBox(
                //   height: MediaQuery.of(context).size.height * 0.03,
                // ),
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: DropdownButtonFormField2<String>(
                    itemPadding: EdgeInsets.only(left: 10),
                    dropdownMaxHeight: 200,
                    dropdownDecoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    validator: (value) =>
                        value == null ? 'field required' : null,
                    value: dropdownvaluename,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: category_name.map((String items) {
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
                        dropdownvaluename = newValue;
                        for (var i = 0; i < category_name.length; i++) {
                          if (category_name[i] == dropdownvaluename) {
                            log(i.toString());
                            singlecategoryid = category_id[i];
                          }
                        }
                      });
                    },
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: DropdownButtonFormField2<String>(
                    itemPadding: EdgeInsets.only(left: 10),
                    dropdownMaxHeight: 200,
                    dropdownDecoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    validator: (value) =>
                        value == null ? 'field required' : null,
                    value: dropdownvalueid,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: employ_name.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),
                    isExpanded: true,
                    isDense: true,
                    hint: Text("Employee name",
                        style: TextStyle(color: Acolors.black, fontSize: 15)),
                    onChanged: (String newValue) {
                      setState(() {
                        dropdownvalueid = newValue;
                        for (var i = 0; i < employ_name.length; i++) {
                          if (employ_name[i] == dropdownvalueid) {
                            log(i.toString());
                            singelemploy_id = employ_id[i];
                          }
                        }
                      });
                    },
                  ),
                ),

                // TextFormField(
                //   onTap: () {
                //     setState(() {
                //       categorylist_shoe = !categorylist_shoe;
                //     });
                //   },
                //   readOnly: true,
                //   decoration: InputDecoration(
                //       hintText: categorylist_shoe ? "true" : 'false'),
                // ),
                // SizedBox(
                //   height: MediaQuery.of(context).size.height * 0.03,
                // ),
                // TextFormField(
                //   onTap: () {
                //     setState(() {
                //       employeelist_shoe = !employeelist_shoe;
                //       print('object');
                //     });
                //   },
                //   readOnly: true,
                //   decoration: InputDecoration(
                //       hintText: employeelist_shoe ? "true" : 'false'),
                // ),
                // SizedBox(
                //   height: MediaQuery.of(context).size.height * 0.14,
                // ),
                // cltr_text_field('Description', TextInputType.text, disp_cltr),
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: cltr_text_field(
                      'Description', TextInputType.text, disp_cltr),
                ),
                Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(88, 50),
                        padding: EdgeInsets.symmetric(horizontal: 16),
                      ),
                      child: isloader
                          ? SizedBox(
                              height: 25,
                              width: 25,
                              child: Center(
                                child: CircularProgressIndicator(
                                    color: Acolors.white, strokeWidth: 2),
                              ),
                            )
                          : Text('Assign'),
                      onPressed: () {
                        setState(() {
                          _image == null ? isimage = false : isimage = true;
                          if (isimage == false) {
                            main_toast('Please Select Image');
                          }
                          if (addtaskgkey.currentState.validate() &&
                              _image != null) {
                            isloader = true;
                            addnewtask(
                                    singlecategoryid.toString(),
                                    singelemploy_id.toString(),
                                    subject_cltr.text.toString(),
                                    disp_cltr.text.toString())
                                .whenComplete(() {
                              if (task_resp.n == 1) {
                                main_toast(task_resp.msg);
                                smallbottomsheet(
                                    context, "Task Asign Sucessfully", () {
                                  Navigator.of(context).pop();
                                  Navigator.pop(context);
                                });
                                isloader = false;
                              } else {
                                isloader = false;
                                main_toast(task_resp.msg);
                              }
                            });
                          }
                        });
                      },
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> addnewtask(String cat_id, emp_id, subject, disp) async {
    final prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');
    final String id = prefs.getString('id');

    var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://' +
            Fetch.insta.URL1 +
            Fetch.insta.URL2 +
            'TaskAssignToSatff'));
    log(request.url.toString());

    request.headers['Apikey'] = Fetch.insta.Common_apikey;
    request.headers['authToken'] = token + '-' + id;
    request.fields['StaffId'] = id;
    request.fields['CategoryId'] = cat_id;
    request.fields['AssignStaffId'] = emp_id;
    request.fields['subject'] = subject;
    request.fields['Description'] = disp;

    (request.files.add(http.MultipartFile.fromBytes(
        'TaskImage', File(_image.path).readAsBytesSync(),
        filename: _image.path)));

    var res = await request.send();
    var response = await http.Response.fromStream(res);
    log(response.body);
    if (response.statusCode == 200) {
      setState(() {
        task_resp = SmallResponce.fromJson(jsonDecode(response.body));
      });
    } else if (response.statusCode == 401) {
      Fetch.insta.expire_dialog(context);
    } else {
      main_toast('Server Not responding ');
    }
  }

  Widget dropdown_list_show_stack() {
    return Stack(
      children: [
        Container(
          child: Form(
            key: addtaskgkey,
            autovalidateMode: AutovalidateMode.disabled,
            child: ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              // mainAxisAlignment: MainAxisAlignment.start,
              children: [
                cltr_text_field('Subject', TextInputType.text, subject_cltr),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
                // Padding(
                //   padding: const EdgeInsets.only(top: 15),
                //   child: DropdownButtonFormField2<String>(
                //     itemPadding: EdgeInsets.only(left: 10),
                //     dropdownMaxHeight: 200,
                //     dropdownDecoration: BoxDecoration(
                //       borderRadius: BorderRadius.circular(20),
                //     ),
                //     validator: (value) => value == null ? 'field required' : null,
                //     value: dropdownvaluename,
                //     icon: const Icon(Icons.keyboard_arrow_down),
                //     items: category_name.map((String items) {
                //       return DropdownMenuItem(
                //         value: items,
                //         child: Text(items),
                //       );
                //     }).toList(),
                //     isExpanded: true,
                //     isDense: true,
                //     hint: Text("Category",
                //         style: TextStyle(color: Acolors.black, fontSize: 15)),
                //     onChanged: (String newValue) {
                //       setState(() {
                //         dropdownvaluename = newValue;
                //         for (var i = 0; i < category_name.length; i++) {
                //           if (category_name[i] == dropdownvaluename) {
                //             log(i.toString());
                //             singlecategoryid = category_id[i];
                //           }
                //         }
                //       });
                //     },
                //   ),
                // ),

                // Padding(
                //   padding: const EdgeInsets.only(top: 15),
                //   child: DropdownButtonFormField2<String>(
                //     itemPadding: EdgeInsets.only(left: 10),
                //     dropdownMaxHeight: 200,
                //     dropdownDecoration: BoxDecoration(
                //       borderRadius: BorderRadius.circular(20),
                //     ),
                //     validator: (value) => value == null ? 'field required' : null,
                //     value: dropdownvalueid,
                //     icon: const Icon(Icons.keyboard_arrow_down),
                //     items: employ_name.map((String items) {
                //       return DropdownMenuItem(
                //         value: items,
                //         child: Text(items),
                //       );
                //     }).toList(),
                //     isExpanded: true,
                //     isDense: true,
                //     hint: Text("Employee name",
                //         style: TextStyle(color: Acolors.black, fontSize: 15)),
                //     onChanged: (String newValue) {
                //       setState(() {
                //         dropdownvalueid = newValue;
                //         for (var i = 0; i < employ_name.length; i++) {
                //           if (employ_name[i] == dropdownvalueid) {
                //             log(i.toString());
                //             singelemploy_id = employ_id[i];
                //           }
                //         }
                //       });
                //     },
                //   ),
                // ),

                TextFormField(
                  onTap: () {
                    setState(() {
                      categorylist_shoe = !categorylist_shoe;
                    });
                  },
                  readOnly: true,
                  decoration: InputDecoration(
                      hintText: categorylist_shoe ? "true" : 'false'),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
                TextFormField(
                  onTap: () {
                    setState(() {
                      employeelist_shoe = !employeelist_shoe;
                      print('object');
                    });
                  },
                  readOnly: true,
                  decoration: InputDecoration(
                      hintText: employeelist_shoe ? "true" : 'false'),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.14,
                ),
                cltr_text_field('Description', TextInputType.text, disp_cltr),
                // Padding(
                //   padding: const EdgeInsets.only(top: 15),
                //   child: cltr_text_field(
                //       'Description', TextInputType.text, disp_cltr),
                // ),
                // Padding(
                //     padding: const EdgeInsets.only(top: 30),
                //     child: ElevatedButton(
                //       style: ElevatedButton.styleFrom(
                //         minimumSize: Size(88, 50),
                //         padding: EdgeInsets.symmetric(horizontal: 16),
                //       ),
                //       child: isloader
                //           ? SizedBox(
                //               height: 25,
                //               width: 25,
                //               child: Center(
                //                 child: CircularProgressIndicator(
                //                     color: Acolors.white, strokeWidth: 2),
                //               ),
                //             )
                //           : Text('Assign'),
                //       onPressed: () {
                //         setState(() {
                //           _image == null ? isimage = false : isimage = true;
                //           if (isimage == false) {
                //             main_toast('Please Select Image');
                //           }
                //           if (addtaskgkey.currentState.validate() &&
                //               _image != null) {
                //             isloader = true;
                //             addnewtask(
                //                     singlecategoryid.toString(),
                //                     singelemploy_id.toString(),
                //                     subject_cltr.text.toString(),
                //                     disp_cltr.text.toString())
                //                 .whenComplete(() {
                //               if (task_resp.n == 1) {
                //                 main_toast(task_resp.msg);
                //                 smallbottomsheet(
                //                     context, "Task Asign Sucessfully", () {
                //                   Navigator.of(context).pop();
                //                   Navigator.pop(context);
                //                 });
                //                 isloader = false;
                //               } else {
                //                 isloader = false;
                //                 main_toast(task_resp.msg);
                //               }
                //             });
                //           }
                //         });
                //       },
                //     )),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.04,
                ),
                ElevatedButton(
                  // style: ElevatedButton.styleFrom(
                  //   minimumSize: Size(88, 50),
                  //   padding: EdgeInsets.symmetric(horizontal: 16),
                  // ),
                  child: isloader
                      ? SizedBox(
                          height: 25,
                          width: 25,
                          child: Center(
                            child: CircularProgressIndicator(
                                color: Acolors.white, strokeWidth: 2),
                          ),
                        )
                      : Text('Assign'),
                  onPressed: () {
                    setState(() {
                      _image == null ? isimage = false : isimage = true;
                      if (isimage == false) {
                        main_toast('Please Select Image');
                      }
                      if (addtaskgkey.currentState.validate() &&
                          _image != null) {
                        isloader = true;
                        addnewtask(
                                singlecategoryid.toString(),
                                singelemploy_id.toString(),
                                subject_cltr.text.toString(),
                                disp_cltr.text.toString())
                            .whenComplete(() {
                          if (task_resp.n == 1) {
                            main_toast(task_resp.msg);
                            smallbottomsheet(context, "Task Asign Sucessfully",
                                () {
                              Navigator.of(context).pop();
                              Navigator.pop(context);
                            });
                            isloader = false;
                          } else {
                            isloader = false;
                            main_toast(task_resp.msg);
                          }
                        });
                      }
                    });
                  },
                )
              ],
            ),
          ),
        ),
        Positioned(
          top: 125,
          child: AnimatedOpacity(
              opacity: categorylist_shoe ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 500),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.2,
                width: MediaQuery.of(context).size.width * 1,
                color: Colors.purple,
              )),
        ),
        Positioned(
          top: 10,
          child: AnimatedOpacity(
              opacity: employeelist_shoe ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 500),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.2,
                width: MediaQuery.of(context).size.width * 1,
                color: Colors.blue,
              )),
        ),
      ],
    );
  }
}
