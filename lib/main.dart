import 'package:flutter/material.dart';
import 'package:universal_html/html.dart' as html;
import 'package:universal_html/driver.dart' as driver;

import 'home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('scraping app'),
        ),
        body: Home(),
      ),
    );
  }
}
