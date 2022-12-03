import 'dart:convert';
import 'dart:developer';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_loader/awesome_loader.dart';
import 'package:flutter/material.dart';
import 'package:responsive_flutter/responsive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:upcomming/Model.dart/mini_model/cat_list.dart';
import 'package:upcomming/Model.dart/outfit/filtered_output.dart';
import 'package:upcomming/Model.dart/outfit/gender.dart';
import 'package:upcomming/Model.dart/outfit/outfit_category.dart';
import 'package:upcomming/color/colors.dart';
import 'package:upcomming/hardcore_Data/data.dart';
import 'package:upcomming/responce/all_fetch.dart';
import 'package:upcomming/responce/internetcheck.dart';

import 'package:upcomming/screens/notifications.dart';
import 'package:upcomming/screens/outfit/addOutfits.dart';
import 'package:upcomming/screens/outfit/showOutfit.dart';
import 'package:upcomming/widgets/common.dart';
import 'package:http/http.dart' as http;
import 'package:upcomming/widgets/loader.dart';

import '../home.dart';

class Outfits extends StatefulWidget {
  const Outfits();

  @override
  State<Outfits> createState() => _OutfitsState();
}

// integrate gender api
class _OutfitsState extends State<Outfits> {
  int sel_index = 0;
  // List<bool> init_check = [false, false, false];

  GanderOt genderot_resp;
  Category category_resp;
  FilteredOt filtered_resp;
  //BOOL VARIABLE
  bool gender_bool = false;
  bool cateory_bool = false;
  bool fitered_bool = false;
  //MAKE IN USE VARIAVLES
  List<String> gender_list;
  List<String> gender_list_shortform;

  @override
  void initState() {
    super.initState();
    CK.inst.internet(context, (val) {
      if (val) {
        log('haseinternet');
        fetch_all();
      }
    });
  }

  void fetch_all() {
    setState(() {
      gender_category('StaffOutfitGender').whenComplete(() {
        if (genderot_resp.response.n == 1) {
          gender_list =
              List.generate(genderot_resp.outfitcategorylist.length, (i) {
            return genderot_resp.outfitcategorylist[i].outfitCategoryName;
          });
          gender_list_shortform =
              List.generate(genderot_resp.outfitcategorylist.length, (i) {
            return genderot_resp.outfitcategorylist[i].type;
          });
          outfit_category('StaffOutfitCategory', gender_list_shortform[0])
              .whenComplete(() {
            if (category_resp.response.n == 1) {
              filter_ot(
                  category_resp.outfitcategorylist[0].type,
                  category_resp.outfitcategorylist[0].outfitCategoryId
                      .toString(),
                  'StaffOutFits');
            }
          });
        } else {
          main_toast(genderot_resp.response.msg);
        }
      });
    });
  }

