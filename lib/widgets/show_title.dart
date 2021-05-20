import 'package:flutter/material.dart';
import 'package:ungbigc/utility/my_constant.dart';

class ShowTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      'Ung Big C',
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w500,
        color: MyConstant.dart,
      ),
    );
  }
}
