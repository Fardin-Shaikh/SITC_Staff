class catogory_list {
  final int id;
  final String name;

  catogory_list({this.id, this.name});
}

class save_var {
  save_var._init();
  static final save_var insta = save_var._init();
  List<catogory_list> Men;
  List<catogory_list> women;
  List<catogory_list> package;

  String token;
  List<catogory_list> props_category;
  List<String> Men_string;
  List<int> Men_int;
  List<String> women_string;
  List<int> women_int;
  List<String> pkg_string;
  List<int> pkg_int;
}
