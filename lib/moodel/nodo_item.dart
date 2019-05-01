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
