import 'package:flutter/material.dart';
import 'package:spreadsheet_decoder_v1/dataTable/dataTableHome.dart';
import 'listview/listViewHome.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter SpreadSheet v1',
      theme: ThemeData(
        primaryColor: Colors.amber
      ),
      home: dataTableHome(title: 'Home Page'),
    );
  }
}

