import 'package:flutter/material.dart';
import 'scan_page.dart';
import 'product_detail_page.dart';
import 'package:manufacture/data/repository/user_repository.dart';

class ProductShortCut extends StatelessWidget{
  final RegExp exp =
  new RegExp(r"(http)(://www.gdmcmc.cn/qrcode.html)?([^# ]*)(\d{12})");
  UserRepository userRepository;

  ProductShortCut({@required this.userRepository});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scan(title: "产品查询", callback: (context, code){
      print(code);
//      Navigator.push(context,new MaterialPageRoute(builder: (BuildContext context){
//        if (exp.hasMatch(code)) {
//          //print(code.split("=")[1].substring(5, 11));
//          code = code.split("=")[1].substring(5, 11);
//        }
//        return new ProductDetailPage(code: code,userRepository: userRepository,);
//      }));
    },);
  }
}