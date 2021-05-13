import 'dart:async';
import 'package:flutter/material.dart';
import 'package:universal_html/html.dart' as html;
import 'package:universal_html/driver.dart' as driver;

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
    if (searchWordController.text == null) {
      streamController.add(null);
    }

    streamController.add('waiting');

    result = [];
    String searchWord = searchWordController.text;

    final client = driver.HtmlDriver();
    final String url = "https://www.lancers.jp/work/search?keyword=$searchWord";

    // Webページを取得
    await client.setDocumentFromUri(Uri.parse(url));

    // 案件タイトルを取得
    final List titles =
        client.document.querySelectorAll('.c-media__title-inner');

    for (final title in titles) {
      print(title.text.replaceAll(RegExp(r'\s'), ''));
      result.add(title.text.replaceAll(RegExp(r'\s'), ''));
    }

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
              return Text('null');
            }

            if (snapshot.data == 'waiting') {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            return ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onLongPress: () {
                    // todo
                  },
                  child: Container(
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Container(
                                  height: 45,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                      color: Colors.lightBlue,
                                      width: 1,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      snapshot.data[index].toString(),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        )
      ],
    );
  }
}
