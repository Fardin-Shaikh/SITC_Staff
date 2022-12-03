import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:upcomming/Model.dart/task/mytask.dart';
import 'package:upcomming/color/colors.dart';
import 'package:upcomming/hardcore_Data/data.dart';
import 'package:upcomming/screens/Task/assignTask.dart';
import 'package:upcomming/screens/notifications.dart';
import 'package:upcomming/widgets/common.dart';

import '../../responce/all_fetch.dart';
import '../../responce/internetcheck.dart';
import '../home.dart';
import 'showTask.dart';
import 'package:http/http.dart' as http;

class Tasks extends StatefulWidget {
  const Tasks();

  @override
  State<Tasks> createState() => _TasksState();
}

class _TasksState extends State<Tasks> {
  Mytask mytask_repo;
  Mytask alltask_repo;
  Mytask completetask_repo;
  Mytask test;

  bool hasmytask = false;
  bool hasalltask = false;
  bool hascompletedtask = false;

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

  fetch_all() {
    mytask();
    // alltask();
    completetask();
    commontask(1, 'StaffAssignedTask', (value) {
      alltask_repo = value;
      alltask_repo == null ? hasalltask = false : hasalltask = true;
    });
    commontask(3, 'StaffCompletedTask', (value) {
      completetask_repo = value;
      completetask_repo == null
          ? hascompletedtask = false
          : hascompletedtask = true;
    });
  }

  Future<void> mytask() async {
    final prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');
    final String id = prefs.getString('id');
    final uri =
        Uri.http(Fetch.insta.URL1, Fetch.insta.URL2 + 'StaffReceivedTask', {
      'StaffId': id,
      'PageNumber': '1',
    });

    final responce = await http.get(uri, headers: {
      'Apikey': Fetch.insta.Common_apikey,
      'authToken': token + '-' + id,
    });
    log(responce.body);
    if (responce.statusCode == 200) {
      setState(() {
        mytask_repo = Mytask.fromJson(jsonDecode(responce.body));
        mytask_repo == null ? hasmytask = false : hasmytask = true;
      });
      return;
    } else if (responce.statusCode == 401) {
      Fetch.insta.expire_dialog(context);
    } else if (responce.statusCode == 401) {
      Fetch.insta.expire_dialog(context);
    } else if (responce.statusCode == 500) {
      main_toast('Server Not responding ');
    } else {
      main_toast('Something went Wrong');
    }
  }

