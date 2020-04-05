import 'dart:async';

import 'package:flutter/material.dart';
import 'package:manufacture/beans/base_bean.dart';
import 'package:manufacture/beans/manager.dart';
import 'package:manufacture/beans/ship.dart';
import 'package:manufacture/core/object_create_modify_page.dart';
import 'package:manufacture/core/object_select_dialog.dart';
import 'package:manufacture/core/object_selector.dart';
import 'package:manufacture/data/repository/ship_repository.dart';
import 'package:manufacture/ui/pages/ship_detail_manage_page.dart';
import 'package:manufacture/ui/widget/smart_filter_page/smart_filter_page.dart';
import 'brand_add_edit_page.dart';
import '../../core/object_manager_page.dart';
import 'package:manufacture/beans/project.dart';


class ShipOrderManage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _ManageState();
}

class _ManageState extends State<ShipOrderManage>{
  ShipObjectRepository _objectRepository;
  @override
  void initState() {
    _objectRepository = ShipObjectRepository.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ObjectManagerPage<ShipOrder>(
      title: "发货单管理",
      objectRepository:_objectRepository,
      filterGroupList: [
        FilterGroup(niceName: "发货单状态", filterName: "finished", filterItems: [
          FilterItem(
            niceName: "全部",
          ),
          FilterItem(niceName: "未完成", filterValue: "false"),
          FilterItem(niceName: "已完成", filterValue: "true"),
        ]),
      ],
      itemWidgetBuilder: (context, BaseBean obj){
        ShipOrder _order = obj as ShipOrder;
        Widget widget = ListTile(
          leading: ExcludeSemantics(
              child: CircleAvatar(child: Text(_order.code[0]))),
          title: Text(_order.code),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(_order.finished!=null?_order.finished?"已完成":"未完成":"未完成"),
            ],
          ),
          trailing: FlatButton(
            child: Text("详情"),
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(
                  builder: (context){
                    return _Detail(
                      order: _order,
                    );
                  }
              ));
            },
          ),
        );
        return widget;
      },
      onTap: (BaseBean value){
        Navigator.push(context, MaterialPageRoute(
          builder: (context){
            return ShipDetailManage(
              shipOrder: value as ShipOrder,
            );
          }
        ));
      },
      addEditPageBuilder: (context, BaseBean obj){
        return _AddModify(
          objectRepository: _objectRepository,
          order: obj as ShipOrder,
        );
      },
    );
  }
}

class _Detail extends StatelessWidget{
  final ShipOrder order;
  _Detail({this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("详情"),),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            ListTile(
              dense: true,
              leading: Text("单号:"),
              title: Text(order.code),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: order.info.map((info){
                return ListTile(
                  dense: true,
                  leading: Text(info.name.toString()+":"),
                  title: Text(info.value.toString()),
                );
              }).toList(),
            ),
          ],
        ),
      )
    );
  }

}

class _AddModify extends StatefulWidget {
  final ShipOrder order;
  final ShipObjectRepository objectRepository;
  _AddModify({Key key, this.order, this.objectRepository})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _ManagerAddModifyState();
}

class _ManagerAddModifyState extends State<_AddModify> {
  ShipOrder order;
  TextEditingController _code = new TextEditingController();
  GlobalKey<_ShipDetailState> _key = GlobalKey<_ShipDetailState>();
  bool _finished;

