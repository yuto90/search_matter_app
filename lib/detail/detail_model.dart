import 'package:flutter/material.dart';
import 'package:universal_html/html.dart' as html;
import 'package:universal_html/driver.dart' as driver;
import 'package:url_launcher/url_launcher.dart';

class DetailModel extends ChangeNotifier {
  final client = driver.HtmlDriver();

  // 案件詳細情報を抜き出す
  Future scrapeDetail(String link) async {
    String url = 'https://www.lancers.jp$link';
    // Webページを取得
    //price-block workprice__text--high
//    await client.setDocumentFromUri(Uri.parse(url));
//
//    var highPrice = client.document.querySelectorAll('.worksummary__text');
//    highPrice.forEach((element) {
//      print(element);
//    });
//    print(highPrice.length);
//    //print(highPrice);
//
//    return highPrice;
    return 'future';
  }

  // ブラウザで開く
  Future launchInBrowser(link) async {
    final url = 'https://www.lancers.jp$link';
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
      );
    } else {
      throw 'このURLにはアクセスできません';
    }
  }
}
