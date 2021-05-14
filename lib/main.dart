import 'package:flutter/material.dart';
import 'package:scrape/home/home.dart';
import 'footer/footer.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0.0, // 影を非表示
          leading: Container(), // 戻るボタンを非表示
          iconTheme: IconThemeData(
            color: Colors.orange,
          ),
          backgroundColor: Colors.white,
          brightness: Brightness.light, // ステータスバー白黒反転
          title: Text(
            'scraping app',
            style: TextStyle(
              color: Colors.lightBlue,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        //body: Home(),
        body: HomePage(),
        bottomNavigationBar: Footer(),
      ),
    );
  }
}
