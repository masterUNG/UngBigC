import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:ungbigc/model/sqlite_model.dart';

class SQLiteHelper {
  final String nameDatabase = 'bigc.db';
  final String nameTable = 'orderTABLE';
  final int version = 1;

  final String columnId = 'id';
  final String columnIdUser = 'idUser';
  final String columnNameUser = 'nameUser';
  final String columnIdProduct = 'idProduct';
  final String columnNameProduct = 'nameProduct';
  final String columnPrict = 'price';
  final String columnAmount = 'amount';
  final String columnSum = 'sum';

  SQLiteHelper() {
    initDatabase();
  }

  Future<Null> initDatabase() async {
    await openDatabase(
      join(await getDatabasesPath(), nameDatabase),
      onCreate: (db, version) => db.execute(
          'CREATE TABLE $nameTable ($columnId INTEGER PRIMARY KEY, $columnIdUser TEXT, $columnNameUser TEXT, $columnIdProduct TEXT, $columnNameProduct TEXT, $columnPrict TEXT, $columnAmount TEXT, $columnSum TEXT)'),
      version: version,
    );
  }

  Future<Database> connectedDatabase() async {
    return await openDatabase(join(await getDatabasesPath(), nameDatabase));
  }

  Future<Null> insertValueSQLite(SQLiteModel model) async {
    Database database = await connectedDatabase();
    try {
      database.insert(
        nameTable,
        model.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      print('###### insert Success #######');
    } catch (e) {}
  }

  Future<List<SQLiteModel>> readSQLite() async {
    Database database = await connectedDatabase();
    List<SQLiteModel> models = [];

    List<Map<String, dynamic>> maps = await database.query(nameTable);
    for (var item in maps) {
      SQLiteModel model = SQLiteModel.fromMap(item);
      models.add(model);
    }

    return models;
  }

  Future<Null> deletevalueById(int id) async {
    Database database = await connectedDatabase();
    try {
      await database.delete(nameTable, where: '$columnId = $id');
    } catch (e) {}
  }

  Future<Null> deleteAll() async {
    Database database = await connectedDatabase();
    try {
      await database.delete(nameTable);
    } catch (e) {}
  }
} // classs
