import 'package:flutter/material.dart';
import 'package:manufacture/beans/base_bean.dart';
import 'package:manufacture/data/repository/attribute_repository.dart';
import '../../core/object_select_widget.dart';
import '../../core/object_add_edit_page.dart';
import 'package:manufacture/beans/project.dart';

class AttributeAddEditPage extends StatefulWidget{
  final ProductAttribute attribute;
  final Category category;
  final AttributeObjectRepository objectRepository;

  AttributeAddEditPage({Key key, this.attribute, this.category, this.objectRepository}):super(key:key);
  @override
  State<StatefulWidget> createState() => _AddEditPageState();
}

class _AddEditPageState extends State<AttributeAddEditPage>{
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _valueController = new TextEditingController();
  int _dataType;

  @override
  void initState() {
    if(widget.attribute!=null){
      _nameController.text = widget.attribute.name;
      _valueController.text = widget.attribute.value;
      _dataType = widget.attribute.data_type;
    }else{
      _dataType = 0;
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return ObjectAddEditPage<ProductAttribute>(
      object: widget.attribute,
      objectRepository: widget.objectRepository,
      objectCallback: () {
        if (widget.attribute != null) {
          widget.attribute.value = _valueController.text.toString();
          widget.attribute.name = _nameController.text.toString();
          widget.attribute.data_type = _dataType;
          return widget.attribute;
        } else {
          ProductAttribute attribute = new ProductAttribute();
          attribute.value = _valueController.text.toString();
          attribute.name = _nameController.text.toString();
          attribute.category = widget.category.id;
          attribute.data_type = _dataType;
          return attribute;
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
            SizedBox(
              height: 24,
            ),

            TextFormField(
              textCapitalization: TextCapitalization.words,
              controller: _valueController,
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
                labelText: '值',
              ),
            ),

            SizedBox(
              height: 24,
            ),

            DropdownButtonFormField<int>(
              onChanged: (int value) {
                setState(() {
                  _dataType = value;
                });
              },
              value: _dataType,
              items: [
                DropdownMenuItem<int>(
                  value: 0,
                  child: Text(ProductAttribute.getDataTypeName(0)),
                ),
                DropdownMenuItem<int>(
                  value: 1,
                  child: Text(ProductAttribute.getDataTypeName(1)),
                ),
                DropdownMenuItem<int>(
                  value: 2,
                  child: Text(ProductAttribute.getDataTypeName(2)),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

}