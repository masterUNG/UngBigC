import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ungbigc/model/user_model.dart';
import 'package:ungbigc/utility/my_constant.dart';
import 'package:ungbigc/utility/my_dialog.dart';
import 'package:ungbigc/utility/my_style.dart';
import 'package:ungbigc/widgets/show_image.dart';
import 'package:ungbigc/widgets/show_title.dart';

class Authen extends StatefulWidget {
  @override
  _AuthenState createState() => _AuthenState();
}

class _AuthenState extends State<Authen> {
  final formKey = GlobalKey<FormState>();
  TextEditingController userController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    print('size = $size');
    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: (){
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Center(
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
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
        onPressed: () {
          if (formKey.currentState!.validate()) {
            cheackAughen(
                user: userController.text, password: passwordController.text);
          }
        },
        child: Text('Login'),
      ),
    );
  }

  Future<Null> cheackAughen(
      {@required String? user, @required String? password}) async {
    print('### user = $user, password = $password');
    String api =
        'https://www.androidthai.in.th/bigc/getUserWhereUser.php?isAdd=true&user=$user';
    await Dio().get(api).then((value) async {
      print('## value ==>> $value');

      if (value.toString() == 'null') {
        normalDialog(context, 'User False', 'No $user in my Database');
      } else {
        var result = json.decode(value.data);
        print('### result ==> $result');
        for (var item in result) {
          UserModel model = UserModel.fromMap(item);
          if (password == model.password) {
            SharedPreferences preferences =
                await SharedPreferences.getInstance();
            preferences.setString('user', model.user);
            preferences.setString('name', model.name);
            preferences.setString('id', model.id);

            Navigator.pushNamedAndRemoveUntil(
                context, '/serviceUser', (route) => false);
          } else {
            normalDialog(
                context, 'Password False', 'Please Try Again Password false');
          }
        }
      }
    });
  }

  Container buildUser(double size) {
    return Container(
      margin: EdgeInsets.only(top: 16),
      width: size * 0.6,
      child: TextFormField(
        controller: userController,
        validator: (value) {
          if (value!.isEmpty) {
            return 'โปรด กรอก User';
          } else {
            return null;
          }
        },
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
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.red),
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
        controller: passwordController,
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please Fill Password';
          } else {
            return null;
          }
        },
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
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.red),
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
