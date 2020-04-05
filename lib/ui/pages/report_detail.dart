import 'package:flutter/material.dart';
import 'package:manufacture/beans/test.dart';

class ReportDetail extends StatefulWidget {
  final List<TestItem> testItems;
  ReportDetail({Key key, this.testItems}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _ReportDetailState();
}

class _ReportDetailState extends State<ReportDetail> {
  @override
  Widget build(BuildContext context) {
    List<DataRow> rowList = widget.testItems.map((item) {
      List<DataCell> cellList = [];
      Color _color = Colors.green;
      if (item.pass == null || item.pass.compareTo("合格") != 0) {
        _color = Colors.red;
      }
      cellList.add(DataCell(Text(
        item.name,
        style: TextStyle(color: _color),
      )));
      cellList.add(DataCell(Text(
        item.value,
        style: TextStyle(color: _color),
      )));
      cellList.add(DataCell(Text(
        item.pass != null ? item.pass : "合格",
        style: TextStyle(color: _color),
      )));
      cellList.add(DataCell(Text(
        item.start,
        style: TextStyle(color: _color),
      )));
      cellList.add(DataCell(Text(
        item.end,
        style: TextStyle(color: _color),
      )));
      return DataRow(cells: cellList);
    }).toList();
    return Scaffold(
      appBar: AppBar(title: Text("报告详情"),),
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: <Widget>[
          //Text(widget.flowHistory.),
        SingleChildScrollView(
          child: new DataTable(
            columns: <DataColumn>[
              new DataColumn(
                label: Text('名称'),
              ),
              new DataColumn(
                label: Text('测试值'),
              ),
              new DataColumn(
                label: Text('测试结果'),
              ),
              new DataColumn(
                label: Text('开始时间'),
              ),
              new DataColumn(
                label: Text('结束时间'),
              ),
            ],
            rows: rowList,
          ),
          scrollDirection: Axis.horizontal,
        ),
        ],
      ),
    );
  }
}
