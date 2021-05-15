import 'package:flutter/material.dart';
import 'package:universal_html/html.dart' as html;
import 'package:universal_html/driver.dart' as driver;
import 'package:url_launcher/url_launcher.dart';

class DetailModel extends ChangeNotifier {
  final client = driver.HtmlDriver();

  Future scrapeDetail(String link) async {
    String url = 'https://www.lancers.jp' + link;
    // Webページを取得
    await client.setDocumentFromUri(Uri.parse(url));

    final title = client.document.title;
    print(title);
    return title;
  }

  // ブラウザで開く
  Future launchInBrowser(link) async {
    final url = 'https://www.lancers.jp' + link;
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
