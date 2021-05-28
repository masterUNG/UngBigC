import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ungbigc/model/sqlite_model.dart';
import 'package:ungbigc/utility/my_constant.dart';
import 'package:ungbigc/utility/my_dialog.dart';
import 'package:ungbigc/utility/my_style.dart';
import 'package:ungbigc/utility/sqlite_helper.dart';
import 'package:ungbigc/widgets/show_progress.dart';
import 'package:ungbigc/widgets/show_title.dart';

class ShowCart extends StatefulWidget {
  @override
  _ShowCartState createState() => _ShowCartState();
}

class _ShowCartState extends State<ShowCart> {
  List<SQLiteModel> models = [];
  int total = 0;
  bool load = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readCart();
  }

  Future<Null> readCart() async {
    if (models.length != 0) {
      models.clear();
      total = 0;
    }

    await SQLiteHelper().readSQLite().then((value) {
      setState(() {
        load = false;
      });
      var result = value;
      print('### value.lenght ==>> ${result.length}');
      for (var item in result) {
        setState(() {
          models.add(item);
          total = total + int.parse(item.sum);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Show Cart'),
        backgroundColor: MyConstant.primary,
      ),
      body: load
          ? ShowProgress()
          : models.length == 0
              ? Center(
                  child: ShowTitle(
                      title: 'No Cart', textStyle: MyStyle().h1Style()))
              : buildContent(),
    );
  }

  Column buildContent() {
    return Column(
      children: [
        buildHead(),
        buildListView(),
        Divider(
          color: Colors.black,
        ),
        buildButton(),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton.icon(
              onPressed: () => processOrder(),
              icon: Icon(Icons.cloud_upload),
              label: Text('Order'),
            ),
            SizedBox(
              width: 20,
            ),
          ],
        ),
      ],
    );
  }

  Future<Null> processOrder() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? idUser = preferences.getString('id');
    String? nameUser = preferences.getString('name');
    String? idProduct = changeIdProduct();
    String? nameProduct = changeNameProduct();
    String? price = changePrice();
    String? amount = changeAmount();

    String api =
        'https://www.androidthai.in.th/bigc/orderUng.php?isAdd=true&idUser=$idUser&nameUser=$nameUser&$idProduct=idProduct&nameProduct=$nameProduct&price=$price&amount=$amount';

    print('### api ==>> $api');

    await Dio().get(api).then((value) async {
      if (value.toString() == 'true') {
        await SQLiteHelper().deleteAll().then((value) => readCart());
      } else {
        normalDialog(context, 'Cannot Order', 'Please Try Again');
      }
    });
  }

  String changeIdProduct() {
    List<String> results = [];
    for (var model in models) {
      results.add(model.idProduct);
    }
    return results.toString();
  }

  String changeNameProduct() {
    List<String> results = [];
    for (var model in models) {
      results.add(model.nameProduct);
    }
    return results.toString();
  }

  String changePrice() {
    List<String> results = [];
    for (var model in models) {
      results.add(model.price);
    }
    return results.toString();
  }

  String changeAmount() {
    List<String> results = [];
    for (var model in models) {
      results.add(model.amount);
    }
    return results.toString();
  }

  Row buildButton() {
    return Row(
      children: [
        Expanded(
          flex: 5,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ShowTitle(
                title: 'Total :',
                textStyle: MyStyle().h1Style(),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: ShowTitle(
            title: '$total',
            textStyle: MyStyle().h1Style(),
          ),
        ),
      ],
    );
  }

  Container buildHead() {
    return Container(
      decoration: BoxDecoration(color: Colors.green.shade300),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: ShowTitle(
                title: 'Name',
                textStyle: MyStyle().h2Style(),
              ),
            ),
            Expanded(
              flex: 1,
              child: ShowTitle(
                title: 'Price',
                textStyle: MyStyle().h2Style(),
              ),
            ),
            Expanded(
              flex: 1,
              child: ShowTitle(
                title: 'Amount',
                textStyle: MyStyle().h2Style(),
              ),
            ),
            Expanded(
              flex: 2,
              child: ShowTitle(
                title: 'Sum',
                textStyle: MyStyle().h2Style(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ListView buildListView() {
    return ListView.builder(
      physics: ScrollPhysics(),
      shrinkWrap: true,
      itemCount: models.length,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.only(left: 4, right: 4),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: ShowTitle(
                title: models[index].nameProduct,
                textStyle: MyStyle().h3tyle(),
              ),
            ),
            Expanded(
              flex: 1,
              child: ShowTitle(
                title: models[index].price,
                textStyle: MyStyle().h3tyle(),
              ),
            ),
            Expanded(
              flex: 1,
              child: ShowTitle(
                title: models[index].amount,
                textStyle: MyStyle().h3tyle(),
              ),
            ),
            Expanded(
              flex: 1,
              child: ShowTitle(
                title: models[index].sum,
                textStyle: MyStyle().h3tyle(),
              ),
            ),
            Expanded(
              flex: 1,
              child: IconButton(
                  onPressed: () => deleteById(models[index].id),
                  icon: Icon(Icons.delete_forever_outlined)),
            ),
          ],
        ),
      ),
    );
  }

  Future<Null> deleteById(int? id) async {
    print('### You delete id = $id');
    await SQLiteHelper().deletevalueById(id!).then(
          (value) => readCart(),
        );
  }
}
