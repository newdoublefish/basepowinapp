import 'package:flutter/material.dart';
import 'package:manufacture/beans/test.dart';
import 'package:manufacture/data/repository/user_repository.dart';
import 'report_detail.dart';

//TODO: https://juejin.im/post/5c6f9e6af265da2deb6aa8fb
//TODO: https://www.jianshu.com/p/e6dafb114855

class ReportPage extends StatefulWidget {
  final Test test;
  final List<TestItem> testItems;
  final UserRepository userRepository;
  ReportPage({Key key, this.test, this.testItems, @required this.userRepository}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _ReportPageState();
}

class _TestDetail extends StatelessWidget {
  final List<TestItem> testItems;
  final String testCode;
  _TestDetail({this.testItems,this.testCode});
  @override
  Widget build(BuildContext context) {
//    List<DataRow> rowList = testItems.map((item) {
//      List<DataCell> cellList = [];
//      Color _color = Colors.green;
//      if (item.pass==null || item.pass.compareTo("合格") != 0) {
//        _color = Colors.red;
//      }
//      cellList.add(DataCell(Text(
//        item.name,
//        style: TextStyle(color: _color),
//      )));
//      cellList.add(DataCell(Text(
//        item.value,
//        style: TextStyle(color: _color),
//      )));
//      cellList.add(DataCell(Text(
//        item.pass!=null?item.pass:"合格",
//        style: TextStyle(color: _color),
//      )));
//      cellList.add(DataCell(Text(
//        item.start,
//        style: TextStyle(color: _color),
//      )));
//      cellList.add(DataCell(Text(
//        item.end,
//        style: TextStyle(color: _color),
//      )));
//      return DataRow(cells: cellList);
//    }).toList();
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        ListTile(
          dense: true,
          title: Row(
            children: <Widget>[
              Icon(
                Icons.art_track,
                color: Colors.green,
              ),
              Text(
                " 测试详情",
              )
            ],
          ),
        ),
        ListTile(
          dense: true,
          leading: Text('点击右边箭头查看报告详情'),
          //title: Text(testCode),
          trailing: IconButton(
              icon: Icon(
                Icons.chevron_right,
                color: Theme.of(context).accentColor,
              ),
              onPressed: () {
                Navigator.push(context,
                    new MaterialPageRoute(
                        builder: (BuildContext
                        context) {
                            return ReportDetail(testItems: testItems,);
                        }));
              }),
        ),
//        Expanded(
//            child: NotificationListener(
//          onNotification: (ScrollNotification note) {
//            //print(note.metrics.outOfRange);
//          },
//          child: ListView(
//            padding: const EdgeInsets.all(20.0),
//            children: <Widget>[
//              //Text(widget.flowHistory.),
//              SingleChildScrollView(
//                child: new DataTable(
//                  columns: <DataColumn>[
//                    new DataColumn(
//                      label: Text('名称'),
//                    ),
//                    new DataColumn(
//                      label: Text('测试值'),
//                    ),
//                    new DataColumn(
//                      label: Text('测试结果'),
//                    ),
//                    new DataColumn(
//                      label: Text('开始时间'),
//                    ),
//                    new DataColumn(
//                      label: Text('结束时间'),
//                    ),
//                  ],
//                  rows: rowList,
//                ),
//                scrollDirection: Axis.horizontal,
//              ),
//            ],
//          ),
//        )),
      ],
    );
  }
}

class _Text extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      width: 30,
    );
  }
}

