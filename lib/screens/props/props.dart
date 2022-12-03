import 'dart:convert';
import 'dart:developer';

import 'dart:io';

import 'package:awesome_loader/awesome_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:upcomming/Model.dart/mini_model/cat_list.dart';
import 'package:upcomming/Model.dart/props/category.dart';
import 'package:upcomming/Model.dart/props/detailprops.dart';
import 'package:upcomming/color/colors.dart';

import 'package:upcomming/hardcore_Data/data.dart';
import 'package:upcomming/responce/all_fetch.dart';
import 'package:upcomming/screens/outfit/addOutfits.dart';
import 'package:upcomming/screens/props/addProp.dart';
import 'package:upcomming/screens/props/props_grid.dart';
import 'package:upcomming/screens/props/showProp.dart';
import 'package:upcomming/widgets/common.dart';
import 'package:http/http.dart' as http;
import 'package:upcomming/widgets/loader.dart';

import '../../responce/internetcheck.dart';

class Props extends StatefulWidget {
  const Props();

  @override
  State<Props> createState() => _PropsState();
}

class _PropsState extends State<Props> {
  List<bool> show_detail = [];
  int select;
  int inn;
  bool isnull = false;
  List<Propcategorylist> categorylist;
  List<PropList> dprop;
  bool hasedata = false;
  bool detailprophasdata = false;

  @override
  void initState() {
    super.initState();
    CK.inst.internet(context, (val) {
      if (val) {
        log('haseinternet');
        Props_category();
      }
    });
  }

  Future<void> Props_category() async {
    final uri = Uri.http(
      Fetch.insta.URL1,
      Fetch.insta.URL2 + 'StaffPropCategory',
    );
    final prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');
    final String id = prefs.getString('id');
    final responce = await http.get(uri, headers: {
      'Apikey': Fetch.insta.Common_apikey,
      'authToken': token + '-' + id,
    });

    if (responce.statusCode == 200) {
      var fin = CategoryProps.fromJson(jsonDecode(responce.body));
      if (fin.response.n == 1) {
        setState(() {
          categorylist = fin.propcategorylist;
          categorylist.length == null ? hasedata = false : hasedata = true;
          save_var.insta.props_category = List<catogory_list>.generate(
              cat_list.length,
              (index) => catogory_list(
                  id: categorylist[index].propCategoryId,
                  name: categorylist[index].propCategoryName));

          log(save_var.insta.props_category[5].name);
        });
      }
    } else if (responce.statusCode == 401) {
      Fetch.insta.expire_dialog(context);
    } else if (responce.statusCode == 500) {
      main_toast('Server Not responding ');
    } else {
      main_toast('Something went Wrong');
    }
  }

  Future<void> staffPropDetails(String slum_name) async {
    final prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');
    final String id = prefs.getString('id');
    final uri =
        Uri.http(Fetch.insta.URL1, Fetch.insta.URL2 + 'StaffPropDetails');

    log(uri.toString());
    final responce = await http.post(uri, headers: {
      'Apikey': Fetch.insta.Common_apikey,
      'authToken': token + '-' + id,
    }, body: {
      "SlugName": slum_name,
    });

    log(slum_name);
    log(token + '-' + id);
    log(responce.body);

    if (responce.statusCode == 200) {
      var boo = DetailProps.fromJson(jsonDecode(responce.body));
      if (boo.response.n == 1) {
        setState(() {
          dprop = boo.propList;
          dprop.length == null
              ? detailprophasdata = false
              : detailprophasdata = true;
        });
      }
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
    return Having_data();
  }

  Widget Having_data() {
    return Scaffold(
        appBar: noTabAppBar(context, 'Props'),
        floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
        floatingActionButton: addTaskFloatingbutton(

            // SignUpPerson(),
            context,
            const Icon(
              Icons.add_circle_outline_rounded,
              size: 45,
            ), () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => addProp()));
        }),
        body: hasedata ? AllPropsCatagory() : Loading_screen());
  }

  Widget AllPropsCatagory() {
    Size mq = MediaQuery.of(context).size;
    return ListView.builder(
        itemCount: categorylist.length,
        // itemExtent: 74,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        itemBuilder: (BuildContext context, int index) {
          var data = categorylist[index];
          if (show_detail.length < categorylist.length) {
            show_detail.add(false);
          }
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 9),
            child: InkWell(
              onTap: (() => setState(() {
                    if (show_detail[index] == false) {
                      select = index;
                      show_detail[index] = true;
                      log(show_detail.toString());
                      staffPropDetails(
                          categorylist[index].slugName); //called api
                    } else {
                      select = -1;
                      show_detail[index] = false;
                      log(show_detail.toString());
                    }
                  })),
              child: Container(
                decoration: BoxDecoration(

                    // color: Colors.red,
                    // border: Border(
                    //     bottom: BorderSide(
                    //         color: Colors.grey[300],
                    //         // select == index ? Colors.grey[300] : Colors.white,
                    //         width: 2))
                    ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 13),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                  height: mq.height * 0.035,
                                  width: mq.width * 0.09,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: NetworkImage(
                                            data.imageLink,
                                          ),
                                          fit: BoxFit.scaleDown))),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.03,
                              ),
                              Text(
                                data.propCategoryName,
                                style: TextStyle(fontSize: 16),
                              )
                            ],
                          ),
                          Padding(
                              padding: const EdgeInsets.only(right: 5),
                              child: select == index
                                  ? Icon(
                                      Icons.keyboard_arrow_up_rounded,
                                      size: 20,
                                    )
                                  : Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                      size: 20,
                                    )),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Visibility(
                          visible: select == index,
                          child: detailprophasdata
                              ? expandWidget(mq, dprop, index)
                              : Center(
                                  child: AwesomeLoader(
                                  loaderType: AwesomeLoader.AwesomeLoader3,
                                  color: Acolors.orange,
                                ))),
                    ),
                    const Divider(
                      thickness: 1,
                    )
                    // Text(dprop.length.toString())
                    // expandWidget(mq, dprop)
                  ],
                ),
              ),
            ),
          );
        });
  }

  Widget expandWidget(Size mq, List<PropList> data, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Column(
        children: [
          Container(
              child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 1.2),
            itemCount: data.length <= 4 ? data.length : 4,
            itemBuilder: (context, index) {
              return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => showProrps(
                                  data: data[index],
                                  cat_name: data[index].propCategoryName,
                                ))).then((value) {
                      setState(() {
                        print('index $index');
                        setState(() {
                          select = -1;
                        });
                      });
                    });
                  },
                  child: Card(
                      elevation: 15,
                      semanticContainer: true,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: Image.network(data[index].thmbnailLink,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                        return Container(
                            child: Center(
                                child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.hide_image_outlined,
                              size: 50,
                            ),
                            Text('No Images to Display'),
                          ],
                        )));
                      })));
            },
          )),
          data.length <= 4
              ? Container()
              : TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PropsGrid(
                                  categorylist: categorylist,
                                  dprop: dprop,
                                  index: index,
                                )));
                  },
                  child: Text(
                    'View More',
                    style: TextStyle(
                      color: Acolors.dark_bround,
                      fontSize: 15,
                      decoration: TextDecoration.underline,
                    ),
                  ))
        ],
      ),
    );
  }
}
