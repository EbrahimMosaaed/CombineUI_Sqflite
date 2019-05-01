import 'dart:async';
import 'dart:io';
import 'package:notodo_app/moodel/nodo_item.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;

  final String tableName = "noDoTable";
  final String columnId = "id";
  final String columnItemname = "itemName";
  final String columnDateCreated = "dateCreated";

  static Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();

    return _db;
  }

  DatabaseHelper.internal();

  initDb() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path,
        "nodo_db.db"); //home://directory/files/nodo_db.db

    var ourDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return ourDb;
  }

  void _onCreate(Database db, int newVersion) async {
    await db.execute(
        "CREATE TABLE $tableName(id INTEGER PRIMARY KEY, $columnItemname TEXT, $columnDateCreated TEXT)");
    print("Table is Created");
  }

//CRUD

/* insert
*/

  Future<int> saveItem(NoDoItem item) async {
    var dbClient = await db;

    int res = await dbClient.insert("$tableName", item.toMap());
    return res;
  }

/* Get All Users
 * Future expected List bc will get all user in database
 * 
 */

  Future<List> getAllItems() async {
    var dbClient = await db;
    var result = await dbClient.rawQuery("SELECT * FROM $tableName ORDER BY $columnItemname ASC ");
    return result.toList();
  }

/* Get the count of our table 
 * how many user we have
 *     var dbClient = await db; instance of our db
 */

  Future<int> getCount() async {
    var dbClient = await db;
    return Sqflite.firstIntValue(
        await dbClient.rawQuery("SELECT COUNT(*) FROM $tableName"));
  }
 
/*GEt One User
 */

  Future<NoDoItem> getItem(int id) async {
    var dbClient = await db;
    var result = await dbClient
        .rawQuery("SELECT * FROM $tableName WHERE id =$id");
    if (result.length == 0) return null;
    return NoDoItem.fromMap(result.first);
  }

/**DELETE one USER
 * 
 * where:"$columnId= ?" means we don't know what but whereArgs: [id] here we will know
 * 
 */

  Future<int> deleteItem(int id) async {
    var dbClient = await db;

    return await dbClient
        .delete(tableName, where: "$columnId= ?", whereArgs: [id]);
    // we could put if satamen here if return 1 deleted susseccful else something happedn
  }

/** UPDATE 
 * 
 * 
 */

  Future<int> updateItem(NoDoItem item) async {
    var dbClient = await db;
    return await dbClient.update(tableName, item.toMap(),
        where: "$columnId = ?", whereArgs: [item.id]);
  }
/** CLOSE DATABASE
 * 
 */

  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }
}
