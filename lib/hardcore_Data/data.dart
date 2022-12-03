import 'package:flutter/material.dart';
import 'package:upcomming/main.dart';
import 'package:upcomming/screens/availability/availability.dart';
import 'package:upcomming/screens/billing/billing.dart';
import 'package:upcomming/screens/checkout/checkout.dart';
import 'package:upcomming/screens/dummy.dart';
import 'package:upcomming/screens/outfit/Outfits.dart';
import 'package:upcomming/screens/Shoots.dart';
import 'package:upcomming/screens/Task/Task.dart';
import 'package:upcomming/screens/attendance/attendance.dart';
import 'package:upcomming/screens/home.dart';
import 'package:upcomming/screens/props/props.dart';

import 'package:upcomming/screens/signin.dart';

class catogory_data {
  final String image;
  final String title;

  catogory_data({this.image, this.title});
}

List<catogory_data> cat_list = [
  catogory_data(image: 'lib/assets/Layer_1.png', title: 'Attendance'),
  catogory_data(image: 'lib/assets/002-shooting-schedule.png', title: 'Shoot'),
  catogory_data(image: 'lib/assets/tasks.png', title: 'Task'),
  catogory_data(image: 'lib/assets/010-stage-props.png', title: 'Props'),
  catogory_data(image: 'lib/assets/009-wardrobe.png', title: 'Outfits'),
  catogory_data(image: 'lib/assets/booking.png', title: 'Availability'),
  catogory_data(image: 'lib/assets/enquiry.png', title: 'Billing'),
  catogory_data(image: 'lib/assets/plan.png', title: 'CheckOut'),
  catogory_data(image: 'lib/assets/report.png', title: 'CheckOut'),
  catogory_data(image: 'lib/assets/chat.png', title: 'Feedback'),
];

List<dynamic> class_list = [
  Attendance(),
  Shoots(),
  Tasks(),
  Props(),
  Outfits(),
  Avail(),
  Billing(),
  CheckOut(),
];

class props_data {
  final String image;
  final String title;

  props_data({this.image, this.title});
}

List<props_data> props_list = [
  props_data(image: 'lib/assets/desk-lamp.png', title: 'Lamps'),
  props_data(image: 'lib/assets/vase.png', title: 'Artifacts'),
  props_data(image: 'lib/assets/flowers.png', title: 'Flowers'),
  props_data(image: 'lib/assets/couch.png', title: 'Furniture'),
  props_data(image: 'lib/assets/prayer-rug.png', title: 'Rugs'),
  props_data(image: 'lib/assets/chest-of-drawers.png', title: 'Furnishings'),
  props_data(image: 'lib/assets/mobile-toy.png', title: 'Others'),
];

List<String> propcataegoryList = [
  'Category',
  'Lamps',
  'Artifacts',
  'Flowers',
  'Furniture',
  'Rugs',
  'Furnishings',
  'Others',
];
List<String> outfitTypeList = [
  'All',
  'Dress',
  'Shirts',
  'Saree',
  'Casual',
  'Casual',
  'Casual',
  'Casual',
  'Casual',
  'Casual',
];

class WomenOutfit {
  final String imageurl;
  final String name;
  final double price;

  WomenOutfit({this.imageurl, this.name, this.price});
}

List<WomenOutfit> ListwomeOutfit = [
  WomenOutfit(
      imageurl:
          'https://images.unsplash.com/photo-1603570388466-eb4fe5617f0d?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTd8fHdvbWVufGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=500&q=60',
      name: 'Midi Dress',
      price: 2000),
  WomenOutfit(
      imageurl:
          'https://images.unsplash.com/photo-1588117260148-b47818741c74?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8ZmFzaW9uJTIwd29tZW58ZW58MHx8MHx8&auto=format&fit=crop&w=500&q=60',
      name: 'Off the Shoulder',
      price: 4000),
  WomenOutfit(
      imageurl:
          'https://images.unsplash.com/photo-1628589712886-072764ecb1ec?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8N3x8ZmFzaW9uJTIwd29tZW58ZW58MHx8MHx8&auto=format&fit=crop&w=500&q=60',
      name: 'Dress 3',
      price: 6000),
  WomenOutfit(
      imageurl:
          'https://images.unsplash.com/photo-1582749474001-14328121e605?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTZ8fHdvbWVuJTIwc2luZ2xlfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=500&q=60',
      name: 'Dress4',
      price: 7000),
  WomenOutfit(
      imageurl:
          'https://images.unsplash.com/photo-1542145748-308fcfd31cc9?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MjB8fHdvbWVuJTIwc2luZ2xlfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=500&q=60',
      name: 'Dress5',
      price: 3000),
  WomenOutfit(
      imageurl:
          'https://images.unsplash.com/photo-1558171813-4c088753af8f?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8OHx8Y2xvdGhzfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=500&q=60',
      name: 'dress6',
      price: 1000),
];

