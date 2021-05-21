import 'package:flutter/material.dart';
import 'package:ungbigc/utility/my_constant.dart';

class MyStyle {
  ButtonStyle myButtonStyle() => ElevatedButton.styleFrom(
        primary: MyConstant.light,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      );

  TextStyle h1Style() => TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: MyConstant.dart,
      );

  TextStyle h2Style() => TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: MyConstant.dart,
      );
  TextStyle h3tyle() => TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: MyConstant.dart,
      );

  MyStyle();
}
