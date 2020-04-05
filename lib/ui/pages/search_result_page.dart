import 'package:flutter/material.dart';
import 'package:manufacture/beans/base_bean.dart';
import 'package:manufacture/beans/project.dart';
import 'package:manufacture/beans/ship.dart';
import 'package:manufacture/beans/technology.dart';
import 'package:manufacture/data/repository/flow_repository.dart';
import 'package:manufacture/data/repository/product_repository.dart';
import 'package:manufacture/data/repository/ship_repository.dart';
import 'package:manufacture/data/repository/tech_repository.dart';
import 'package:manufacture/ui/pages/tech_manage_page.dart';
import 'package:manufacture/ui/pages/tech_report_page.dart';

import 'flow_instance_process_page.dart';
import '../../core/object_manager_page.dart';
import 'product_detail_page.dart';
import 'ship_detail_manage_page.dart';

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
  FlowInstanceObjectRepository _flowInstanceObjectRepository= FlowInstanceObjectRepository.init();
  ProductObjectRepository _productObjectRepository = ProductObjectRepository.init();
  ShipObjectRepository _shipObjectRepository =ShipObjectRepository.init();
  TechObjectRepository _techObjectRepository = TechObjectRepository.init();
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
      return ObjectManagerPage<FlowInstance>(
        title: "流水搜索结果",
        initQueryParams: {"code_contains": _code},
        objectRepository: _flowInstanceObjectRepository,
        canDeleteSingle: false,
        canDeleteBatch: false,
        itemWidgetBuilder: (context, BaseBean obj) {
          Widget widget = ListTile(
            leading: Icon(Icons.group),
            title: Text((obj as FlowInstance).code),
          );
          return widget;
        },
        onTap: (BaseBean value) {
          Navigator.push(context, MaterialPageRoute(builder: (context){
            return FlowInstanceProcess(
              instance: value as FlowInstance,
              flowInstanceObjectRepository: _flowInstanceObjectRepository,
            );
          }));
        },
      );
    }else if(widget.searchItem.type==SearchType.PRODUCT){
      String _code = widget.searchItem.code;
      if (exp.hasMatch(widget.searchItem.code)) {
        //print(code.split("=")[1].substring(5, 11));
        _code = _code.split("=")[1].substring(5, 11);
      }
      return ObjectManagerPage<Product>(
        title: "搜索产品结果",
        initQueryParams: {"code": _code},
        objectRepository: _productObjectRepository,
        canDeleteSingle: false,
        canDeleteBatch: false,
        itemWidgetBuilder: (context, BaseBean obj) {
          Product _product = obj as Product;
          Widget widget = ListTile(
            leading: Icon(Icons.category, color: Theme.of(context).accentColor,),
            title: Text(_product.code),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text("型号:${(_product.category_text)}"),
              ],
            ),
            trailing: Text(_product.status_text),
          );
          return widget;
        },

        onTap: (BaseBean value) {
          Navigator.push(context, MaterialPageRoute(builder: (context){
            return ProductDetailPage(
              product: value as Product,
            );
          }));
        },
      );
    }else if(widget.searchItem.type==SearchType.SHIP){
      return ObjectManagerPage<ShipOrder>(
        title: "搜索发货单结果",
        initQueryParams: {"code": widget.searchItem.code},
        objectRepository: _shipObjectRepository,
        canDeleteSingle: false,
        canDeleteBatch: false,
        itemWidgetBuilder: (context, BaseBean obj) {
          ShipOrder _order = obj as ShipOrder;
          Widget widget = ListTile(
            leading: Icon(Icons.category, color: Theme.of(context).accentColor,),
            title: Text(_order.code),
            trailing: Text("完成情况:${(_order.finished)}"),
          );
          return widget;
        },

        onTap: (BaseBean value) {
          Navigator.push(context, MaterialPageRoute(
              builder: (context){
                return ShipDetailManage(
                  canDeleteSingle: false,
                  canDeleteBatch: false,
                  canAddEditObject: false,
                  shipOrder: value as ShipOrder,
                );
              }
          ));
        },
      );
    }else if(widget.searchItem.type==SearchType.TECH){
      return ObjectManagerPage<Tech>(
        title: "搜索发货单结果",
        initQueryParams: {"code": widget.searchItem.code},
        objectRepository: _techObjectRepository,
        canDeleteSingle: false,
        canDeleteBatch: false,
        itemWidgetBuilder: (context, BaseBean obj) {
          Tech _tech = obj as Tech;
          Widget widget = ListTile(
            leading: Icon(Icons.category, color: Theme.of(context).accentColor,),
            title: Text(_tech.code),
            trailing: Text("完成情况:${(_tech.finished)}"),
          );
          return widget;
        },

        onTap: (BaseBean value) {
          Navigator.push(context, MaterialPageRoute(
              builder: (context){
                return TechReportPage(
                  techId: (value as Tech).id,
                );
              }
          ));
        },
      );
    }
    return Container();
  }
}