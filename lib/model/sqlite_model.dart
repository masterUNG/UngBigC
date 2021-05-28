import 'dart:convert';

class SQLiteModel {
   int? id;
   String idUser;
   String nameUser;
   String idProduct;
   String nameProduct;
   String price;
   String amount;
   String sum;
  SQLiteModel({
    required this.id,
    required this.idUser,
    required this.nameUser,
    required this.idProduct,
    required this.nameProduct,
    required this.price,
    required this.amount,
    required this.sum,
  });

  SQLiteModel copyWith({
    int? id,
    String? idUser,
    String? nameUser,
    String? idProduct,
    String? nameProduct,
    String? price,
    String? amount,
    String? sum,
  }) {
    return SQLiteModel(
      id: id ?? this.id,
      idUser: idUser ?? this.idUser,
      nameUser: nameUser ?? this.nameUser,
      idProduct: idProduct ?? this.idProduct,
      nameProduct: nameProduct ?? this.nameProduct,
      price: price ?? this.price,
      amount: amount ?? this.amount,
      sum: sum ?? this.sum,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'idUser': idUser,
      'nameUser': nameUser,
      'idProduct': idProduct,
      'nameProduct': nameProduct,
      'price': price,
      'amount': amount,
      'sum': sum,
    };
  }

  factory SQLiteModel.fromMap(Map<String, dynamic> map) {
    return SQLiteModel(
      id: map['id'],
      idUser: map['idUser'],
      nameUser: map['nameUser'],
      idProduct: map['idProduct'],
      nameProduct: map['nameProduct'],
      price: map['price'],
      amount: map['amount'],
      sum: map['sum'],
    );
  }

  String toJson() => json.encode(toMap());

  factory SQLiteModel.fromJson(String source) => SQLiteModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'SQLiteModel(id: $id, idUser: $idUser, nameUser: $nameUser, idProduct: $idProduct, nameProduct: $nameProduct, price: $price, amount: $amount, sum: $sum)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is SQLiteModel &&
      other.id == id &&
      other.idUser == idUser &&
      other.nameUser == nameUser &&
      other.idProduct == idProduct &&
      other.nameProduct == nameProduct &&
      other.price == price &&
      other.amount == amount &&
      other.sum == sum;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      idUser.hashCode ^
      nameUser.hashCode ^
      idProduct.hashCode ^
      nameProduct.hashCode ^
      price.hashCode ^
      amount.hashCode ^
      sum.hashCode;
  }
}
