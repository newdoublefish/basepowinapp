import 'package:flutter/material.dart';
import 'package:manufacture/beans/base_bean.dart';
import 'package:manufacture/util/dialog_util.dart';

typedef IndexedWidgetBuilder<T extends BaseBean> = Widget Function(
    BuildContext context, T obj);

class ObjectBatchOperate<T extends BaseBean> extends StatefulWidget {
  final List<T> objectList;
  final Color footColor;
  final Color backGroundColor;
  final IndexedWidgetBuilder<T> itemBuilder;
  ObjectBatchOperate(
      {Key key,
      this.objectList,
      this.footColor,
      this.backGroundColor,
      this.itemBuilder})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => ObjectBatchOperateState<T>();
}

class ObjectBatchOperateState<T extends BaseBean>
    extends State<ObjectBatchOperate> {
  List<bool> _isCheckList = new List();
  int _selectedNum = 0;
  bool _isSelectedAll = false;
  @override
  void initState() {
    _isCheckList = widget.objectList.map((t) {
      return false;
    }).toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("批量管理"),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
              child: Container(
            color: widget.backGroundColor != null
                ? widget.backGroundColor
                : Colors.white,
            child: ListView.builder(
                itemCount: _isCheckList.length,
                itemBuilder: (context, index) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Builder(builder: (context) {
                        return Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                child: Checkbox(
                                  value: _isCheckList[index],
                                  onChanged: (value) {
                                    setState(() {
                                      _isCheckList[index] = value;
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
                                child: Container(
                                  child: Builder(builder: (context){
                                    if(widget.itemBuilder!=null){
                                      print("1212121212");
                                    }
                                    return widget.itemBuilder!=null?widget.itemBuilder(
                                        context, widget.objectList[index]):ListTile(title: Text("item $index"),);
                                  },)
                                )
                              )
                            ],
                          ),
                        );
                      }),
                      Divider(),
                    ],
                  );
                }),
          )),
          Container(
            height: 50,
            alignment: Alignment.bottomCenter,
            color:
                widget.footColor != null ? widget.footColor : Colors.grey[300],
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
                        value = false;
                        return value;
                      }).toList();
                      _isSelectedAll = false;
                    } else {
                      _selectedNum = _isCheckList.length;
                      _isCheckList = _isCheckList.map((value) {
                        value = true;
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
                      List<T> _list = new List<T>();
                      for (int i = 0; i < _isCheckList.length; i++) {
                        if (_isCheckList[i]) {
                          _list.add(widget.objectList[i]);
                        }
                      }
                      DialogUtil.show(context, content: Text("确认要删除?"),
                          onPositive: () {
                        Navigator.pop(context, _list);
                      });
                    },
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
