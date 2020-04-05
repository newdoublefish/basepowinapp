import 'package:flutter/material.dart';
import 'scan_page.dart';
import 'search_result_page.dart';

class ShortCutPage extends StatelessWidget{
  final SearchType type;
  final String title;

  ShortCutPage({this.type, this.title});

  @override
  Widget build(BuildContext context) {
    return Scan(title: title, callback: (context, code){
      if(code==null){
        return;
      }

      if(code.length==0){
        return;
      }

      Navigator.push(context,new MaterialPageRoute(builder: (BuildContext context){
        return SearchResultPage(
          searchItem: SearchItem(type: type, code: code),
        );
      }));
    },);
  }
}