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
    // ローディング画面を表示
    streamController.add('waiting');

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
      // todo 提案数
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
    streamController.add(result);

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
//    streamController.add(result);
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
                            onTap: () {
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
