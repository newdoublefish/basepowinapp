import 'package:flutter/material.dart';
import 'package:manufacture/beans/base_bean.dart';
import 'package:manufacture/data/repository/object_repository.dart';

import 'object_manager_page.dart';

const double _kTimePickerHeaderPortraitHeight = 96.0;
const double _kTimePickerHeaderLandscapeWidth = 168.0;

const double _kTimePickerWidthPortrait = 328.0;
const double _kTimePickerWidthLandscape = 512.0;

const double _kTimePickerHeightPortrait = 496.0;
const double _kTimePickerHeightLandscape = 316.0;

const double _kTimePickerHeightPortraitCollapsed = 484.0;
const double _kTimePickerHeightLandscapeCollapsed = 304.0;

typedef BuildQueryParam = Map<String, dynamic> Function(BaseBean baseBean);
typedef BuildObjectItem<T extends BaseBean> = Widget Function(T t);

class ObjectTobeSelect<T extends BaseBean> {
  final ObjectRepository<T> objectRepository;
  final String title;
  final BuildQueryParam buildQueryParam;
  final BuildObjectItem<T> buildObjectItem;
  ObjectTobeSelect(
      {this.title,
      this.objectRepository,
      this.buildQueryParam,
      this.buildObjectItem,});
}

class ObjectSelectDialog extends StatefulWidget {
  final List<ObjectTobeSelect> tobeSelectList;
  final String title;
  ObjectSelectDialog({Key key,@required this.tobeSelectList,this.title}):super(key:key);
  @override
  State<StatefulWidget> createState() => _ObjectSelectPageState();
}

class _ObjectSelectPageState
    extends State<ObjectSelectDialog> {
  int current=0;
  List<Widget> _widgetList = [];
  Map<int,BaseBean> _selectBaseBean={};

  @override
  void initState() {
    print("121212");
    super.initState();
  }


  Widget _buildWidgetList()
  {
    _widgetList.clear();

    for(int i=0;i<widget.tobeSelectList.length;i++){
      if(current>=i){
        _widgetList.add(_buildSelectPage(i));
      }
    }

    print("$current , ${_widgetList.length}");

    return Stack(
      children: _widgetList,
    );
  }


  bool _isLast(int index){
    if(index==widget.tobeSelectList.length-1){
      return true;
    }else{
      return false;
    }
  }



  Widget _buildSelectPage(int i) {
    return ObjectManagerPage(
      showAppBar: false,
      objectRepository: widget.tobeSelectList[i].objectRepository,
      initQueryParams: widget.tobeSelectList[i].buildQueryParam!=null?widget.tobeSelectList[i].buildQueryParam(_selectBaseBean[i-1]):null,
      itemWidgetBuilder: (context, BaseBean obj) {
        //Widget widget = objectTobeSelect.buildObjectItem(obj);
        Widget _widget = ListTile(
          selected: obj == _selectBaseBean[i]?true:false,
          title: widget.tobeSelectList[i].buildObjectItem(obj),
          trailing: _isLast(i)?null:IconButton(
            icon: Icon(Icons.keyboard_arrow_right),
            onPressed: (){
              _selectBaseBean[i] = obj;
              setState(() {
                current = i+1;
                widget.tobeSelectList[current].objectRepository.clear(); //清空
                print(current);
              });
            },
          ),
        );
        return _widget;
      },
      onTap: (BaseBean baseBean){
        if(_isLast(i)){
          Navigator.pop(context,baseBean);
        }
      },
    );
  }

  Widget _buildHeader()
  {
    return Container(
      color: Theme.of(context).accentColor,
      child: ListTile(
        leading: current!=0?IconButton(
          icon: Icon(Icons.keyboard_arrow_left),
          onPressed: (){
            setState(() {
              current-=1;
            });
          },
        ):null,
        title: Text(widget.title!=null?widget.title:"请选择"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        dialogBackgroundColor: Colors.white,
      ),
      child: Dialog(
        child: OrientationBuilder(
          builder: (BuildContext context, Orientation orientation) {
            double timePickerHeightPortrait;
            double timePickerHeightLandscape;
            switch (Theme.of(context).materialTapTargetSize) {
              case MaterialTapTargetSize.padded:
                timePickerHeightPortrait = _kTimePickerHeightPortrait;
                timePickerHeightLandscape = _kTimePickerHeightLandscape;
                break;
              case MaterialTapTargetSize.shrinkWrap:
                timePickerHeightPortrait = _kTimePickerHeightPortraitCollapsed;
                timePickerHeightLandscape =
                    _kTimePickerHeightLandscapeCollapsed;
                break;
            }

            assert(orientation != null);
            switch (orientation) {
              case Orientation.portrait:
                return SizedBox(
                  width: _kTimePickerWidthPortrait,
                  height: timePickerHeightPortrait,
                  //child: widget.tobeSelect.buildSelectPage(),
                  //child: _buildSelectPage(widget.tobeSelectList[current]),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      _buildHeader(),
                      Expanded(
                        child: _buildWidgetList(),
                      )
                    ],
                  ),
                );
              case Orientation.landscape:
                return SizedBox(
                  width: _kTimePickerWidthLandscape,
                  height: timePickerHeightLandscape,
                  //child: _buildSelectPage(widget.tobeSelectList[current]),
                  child: _buildWidgetList(),
                );
            }
            return null;
          },
        ),
      ),
    );
  }
}
