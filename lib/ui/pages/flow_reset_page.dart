import 'package:flutter/material.dart';
import 'package:manufacture/beans/project.dart';

class FlowReset extends StatefulWidget{
  final List<Node> nodeList;
  FlowReset({@required this.nodeList});

  @override
  State<StatefulWidget> createState() => _FlowResetPage();
}

class _FlowResetPage extends State<FlowReset>{

  List<Node> get nodeList => widget.nodeList;
  List<bool> _boolList=[];

  @override
  void initState() {
    // TODO: implement initState
    nodeList.forEach((node){
      _boolList.add(false);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text("重置"),),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: ListView.builder(
                itemCount: nodeList.length,
                itemBuilder: (BuildContext context, int index){
                  return CheckboxListTile(
                    value: _boolList[index],
                    title: Text(nodeList[index].name),
                    onChanged: (flag){
                      setState(() {
                        for(int i=0;i<_boolList.length;i++)
                        {
                          if(i>=index){
                            _boolList[i] = true;
                          }else{
                            _boolList[i] = false;
                          }
                        }
                      });

                    },
                  );
                }),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
            height: 60,
            child: RaisedButton(
                color: Theme.of(context).accentColor,
                //color: Colors.blue,
                child: Text("确认"),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    side: BorderSide(
                        color: Color(0xFFFFF00F), style: BorderStyle.solid, width: 2)),
                onPressed: (){
                  Node resetNode;
                  for(int i=0;i<=_boolList.length;i++){
                    if(_boolList[i] == true){
                      resetNode = nodeList[i];
                      break;
                    }
                  }
                  Navigator.pop(context,resetNode);
                }),
          ),
        ],
      )
    );
  }

}