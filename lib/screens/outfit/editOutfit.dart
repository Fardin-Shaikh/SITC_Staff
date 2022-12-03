import 'dart:developer';

import 'package:image_picker/image_picker.dart';

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:upcomming/Model.dart/outfit/filtered_output.dart';
import 'package:upcomming/color/colors.dart';
import 'package:upcomming/hardcore_Data/data.dart';
import 'package:upcomming/responce/internetcheck.dart';

import '../../widgets/common.dart';

class editOutfit extends StatefulWidget {
  final OutFitList data;
  const editOutfit({this.data});

  @override
  State<editOutfit> createState() => _editOutfitState();
}

class _editOutfitState extends State<editOutfit> {
  File _image;
  TextEditingController name;
  TextEditingController category;
  TextEditingController qty;
  String dropdownvalue = 'Category';
  @override
  void initState() {
    super.initState();
   
    name = TextEditingController(text: widget.data.productName);
    category = TextEditingController(text: widget.data.outfitCategoryName);
    qty = TextEditingController(text: widget.data.quantity);
  }

  @override
  Widget build(BuildContext context) {
    Size mq = MediaQuery.of(context).size;
    return Scaffold(
      appBar: noTabAppBar(context, 'Edit Outfit'),
      bottomSheet: editOutfitbottomsheet(),
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                height: mq.height * 0.35,
                width: mq.width * 1,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: _image == null
                          ? NetworkImage(widget.data.imageLink)
                          : FileImage(_image) as ImageProvider,
                      fit: BoxFit.cover),
                ),
              ),
              Positioned(
                left: 320,
                top: 180,
                child: FloatingActionButton(
                    onPressed: () {
                      imagepop();
                    },
                    tooltip: 'Add Task',
                    backgroundColor: Acolors.dark_bround,
                    foregroundColor: Acolors.white,
                    child: const Icon(
                      Icons.add_photo_alternate_outlined,
                      size: 30,
                    )),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget editOutfitbottomsheet() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      width: MediaQuery.of(context).size.width * 1,
      // color: Color.fromARGB(255, 211, 151, 195),
      child: Padding(
        padding: const EdgeInsets.only(left: 22, right: 22, top: 25),
        child: ListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            cltr_text_field('Name', TextInputType.text, name),
            Padding(
              padding: const EdgeInsets.only(top: 50),
              child: InputDecorator(
                decoration: InputDecoration(),
                child: DropdownButton(
                  underline: Container(),
                  value: dropdownvalue,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: items.map((String items) {
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
                    });
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 50),
              child: cltr_text_field('Quantity', TextInputType.text, qty),
            ),
            Padding(
                padding: const EdgeInsets.only(top: 100),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(88, 50),
                    padding: EdgeInsets.symmetric(horizontal: 16),
                  ),
                  child: const Text("Save"),
                  onPressed: () {
                    smallbottomsheet(context, 'Outfit Added Successfully',
                     () {
                          Navigator.of(context).pop(); //to close the sheet
                          // Navigator.pop(context);
                          Navigator.pop(context);
                          // to navigate to the prevoiuse page
                        }
                    );
                  },
                ))
          ],
        ),
      ),
    );
  }

  pickImage(ImageSource imageSource) async {
    var image = await ImagePicker()
        .pickImage(source: imageSource)
        .then((imgFile) async {
      if (imgFile == null) return;
      final imagtemppath = File(imgFile.path);
      setState(() {
        this._image = imagtemppath;
      });
    });
  }

  void imagepop() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("From where do you want to take photo"),
              actions: [
                TextButton(
                  onPressed: () {
                    pickImage(ImageSource.gallery);
                    Navigator.of(context).pop();
                  },
                  child: const Text("Gallery"),
                ),
                TextButton(
                  onPressed: () {
                    pickImage(ImageSource.camera);
                    Navigator.of(context).pop();
                  },
                  child: const Text("Camera"),
                )
              ],
            ));
    ;
  }
}
