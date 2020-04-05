import 'package:flutter/material.dart';
import 'package:manufacture/beans/base_bean.dart';
import '../../core/object_select_widget.dart';
import '../../core/object_add_edit_page.dart';
import 'package:manufacture/beans/project.dart';
import 'package:manufacture/data/repository/trade_repository.dart';

class TradeAddEditPage extends StatefulWidget{
  final Trade trade;
  final TradeObjectRepository objectRepository;

  TradeAddEditPage({Key key, this.trade, this.objectRepository}):super(key:key);
  @override
  State<StatefulWidget> createState() => _TradeAddEditPageState();
}

class _TradeAddEditPageState extends State<TradeAddEditPage>{
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _codeController = new TextEditingController();

  @override
  void initState() {
    if(widget.trade!=null){
      _nameController.text = widget.trade.name;
      _codeController.text = widget.trade.code;
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return ObjectAddEditPage<Trade>(
      object: widget.trade,
      objectRepository: widget.objectRepository,
      objectCallback: () {
        if (widget.trade != null) {
          widget.trade.code = _codeController.text.toString();
          widget.trade.name = _nameController.text.toString();
          return widget.trade;
        } else {
          Trade trade = new Trade();
          trade.code = _codeController.text.toString();
          trade.name = _nameController.text.toString();
          return trade;
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