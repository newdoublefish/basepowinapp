import 'dart:async';

import 'package:flutter/material.dart';
import 'package:manufacture/beans/project.dart';
import 'package:manufacture/beans/req_response.dart';
import 'package:manufacture/beans/ship.dart';
import 'package:manufacture/data/repository/attribute_repository.dart';
import 'package:manufacture/data/repository/flow_repository.dart';
import 'package:manufacture/data/repository/ship_repository.dart';

import 'flow_instance_process_page.dart';

class ProductDetailPage extends StatefulWidget {
  final Product product;
  ProductDetailPage({Key key, this.product}):super(key:key);
  @override
  State<StatefulWidget> createState() => ProductDetailPageState();
}

class ProductDetailPageState extends State<ProductDetailPage> {
  StreamController<List<ProductAttribute>> _attributeStreamController = StreamController(sync: false);
  StreamController<FlowInstance> _flowInstanceStreamController = StreamController(sync: false);
  StreamController<ShipOrder> _shipOrderStreamController = StreamController(sync: false);

  AttributeObjectRepository _attributeObjectRepository = AttributeObjectRepository.init();
  FlowInstanceObjectRepository _flowInstanceObjectRepository = FlowInstanceObjectRepository.init();

  ShipObjectRepository _shipObjectRepository = ShipObjectRepository.init();
  ShipDetailObjectRepository _shipDetailObjectRepository = ShipDetailObjectRepository.init();
  ShipInfoObjectRepository _shipInfoObjectRepository = ShipInfoObjectRepository.init();

  _getShipOrderList() async{
    ReqResponse<List<ShipInfo>> req = await _shipInfoObjectRepository.getList(queryParams: {"product": widget.product.id});
    if(req.t.length>0){
      ShipInfo _info = req.t[0];
      ShipDetail _detail = await _shipDetailObjectRepository.get(_info.ship_detail);
      if(_detail!=null){
        ShipOrder _order = await _shipObjectRepository.get(_detail.ship_instance);
        if(_order!=null){
          _shipOrderStreamController.sink.add(_order);
        }
      }
    }

    //_shipOrderStreamController.sink.add(req.t);
  }

  _getAttributeList() async{
    ReqResponse<List<ProductAttribute>> req = await _attributeObjectRepository.getList(queryParams: {"category": widget.product.category});
    _attributeStreamController.sink.add(req.t);
  }

  _getFlowInstance() async{
    ReqResponse<List<FlowInstance>> req = await _flowInstanceObjectRepository.getList(queryParams: {"product": widget.product.id});
    if(req.t.length>0){
      _flowInstanceStreamController.sink.add(req.t[0]);
    }
  }

  @override
  void initState() {
    if(widget.product.category !=null){
      _getAttributeList();
    }
    _getFlowInstance();
    _getShipOrderList();
    super.initState();
  }

  @override
  void dispose() {
    _attributeStreamController.close();
    _flowInstanceStreamController.close();
    _shipOrderStreamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("产品详情"),),
      body: Stack(
        children: <Widget>[
          Container(color: Colors.grey[100],),
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(height: 16,),
                Container(
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        leading: Icon(
                          Icons.info,
                          color: Theme.of(context).accentColor,
                        ),
                        dense: true,
                        title: Text("基本信息"),
                      ),
                      ListTile(
                        leading: Text("编号"),
                        dense: true,
                        title: Text(widget.product.code),
                      ),
                      ListTile(
                        leading: Text("型号"),
                        dense: true,
                        title: Text(widget.product.category_text!=null?widget.product.category_text:"无"),
                      ),
                      ListTile(
                        leading: Text("批次"),
                        dense: true,
                        title: Text(widget.product.project_text!=null?widget.product.project_text:"无"),
                      ),
                      ListTile(
                        leading: Text("状态"),
                        dense: true,
                        title: Text(widget.product.status_text),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                widget.product.category!=null?Container(
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        leading: Icon(
                          Icons.apps,
                          color: Theme.of(context).accentColor,
                        ),
                        dense: true,
                        title: Text("产品属性"),
                      ),
                      StreamBuilder<List<ProductAttribute>>(
                        stream: _attributeStreamController.stream,
                        builder: (context, snapShort){
                          if(snapShort.data == null){
                            return Center(child: CircularProgressIndicator(),);
                          }else{
                            List<ProductAttribute> _list = snapShort.data;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisSize: MainAxisSize.min,
                              children: _list.map((attribute){
                                return ListTile(
                                  dense: true,
                                  leading: Text(attribute.name),
                                  title: Text(attribute.value),
                                );
                              }).toList(),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ):Container(),
                SizedBox(
                  height: 16,
                ),
                Container(
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        leading: Icon(
                          Icons.low_priority,
                          color: Theme.of(context).accentColor,
                        ),
                        dense: true,
                        title: Text("生产流程"),
                      ),
                      StreamBuilder<FlowInstance>(
                        stream: _flowInstanceStreamController.stream,
                        builder: (context, snapShot){
                          if(snapShot.data == null){
                            return ListTile(
                              dense: true,
                              title: Text("无相关流程"),
                            );
                          }else{
                            return ListTile(
                              dense: true,
                              leading: Text("流水号"),
                              title: Text(snapShot.data.code),
                              trailing: IconButton(
                                icon: Icon(Icons.keyboard_arrow_right, color: Theme.of(context).accentColor,),
                                onPressed: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context){
                                    return FlowInstanceProcess(
                                      instance: snapShot.data,
                                      flowInstanceObjectRepository: _flowInstanceObjectRepository,
                                    );
                                  }));
                                },
                              ),
                            );
                          }
                        },
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Container(
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        leading: Icon(
                          Icons.local_shipping,
                          color: Theme.of(context).accentColor,
                        ),
                        dense: true,
                        title: Text("发货信息"),
                      ),
                      StreamBuilder<ShipOrder>(
                        stream: _shipOrderStreamController.stream,
                        builder: (context, snapShot){
                          if(snapShot.data == null){
                            return ListTile(
                              dense: true,
                              title: Text("无相关信息"),
                            );
                          }else{
                            ShipOrder _shipOrder = snapShot.data;
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                ListTile(
                                  dense: true,
                                  leading: Text("发货单号"),
                                  title: Text(_shipOrder.code),
                                ),
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: _shipOrder.info.map((info){
                                    return ListTile(
                                      dense: true,
                                      leading: Text(info.name),
                                      title: Text(info.value),
                                    );
                                  }).toList(),
                                ),
                              ],
                            );
                          }
                        },
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
              ],
            ),
          )
        ],
      )
    );
  }
}
