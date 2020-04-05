import 'package:flutter/material.dart';
import 'package:manufacture/beans/base_bean.dart';
import 'package:manufacture/data/repository/attribute_repository.dart';
import 'package:manufacture/ui/pages/category_add_edit_page.dart';
import 'attribute_add_edit_page.dart';
import '../../core/object_manager_page.dart';
import '../../core/object_select_widget.dart';
import '../../core/object_add_edit_page.dart';
import 'package:manufacture/beans/project.dart';

import 'trade_add_edit_page.dart';


class AttributeManage extends StatefulWidget{
  final Category category;
  AttributeManage({Key key, this.category}):super(key:key);
  @override
  State<StatefulWidget> createState() => _AttributeManageState();
}

class _AttributeManageState extends State<AttributeManage>{
  AttributeObjectRepository _objectRepository;
  @override
  void initState() {
    _objectRepository = AttributeObjectRepository.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ObjectManagerPage<ProductAttribute>(
      title: "产品属性",
      initQueryParams: {"category": widget.category.id},
      objectRepository:_objectRepository,
      itemWidgetBuilder: (context, BaseBean obj){
        Widget widget = ListTile(
          dense: true,
          leading: Text((obj as ProductAttribute).name),
          title: Text((obj as ProductAttribute).value),
        );
        return widget;
      },
      onTap: (BaseBean value){
//        Navigator.push(context, MaterialPageRoute(builder: (context){
//          return PositionManager(
//            unit: value as Unit,
//          );
//        }));
      },
      addEditPageBuilder: (context, BaseBean obj){
        return AttributeAddEditPage(
          objectRepository: _objectRepository,
          attribute: obj as ProductAttribute,
          category: widget.category,
        );
      },
    );
  }

}