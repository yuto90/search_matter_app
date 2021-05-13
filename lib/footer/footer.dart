import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'footer_model.dart';

class Footer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<FooterModel>(
      create: (_) => FooterModel(),
      child: Consumer<FooterModel>(
        builder: (context, model, child) {
          return BottomNavigationBar(
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.list),
                title: Text('ホーム'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.supervised_user_circle),
                title: Text('マイページ'),
              ),
            ],
          );
        },
      ),
    );
  }
}
