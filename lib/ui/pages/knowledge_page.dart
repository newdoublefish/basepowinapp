import 'package:flutter/material.dart';

class Knowledge extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _KnowledgeState();
}

class _KnowledgeState extends State<Knowledge> with AutomaticKeepAliveClientMixin{
  static final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
//    return MaterialApp(
//      //key: _scaffoldKey,
//      routes: {
//        "/": (_) => new WebviewScaffold(
//          url: "https://www.baidu.com",
//          appBar: new AppBar(
//            title: new Text("Widget webview"),
//          ),
//        )
//      },
//    );
    return Scaffold(
      key: _scaffoldKey,
        body: Text('hello'),
//        body: new WebviewScaffold(
//          url: "https://www.sina.com",
//          appBar: new AppBar(
//            title: new Text("Widget webview"),
//          ),
//        )
    );
  }
}

