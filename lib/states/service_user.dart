import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ungbigc/model/product_model.dart';
import 'package:ungbigc/model/sqlite_model.dart';
import 'package:ungbigc/utility/my_constant.dart';
import 'package:ungbigc/utility/my_style.dart';
import 'package:ungbigc/utility/sqlite_helper.dart';
import 'package:ungbigc/widgets/show_image.dart';
import 'package:ungbigc/widgets/show_progress.dart';
import 'package:ungbigc/widgets/show_title.dart';

class ServiceUser extends StatefulWidget {
  @override
  _ServiceUserState createState() => _ServiceUserState();
}

class _ServiceUserState extends State<ServiceUser> {
  List<Widget> widgets = [];
  List<String> pathImages = [
    'images/banner1.png',
    'images/banner2.png',
    'images/banner3.png',
  ];

  List<ProductModel> productModels = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    buildWidgets();
    readData();
  }

  Future<Null> readData() async {
    String api = 'https://www.androidthai.in.th/bigc/getAllFood.php';
    await Dio().get(api).then((value) {
      print('### value = $value');
      for (var item in json.decode(value.data)) {
        ProductModel model = ProductModel.fromMap(item);
        setState(() {
          productModels.add(model);
        });
      }
    });
  }

  void buildWidgets() {
    for (var item in pathImages) {
      widgets.add(Image.asset(item));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome User'),
        backgroundColor: MyConstant.primary,
        actions: [
          buildIShowCart(context),
          buildSignOut(),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            buildCarouselSlider(),
            buildTitle(),
            productModels.length == 0 ? ShowProgress() : buildListView()
          ],
        ),
      ),
    );
  }

  IconButton buildIShowCart(BuildContext context) {
    return IconButton(
      onPressed: () => Navigator.pushNamed(context, '/showCart'),
      icon: Icon(Icons.shopping_cart),
    );
  }

  String cutWord(String string) {
    String word = string;
    if (word.length > 100) {
      word = word.substring(1, 100);
      word = '$word ...';
    }
    return word;
  }

  Future<Null> showDetailDialog(ProductModel model) async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: ListTile(
          leading: ShowImage(),
          title: ShowTitle(
            title: model.nameFood,
            textStyle: MyStyle().h2Style(),
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Image.network(
                'https://www.androidthai.in.th/bigc${model.image}'),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ShowTitle(
              title: model.category,
              textStyle: MyStyle().h2Style(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ShowTitle(
              title: model.detail,
              textStyle: MyStyle().h3tyle(),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  processAddCart(model);
                },
                child: Text('Add Cart'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<Null> processAddCart(ProductModel productModel) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? idUser = preferences.getString('id');
    String? nameUser = preferences.getString('name');

    SQLiteModel model = SQLiteModel(
        id: null,
        idUser: idUser!,
        nameUser: nameUser!,
        idProduct: productModel.id,
        nameProduct: productModel.nameFood,
        price: productModel.price,
        amount: '1',
        sum: productModel.price);

    await SQLiteHelper()
        .insertValueSQLite(model)
        .then((value) => print('#### processAddCart Success ###'));
  }

  ListView buildListView() {
    return ListView.builder(
      shrinkWrap: true,
      physics: ScrollPhysics(),
      itemCount: productModels.length,
      itemBuilder: (context, index) => GestureDetector(
        onTap: () {
          showDetailDialog(productModels[index]);
        },
        child: Card(
          color: index % 2 == 0 ? Colors.grey.shade300 : Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 250,
                  height: 120,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShowTitle(
                        title: productModels[index].nameFood,
                        textStyle: MyStyle().h2Style(),
                      ),
                      ShowTitle(
                        title: cutWord(productModels[index].detail),
                        textStyle: MyStyle().h3tyle(),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 120,
                  child: Image.network(
                      'https://www.androidthai.in.th/bigc${productModels[index].image}'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row buildTitle() {
    return Row(
      children: [
        SizedBox(
          width: 16,
        ),
        ShowTitle(
          title: 'Product :',
          textStyle: MyStyle().h1Style(),
        ),
      ],
    );
  }

  CarouselSlider buildCarouselSlider() {
    return CarouselSlider(
      items: widgets,
      options: CarouselOptions(
        autoPlay: true,
        autoPlayAnimationDuration: Duration(seconds: 2),
        aspectRatio: 16 / 9,
        enlargeCenterPage: true,
      ),
    );
  }

  IconButton buildSignOut() {
    return IconButton(
      onPressed: () async {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.clear();
        Navigator.pushNamedAndRemoveUntil(context, '/authen', (route) => false);
      },
      icon: Icon(Icons.exit_to_app),
    );
  }
}
