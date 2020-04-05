import 'package:flutter/material.dart';
import 'package:manufacture/beans/base_bean.dart';
import 'package:manufacture/data/repository/category_repository.dart';
import '../../core/object_select_widget.dart';
import '../../core/object_add_edit_page.dart';
import 'package:manufacture/beans/project.dart';
import 'package:manufacture/data/repository/trade_repository.dart';

class CategoryAddEditPage extends StatefulWidget{
  final Trade trade;
  final Category category;
  final CategoryObjectRepository objectRepository;

  CategoryAddEditPage({Key key, this.trade, this.category, this.objectRepository}):super(key:key);
  @override
  State<StatefulWidget> createState() => _CategoryAddEditPageState();
}

class _CategoryAddEditPageState extends State<CategoryAddEditPage>{
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _codeController = new TextEditingController();

  @override
  void initState() {
    if(widget.category!=null){
      _nameController.text = widget.category.name;
      _codeController.text = widget.category.code;
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return ObjectAddEditPage<Category>(
      object: widget.category,
      objectRepository: widget.objectRepository,
      objectCallback: () {
        if (widget.category != null) {
          widget.category.code = _codeController.text.toString();
          widget.category.name = _nameController.text.toString();
          return widget.category;
        } else {
          Category category = new Category();
          category.code = _codeController.text.toString();
          category.name = _nameController.text.toString();
          category.trade = widget.trade.id;
          return category;
        }
      },
      builder: (context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(
              height: 24,
            ),
            TextFormField(
              textCapitalization: TextCapitalization.words,
              controller: _codeController,
              validator: (value) {
                if (value.isEmpty) {
                  return "内容不能为空";
                }
                return null;
              },
              decoration: InputDecoration(
                border: UnderlineInputBorder(),
                filled: true,
                icon: Icon(Icons.code),
                labelText: '编号',
              ),
            ),
            SizedBox(
              height: 24,
            ),
            TextFormField(
              textCapitalization: TextCapitalization.words,
              controller: _nameController,
              validator: (value) {
                if (value.isEmpty) {
                  return "内容不能为空";
                }
                return null;
              },
              decoration: InputDecoration(
                border: UnderlineInputBorder(),
                filled: true,
                icon: Icon(Icons.edit),
                labelText: '名称',
              ),
            ),
          ],
        );
      },
    );
  }

}