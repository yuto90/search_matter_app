import 'package:flutter/material.dart';
import 'package:universal_html/html.dart' as html;
import 'package:universal_html/driver.dart' as driver;

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
}
