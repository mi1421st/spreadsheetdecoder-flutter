import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spreadsheet_decoder/spreadsheet_decoder.dart';
import 'package:pluto_grid/pluto_grid.dart';

class dataTableHome extends StatefulWidget {
  dataTableHome({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _dataTableState createState() => _dataTableState();
}

class _dataTableState extends State<dataTableHome> {
  Future futureData;

  PlutoGridStateManager stateManager;

  readDataSpreadSheet() async{
    var file = await rootBundle.load("assets/testData.xlsx");
    List<int> bytes = file.buffer.asUint8List(file.offsetInBytes, file.lengthInBytes);
    var spreadSheet = SpreadsheetDecoder.decodeBytes(bytes, update: true);
    for(var sheet in spreadSheet.tables.keys)
    {
      return spreadSheet.tables[sheet].rows;
    }
  }

  void handleSeleceted(){
    List<String> rowValue = [];

    stateManager.currentSelectingRows.forEach((element) {
      element.cells.values.forEach((val) {
        print(val.value.toString());
        rowValue.add(val.value.toString());
      });

      print(rowValue);
    });
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
      body: _body(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => handleSeleceted(),
        tooltip: 'current Selected',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }


  Widget _body() {

    return FutureBuilder(
      future: futureData,
      builder: (context, snapshot) {
        var data =  snapshot.data;
        List<PlutoColumn> columns = [];

        data[0].forEach((value) {
          columns.add(PlutoColumn(
            title: value.toString(),
            field: "${value.toString()}_field",
            type: PlutoColumnType.text(),
          ));
        });



        List<PlutoRow> rows = [];

        print(data.length);
        print(data[0].length);

        for(var i = 1; i < data.length; i++) {
          Map<String, PlutoCell> mappedRow = Map();
          for (var j = 0; j < data[i].length; j++) {
            print(data[i][j]);
            mappedRow["${data[0][j].toString()}_field"] = PlutoCell(value: data[i][j].toString());
          }
          print(mappedRow);
          rows.add(PlutoRow(cells: mappedRow));
        }

        print(columns.length);
        print(rows.length);

        return Container(
          padding: const EdgeInsets.all(10),
          child: PlutoGrid(
              columns: columns,
              rows: rows,
              onLoaded: (PlutoGridOnLoadedEvent event) {
                event.stateManager.setSelectingMode(PlutoGridSelectingMode.row);

                stateManager = event.stateManager;
              },
          ),
        );
      },
    );
  }
}