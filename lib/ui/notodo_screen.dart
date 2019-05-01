import 'package:flutter/material.dart';
import 'package:notodo_app/moodel/nodo_item.dart';
import 'package:notodo_app/uitil/database_client.dart';
import 'package:notodo_app/uitil/date_format.dart';

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
    int savedItem = await db.saveItem(NoDoItem(text, dateformatted()));
    NoDoItem addedTtem = await db.getItem(savedItem);
    setState(() {
      //Redrow the screen & show changes
      _itemList.insert(0, addedTtem);
    });
  }


  _showSubmited() async {
    List item = await db.getAllItems();
    for (int i = 0; i < item.length; i++) {
      // NoDoItem noDoItem = NoDoItem.map(item[i]);
      setState(() {
        // refresh and redrow
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
                    onLongPress: () =>
                        _updatedItem(_itemList[postion], postion),
                    trailing: Listener(
                      // for event (delete action)
                      key: Key(_itemList[postion].dateCreated),
                      child: Icon(
                        Icons.remove_circle,
                        color: Colors.red,
                        size: 20.5,
                      ),
                      onPointerDown: (PointerEvent) =>
                          _deleteItem(_itemList[postion].id, postion),
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


// Dialog for insert or save
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

//Deleted item method //notice in db we need to pass int id only but here we increes int postion (take it as index to push and use with _itemList)
  _deleteItem(int id, int postion) async {
    debugPrint("Deleted");
    await db.deleteItem(id);
    setState(() {
      // refresh the screen nd redrow after deleted item
      _itemList.removeAt(postion);
    });
  }


//Dialog for updated
  _updatedItem(NoDoItem item, int postion) {
    var alert = AlertDialog(
      title: Text("Update Item"),
      content: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _textEdtingController,
              autofocus: true,
              decoration: InputDecoration(
                  labelText: "item",
                  hintText: "eg. Don't do!",
                  icon: Icon(Icons.update)),
            ),
          ),
        ],
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () async {
            NoDoItem newUpdatedItem = NoDoItem.fromMap({
              "itemName": _textEdtingController.text,
              "dateCreated": dateformatted(),
              "id": item.id
            });

            _handelSubmitedUpdate(postion, item);
            await db.updateItem(newUpdatedItem);

            setState(() {
              // after do all updated go and retrive all item from showSubmited method
              _showSubmited();
            });
            Navigator.pop(context);
          },
          child: Text("Update"),
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


  void _handelSubmitedUpdate(int postion, NoDoItem item) {
    //call the database again after uptade redorw screen show changes

    // removeWhere(we pass the postion to know which row gonna updated then we pass the acutal object NoDoItem)
    // means loop to the list with positon and fine itemName WHICH equal to item.itemName
    setState(() {
      _itemList.removeWhere((element) {
        _itemList[postion].itemName == item.itemName;
      });
    });
  }



}