  @override
  void initState() {
    if(widget.order!=null){
      order = widget.order;
      _code.text = order.code;
      _finished = order.finished;
    }else{
      order = ShipOrder();
      _finished = false;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ObjectCreateModifyPage<ShipOrder>(
      title: "订单管理",
      type: widget.order!=null?ObjectOperateType.MODIFY:ObjectOperateType.CREATE,
      objectRepository: widget.objectRepository,
      buildBody: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextFormField(
              autofocus: false,
              textCapitalization: TextCapitalization.words,
              controller: _code,
              validator: (value) {
                if (value.isEmpty) {
                  return "内容不能为空";
                }
                return null;
              },
              decoration: InputDecoration(
                border: UnderlineInputBorder(),
                filled: true,
//                icon: Icon(Icons.edit),
                labelText: '名称',
              ),
            ),
            _ShipDetail(order: order,key: _key,),
            SizedBox(
              height: 24,
            ),
            DropdownButtonFormField<bool>(
              onChanged: (bool value) {
                setState(() {
                  _finished = value;
                });
              },
              value: _finished,
              items: [
                DropdownMenuItem<bool>(
                  value: false,
                  child: Text("未完成"),
                ),
                DropdownMenuItem<bool>(
                  value: true,
                  child: Text("已完成"),
                ),
              ],
            ),
          ],
        );
      },
      buildObject: (){
        order.code = _code.text.toString();
        order.modal = _key.currentState.getModal();
        order.info = _key.currentState.getListInfo();
        order.finished = _finished;
        return order;
      },
    );
  }
}

class _ShipDetail extends StatefulWidget{
  final ShipOrder order;
  _ShipDetail({Key key, this.order}):super(key:key);
  @override
  State<StatefulWidget> createState() => _ShipDetailState();
}

class _ShipDetailState extends State<_ShipDetail>{
  ShipModalObjectRepository _shipModalObjectRepository;
  StreamController<ShipModal> _streamController = StreamController(sync: true);
  Map<Info, TextEditingController> controllerMap = {};
  ShipModal _modal;
  List<Info> _infoList=[];

  TextEditingController _getController(Info info) {
    print(info);
    if (controllerMap.containsKey(info)) {
      print("11-------- ${controllerMap[info].text}");
      return controllerMap[info];
    } else {
      TextEditingController controller = new TextEditingController();
      controllerMap[info] = controller;
      if(widget.order.info!=null)
        for(Info _info in  widget.order.info){
          if(info.name.compareTo(_info.name)==0){
            controller.text = _info.value;
            break;
          }
        }
      print("22-------- ${controller.text}");
      return controller;
    }
  }

  _getShipModal(int modal) async{
    ShipModal shipModal = await _shipModalObjectRepository.get(modal);
    print(shipModal);
    _streamController.sink.add(shipModal);
  }

  @override
  void initState() {
    _shipModalObjectRepository = ShipModalObjectRepository.init();
    if(widget.order.modal!=null){
      _modal = ShipModal();
      _modal.id = widget.order.modal;
      _getShipModal(_modal.id);
    }
    super.initState();
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  int getModal(){
    return _modal.id;
  }

  List<Info> getListInfo(){
    for(Info info in _modal.info){
      info.value = _getController(info).text;
    }
    return _modal.info;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        ObjectSelector<ShipModal>(
          objectRepository: _shipModalObjectRepository,
          title: "发货模型",
          buildValueText: (BaseBean detail) {
            return (detail as ShipModal).name;
          },
          object: _modal,
          //controller: _techModalSelectController,
          onSelectCallBack: (BaseBean value) {
            _modal = value as ShipModal;
            _getShipModal(_modal.id);
          },
          objectSelectDialog: ObjectSelectDialog(tobeSelectList: [
            ObjectTobeSelect<ShipModal>(
                title: "发货模型",
                buildQueryParam: (BaseBean t) {
                  return null;
                },
                objectRepository: _shipModalObjectRepository,
                buildObjectItem: (BaseBean t) {
                  return Text(((t as ShipModal).name));
                }),
          ]),
        ),
        StreamBuilder<ShipModal>(
          stream: _streamController.stream,
          builder: (context, snapShot){
            if(snapShot.data==null){
              return Container();
            }else{
              _modal = snapShot.data;
              //controllerMap.clear();
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: _modal.info.map((m){
                  return Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: TextFormField(
                      controller: _getController(m),
                      validator: (value) {
                        if (value.isEmpty) {
                          return "内容不能为空";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        border: UnderlineInputBorder(),
                        filled: true,
//                icon: Icon(Icons.edit),
                        labelText: m.name,
                      ),
                      autovalidate: false,
                    ),
                  );
                }).toList(),
              );
            }
          },
        ),
      ],
    );
  }

}