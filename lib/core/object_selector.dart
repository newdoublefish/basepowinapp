import 'dart:async';

import 'package:flutter/material.dart';
import 'package:manufacture/beans/base_bean.dart';
import 'package:manufacture/data/repository/object_repository.dart';
import 'package:manufacture/core/object_select_dialog.dart';
import 'package:manufacture/core/object_select_widget.dart';

typedef BuildValueText<T> = String Function(T t);
typedef OnSelectCallBack<T> = void Function(T t);

//class ObjectSelectController<T>{
//  T selectObject;
//}

class ObjectSelector<T extends BaseBean> extends StatefulWidget{
  final ObjectRepository<T> objectRepository;
  final ObjectSelectDialog objectSelectDialog;
  final ObjectSelectController controller;
  final T object; //init
  final BuildValueText<T> buildValueText;
  final OnSelectCallBack<T> onSelectCallBack;
  final String title;
  ObjectSelector({Key key, this.objectRepository,this.object,this.objectSelectDialog,this.title,this.buildValueText,this.controller,this.onSelectCallBack}):super(key:key);
  @override
  State<StatefulWidget> createState() => _ObjectSelectorState<T>();
}

class _InputDropdown extends StatelessWidget {
  const _InputDropdown(
      {Key key,
        this.child,
        this.labelText,
        this.valueText,
        this.valueStyle,
        this.onPressed})
      : super(key: key);

  final String labelText;
  final String valueText;
  final TextStyle valueStyle;
  final VoidCallback onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: labelText,
        ),
        baseStyle: valueStyle,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Center(
                  child: Text(valueText, style: valueStyle),
                ),
              ),
            ),
            Icon(Icons.arrow_drop_down,
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.grey.shade700
                    : Colors.white70),
          ],
        ),
      ),
    );
  }
}

class _ObjectSelectorState<T extends BaseBean> extends State<ObjectSelector>{
  StreamController<T> _streamController = StreamController(sync: true);

  _getObject() async{
    T t = await widget.objectRepository.get(widget.object.id);
    _streamController.sink.add(t);
  }

  @override
  void initState() {
    if(widget.object!=null)
      _getObject();
    super.initState();
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<T>(
      stream: _streamController.stream,
      builder: (context, snapShot){
        return _InputDropdown(
          labelText: widget.title,
          valueText: snapShot.data!=null?widget.buildValueText(snapShot.data):"",
          onPressed: () async{
            BaseBean select = await showDialog(
              context: context,
              builder: (context){
                return widget.objectSelectDialog;
              }
            );
            if(select!=null){
              if(widget.controller!=null)
                widget.controller.selectObject = select as T;
              if(widget.onSelectCallBack!=null){
                widget.onSelectCallBack(select);
              }
            _streamController.sink.add(select as T);}
          },
        );
      },
    );
  }

}