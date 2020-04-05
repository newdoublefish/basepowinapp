import 'package:flutter/material.dart';
import 'package:manufacture/beans/base_bean.dart';
import 'package:manufacture/data/repository/brand_repository.dart';
import 'attribute_add_edit_page.dart';
import 'brand_add_edit_page.dart';
import '../../core/object_manager_page.dart';
import 'package:manufacture/beans/project.dart';


class BrandManage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _ManageState();
}

class _ManageState extends State<BrandManage>{
  BrandObjectRepository _objectRepository;
  @override
  void initState() {
    _objectRepository = BrandObjectRepository.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ObjectManagerPage<Brand>(
      title: "品牌",
      objectRepository:_objectRepository,
      itemWidgetBuilder: (context, BaseBean obj){
        Widget widget = ListTile(
          leading: ExcludeSemantics(
              child: CircleAvatar(child: Text((obj as Brand).name[0]))),
          title: Text((obj as Brand).name),
          subtitle: Text((obj as Brand).pinyin),
        );
        return widget;
      },
      onTap: (BaseBean value){
      },
      addEditPageBuilder: (context, BaseBean obj){
        return BrandAddEditPage(
          objectRepository: _objectRepository,
          brand: obj as Brand,
        );
      },
    );
  }

}