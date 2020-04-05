import 'package:flutter/material.dart';
import 'scan_page.dart';
import 'package:manufacture/bloc/ship_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manufacture/beans/ship.dart';
import 'package:manufacture/data/repository/ship_repository.dart';
import 'package:manufacture/data/repository/flow_repository.dart';

class ShipQuery extends StatefulWidget {
  final String flowCode;
  final String nodeCode;
  final FlowRepository flowRepository;

  ShipQuery({Key key,this.flowCode,this.nodeCode,this.flowRepository}):super(key:key);

  @override
  State<StatefulWidget> createState() => _ShipQueryState();
}

class _ShipQueryState extends State<ShipQuery> {
  ShipBloc _shipBloc;

  @override
  void initState() {
    // TODO: implement initState
    _shipBloc = ShipBloc(shipRepository:new ShipRepository(),flowRepository: widget.flowRepository);
    super.initState();
  }

  @override
  void dispose()
  {
    _shipBloc.close();
    super.dispose();
  }

  _showDialog(String text) {
    showDialog(
        builder: (context) =>
        new AlertDialog(
          title: new Text('提示'),
          content: new Text(text),
          actions: <Widget>[
            new FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: new Text('确定'))
          ],
        ),
        context: context);
  }

  void _onWidgetDidBuild(Function callback) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callback();
    });
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return BlocBuilder<ShipBloc, ShipState>(
    bloc: _shipBloc,
    builder: (BuildContext context, ShipState state) {
      return Scaffold(
        appBar: AppBar(
          title: Text('发货管理'),
          actions: <Widget>[
            MaterialButton(
                color: Theme.of(context).accentColor,
                //color: Colors.blue,
                child: Text("重置"),
                onPressed: ()  {
                  _shipBloc.add(new ResetEvent());
                }),
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: Builder(builder: (BuildContext context){
                if(state is ShipInitState) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Container(
                        alignment: Alignment.center,
                        child: GestureDetector(
                          child: Image.asset(
                            "images/add.jpg",
                            fit: BoxFit.cover,
                            width: 100,
                            height: 100,
                          ),
                          onTap: () {
                            Navigator.push<String>(context,
                                new MaterialPageRoute(
                                    builder: (BuildContext context) {
                                      return new Scan(title: "发货单");
                                    })).then((String result) {
                              print(result);
                              _shipBloc.add(new FetchShipInfoEvent(code:result));
                              //处理代码
                            });
                          },
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 10),
                        alignment: Alignment.center,
                        child: Text("点击添加发货单"),
                      )
                    ],
                  );
                }else if(state is CommitSuccessState){
                  _onWidgetDidBuild(() {
                    Navigator.pop(context);
                  });
                  List<ListTile> _list = state.order.info.map<ListTile>((Info info){
                    return ListTile(
                      leading: Icon(Icons.art_track),
                      title: Text(info.name),
                      subtitle: Text(info.value),
                    );
                  }).toList();
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: _list,
                  );
                }else if(state is ShipOrderLoadedState){

                  List<ListTile> _list = state.order.info.map<ListTile>((Info info){
                    return ListTile(
                      leading: Icon(Icons.art_track),
                      title: Text(info.name),
                      subtitle: Text(info.value),
                    );
                  }).toList();
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: _list,
                  );
                }
              }),
//            child: new SingleChildScrollView(
//              child: Container(
//                alignment: Alignment.center,
//                child: Text("hello"),
//              ),
//            ),
//              child: Container(
//                alignment: Alignment.center,
//                child: GestureDetector(
//                  child: Image.asset(
//                    "images/add.jpg",
//                    fit: BoxFit.cover,
//                    width: 100,
//                    height: 100,
//                  ),
//                  onTap: () {
//
//                  },
//                ),
//              ),
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
                          color: Color(0xFFFFF00F),
                          style: BorderStyle.solid,
                          width: 2)),
                  onPressed: () {
                    _shipBloc.add(CommitEvent(flow: widget.flowCode, node: widget.nodeCode));
                  }),
            ),
          ],
        ),
      );
    });
  }
}
