import 'dart:async';
import 'package:flutter/material.dart';
import 'package:universal_html/html.dart' as html;
import 'package:universal_html/driver.dart' as driver;
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:url_launcher/url_launcher.dart';

// todo providerを使って書き換える
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController searchWordController = TextEditingController();

  // 案件リスト用
  StreamController listStreamController;
  Stream listStream;

  // 最終更新用
  StreamController updateStreamController;
  Stream updateStream;

  // スクレイピング結果格納用
  List<Map<String, String>> result;

  void search() async {
    if (searchWordController.text == '') {
      listStreamController.add(null);
      updateStreamController.add(null);
      return;
    }

    // ローディング画面を表示
    listStreamController.add('waiting');
    updateStreamController.add('waiting');

    result = [];
    String searchWord = searchWordController.text;

    // ! スクレイピング ----------------------------------------------------------------
    final client = driver.HtmlDriver();

    final url =
        'https://www.lancers.jp/work/search?keyword=$searchWord&show_description=0&sort=started&work_rank%5B%5D=0&work_rank%5B%5D=1&work_rank%5B%5D=2&work_rank%5B%5D=3';

    // Webページを取得
    await client.setDocumentFromUri(Uri.parse(url));

    // 案件リストを格納
    final itemLists =
        client.document.querySelectorAll('div > .c-media-list__item');

    // 1件づつ抽出してリストに格納
    for (int i = 0; i < 30; i++) {
      // 案件タイトルを取得
      final title = itemLists[i].querySelector('.c-media__title-inner');
      // 案件リンクを取得
      final link = itemLists[i].querySelector('.c-media__title');
      // 案件単価を取得
      final price = itemLists[i].querySelector('.c-media__job-price');
      // 提案数
      final propose = itemLists[i].querySelector('div > .c-media__job-propose');

      result.add({
        'title': title.text.replaceAll(RegExp(r'\s'), ''),
        'link': link.getAttribute("href"),
        'price': price.text.replaceAll(RegExp(r'\s'), ''),
        'propose': propose == null
            ? 'null'
            : propose.text.replaceAll(RegExp(r'\s'), '')
      });
    }

    listStreamController.add(result);

    // * テストデータ ---------------------------------------------------------
//    await Future.delayed(Duration(seconds: 1));
//    result = [
//      {
//        'title': 'テストタイトル1',
//        'link': '/work/detail/3473226',
//        'price': '10001',
//        'propose': '提案数30'
//      },
//      {
//        'title': 'テストタイトル2',
//        'link': '/work/detail/3052029',
//        'price': '10001',
//        'propose': '提案数30'
//      },
//      {
//        'title': 'テストタイトル3',
//        'link': '/work/detail/3074955',
//        'price': '10001',
//        'propose': '提案数30'
//      },
//    ];
//    listStreamController.add(result);

    // 最終更新表示用
    initializeDateFormatting('ja');
    updateStreamController.add(
      DateFormat.MMMMd('ja').format(DateTime.now()).toString() +
          ' ' +
          DateFormat('hh:mm').format(DateTime.now()).toString(),
    );
  }

  @override
  void initState() {
    super.initState();

    listStreamController = StreamController();
    listStream = listStreamController.stream;
    updateStreamController = StreamController();
    updateStream = updateStreamController.stream;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  controller: searchWordController,
                  decoration: InputDecoration(
                    hintText: 'input search word',
                    icon: Icon(Icons.search),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                  child: FlatButton(
                    onPressed: () {
                      search();
                    },
                    child: Text('検索'),
                    color: Colors.lightBlue,
                  ),
                ),
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // 最終更新
            Padding(
              padding: const EdgeInsets.all(8.0),
              //child: Text('最終更新:\n' + getTodayDate()),
              child: StreamBuilder(
                stream: updateStream,
                builder: (context, snapshot) {
                  if (snapshot.data == null) {
                    return Text('最終更新:\n' + '-----');
                  }

                  if (snapshot.data == 'waiting') {
                    return Container(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  return Text('最終更新:\n' + snapshot.data);
                },
              ),
            ),
          ],
        ),
        // 案件リスト
        StreamBuilder(
          stream: listStream,
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
                child: ListView.separated(
                  separatorBuilder: (context, index) => Divider(
                    color: Colors.black,
                    height: 1,
                  ),
                  shrinkWrap: true,
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text(snapshot.data[index]['title']),
                      subtitle: Text(
                        snapshot.data[index]['price'],
                        style: TextStyle(color: Colors.red),
                      ),
                      leading: Text('aaa'),
                      trailing: Text(snapshot.data[index]['propose']),
                      onTap: () async {
                        final url = 'https://www.lancers.jp' +
                            snapshot.data[index]['link'];
                        if (await canLaunch(url)) {
                          await launch(
                            url,
                            forceSafariVC: false,
                            forceWebView: false,
                          );
                        } else {
                          throw 'このURLにはアクセスできません';
                        }
                      },
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
