import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter/cupertino.dart';

class SmartEditableListView<T> extends StatefulWidget {
  final List<T> list;
  final bool isEdit;
  final IndexedWidgetBuilder itemBuilder;
  final ValueChanged<List<T>> onTapDelete;
  final Color footColor;
  final Color backGroundColor;
  final VoidCallback onRefresh;
  final VoidCallback onLoading;
  SmartEditableListView(
      {Key key,
      @required this.itemBuilder,
      @required this.onTapDelete,
      this.isEdit,
      this.footColor,
        this.onLoading,
        this.onRefresh,
      this.backGroundColor,
      @required this.list})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => SmartEditableListViewState<T>();
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

class SmartEditableListViewState<T> extends State<SmartEditableListView<T>> {
  List<_CheckItem<T>> _isCheckList = new List();
  bool _isEdit = false;
  bool _isSelectedAll = false;
  int _selectedNum = 0;
  RefreshController _refreshController =
  RefreshController(initialRefresh: false);

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

  bool isEdit(){
    return _isEdit;
  }

  void setEdit(bool isEdit) {
    setState(() {
      _selectedNum = 0;
      _isSelectedAll = false;
      _isEdit = isEdit;
    });
  }

  void requestRefresh(){
    _refreshController.requestRefresh();
  }

  void loadComplete(){
    _refreshController.loadComplete();
  }

  void loadNoData(){
    _refreshController.loadNoData();
  }

  void refreshCompleted(){
    _refreshController.refreshCompleted();
  }

  void resetNoData(){
    _refreshController.resetNoData();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
            child: Container(
          color: widget.backGroundColor != null
              ? widget.backGroundColor
              : Colors.white,
              child:SmartRefresher(
                  enablePullDown: _isEdit?false:true,
                  enablePullUp: _isEdit?false:true,
                  header: ClassicHeader(),
                  footer: CustomFooter(
                    builder: (BuildContext context, LoadStatus mode) {
                      Widget body;
                      if (mode == LoadStatus.idle) {
                        body = Text("pull up load");
                      } else if (mode == LoadStatus.loading) {
                        body = CupertinoActivityIndicator();
                      } else if (mode == LoadStatus.failed) {
                        body = Text("Load Failed!Click retry!");
                      } else {
                        body = Text("No more Data");
                      }
                      return Container(
                        height: 55.0,
                        child: Center(child: body),
                      );
                    },
                  ),
                  controller: _refreshController,
                  onRefresh: widget.onRefresh,
                  onLoading: widget.onLoading,
                  child: ListView.builder(
                    physics: new AlwaysScrollableScrollPhysics(),
                    itemBuilder: (context, i) {
                      if (_isEdit) {
                        return Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                child: Checkbox(
                                  value: _isCheckList[i].isCheck,
                                  onChanged: (value) {
                                    setState(() {
                                      _isCheckList[i].isCheck = value;
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
                                child: widget.itemBuilder(context, i),
                              )
                            ],
                          ),
                        );
                      } else {
                        return Container(
                          child: widget.itemBuilder(context, i),
                        );
                      }

//                      return Card(
//                        //color: Colors.amber,
//                        child: Column(
//                        mainAxisAlignment: MainAxisAlignment.start,
//                        crossAxisAlignment: CrossAxisAlignment.stretch,
//                        children: <Widget>[
//                          _isEdit?Container(
//                            //height:0,
//                            alignment: Alignment.centerLeft,
//                            child: Checkbox(
//                              value: _isCheckList[i].isCheck,
//                              onChanged: (value) {
//                                setState(() {
//                                  _isCheckList[i].isCheck = value;
//                                  if (value == true) {
//                                    _selectedNum++;
//                                  } else {
//                                    _selectedNum--;
//                                  }
//                                });
//                              },
//                            ),
//                          ):Container(),
//                          widget.itemBuilder(context, i),
//                        ],
//                      ),
//                      );

                    },
                    itemCount: _isCheckList.length,
                  ),
                ),
//          child: ListView.builder(
//              physics: new AlwaysScrollableScrollPhysics(),
//              itemCount: _isCheckList.length,
//              itemBuilder: (context, index) {
//                return Column(
//                  mainAxisAlignment: MainAxisAlignment.start,
//                  crossAxisAlignment: CrossAxisAlignment.stretch,
//                  children: <Widget>[
//                    Builder(builder: (context) {
//                      if (_isEdit) {
//                        return Container(
//                          child: Row(
//                            mainAxisAlignment: MainAxisAlignment.start,
//                            children: <Widget>[
//                              Container(
//                                child: Checkbox(
//                                  value: _isCheckList[index].isCheck,
//                                  onChanged: (value) {
//                                    setState(() {
//                                      _isCheckList[index].isCheck = value;
//                                      if (value == true) {
//                                        _selectedNum++;
//                                      } else {
//                                        _selectedNum--;
//                                      }
//                                    });
//                                  },
//                                ),
//                              ),
//                              Expanded(
//                                child: widget.itemBuilder(context, index),
//                              )
//                            ],
//                          ),
//                        );
//                      } else {
//                        return Container(
//                          child: widget.itemBuilder(context, index),
//                        );
//                      }
//                    }),
//                    Divider(),
//                  ],
//                );
//              }),
        )),
        Container(
          height: _isEdit ? 50 : 0,
          alignment: Alignment.bottomCenter,
          color: widget.footColor != null ? widget.footColor : Colors.grey[300],
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
