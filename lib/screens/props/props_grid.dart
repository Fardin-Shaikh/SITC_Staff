import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:upcomming/Model.dart/mini_model/cat_list.dart';
import 'package:upcomming/Model.dart/props/detailprops.dart';
import 'package:upcomming/color/colors.dart';
import 'package:upcomming/hardcore_Data/data.dart';
import 'package:upcomming/screens/outfit/addOutfits.dart';
import 'package:upcomming/screens/props/addProp.dart';
import 'package:upcomming/screens/props/showProp.dart';
import 'package:upcomming/widgets/common.dart';

import '../../Model.dart/props/category.dart';

class PropsGrid extends StatefulWidget {
  final List<Propcategorylist> categorylist;
  final List<PropList> dprop;
  final int index;

  const PropsGrid({this.categorylist, this.dprop, this.index});

  @override
  State<PropsGrid> createState() => _PropsGridState();
}

class _PropsGridState extends State<PropsGrid> {
  int selectedindex = 0;
  int _curr = 0;

  @override
  Widget build(BuildContext context) {
    Size mq = MediaQuery.of(context).size;
    return Scaffold(
      appBar: noTabAppBar(
          context, widget.categorylist[widget.index].propCategoryName),
      floatingActionButton: addTaskFloatingbutton(
          
          context,
          const Icon(
            Icons.add_circle_outline_rounded,
            size: 45,
          ),
           () {
      Navigator.push(context, MaterialPageRoute(builder: (context) => addProp()));
    }
          ),
      body: ListView(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.03,
          ),
          // SizedBox(
          //   height: mq.height * 0.08,
          //   child: ListView.builder(
          //       itemCount: widget.categorylist.length,
          //       // itemExtent: 100,
          //       scrollDirection: Axis.horizontal,
          //       itemBuilder: (BuildContext context, int index) {
          //         var data = widget.categorylist[index];

          //         return ChoiceChip(
          //           label: Text(data.propCategoryName),
          //           labelStyle: TextStyle(
          //               color: selectedindex == index
          //                   ? Acolors.white
          //                   : Acolors.black),
          //           backgroundColor: Acolors.offwhite,
          //           selected: selectedindex == index,
          //           selectedColor: Acolors.dark_bround,
          //           onSelected: (bool value) {
          //             setState(() {
          //               selectedindex = value ? index : 0;
          //             });
          //           },
          //         );
          //       }),
          // ),
          itemGrid()
        ],
      ),
    );
  }

  Widget itemGrid() {
    var data = widget.dprop;

    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              childAspectRatio: 1.2),
          itemCount: data.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => showProrps(
                              data: data[index],
                              cat_name: data[index].propCategoryName,
                            )));
              },
              child: Card(
                elevation: 2,
                semanticContainer: true,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: Image.network(
                  widget.dprop[index].thmbnailLink,
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
