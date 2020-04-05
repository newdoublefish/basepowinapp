import 'package:flutter/material.dart';
import 'package:manufacture/beans/base_bean.dart';
import 'package:manufacture/ui/pages/category_manage_page.dart';
import '../../core/object_manager_page.dart';
import '../../core/object_select_widget.dart';
import '../../core/object_add_edit_page.dart';
import 'package:manufacture/beans/project.dart';
import 'package:manufacture/data/repository/trade_repository.dart';

import 'trade_add_edit_page.dart';


class TradeManage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _TradeManageState();
}

class _TradeManageState extends State<TradeManage>{
  TradeObjectRepository _tradeObjectRepository;
  @override
  void initState() {
    _tradeObjectRepository = TradeObjectRepository.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ObjectManagerPage<Trade>(
      title: "行业",
      //initQueryParams: {"organization": widget.organization.id},
      objectRepository:_tradeObjectRepository,
      itemWidgetBuilder: (context, BaseBean obj){
        Widget widget = ListTile(
          leading: ExcludeSemantics(
              child: CircleAvatar(child: Text((obj as Trade).name[0]))),
          title: Text((obj as Trade).name),
        );
        return widget;
      },
      onTap: (BaseBean value){
        Navigator.push(context, MaterialPageRoute(builder: (context){
          return CategoryManage(
            trade: value as Trade,
          );
        }));
      },
      addEditPageBuilder: (context, BaseBean obj){
        return TradeAddEditPage(
          objectRepository: _tradeObjectRepository,
          trade: obj as Trade,
        );
      },
    );
  }

}