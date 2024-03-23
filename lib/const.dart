

import 'package:flutter/material.dart';

const enableBorder =
    UnderlineInputBorder(borderSide: BorderSide(color: Colors.black));
const focusBorder =
    UnderlineInputBorder(borderSide: BorderSide(color: Colors.black));

const backgroundColor = Color(0xFFF2F2F2);
const mainColor = Color(0xFF719f4b);

const div = Padding(
  padding: EdgeInsets.only(left: 8.0, right: 8),
  child: Divider(
    color: Colors.black,
  ),
);

const textsty = TextStyle(
  fontSize: 25,
  color: Colors.black,
);


PreferredSizeWidget appbar(String text) {
  return AppBar(
    backgroundColor: Color(0xffE9E3D5),
    title: Text(
      text,
      style: const TextStyle(
        fontFamily: "Anton",
        wordSpacing: 2,
        // fontWeight: FontWeight.bold,
        fontSize: 22,
      ),
    ),
   
    centerTitle: true,
  );
}