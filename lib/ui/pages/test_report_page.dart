import 'dart:async';

import 'package:flutter/material.dart';
import 'package:manufacture/beans/project.dart';
import 'package:manufacture/beans/test.dart';
import 'package:manufacture/data/repository/test_repository.dart';

class TestReportPage extends StatefulWidget{
  final FlowHistory flowHistory;
  TestReportPage({Key key,this.flowHistory}):super(key:key);
  @override
  State<StatefulWidget> createState() => _TestReportPage();
}

class _TestReportPage extends State<TestReportPage>{
  StreamController<Test> _controller = new StreamController();
  StreamController<List<TestItem>> _testItemController = new StreamController();
  TestRepository _testRepository = new TestRepository();

  void getTest() async{
    Test test = await _testRepository.getTest(id: widget.flowHistory.work_pk);
    print(test);
    _controller.sink.add(test);
  }

  void getTestItems(Test test) async{
    List<TestItem> itemList=[];
    if(test.project_file!=null){
      itemList = await _testRepository.getTestProjectFile(url: test.project_file);
    }else if(test.detail!=null){
      for(var group in test.detail.results){
        for(var item in group.items){
          itemList.add(item);
        }
      }
    }
    print(itemList);
    _testItemController.sink.add(itemList);
  }

  @override
  void initState() {
    getTest();
    super.initState();
  }

  @override
  void dispose() {
    _controller.close();
    _testItemController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text("测试报告"),),
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
                        leading: Text('测试编号'),
                        title: Text(streamData.data.code),
                      ),
                      ListTile(
                        dense: true,
                        leading: Text('测试类型'),
                        title: Text(streamData.data.test_name),
                      ),
                      ListTile(
                        dense: true,
                        leading: Text('测试结果'),
                        title: Text("${streamData.data.result_integer}%",style: TextStyle(color: streamData.data.result_integer!=100?Colors.red:Colors.green),),
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
                    ],
                  ),
                ),
                Container(
                  height: 16,
                  color: Colors.grey[100],
                ),
                Container(
                  color: Colors.white,
                  child: ListTile(
                      dense: true,
                      leading: Icon(
                        Icons.receipt,
                        color: Theme.of(context).accentColor,
                      ),
                      title: Text(
                        "测试报告",
                      )
                  ),
                ),
                Builder(builder: (context){
                  getTestItems(streamData.data);
                  return StreamBuilder(
                    stream: _testItemController.stream,
                    builder: (context, itemData){
                      if(itemData.data==null){
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      int index = 1;
                      return Container(
                        color: Colors.white,
                        child: ListView(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            children: (itemData.data as List<TestItem>).map((v){
                              print(v);
                              return Card(
                                //color: Colors.red,
                                color: v.pass!=null?v.pass.compareTo("合格")==0?Colors.white:Colors.redAccent[200]:Colors.green[200],
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: <Widget>[
                                    ListTile(
                                      leading: Text("${index++}"),//CircleAvatar(child: Text("${index++}"),),
                                      title: Text(v.name),
                                      subtitle: Column(
                                        crossAxisAlignment: CrossAxisAlignment.stretch,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Text("测试值:${v.value}"),
                                          Text("一次合格率:${v.total-v.error}/${v.total}"),
                                          Text("${v.start}"),
                                        ],
                                      ),
                                      trailing: Text(v.pass!=null?v.pass:"合格", style: TextStyle(
                                        color: v.pass!=null?v.pass.compareTo("合格")==0?Colors.green[200]:Colors.white:Colors.green[200],
                                      ),),
                                    ),
                                  ],
                                ),
                              );
                            }).toList()
                        ),
                      );
                    },
                  );
                },),
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