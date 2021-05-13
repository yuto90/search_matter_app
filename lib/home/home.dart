import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'home_model.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeModel>(
      create: (_) => HomeModel(),
      child: Consumer<HomeModel>(
        builder: (context, model, child) {
          return SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextFormField(
                    keyboardType: TextInputType.text,
                    controller: model.searchWordController,
                    decoration: InputDecoration(
                      hintText: 'input search word',
                      icon: Icon(Icons.add_circle_outline),
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      model.scrape();
                    },
                    child: Text('検索'),
                    color: Colors.blue,
                  ),
                  Column(
                    children: [
                      Container(
                        height: 350,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          border: Border.all(color: Colors.grey, width: 0.3),
                        ),
                        child: StreamBuilder(
                          stream: model.stream,
                          builder: (context, snapshot) {
                            if (snapshot.data == null) {
                              return Column(
                                children: [
                                  Container(
                                    height: 20,
                                    color: Colors.orange[300],
                                    child: Row(
                                      children: [
                                        Expanded(flex: 3, child: Text('title')),
                                        Expanded(flex: 3, child: Text('title')),
                                        Expanded(flex: 3, child: Text('title')),
                                        Expanded(flex: 3, child: Container()),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: 250,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      border: Border.all(
                                          color: Colors.grey, width: 0.3),
                                    ),
                                    child: Icon(
                                      Icons.add,
                                      size: 100,
                                      color: Colors.lightBlue,
                                    ),
                                  ),
                                ],
                              );
                            }

                            if (snapshot.data == 'waiting') {
                              return Text('waiting');
                            }

                            return ListView.builder(
                              shrinkWrap: true,
                              itemCount: model.result.length,
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
                                                      model.result[index]
                                                          .toString(),
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
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
