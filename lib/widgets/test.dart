import 'package:flutter/material.dart';

class GlobalTextField extends StatelessWidget {
  final Widget fieldIcon;
  final String fieldText;
  final TextEditingController fieldController;
  final bool isEnabled;

  const GlobalTextField(
    this.fieldIcon,
    this.fieldText,
    this.fieldController, [
    this.isEnabled,
  ]);
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: fieldController,
      enabled: isEnabled ?? true,
      decoration: InputDecoration(
        hintText: fieldText,
        prefixIcon: fieldIcon,
        hintStyle: TextStyle(color: Colors.grey),
        filled: true,
        fillColor: Colors.white70,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color.fromRGBO(198, 57, 93, 1)),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color.fromRGBO(198, 57, 93, 1)),
        ),
      ),
      cursorColor: Color.fromRGBO(198, 57, 93, 1),
    );
  }
}