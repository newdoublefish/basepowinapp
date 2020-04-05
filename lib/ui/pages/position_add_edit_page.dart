import 'package:flutter/material.dart';
import 'package:manufacture/beans/base_bean.dart';
import '../../core/object_select_widget.dart';
import '../../core/object_add_edit_page.dart';
import 'package:manufacture/beans/organization.dart';
import 'package:manufacture/data/repository/position_repository.dart';

class PositionAddEditPage extends StatefulWidget{
  final Position position;
  final Unit unit;
  final PositionObjectRepository objectRepository;

  PositionAddEditPage({Key key, this.position, this.objectRepository,this.unit}):super(key:key);
  @override
  State<StatefulWidget> createState() => _UnitAddEditPageState();
}

class _UnitAddEditPageState extends State<PositionAddEditPage>{
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _shortController = new TextEditingController();
  TextEditingController _pinyinController = new TextEditingController();

  @override
  void initState() {
    if(widget.position!=null){
      _nameController.text = widget.position.name;
      _shortController.text = widget.position.short;
      _pinyinController.text = widget.position.pinyin;
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return ObjectAddEditPage<Position>(
      object: widget.position,
      objectRepository: widget.objectRepository,
      objectCallback: () {
        if (widget.position != null) {
          widget.position.name = _nameController.text.toString();
          widget.position.short = _shortController.text.toString();
          widget.position.pinyin = _shortController.text.toString();
          return widget.position;
        } else {
          Position position = new Position();
          position.name = _nameController.text.toString();
          position.short = _shortController.text.toString();
          position.pinyin = _shortController.text.toString();
          position.unit = widget.unit.id;
          return position;
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