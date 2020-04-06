import 'package:flutter/material.dart';

enum SearchType{
  FLOW,
  PRODUCT,
  SHIP,
  TECH
}

class SearchItem{
  final SearchType type;
  final String code;
  SearchItem({this.type,this.code});

  @override
  String toString() {
    return "searchItem:{type:$type, code:$code}";
  }
}

class SearchResultPage extends StatefulWidget{
  final SearchItem searchItem;
  SearchResultPage({Key key, this.searchItem}):super(key:key);
  @override
  State<StatefulWidget> createState() => _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage>{
  final RegExp exp = RegExp(r"(http)(://www.gdmcmc.cn/qrcode.html)?([^# ]*)(\d{12})");

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(widget.searchItem.type==SearchType.FLOW){
      String _code = widget.searchItem.code;
      if (exp.hasMatch(widget.searchItem.code)) {
        //print(code.split("=")[1].substring(5, 11));
        _code = _code.split("=")[1].substring(5, 11);
      }
      return null;
    }else if(widget.searchItem.type==SearchType.PRODUCT){
      String _code = widget.searchItem.code;
      if (exp.hasMatch(widget.searchItem.code)) {
        //print(code.split("=")[1].substring(5, 11));
        _code = _code.split("=")[1].substring(5, 11);
      }
      return null;
    }else if(widget.searchItem.type==SearchType.SHIP){
      return null;
    }else if(widget.searchItem.type==SearchType.TECH){
      return null;
    }
    return Container();
  }
}