  Future<void> completetask() async {
    final prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');
    final String id = prefs.getString('id');
    final uri =
        Uri.http(Fetch.insta.URL1, Fetch.insta.URL2 + 'StaffCompletedTask', {
      'PageNumber': '3',
    });

    final responce = await http.get(uri, headers: {
      'Apikey': Fetch.insta.Common_apikey,
      'authToken': token + '-' + id,
    });
    log(responce.body);
    if (responce.statusCode == 200) {
      setState(() {
        completetask_repo = Mytask.fromJson(jsonDecode(responce.body));
        completetask_repo == null ? hasmytask = false : hasmytask = true;
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

  Future<void> commontask(
      int status, String end_url, ValueSetter callback2) async {
    final prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');
    final String id = prefs.getString('id');
    final uri = Uri.http(Fetch.insta.URL1, Fetch.insta.URL2 + end_url, {
      'PageNumber': status.toString(),
    });
    log(uri.toString());
    final responce = await http.get(uri, headers: {
      'Apikey': Fetch.insta.Common_apikey,
      'authToken': token + '-' + id,
    });
    log(responce.body);
    if (responce.statusCode == 200) {
      setState(() {
        completetask_repo = Mytask.fromJson(jsonDecode(responce.body));
        callback2(completetask_repo);

        completetask_repo == null ? hasmytask = false : hasmytask = true;
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

  Widget build(BuildContext context) {
    return  main_widget();
  }

  Widget main_widget() {
    return DefaultTabController(
        length: 3,
        initialIndex: 0,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: Acolors.dark_bround),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text(
              'Task',
              style: TextStyle(color: Acolors.dark_bround),
            ),
            backgroundColor: Acolors.orange,
            elevation: 1,
            bottom: TabBar(
              labelColor: Acolors.dark_bround,
              labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              indicatorColor: Acolors.dark_bround,
              unselectedLabelColor: Acolors.offwhite,
              unselectedLabelStyle:
                  TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
              tabs: const [
                Tab(
                  text: 'My Task',
                ),
                Tab(
                  text: 'All Task',
                ),
                Tab(
                  text: 'Completed Task',
                ),
              ],
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
          body: hasmytask ? TabBarView(
            children: [
              myTask(mytask_repo, true),
              hasalltask
                  ? myTask(alltask_repo, false)
                  : Center(
                      child: CircularProgressIndicator(),
                    ),
              hascompletedtask
                  ? myTask(completetask_repo, false)
                  : Loading_screen(),

              // Center(child:Text('name '))
            ],
          ) : Loading_screen(),
          floatingActionButton: addTaskFloatingbutton(
              context, const Icon(Icons.post_add_outlined), () {
            Navigator.pushNamed(context, '/home/task/add_task').then((_) {
              fetch_all();
              setState(() {
                print("staet run");
              });
            });

            // Navigator.push(context,
            //         MaterialPageRoute(builder: (context) => AssignTask()))
            //     .then((value) {
            //   log('chnaeg ');
            // });
          }),
        ));
  }

  Widget myTask(Mytask temp_resp, bool isnavigation) {
    Size mq = MediaQuery.of(context).size;
    var data = temp_resp.taskdetailslist;
    if (data.length == 0) {
      return Center(
          child: dec_text(
              context, 'No Task ', Acolors.dark_bround, FontWeight.bold, 2));
    }
    return data.length == 0
        ? const Center(
            child: Text('No Task'),
          )
        : ListView.builder(
            itemCount: data.length,
            // itemExtent: 110,
            itemBuilder: (BuildContext context, int index) {
              var chnage = Task_List[index];
              return Padding(
                padding: const EdgeInsets.only(top: 15),
                child: GestureDetector(
                  onTap: isnavigation
                      ? () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => showTask(
                                        data: temp_resp.taskdetailslist[index],
                                      ))).then((value) {
                            fetch_all();
                          });
                        }
                      : () {},
                  child: Container(
                    decoration: const BoxDecoration(
                        //  color: Colors.lightBlue[100],
                        border: Border(
                            bottom: BorderSide(color: Colors.grey, width: 1))),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      child: Row(
                        //here
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            height: mq.height * 0.12,
                            width: mq.width * 0.19,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(data[index].imageLink),
                                  fit: BoxFit.cover),
                              // border: Border.all(
                              //   color: Acolors.dark_bround,
                              // ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Container(
                              // color: Colors.yellow,
                              height: mq.height * 0.12,
                              width: mq.width * 0.722,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Subject",
                                        style: TextStyle(
                                            color: Acolors.light_grey,
                                            fontSize: 13),
                                      ),
                                      Text(
                                        data[index].date,
                                        style: TextStyle(
                                            color: Acolors.light_grey,
                                            fontSize: 13),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: mq.width * 0.7,
                                        child: Text(data[index].description,
                                            style: TextStyle(
                                                color: Acolors.black,
                                                fontSize: 13,
                                                // letterSpacing: 1
                                                height: 2.2)),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Card(
                                        color: Acolors.light_pink,
                                        // margin: const EdgeInsets.symmetric(
                                        //     vertical: 4, horizontal: 8),
                                        child: Text(
                                            "Assigned to - ${data[index].assignBy}",
                                            style: TextStyle(
                                                color: Acolors.dark_bround,
                                                fontSize: 13)),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            });
  }
}
