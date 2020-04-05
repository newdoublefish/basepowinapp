import 'package:flutter/material.dart';
import 'package:manufacture/data/repository/flow_repository.dart';
import 'dart:async';
class Review extends StatefulWidget{
  final String flowCode;
  final String nodeCode;
  final FlowRepository flowRepository;
  Review({Key key,@required this.flowCode, @required this.nodeCode, @required this.flowRepository}):super(key:key);
  @override
  State<StatefulWidget> createState() => _ReviewState();
}

class _ReviewState extends State<Review>{
  int selectedValue=1;

  void updateGroupValue(int v){
    setState(() {
      selectedValue=v;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text('审核'),),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    ListTile(leading: Icon(Icons.check),title: Text("通过"),trailing: Radio(
                      value: 1,
                      groupValue: selectedValue,
                      activeColor: Colors.red,
                      onChanged: (T){
                        updateGroupValue(T);
                      },
                    ),),
                    ListTile(leading: Icon(Icons.clear),title: Text("拒绝"),trailing:Radio(
                      value: 2,
                      groupValue: selectedValue,
                      activeColor: Colors.red,
                      onChanged: (T){
                        updateGroupValue(T);
                      },
                    ),),
                  ],
                ),

              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              height: 40,
              child: RaisedButton(
                  color: Theme.of(context).accentColor,
                  //color: Colors.blue,
                  child: Text("确认"),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      side: BorderSide(
                          color: Color(0xFFFFF00F), style: BorderStyle.solid, width: 2)),
                  onPressed: () async{
                     await widget.flowRepository.confirm(flowCode: widget.flowCode,nodeCode: widget.nodeCode);
                     Navigator.pop(context);
                  }),
            )
          ],
        ),
      ),
    );
  }
}