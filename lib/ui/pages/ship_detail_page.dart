import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manufacture/beans/ship.dart';
import 'package:manufacture/bloc/ship_detail_block.dart';
import 'package:manufacture/data/repository/ship_repository.dart';
import 'package:manufacture/data/repository/project_respository.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'scan_page.dart';
import 'editable_listview.dart';

class ShipDetailPage extends StatefulWidget {
  final ShipDetail shipDetail;
  final ShipRepository shipRepository;
  ShipDetailPage(
      {Key key, @required this.shipDetail, @required this.shipRepository})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => _ShipDetailState();
}

void _showSnackBar(BuildContext context, String text, Color color) {
  Scaffold.of(context).showSnackBar(SnackBar(content: new Text(text), backgroundColor: color,));
}



class _ShipDetailState extends State<ShipDetailPage> {
  bool isEdit=false;
  ShipDetailBlock _shipDetailBlock;
  GlobalKey<EditableListViewState<ShipInfo>> _editableListKey =
  new GlobalKey<EditableListViewState<ShipInfo>>();
  RegExp exp =
  new RegExp(r"(http)(://www.gdmcmc.cn/qrcode.html)?([^# ]*)(\d{12})");

  @override
  void initState() {
    super.initState();
    _shipDetailBlock = ShipDetailBlock(shipRepository: widget.shipRepository, projectRepository: ProjectRepository());
    _shipDetailBlock.add(LoadEvent(detailId: widget.shipDetail.id));
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.shipDetail.name),
        actions: <Widget>[
          FlatButton(
            child: isEdit?Text('取消'):Text('编辑'),
            onPressed: (){
              if(isEdit){
                isEdit = false;
              }else{
                isEdit= true;
              }
              if(_editableListKey.currentState!=null){
                _editableListKey.currentState.setEdit(isEdit);
              }
              setState(() {

              });
            },
          )
        ],
      ),
      body: BlocListener(
        bloc: _shipDetailBlock,
        listener: (context, state) {
          if(state is LoadedSuccessState){
            _showSnackBar(context, state.msg, Colors.green);
          }else if(state is LoadedFailState){
            _showSnackBar(context, state.msg, Colors.red);
          }
        },
        child: BlocBuilder(
            bloc: _shipDetailBlock,
            builder: (event, state) {
              if (state is LoadedState) {

                print(state.infoList.length);
                if(_editableListKey.currentState!=null)
                    _editableListKey.currentState.initChecks(state.infoList);

                return EditableListView<ShipInfo>(
                  key: _editableListKey,
                  //count: state.infoList.length,
                  list: state.infoList,
                  onTapDelete: (list){
                    _shipDetailBlock.add(DeleteEvent(shipInfoList: list, shipDetail: widget.shipDetail.id));
                  },
                  itemBuilder: (context, index){
                    return Slidable(
                        key: new Key(state.infoList[index].code),
                        closeOnScroll: true,
                        delegate: new SlidableDrawerDelegate(),
                        actionExtentRatio: 0.25,
                        child: ListTile(
//                          leading: Icon(
//                            Icons.assignment,
//                            color: Colors.deepOrange,
//                          ),
                          title: Text("${state.infoList[index].product}"),
                          //subtitle: Text(state.infoList[index].operate_at),
                        ),
                        secondaryActions: <Widget>[
                          new IconSlideAction(
                            closeOnTap: true,
                            caption: '删除',
                            color: Colors.blue,
                            icon: Icons.restore_from_trash,
                            onTap: (){
                            //_shipDetailBlock.dispatch(new DeleteEvent(shipInfo:state.infoList[index], shipDetail: widget.shipDetail.id));
                            },
                          ),
                        ]);
                  },
                );
//                return ListView(
//                  children: state.infoList.map<Slidable>((info) {
//                    return Slidable(
//                        key: new Key(info.code),
//                        closeOnScroll: true,
//                        delegate: new SlidableDrawerDelegate(),
//                        actionExtentRatio: 0.25,
//                        child: ListTile(
//                          leading: Icon(
//                            Icons.assignment,
//                            color: Colors.deepOrange,
//                          ),
//                          title: Text(info.product.code),
//                          subtitle: Text(info.operate_at),
//                        ),
//                        secondaryActions: <Widget>[
//                          new IconSlideAction(
//                            closeOnTap: true,
//                            caption: '删除',
//                            color: Colors.blue,
//                            icon: Icons.restore_from_trash,
//                            onTap: (){
//                            _shipDetailBlock.dispatch(new DeleteEvent(shipInfo:info, shipDetail: widget.shipDetail.id));
//                            },
//                          ),
//                        ]);
//                  }).toList(),
//                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
      ),
      floatingActionButton: Builder(builder: (context){
        if(!isEdit){
          return FloatingActionButton(
            child: Icon(Icons.add),
            shape: new CircleBorder(),
            onPressed: () {
              Navigator.push<String>(context,
                  new MaterialPageRoute(builder: (BuildContext context) {
                    return new Scan(title: "流水号");
                  })).then((String result) {

                if (exp.hasMatch(result)) {
                  //print(code.split("=")[1].substring(5, 11));
                  result = result.split("=")[1].substring(5, 11);
                }

                if(result!=null)
                  _shipDetailBlock.add(new AddEvent(shipDetail: widget.shipDetail.id, productCode: result));
                //处理代码
              });
            },
          );
        }else{
          return Container();
        }
      })
    );
  }
}
