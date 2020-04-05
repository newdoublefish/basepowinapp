import 'dart:async';

import 'package:flutter/material.dart';
import 'package:manufacture/beans/project.dart';
import 'package:manufacture/data/repository/tech_repository.dart';
import 'package:manufacture/beans/technology.dart';

import 'tech_operate_page.dart';

class TechReportPage extends StatefulWidget{
  //final FlowHistory flowHistory;
  final int techId;
  final Node node;
  TechReportPage({Key key,this.techId,this.node}):super(key:key);
  @override
  State<StatefulWidget> createState() => _TechReportPage();
}

class _TechReportPage extends State<TechReportPage>{
  StreamController<Tech> _controller = new StreamController.broadcast();
  TechObjectRepository _techObjectRepository = new TechObjectRepository.init();

  void _getTech() async{
    Tech tech = await _techObjectRepository.get(widget.techId);
    _controller.sink.add(tech);
  }


  @override
  void initState() {
    _getTech();
    super.initState();
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text("报告"),actions: <Widget>[
        StreamBuilder(
          stream: _controller.stream,
          builder: (context, snapShot){
            if(snapShot.data==null || (widget.node==null && snapShot.data.modal==null)){
              return Container();
            }else{
              int _techModal;
              if(widget.node!=null){
                _techModal = widget.node.type_id;
              }else{
                _techModal = snapShot.data.modal;
              }
              return FlatButton(
                child: Text("修改"),
                onPressed: (){
                  Navigator.push<String>(context,
                      new MaterialPageRoute(builder:
                          (BuildContext context) {
                        return new TechOperate(code: snapShot.data.code,techModalId: _techModal,);
                      })).then((_){
                        _getTech();
                  });
                },
              );
            }
          },
        )
      ],),
      body: StreamBuilder(
        stream: _controller.stream,
        builder: (context, streamData){
          if(streamData.data==null){
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return SingleChildScrollView(
            child: ListView(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: <Widget>[
                Container(
                  height: 16,
                  color: Colors.grey[100],
                ),
                Container(
                  color: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      ListTile(
                        dense: true,
                        leading: Icon(
                          Icons.receipt,
                          color: Theme.of(context).accentColor,
                        ),
                        title: Text(
                          "测试报告",
                        )
                      ),
                      ListTile(
                        dense: true,
                        leading: Text('测试类型'),
                        title: Text(streamData.data.modalname),
                      ),
                      ListTile(
                        dense: true,
                        leading: Text('操作人员'),
                        title: Text(streamData.data.username),
                      ),
                      ListTile(
                        dense: true,
                        leading: Text('测试时间'),
                        title: Text(streamData.data.pub_date),
                      ),
                      ListTile(
                        dense: true,
                        leading: Text('已完成'),
                        title: Text(streamData.data.finished.toString()),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 16,
                  color: Colors.grey[100],
                ),
                ListTile(
                    dense: true,
                    leading: Icon(
                      Icons.dehaze,
                      color: Theme.of(context).accentColor,
                    ),
                    title: Text(
                      "详情",
                    )
                ),
                ListView(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: streamData.data.detail!=null?streamData.data.detail.map<ListTile>((i) {
                    return ListTile(
                        dense: true,
                        leading: Text(
                          "${i.name}:",
                        ),
                        title: Builder(builder: (BuildContext context) {
                          return Text(i.value!=null?i.value.toString():"无");
                        }));
                  }).toList():[],
                ),
                Container(
                  height: 16,
                  color: Colors.grey[100],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

}