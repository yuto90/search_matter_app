import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrape/home/home_model.dart';
import 'package:universal_html/html.dart' as html;
import 'package:universal_html/driver.dart' as driver;
import '../detail/detail.dart';

// todo providerを使って書き換える
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController searchWordController = TextEditingController();
  StreamController streamController;
  Stream stream;
  List result;

  void search() async {
    if (searchWordController.text == '') {
      streamController.add(null);
      return;
    }

    streamController.add('waiting');

    result = [];
    String searchWord = searchWordController.text;

    // ! スクレイピング ----------------------------------------------------------------
//    final client = driver.HtmlDriver();
//    final String url = "https://www.lancers.jp/work/search?keyword=$searchWord";
//
//    // Webページを取得
//    await client.setDocumentFromUri(Uri.parse(url));
//
//    // 案件タイトルを取得
//    final List titles =
//        client.document.querySelectorAll('.c-media__title-inner');
//
//    final List links = client.document.querySelectorAll('.c-media__title');
//
//    for (int i = 0; i < titles.length; i++) {
//      // 案件タイトルとリンクの組み合わせリストを生成
//      result.add({
//        'title': titles[i].text.replaceAll(RegExp(r'\s'), ''),
//        'link': links[i].getAttribute("href")
//      });
//    }
//    print(result);
//    streamController.add(result);

    // * テストデータ ---------------------------------------------------------
    await Future.delayed(Duration(seconds: 1));
    result = [
      {'title': 'テストタイトル1', 'link': '/work/detail/3473226'},
      {'title': 'テストタイトル2', 'link': '/work/detail/3052029'},
      {'title': 'テストタイトル3', 'link': '/work/detail/3074955'},
      {'title': 'テストタイトル4', 'link': '/work/detail/3490428'},
      {'title': 'テストタイトル5', 'link': '/work/detail/3375993'},
      {'title': 'テストタイトル6', 'link': '/work/detail/3183881'},
    ];
    streamController.add(result);
  }

  @override
  void initState() {
    super.initState();

    streamController = StreamController();
    stream = streamController.stream;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          keyboardType: TextInputType.text,
          controller: searchWordController,
          decoration: InputDecoration(
            hintText: 'input search word',
            icon: Icon(Icons.add_circle_outline),
          ),
        ),
        FlatButton(
          onPressed: () {
            search();
          },
          child: Text('検索'),
          color: Colors.lightBlue,
        ),
        StreamBuilder(
          stream: stream,
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    border: Border.all(color: Colors.grey, width: 0.3),
                  ),
                  child: Icon(
                    Icons.add,
                    size: 100,
                    color: Colors.lightBlue,
                  ),
                ),
              );
            }

            if (snapshot.data == 'waiting') {
              return Expanded(
                child: Container(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              );
            }

            return ChangeNotifierProvider<HomeModel>(
              create: (_) => HomeModel(),
              child: Consumer<HomeModel>(
                builder: (context, model, child) {
                  return Expanded(
                    child: Container(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                            ),
                            child: FlatButton(
                              padding: EdgeInsets.all(10.0),
                              textColor: Colors.black,
                              // 画面遷移
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Provider<Map>.value(
                                      value: snapshot.data[index],
                                      child: Detail(),
                                    ),
                                  ),
                                );
                              },
                              child: Text(
                                snapshot.data[index]['title'],
                                textScaleFactor: 1.0,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
