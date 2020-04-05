import 'package:flutter/material.dart';
import 'package:manufacture/data/repository/brand_repository.dart';
import '../../core/object_add_edit_page.dart';
import 'package:manufacture/beans/project.dart';

class BrandAddEditPage extends StatefulWidget{
  final BrandObjectRepository objectRepository;
  final Brand brand;

  BrandAddEditPage({Key key, this.brand, this.objectRepository}):super(key:key);
  @override
  State<StatefulWidget> createState() => _AddEditPageState();
}

class _AddEditPageState extends State<BrandAddEditPage>{
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _pinyinController = new TextEditingController();

  @override
  void initState() {
    if(widget.brand!=null){
      _nameController.text = widget.brand.name;
      _pinyinController.text = widget.brand.pinyin;
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return ObjectAddEditPage<Brand>(
      object: widget.brand,
      objectRepository: widget.objectRepository,
      objectCallback: () {
        if (widget.brand != null) {
          widget.brand.pinyin = _pinyinController.text.toString();
          widget.brand.name = _nameController.text.toString();
          return widget.brand;
        } else {
          Brand brand = new Brand();
          brand.pinyin = _pinyinController.text.toString();
          brand.name = _nameController.text.toString();
          return brand;
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
              controller: _pinyinController,
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
                labelText: '拼音',
              ),
            ),
          ],
        );
      },
    );
  }

}