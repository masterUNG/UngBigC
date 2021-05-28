import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ungbigc/states/authen.dart';
import 'package:ungbigc/states/create_account.dart';
import 'package:ungbigc/states/service_admin.dart';
import 'package:ungbigc/states/service_user.dart';
import 'package:ungbigc/states/show_cart.dart';

final Map<String, WidgetBuilder> map = {
  '/authen': (BuildContext context) => Authen(),
  '/createAccount': (BuildContext context) => CreateAccount(),
  '/serviceAdmin': (BuildContext context) => ServiceAdmin(),
  '/serviceUser': (BuildContext context) => ServiceUser(),
  '/showCart':(BuildContext context)=> ShowCart(),
};

String? initialRoute;

Future<Null> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  String? user = preferences.getString('user');
  if (user?.isEmpty??true) {
    initialRoute = '/authen';
    runApp(MyApp());
  } else {
    initialRoute = '/serviceUser';
    runApp(MyApp());
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: map,
      initialRoute: initialRoute,
      title: 'Ung BigC',
    );
  }
}
