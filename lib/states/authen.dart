import 'package:flutter/material.dart';
import 'package:ungbigc/utility/my_constant.dart';
import 'package:ungbigc/utility/my_style.dart';
import 'package:ungbigc/widgets/show_image.dart';
import 'package:ungbigc/widgets/show_title.dart';

class Authen extends StatefulWidget {
  @override
  _AuthenState createState() => _AuthenState();
}

class _AuthenState extends State<Authen> {
  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    print('size = $size');
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                buildImage(size),
                buildShowTitle(),
                buildUser(size),
                buildPassword(size),
                buildLogin(size),
                buildRow()
              ],
            ),
          ),
        ),
      ),
    );
  }

  ShowTitle buildShowTitle() {
    return ShowTitle(
                title: 'Ung BigC',
                textStyle: MyStyle().h1Style(),
              );
  }

  Row buildRow() {
    return Row(mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ShowTitle(
                    title: 'Non Account ? ',
                    textStyle: MyStyle().h3tyle(),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pushNamed(context, '/createAccount'),
                    child: Text('Create Account'),
                  ),
                ],
              );
  }

  Container buildLogin(double size) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16),
      width: size * 0.6,
      child: ElevatedButton(
        style: MyStyle().myButtonStyle(),
        onPressed: () {},
        child: Text('Login'),
      ),
    );
  }

  Container buildUser(double size) {
    return Container(
      margin: EdgeInsets.only(top: 16),
      width: size * 0.6,
      child: TextFormField(
        decoration: InputDecoration(
          labelText: 'User :',
          prefixIcon: Icon(
            Icons.perm_identity,
            color: MyConstant.dart,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: MyConstant.dart),
          ),
        ),
        keyboardType: TextInputType.text,
      ),
    );
  }

  Container buildPassword(double size) {
    return Container(
      margin: EdgeInsets.only(top: 16),
      width: size * 0.6,
      child: TextFormField(
        obscureText: true,
        decoration: InputDecoration(
          suffixIcon: IconButton(
            onPressed: () {},
            icon: Icon(Icons.remove_red_eye),
          ),
          labelText: 'Password :',
          prefixIcon: Icon(
            Icons.lock_outline,
            color: MyConstant.dart,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: MyConstant.dart),
          ),
        ),
        keyboardType: TextInputType.text,
      ),
    );
  }

  Container buildImage(double size) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16),
      width: size * 0.5,
      child: ShowImage(),
    );
  }
}
