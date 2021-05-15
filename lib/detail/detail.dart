import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrape/detail/detail_model.dart';
import 'package:url_launcher/url_launcher.dart';

class Detail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final title = Provider.of<Map>(context)['title'];
    final link = Provider.of<Map>(context)['link'];

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
                title,
                style: TextStyle(
                  color: Colors.lightBlue,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            body: Container(
              child: Column(
                children: [
                  Text(
                    'https://www.lancers.jp' + link,
                  ),
                  FutureBuilder(
                    future: model.scrapeDetail(link),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Text(snapshot.data);
                      } else {
                        return Expanded(
                          child: Container(
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        );
                      }
                    },
                  ),
                  FlatButton(
                    child: Text('ブラウザで開く'),
                    onPressed: () async {
                      model.launchInBrowser(link);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
