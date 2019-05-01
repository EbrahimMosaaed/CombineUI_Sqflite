/*

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


*/



/*

import 'package:flutter/material.dart';

class NoDoItem extends StatelessWidget {
  // this what we will show
  String _itemName;
  String _dateCreated;
  int _id;

//Constartctor
  NoDoItem(this._itemName, this._dateCreated);

// Mapping all var (setData)
  NoDoItem.map(dynamic obj) {
    this._itemName = obj["itemName"];
    this._dateCreated = obj["dateCreated"];
    this._id = obj["id"];
  }

// Getter for pravite var

  String get itemName => _itemName;
  String get dateCreated => _dateCreated;
  int get id => _id;

// Map for(GetData ) recive and expect string
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["itemName"] = _itemName;
    map["dateCreated"] = _dateCreated;
    if (_id != null) {
      map["id"] = _id;
    }
    return map;
  }

  NoDoItem.fromMap(Map<String, dynamic> map) {
    this._itemName = map["itemName"];
    this._dateCreated = map["dateCreated"];
    this._id = map["id"];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(3.5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                _itemName,
                style: TextStyle(fontSize: 20.0, color: Colors.white),
              ),
              Container(
                margin: const EdgeInsets.only(top: 3.5),
                child: Text(
                  "Created on $_dateCreated",
                  style: TextStyle(fontSize: 15.5, color: Colors.blueGrey),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}


*/



/*

import 'package:flutter/material.dart';
import 'package:notodo_app/moodel/nodo_item.dart';
import 'package:notodo_app/uitil/database_client.dart';

class NotToDoScreen extends StatefulWidget {
  @override
  _NotToDoScreenState createState() => _NotToDoScreenState();
}

class _NotToDoScreenState extends State<NotToDoScreen> {
  final TextEditingController _textEdtingController = TextEditingController();

  var db = DatabaseHelper();
//  List _items;
  final List<NoDoItem> _itemList =
      <NoDoItem>[]; //empty List type of NoDoItem from our moodel

  @override
  void initState() {
    // execute every time when app run
    super.initState();
    _showSubmited();
  }

  void _handelSubmited(String text) async {
    // async bc it dealing with db
    _textEdtingController.clear();
    int savedItem =
        await db.saveItem(NoDoItem(text, DateTime.now().toIso8601String()));
    NoDoItem addedTtem = await db.getItem(savedItem);
    setState(() {
      //ReDrow the screen & show changes
      _itemList.insert(0, addedTtem);
    });
  }

  _showSubmited() async {
    List item = await db.getAllItems();
    for (int i = 0; i < item.length; i++) {
      // NoDoItem noDoItem = NoDoItem.map(item[i]);
      setState(() {
        _itemList.add(NoDoItem.map(item[i]));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      body: Column(
        children: <Widget>[
          Flexible(
            child: ListView.builder(
              padding: EdgeInsets.all(15.0),
              reverse: false,
              itemCount: _itemList.length,
              itemBuilder: (_, int postion) {
                return Card(
                  child: ListTile(
                    title: _itemList[postion],
                    onLongPress: () {},
                    trailing: Listener(
                      // for event (actoin delete)
                      key: Key(_itemList[postion].dateCreated),
                      child: Icon(
                        Icons.remove_circle,
                        color: Colors.red,
                        size: 20.5,
                      ),
                      onPointerDown: (PointerEvent) =>
                          _deleteItem(_itemList[postion].id,postion),
                    ),
                    selected: true,
                  ),
                  color: Colors.black,
                  elevation: 3.0,
                );
              },
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: "Add Item",
        backgroundColor: Colors.red,
        child: ListTile(
          title: Icon(Icons.add),
        ),
        onPressed: _showFormDialog,
      ),
    );
  }

  _showFormDialog() {
    var alert = AlertDialog(
      content: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _textEdtingController,
              autofocus: true,
              decoration: InputDecoration(
                  labelText: "Items", icon: Icon(Icons.note_add)),
            ),
          )
        ],
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            _handelSubmited(_textEdtingController.text);
            _textEdtingController.clear();
            Navigator.pop(context);
          },
          child: Text("Save"),
        ),
        FlatButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Cancel"),
        )
      ],
    );
    showDialog(
        context: context,
        builder: (_) {
          return alert;
        });
  }

  _deleteItem(int id,int postion) async{
    debugPrint("Deleted");
await db.deleteItem(id);
setState(() { // refresh the screen nd redrow after deleteditem gone
  _itemList.removeAt(postion);
});
  }
}



*/