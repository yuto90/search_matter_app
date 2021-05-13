import 'dart:async';
import 'package:flutter/material.dart';
import 'package:universal_html/html.dart' as html;
import 'package:universal_html/driver.dart' as driver;
import 'detail/detail.dart';

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
//    String searchWord = searchWordController.text;
//
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
//    for (final title in titles) {
//      print(title.text.replaceAll(RegExp(r'\s'), ''));
//      result.add(title.text.replaceAll(RegExp(r'\s'), ''));
//    }
//
//    streamController.add(result);

    await Future.delayed(Duration(seconds: 1));
    final titles = [
      'aaaaa',
      'bbbbb',
      'ccccc',
      'ddddd',
      'eeeee',
      'fffff',
      'ggggg',
      'aaaaa',
      'bbbbb',
      'ccccc',
      'ddddd',
      'eeeee',
      'fffff',
      'ggggg',
    ];

    titles.forEach((title) {
      result.add(title);
    });
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
          color: Colors.blue,
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
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Detail(),
                            ),
                          );
                        },
                        child: Text(
                          snapshot.data[index].toString(),
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
      ],
    );
  }
}
