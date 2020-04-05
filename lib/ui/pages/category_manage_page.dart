import 'package:flutter/material.dart';
import 'package:manufacture/beans/base_bean.dart';
import 'package:manufacture/data/repository/category_repository.dart';
import 'package:manufacture/ui/pages/attribute_manage_page.dart';
import 'package:manufacture/ui/pages/category_add_edit_page.dart';
import '../../core/object_manager_page.dart';
import '../../core/object_select_widget.dart';
import '../../core/object_add_edit_page.dart';
import 'package:manufacture/beans/project.dart';

import 'trade_add_edit_page.dart';


class CategoryManage extends StatefulWidget{
  final Trade trade;
  CategoryManage({Key key, this.trade}):super(key:key);
  @override
  State<StatefulWidget> createState() => _CategoryManageState();
}

class _CategoryManageState extends State<CategoryManage>{
  CategoryObjectRepository _objectRepository;
  @override
  void initState() {
    _objectRepository = CategoryObjectRepository.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ObjectManagerPage<Category>(
      title: "产品类型",
      initQueryParams: {"trade": widget.trade.id},
      objectRepository:_objectRepository,
      itemWidgetBuilder: (context, BaseBean obj){
        Widget widget = ListTile(
          leading: ExcludeSemantics(
              child: CircleAvatar(child: Text((obj as Category).code[0]))),
          title: Text((obj as Category).code),
          subtitle: Text((obj as Category).name),
        );
        return widget;
      },
      onTap: (BaseBean value){
        Navigator.push(context, MaterialPageRoute(builder: (context){
          return AttributeManage(
            category: value as Category,
          );
        }));
      },
      addEditPageBuilder: (context, BaseBean obj){
        return CategoryAddEditPage(
          objectRepository: _objectRepository,
          trade: widget.trade,
          category: obj as Category,
        );
      },
    );
  }

}