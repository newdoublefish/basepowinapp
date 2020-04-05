import 'package:flutter/material.dart';
import 'scan_page.dart';
import 'ship_order_page.dart';

class ShipShortcut extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scan(title: "发货单", callback: (context, code){
      print(code);
      Navigator.push(context,new MaterialPageRoute(builder: (BuildContext context){
        return new ShipOrderPage(code: code,);
      }));
    },);
  }
}