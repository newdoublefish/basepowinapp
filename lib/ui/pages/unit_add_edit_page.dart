import 'package:flutter/material.dart';
import 'package:manufacture/beans/base_bean.dart';
import '../../core/object_select_widget.dart';
import '../../core/object_add_edit_page.dart';
import 'package:manufacture/beans/organization.dart';
import 'package:manufacture/data/repository/unit_repository.dart';

class UnitAddEditPage extends StatefulWidget{
  final Unit unit;
  final Organization organization;
  final UnitObjectRepository objectRepository;

  UnitAddEditPage({Key key, this.unit, this.objectRepository,this.organization}):super(key:key);
  @override
  State<StatefulWidget> createState() => _UnitAddEditPageState();
}

class _UnitAddEditPageState extends State<UnitAddEditPage>{
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _codeController = new TextEditingController();
  TextEditingController _shortController = new TextEditingController();
  TextEditingController _pinyinController = new TextEditingController();

  @override
  void initState() {
    if(widget.unit!=null){
      _nameController.text = widget.unit.name;
      _codeController.text = widget.unit.code;
      _shortController.text = widget.unit.short;
      _pinyinController.text = widget.unit.pinyin;
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return ObjectAddEditPage<Unit>(
      object: widget.unit,
      objectRepository: widget.objectRepository,
      objectCallback: () {
        if (widget.unit != null) {
          widget.unit.code = _codeController.text.toString();
          widget.unit.name = _nameController.text.toString();
          widget.unit.short = _shortController.text.toString();
          widget.unit.pinyin = _shortController.text.toString();
          return widget.unit;
        } else {
          Unit unit = new Unit();
          unit.code = _codeController.text.toString();
          unit.name = _nameController.text.toString();
          unit.short = _shortController.text.toString();
          unit.pinyin = _shortController.text.toString();
          unit.organization = widget.organization.id;
          return unit;
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
            SizedBox(
              height: 24,
            ),
            TextFormField(
              textCapitalization: TextCapitalization.words,
              controller: _shortController,
              validator: (value) {
                if (value.isEmpty) {
                  return "内容不能为空";
                }
                return null;
              },
              decoration: InputDecoration(
                border: UnderlineInputBorder(),
                filled: true,
                icon: Icon(Icons.trip_origin),
                labelText: '简称',
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
                icon: Icon(Icons.map),
                labelText: '拼音',
              ),
            ),
          ],
        );
      },
    );
  }

}