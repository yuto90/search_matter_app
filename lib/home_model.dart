import 'dart:async';

import 'package:flutter/material.dart';
import 'package:universal_html/html.dart' as html;
import 'package:universal_html/driver.dart' as driver;

class HomeModel extends ChangeNotifier {
  List result;
  TextEditingController searchWordController = TextEditingController();

  void scrape() async {
    result = [];
    String searchWord = searchWordController.text;

//    final client = driver.HtmlDriver();
//    final String url = "https://www.lancers.jp/work/search?keyword=$searchWord";
//
//    // Webページを取得
//    await client.setDocumentFromUri(Uri.parse(url));
//
//    // 案件タイトルを取得
//    final List titles =
//        client.document.querySelectorAll('.c-media__title-inner');

    // 遅延の実行（async/awaitで待機します）
    await Future.delayed(Duration(seconds: 1));
    final titles = ['aaaaa', 'bbbbb', 'ccccc'];

    for (final title in titles) {
//      print(title.text.replaceAll(RegExp(r'\s'), ''));
//      // 空白を削除して案件名をリストに追加
//      result.add(title.text.replaceAll(RegExp(r'\s'), ''));
      print(title.replaceAll(RegExp(r'\s'), ''));
      // 空白を削除して案件名をリストに追加
      result.add(title.replaceAll(RegExp(r'\s'), ''));
    }
    //streamController.sink.add(result);

    // 画面を更新
    notifyListeners();
  }
}
