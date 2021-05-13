import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrape/detail/detail_model.dart';

class Detail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DetailModel>(
      create: (_) => DetailModel(),
      child: Consumer<DetailModel>(
        builder: (context, model, child) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              elevation: 0.0, // 影を非表示
              iconTheme: IconThemeData(
                color: Colors.lightBlue,
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
            body: Container(),
          );
        },
      ),
    );
  }
}
