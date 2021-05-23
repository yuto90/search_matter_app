import 'dart:async';
import 'package:flutter/material.dart';
import 'package:universal_html/driver.dart' as driver;
import 'package:intl/date_symbol_data_local.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // 検索ボックス用
  TextEditingController searchWordController = TextEditingController();

  // 案件リスト用
  StreamController listStreamController;
  Stream listStream;

  // 最終更新用
  StreamController updateStreamController;
  Stream updateStream;

  // スクレイピング結果格納用
  List<Map<String, String>> result;

  String url;

  // 案件を検索する
  void search([tag]) async {
    if (searchWordController.text == '' && tag == null) {
      listStreamController.add(null);
      updateStreamController.add(null);
      return;
    }

    // ローディング画面を表示
    listStreamController.add('waiting');
    updateStreamController.add('waiting');

    result = [];
    // 検索ボックスに入力したワードを代入
    String searchWord = searchWordController.text;

    final client = driver.HtmlDriver();

    url =
        'https://www.lancers.jp/work/search/task/collect?type%5B%5D=project&open=1&work_rank%5B%5D=3&work_rank%5B%5D=2&work_rank%5B%5D=1&work_rank%5B%5D=0&budget_from=&budget_to=&search=%E6%A4%9C%E7%B4%A2&keyword=$searchWord&not=';

    // タグを押された場合は検索ボックスの入力に関係なくurlをタグの内容に変更
    if (tag != null) {
      // データ収集カテゴリ, 新着, プロジェクト
      url =
          'https://www.lancers.jp/work/search/task/collect?type%5B%5D=project&open=1&work_rank%5B%5D=3&work_rank%5B%5D=2&work_rank%5B%5D=1&work_rank%5B%5D=0&budget_from=&budget_to=&keyword=&not=';
    }

    // Webページを取得
    await client.setDocumentFromUri(Uri.parse(url));
    // 単体の案件リストを格納
    final itemLists = client.document.querySelectorAll('.c-media-list__item');

    // アプリに表示したい情報を抽出してリストに格納
    for (int i = 0; i < itemLists.length; i++) {
      // 案件タイトルを取得
      final title = itemLists[i].querySelector('.c-media__title-inner');
      // 案件リンクを取得
      final link = itemLists[i].querySelector('.c-media__title');
      // 案件単価を取得
      final price = itemLists[i].querySelector('.c-media__job-price');
      // 提案数
      final propose = itemLists[i].querySelector('div > .c-media__job-propose');
      // 応募期間
      final limit = itemLists[i].querySelector('.c-media__job-time__remaining');

      // 案件1件毎のタイトル、リンク、単価、提案数、応募期間を配列に格納
      result.add({
        'title': title.text.replaceAll(RegExp(r'\s'), ''),
        'link': link.getAttribute("href"),
        'price': price.text.replaceAll(RegExp(r'\s'), ''),
        'propose': propose == null
            ? 'null'
            : propose.text.replaceAll(RegExp(r'\s'), ''),
        'limit':
            limit == null ? 'null' : limit.text.replaceAll(RegExp(r'\s'), ''),
      });
    }

    // streamに結果を流す
    listStreamController.add(result);

    // 最終更新表示用
    DateTime now = DateTime.now();

    // 最終更新表示用
    initializeDateFormatting('ja');
    updateStreamController.add(
      DateFormat.MMMMd('ja').format(now).toString() +
          ' ' +
          DateFormat.Hm().format(now).toString(),
    );
  }

  @override
  void initState() {
    super.initState();

    // widget生成時にstream系を初期化
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
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal, // スクロールの向きを水平方向に指定
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                RaisedButton(
                  child: Text('データ収集'),
                  color: Colors.white,
                  shape: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  onPressed: () {
                    search('data');
                  },
                ),
              ],
            ),
          ),
        ),
        // 案件表示エリア
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
                  child: Center(child: Text('検索したいワードを入力してね')),
                ),
              );
            }

            if (snapshot.data.length == 0) {
              return Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    border: Border.all(color: Colors.grey, width: 0.3),
                  ),
                  child: Center(child: Text('検索結果なし')),
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
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  // 募集期間が設定されている（募集終了していなければ画面に表示する）
                  if (snapshot.data[index]['limit'] != 'null') {
                    return Container(
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: Colors.black,
                            width: 1,
                          ),
                        ),
                      ),
                      child: ListTile(
                        title: Text(snapshot.data[index]['title']),
                        subtitle: Text(
                          snapshot.data[index]['price'],
                          style: TextStyle(color: Colors.red),
                        ),
                        leading: Text(snapshot.data[index]['propose']),
                        trailing: Text(snapshot.data[index]['limit']),
                        onTap: () async {
                          // 外部ブラウザで案件詳細画面を表示
                          final url = 'https://www.lancers.jp' +
                              snapshot.data[index]['link'];
                          if (await canLaunch(url)) {
                            await launch(
                              url,
                              forceSafariVC: false,
                              forceWebView: false,
                            );
                          } else {
                            throw 'ページが開けませんでした';
                          }
                        },
                      ),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
