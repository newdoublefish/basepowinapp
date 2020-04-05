import 'package:flutter/material.dart';

class EditableListView<T> extends StatefulWidget {
  final List<T> list;
  final bool isEdit;
  final IndexedWidgetBuilder itemBuilder;
  final ValueChanged<List<T>> onTapDelete;
  final Color footColor;
  final Color backGroundColor;
  EditableListView(
      {Key key,
      @required this.itemBuilder,
      @required this.onTapDelete,
      this.isEdit,
      this.footColor,
      this.backGroundColor,
      @required this.list})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => EditableListViewState<T>();
}

class _CheckItem<T> {
  bool isCheck;
  T t;
  _CheckItem({this.isCheck, this.t});
  @override
  String toString() {
    // TODO: implement toString
    return "_CheckItem: isCheck:$isCheck, t:$t";
  }
}

class EditableListViewState<T> extends State<EditableListView<T>> {
  List<_CheckItem<T>> _isCheckList = new List();
  bool _isEdit = false;
  bool _isSelectedAll = false;
  int _selectedNum = 0;

  @override
  void initState() {
    if (widget.isEdit != null) _isEdit = widget.isEdit;
    _isCheckList = widget.list.map((t) {
      return _CheckItem<T>(t: t, isCheck: false);
    }).toList();
    super.initState();
  }

  void initChecks(List<T> list) {
    _selectedNum = 0;
    _isCheckList.clear();
    _isCheckList = list.map((t) {
      return _CheckItem<T>(t: t, isCheck: false);
    }).toList();
  }

  void setEdit(bool isEdit) {
    setState(() {
      _selectedNum = 0;
      _isSelectedAll = false;
      _isEdit = isEdit;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
            child: Container(
              color:widget.backGroundColor!=null?widget.backGroundColor:Colors.white,
          child: ListView.builder(
              itemCount: _isCheckList.length,
              itemBuilder: (context, index) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Builder(builder: (context){
                      if (_isEdit) {
                        return Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                child: Checkbox(
                                  value: _isCheckList[index].isCheck,
                                  onChanged: (value) {
                                    setState(() {
                                      _isCheckList[index].isCheck = value;
                                      if (value == true) {
                                        _selectedNum++;
                                      } else {
                                        _selectedNum--;
                                      }
                                    });
                                  },
                                ),
                              ),
                              Expanded(
                                child: widget.itemBuilder(context, index),
                              )
                            ],
                          ),
                        );
                      } else {
                        return Container(
                          child: widget.itemBuilder(context, index),
                        );
                      }
                    }),
                    Divider(),
                  ],
                );
              }),
        )),
        Container(
          height: _isEdit ? 50 : 0,
          alignment: Alignment.bottomCenter,
          color:widget.footColor!=null?widget.footColor:Colors.grey[300],
          //color: Colors.green,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              FlatButton(
                child: _isSelectedAll ? Text('取消') : Text('全选'),
                onPressed: () {
                  if (_isSelectedAll) {
                    _selectedNum = 0;
                    _isCheckList = _isCheckList.map((value) {
                      value.isCheck = false;
                      return value;
                    }).toList();
                    _isSelectedAll = false;
                  } else {
                    _selectedNum = _isCheckList.length;
                    _isCheckList = _isCheckList.map((value) {
                      value.isCheck = true;
                      return value;
                    }).toList();
                    _isSelectedAll = true;
                  }
                  setState(() {});
                },
              ),
              Text('已选择:$_selectedNum'),
              Container(
                alignment: Alignment.bottomCenter,
                child: MaterialButton(
                  color: Colors.red,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      side: BorderSide(
                          color: Color(0xFFFFF00F),
                          style: BorderStyle.solid,
                          width: 0)),
                  child: Text("删除"),
                  onPressed: () {
                    if (widget.onTapDelete != null) {
                      List<T> _list = _isCheckList.where((value) {
                        return value.isCheck;
                      }).map<T>((value) {
                        return value.t;
                      }).toList();
                      widget.onTapDelete(_list);
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
