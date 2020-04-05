import 'dart:async';

import 'package:flutter/material.dart';
import 'package:manufacture/beans/project.dart';
import 'package:manufacture/beans/req_response.dart';
import 'package:manufacture/data/repository/flow_nodes_repository.dart';
import 'package:manufacture/ui/pages/scan_page.dart';
import 'package:manufacture/ui/pages/tech_operate_page.dart';

class NodeOperate extends StatefulWidget {
  final int procedure;
  NodeOperate({Key key, this.procedure}):super(key:key);
  @override
  State<StatefulWidget> createState() => _NodeOperate();
}

class _NodeOperate extends State<NodeOperate> {
  StreamController<List<Node>> _streamController = StreamController(sync: true);
  FlowNodeObjectRepository _objectRepository = FlowNodeObjectRepository.init();


  _getOrderdNodes() async{
    ReqResponse<List<Node>> req = await _objectRepository.getNodes(modalId: widget.procedure);
    _streamController.sink.add(req.t);
  }


  @override
  void initState() {
    _getOrderdNodes();
    super.initState();
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("工序"),),
      body: StreamBuilder(
        stream: _streamController.stream,
        builder: (context, snapShot){
          if(snapShot.data != null){
            int _index = 1;
            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: snapShot.data.map<ListTile>((Node node){
                  return ListTile(
                    leading: CircleAvatar(child: Text("${_index++}"),),
                    title: Text(node.name),
                    trailing: node.out_flow?IconButton(
                      icon: Icon(Icons.arrow_forward, color: Theme.of(context).accentColor,),
                      onPressed: (){
                        if(node.node_type == 1){
                          Navigator.push<String>(context,
                              new MaterialPageRoute(builder:
                                  (BuildContext context) {
                                return new Scan(title: "二维码编号");
                              })).then((String result) {
                            //TODO:添加产品编号
                            if (result != null) {
                              Navigator.push<String>(context,
                                  new MaterialPageRoute(builder:
                                      (BuildContext context) {
                                    return new TechOperate(code: result,techModalId: node.type_id,);
                                  }));
                            }
                          });
                        }else{

                        }
                      }
                    ):null,
                  );
                }).toList(),
              ),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
