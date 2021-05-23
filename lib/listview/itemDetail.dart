import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class itemDetail extends StatefulWidget{
  itemDetail({@required this.passedData});
  Map passedData;
  @override
  _itemDetailState createState() => _itemDetailState();
}

class _itemDetailState extends State<itemDetail> {
  @override
  Widget build(BuildContext context) {
    var data = widget.passedData;
    return Scaffold(
      body: ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, idx) {
          String key = data.keys.elementAt(idx).toString();
          return Padding(
            padding: EdgeInsets.all(2.0),
            child: Container(
              color: idx % 2 == 0 ? Colors.amberAccent[100] : Colors.amberAccent[200],
              child: Row(
                children: <Widget> [
                  Expanded(child: Text("$key ")),
                  Expanded(child: Text(" : ")),
                  Expanded(child: Text(" ${data[key]}"))
                ],
              ),
            ),
          );
        },
      ),
    );
  }

}