class _TestDetailA extends StatelessWidget {
  final List<TestItem> testItems;
  _TestDetailA({this.testItems});
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        ListTile(
          dense: true,
          title: Row(
            children: <Widget>[
              Icon(
                Icons.details,
                color: Colors.green,
              ),
              Text(
                " 测试详情",
              )
            ],
          ),
        ),
//        SingleChildScrollView(
//          scrollDirection: Axis.horizontal,
//          child: ListView.builder(
//            itemBuilder: (context, index) {
//              TestItem item = testItems[index];
//              Color _color = Colors.green;
//              if (item.result.compareTo("合格") != 0) {
//                _color = Colors.red;
//              }
//              return SingleChildScrollView(
//                child:  Row(
//                  mainAxisAlignment: MainAxisAlignment.start,
//                  children: <Widget>[
//                    Text(
//                      item.name,
//                      style: TextStyle(color: _color),
//                    ),
//                    Text(
//                      item.value,
//                      style: TextStyle(color: _color),
//                    ),
//                    Text(
//                      item.result,
//                      style: TextStyle(color: _color),
//                    ),
//                    Text(
//                      item.start,
//                      style: TextStyle(color: _color),
//                    ),
//                    Text(
//                      item.end,
//                      style: TextStyle(color: _color),
//                    )
//                  ],
//                ),
//                scrollDirection: Axis.horizontal,
//                physics: NeverScrollableScrollPhysics(),
//              );
//            },
//            itemCount: testItems.length,
//            shrinkWrap: true,
//            physics: NeverScrollableScrollPhysics(),
//          ),
//        ),
        ListView.builder(itemBuilder: (context,index){
          return SingleChildScrollView(
            child: ListView.builder(
              itemBuilder: (context, index) {
                TestItem item = testItems[index];
                Color _color = Colors.green;
                if (item.pass==null || item.pass.compareTo("合格") != 0) {
                  _color = Colors.red;
                }
                return SingleChildScrollView(
                  child:  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        item.name,
                        style: TextStyle(color: _color),
                      ),
                      Text(
                        item.value,
                        style: TextStyle(color: _color),
                      ),
                      Text(
                        item.pass!=null?item.pass:"合格",
                        style: TextStyle(color: _color),
                      ),
                      Text(
                        item.start,
                        style: TextStyle(color: _color),
                      ),
                      Text(
                        item.end,
                        style: TextStyle(color: _color),
                      )
                    ],
                  ),
                  scrollDirection: Axis.horizontal,
                  physics: NeverScrollableScrollPhysics(),
                );
              },
              itemCount: testItems.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
            ),
            scrollDirection: Axis.horizontal,
          );
        },
        itemCount: 1,
          physics: NeverScrollableScrollPhysics(),
        )
      ],
    );
  }
}

class _ReportPageState extends State<ReportPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Stack(
      children: <Widget>[
        Container(
          color: Colors.grey[100],
        ),
        SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(top: 10),
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    ListTile(
                      dense: true,
                      title: Row(
                        children: <Widget>[
                          Icon(
                            Icons.receipt,
                            color: Colors.green,
                          ),
                          Text(
                            " 测试报告",
                          )
                        ],
                      ),
                    ),
                    ListTile(
                      dense: true,
                      leading: Text('测试编号'),
                      title: Text(widget.test.code),
                    ),
                    ListTile(
                      dense: true,
                      leading: Text('测试类型'),
                      title: Text(widget.test.test_name),
                    ),
                    ListTile(
                      dense: true,
                      leading: Text('测试结果'),
                      title: Text("${widget.test.result_integer}%",style: TextStyle(color: widget.test.result_integer!=100?Colors.red:Colors.green),),
                    ),
                    ListTile(
                      dense: true,
                      leading: Text('操作人员'),
                      title: Text(widget.test.username),
                    ),
                    ListTile(
                      dense: true,
                      leading: Text('测试时间'),
                      title: Text(widget.test.pub_date),
                    ),
                  ],
                ),
              ),
              widget.userRepository.authority.can_view?
              Container(
                color: Colors.white,
                margin: const EdgeInsets.only(top: 10),
                child: _TestDetail(
                  testItems: widget.testItems,
                  testCode: widget.test.code,
                ),
              ):Container(),
//              Container(
//                color: Colors.white,
//                margin: const EdgeInsets.only(top: 10),
//                child: _TestDetailA(
//                  testItems: widget.testItems,
//                ),
//              ),
            ],
          ),
        )
      ],
    );
  }
}