  //FETCH APIS
  Future<void> gender_category(String api_name) async {
    final prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');
    final String id = prefs.getString('id');
    final uri = Uri.http(Fetch.insta.URL1, Fetch.insta.URL2 + api_name);
    final responce = await http.get(uri, headers: {
      'Apikey': Fetch.insta.Common_apikey,
      'authToken': token + '-' + id,
    });
    log(uri.toString());
    // log(responce.body);
    if (responce.statusCode == 200) {
      setState(() {
        var jam = GanderOt.fromJson(jsonDecode(responce.body));
        genderot_resp = jam;
        genderot_resp == null ? gender_bool = false : gender_bool = true;
      });
    } else if (responce.statusCode == 401) {
      Fetch.insta.expire_dialog(context);
    } else if (responce.statusCode == 500) {
      main_toast('Server Not responding ');
    } else {
      main_toast('Something went Wrong');
    }
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
        category_resp = binod;
        category_resp == null ? cateory_bool = false : cateory_bool = true;
      });
    } else if (responce.statusCode == 401) {
      Fetch.insta.expire_dialog(context);
    } else if (responce.statusCode == 500) {
      main_toast('Server Not responding ');
    } else {
      main_toast('Something went Wrong');
    }
  }

  Future<void> filter_ot(
      String gendertype, String OutfitCategoryId, api_name) async {
    final prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');
    final String id = prefs.getString('id');
    final uri = Uri.http(Fetch.insta.URL1, Fetch.insta.URL2 + api_name);

    final responce = await http.post(uri, headers: {
      'Apikey': Fetch.insta.Common_apikey,
      'authToken': token + '-' + id,
    }, body: {
      "OutfitCategoryId": OutfitCategoryId,
      "FromPrice": "",
      "ToPrice": "",
      "GenderType": gendertype,
      "ActionBy": "1",
      "ProfessionalId": "1"
    });
    // print(responce.body);
    log(uri.toString());

    if (responce.statusCode == 200) {
      setState(() {
        filtered_resp = FilteredOt.fromJson(jsonDecode(responce.body));
        filtered_resp == null ? fitered_bool = false : fitered_bool = true;
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
    return gender_bool
        ? DefaultTabController(
            length: gender_bool ? gender_list.length : 1,
            initialIndex: 0,
            child: Scaffold(
              floatingActionButton: addTaskFloatingbutton(
                  context,
                  const Icon(
                    Icons.add_circle_outline_rounded,
                    size: 45,
                  ), () {
                Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                addOutfit(gender_list, gender_list_shortform)))
                    .then((value) {});
              }),
              appBar: AppBar(
                automaticallyImplyLeading: false,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios, color: Acolors.dark_bround),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                title: Text(
                  'Outfits',
                  style: TextStyle(color: Acolors.dark_bround),
                ),
                backgroundColor: Acolors.orange,
                elevation: 1,
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(50),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: TabBar(
                        onTap: ((value) {
                          setState(() {
                            sel_index = 0; //for chips
                          });

                          Utils(context).startLoading();
                          outfit_category('StaffOutfitCategory',
                                  gender_list_shortform[value])
                              .whenComplete(() {
                            if (category_resp.response.n == 1) {
                              filter_ot(
                                      gender_list_shortform[value],
                                      category_resp.outfitcategorylist[0]
                                          .outfitCategoryId
                                          .toString(),
                                      'StaffOutFits')
                                  .whenComplete(() {
                                if (filtered_resp.response.n == 1) {
                                  Utils(context).stopLoading();
                                }
                              });
                            }
                          });
                        }),
                        labelColor: Acolors.dark_bround,
                        labelStyle: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w700),
                        indicatorColor: Acolors.dark_bround,
                        unselectedLabelColor: Acolors.offwhite,
                        unselectedLabelStyle: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w700),
                        //  List<Widget>.generate(cat_list.length, (int index) {

                        tabs: List.generate(
                          gender_list.length,
                          (i) => Tab(text: gender_list[i]),
                        )),
                  ),
                ),
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
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Notif()));
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
                    child: CircleAvatar(
                      radius: 17,
                      backgroundImage: Fetch.insta.final_image_link == " "
                          ? NetworkImage(
                              'https://cdn-icons-png.flaticon.com/128/1144/1144709.png')
                          : NetworkImage(Fetch.insta.final_image_link),
                    ),
                  )
                ],
              ),
              body: TabBarView(
                  children: List.generate(
                      gender_list.length,
                      (index) => cateory_bool
                          ? outfitsBody(category_resp)
                          : Center(
                              child: AwesomeLoader(
                                loaderType: AwesomeLoader.AwesomeLoader3,
                                color: Acolors.orange,
                              ),
                            ))),
            ),
          )
        : Loading_screen();
  }

  Widget outfitsBody(
    Category cat_data,
  ) {
    var data = cat_data.outfitcategorylist;
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 8),
          child: Wrap(
            children: List<Widget>.generate(data.length, (int i) {
              return Transform(
                  transform: Matrix4.identity()..scale(0.9),
                  child: ChoiceChip(
                    label:
                        // dec_text(context, data[i].outfitCategoryName, Acolors.black, FontWeight.w500, 2),
                        Text(data[i].outfitCategoryName,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize:
                                  ResponsiveFlutter.of(context).fontSize(2),
                            )),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        side: BorderSide(
                            color: sel_index == i
                                ? Acolors.dark_bround
                                : Colors.grey[300],
                            width: 0.9,
                            style: BorderStyle.solid)),
                    // shape: StadiumBorder(
                    //     side: BorderSide(
                    //         color: Acolors.dark_bround,
                    //         width: 0.9,
                    //         style: BorderStyle.solid)),
                    labelStyle: TextStyle(
                        color: sel_index == i ? Acolors.white : Acolors.grey),
                    backgroundColor: Colors.white,
                    selected: sel_index == i,
                    selectedColor: Acolors.dark_bround,
                    onSelected: (bool value) {
                      setState(() {
                        sel_index = i;
                        print(i);
                        Utils(context).startLoading();
                        CK.inst.onhit_internet(context, (value) {
                          filter_ot(
                                  category_resp.outfitcategorylist[i].type,
                                  category_resp
                                      .outfitcategorylist[i].outfitCategoryId
                                      .toString(),
                                  'StaffOutFits')
                              .whenComplete(() {
                            Utils(context).stopLoading();
                          });
                        });
                      });
                    },
                  ));
            }),
          ),
        ),
        // Container(
        //   child: Center(
        //       child: TextButton(
        //           onPressed: () {},
        //           child: Text(
        //             'View More',
        //             style: TextStyle(
        //               color: Acolors.dark_bround,
        //             ),
        //           ))),
        // ),
        // OutfitGridview(sorted_data)
        fitered_bool
            ? OutfitGridview(filtered_resp)
            : Center(
                child: AwesomeLoader(
                  loaderType: AwesomeLoader.AwesomeLoader3,
                  color: Acolors.orange,
                ),
              )
      ],
    );
  }

  Widget change() {
    return Container();
  }

  Widget OutfitGridview(FilteredOt data) {
    Size mq = MediaQuery.of(context).size;
    var op = data.outFitList;
    return Padding(
      padding: const EdgeInsets.only(left: 17, right: 17, top: 15, bottom: 8),
      child: GridView.builder(
          itemCount: op.length,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.63),
          itemBuilder: (context, index) {
            // var data = ListwomeOutfit[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => showOutfit(
                              data: op[index],
                              gender: gender_list,
                              gender_short: gender_list_shortform,
                            ))).then((value) {
                  Utils(context).startLoading();
                  CK.inst.onhit_internet(context, (value) {
                    filter_ot(
                            gender_list_shortform[index],
                            category_resp
                                .outfitcategorylist[index].outfitCategoryId
                                .toString(),
                            'StaffOutFits')
                        .whenComplete(() {
                      Utils(context).stopLoading();
                    });
                  });
                });
              },
              child: Card(
                // color: Acolors.dark_bround,
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(12),
                  ),
                  // side: BorderSide(width: 1, color: Colors.green)
                ),
                // decoration: BoxDecoration(
                // borderRadius: BorderRadius.all(
                //   Radius.circular(10)
                //     ),
                //     boxShadow: [ // so here your custom shadow goes:
                //       BoxShadow(
                //         color: Colors.black.withAlpha(20), // the color of a shadow, you can adjust it
                //         spreadRadius: 1, //also play with this two values to achieve your ideal result
                //         blurRadius: 1,
                //         offset: Offset(0, -7), // changes position of shadow, negative value on y-axis makes it appering only on the top of a container
                //       ),
                //     ],
                //   ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              await showDialog(
                                  context: context,
                                  builder: (_) => ImageDialog(
                                        img: op[index].imageLink,
                                      ));
                            },
                            child: Card(
                              elevation: 3.5,
                              child: Container(
                                height: mq.height * 0.21,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: NetworkImage(
                                        op[index].imageLink,
                                      ),
                                      fit: BoxFit.cover),
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 5,
                              right: 5,
                              top: 9,
                            ),
                            child: Container(
                                // color: Colors.pink,
                                // height: mq.height*0.05,
                                alignment: Alignment.topLeft,
                                child: AutoSizeText(
                                  '${op[index].productName} ',
                                  //  minFontSize: ,
                                  softWrap: true,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal,
                                  ),
                                )),
                          )
                        ],
                      ),
                    ),
                    Flexible(
                      child: Container(
                        // color: Colors.blue,
                        height: MediaQuery.of(context).size.height * 0.01,
                      ),
                    ),
                    Divider(color: Acolors.grey, height: mq.height * 0.00),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 10,
                        right: 5,
                        top: 3,
                      ),
                      child: Container(
                        // color: Colors.red,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'INR ${op[index].price}',
                          textDirection: TextDirection.ltr,
                          softWrap: true,
                          style: TextStyle(
                            fontSize:
                                ResponsiveFlutter.of(context).fontSize(1.9),
                            fontWeight: FontWeight.bold,
                            color: Acolors.dark_bround,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }
}

class ImageDialog extends StatelessWidget {
  final String img;

  const ImageDialog({Key key, this.img}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.5,
            // height: 200,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                    image: NetworkImage(img), fit: BoxFit.fill)),
          ),
          Positioned(
            top: 5,
            right: 5,
            child: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(
                  Icons.cancel,
                  size: 30,
                  color: Acolors.white,
                )),
          )
        ],
      ),
    );
  }
}