class props {
  final String imageurl;
  final String name;
  final int qty;
  final String catogory;

  props({this.imageurl, this.name, this.qty, this.catogory});
}

List<props> props_list_data = [
  props(
      imageurl: 'lib/assets/temp_asset/prop1.png',
      name: 'Cups',
      qty: 2,
      catogory: 'Articals'),
  props(
      imageurl: 'lib/assets/temp_asset/prop2.jpg',
      name: 'laltain',
      qty: 3,
      catogory: 'Articals'),
  props(
      imageurl: 'lib/assets/temp_asset/prop3.jpg',
      name: 'Lorem Ipsum',
      qty: 2,
      catogory: 'Lamp'),
  props(
      imageurl: 'lib/assets/temp_asset/prop1.png',
      name: 'Cups',
      qty: 2,
      catogory: 'Articals'),
  props(
      imageurl: 'lib/assets/temp_asset/prop2.jpg',
      name: 'laltain',
      qty: 3,
      catogory: 'Articals'),
  props(
      imageurl: 'lib/assets/temp_asset/prop3.jpg',
      name: 'Lorem Ipsum',
      qty: 2,
      catogory: 'Lamp'),
  props(
      imageurl: 'lib/assets/temp_asset/prop1.png',
      name: 'Cups',
      qty: 2,
      catogory: 'Articals'),
  props(
      imageurl: 'lib/assets/temp_asset/prop2.jpg',
      name: 'laltain',
      qty: 3,
      catogory: 'Articals'),
  props(
      imageurl: 'lib/assets/temp_asset/prop3.jpg',
      name: 'Lorem Ipsum',
      qty: 2,
      catogory: 'Lamp'),
];

class Task {
  final String date;
  final String task;
  final String assignedTo;

  Task({this.date, this.task, this.assignedTo});
}

List<Task> Task_List = [
  Task(
      date: '02/10/2022',
      task: 'Complete Shoot 3 with limited resources',
      assignedTo: 'Rahul Jh'),
  Task(
      date: '03/10/2022',
      task: 'Complete Shoot 4 with limited resources',
      assignedTo: 'Fardin Shaikh'),
  Task(
      date: '07/10/2022',
      task: 'Complete Shoot 2 with limited resources',
      assignedTo: 'Shrada Aher'),
  Task(
      date: '08/10/2022',
      task: 'Complete Shoot 5 with limited resources',
      assignedTo: 'Shrutu Suruti'),
  Task(
      date: '12/10/2022',
      task: 'Complete Shoot 1 with limited resources',
      assignedTo: 'Firoz Shaikh'),
  Task(
      date: '14/10/2022',
      task: 'Complete Shoot 6 with limited resources',
      assignedTo: 'Akash Aher'),
  Task(
      date: '19/10/2022',
      task: 'Complete Shoot 7 with limited resources',
      assignedTo: 'Kapil xyz'),
  Task(
      date: '13/10/2022',
      task: 'Complete Shoot 8 with limited resources',
      assignedTo: 'Mahersh abc'),
  Task(
      date: '15/10/2022',
      task: 'Complete Shoot 9 with limited resources',
      assignedTo: 'Akash Gajra'),
  Task(
      date: '20/10/2022',
      task: 'Complete Shoot 10 with limited resources',
      assignedTo: 'Aishwarya Kanaker'),
];

List<String> items = [
  'Category',
  'Men',
  'Women',
  'Kids',
];

List<String> tabs = [
  'Men',
  'Women',
  'Kids',
  // 'abs',
];
