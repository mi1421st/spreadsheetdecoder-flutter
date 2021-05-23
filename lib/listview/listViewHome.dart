import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spreadsheet_decoder/spreadsheet_decoder.dart';
import 'package:spreadsheet_decoder_v1/listview/itemDetail.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  Future futureData;

  readDataSpreadSheet() async{
    var file = await rootBundle.load("assets/testData.xlsx");
    List<int> bytes = file.buffer.asUint8List(file.offsetInBytes, file.lengthInBytes);
    var spreadSheet = SpreadsheetDecoder.decodeBytes(bytes, update: true);
    for(var sheet in spreadSheet.tables.keys)
    {
      return spreadSheet.tables[sheet].rows;
    }

  }

  @override
  void initState() {
    super.initState();
    futureData = readDataSpreadSheet();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _body2(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => readDataSpreadSheet(),
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget _body() {
    return FutureBuilder(
        future: futureData,
        builder: (context, data) {
          return ListView.builder(
              itemCount: data.data.length,
              itemBuilder:  (context, idx) {
                return Padding(
                  padding: idx > 0 ? const EdgeInsets.all(8.0) : const EdgeInsets.all(0),
                  child: InkWell(
                    onLongPress: () {
                      Map map = Map.fromIterables(data.data[0], data.data[idx]);
                      print(map);
                      print(map.length);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => itemDetail(passedData: map,)));
                    },
                    child: Container(
                      height: idx > 0 ? 70 : 0,
                      color: Colors.lightGreenAccent[200],
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: data.data[idx].length,
                          itemBuilder: (context, i) {
                            return idx > 0 ? Container(
                              color: i % 2 == 0 ? Colors.amberAccent[100] : Colors.amber[100],
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                      padding: EdgeInsets.only(left: 7, right: 7),
                                      height: 32,
                                      child: Text(data.data[0][i].toString()),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      padding: EdgeInsets.only(left: 7, right: 7),
                                      height: 32,
                                      child: data.data[idx][i] != null ?
                                      Text(data.data[idx][i].toString())
                                          : Text(''),
                                    ),
                                  ),
                                ],
                              ),
                            ):null;
                          }
                      ),
                    ),
                  ),
                );
              }
          );
        }
    );
  }

  Widget _body2() {
    return FutureBuilder(
      future: futureData,
      builder: (context, data) {
        print(data.data[0]);
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
            width: MediaQuery.of(context).size.width * 30,
            color: Colors.cyanAccent,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: data.data.length,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, idx) {
                  return Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Row(
                          mainAxisSize: MainAxisSize.max,
                          children: data.data[idx].map<Widget>((row) {
                            return Expanded(
                              child: Padding(
                                padding:  EdgeInsets.all(5),
                                  child:  Container(
                                    alignment: Alignment.centerLeft,
                                      color: Colors.amberAccent,
                                      child: Text(
                                          row.toString(),
                                      ),
                                    ),
                                  ),
                            );
                          }).toList(),
                      ),
                    ],
                  );
                }
            ),
          ),
        );
      }
    );

  }
}
