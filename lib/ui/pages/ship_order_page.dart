import 'package:flutter/material.dart';
import 'package:manufacture/bloc/ship_order_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manufacture/beans/ship.dart';
import 'package:manufacture/data/repository/ship_repository.dart';
import 'package:manufacture/data/repository/flow_repository.dart';
import 'scan_page.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'ship_detail_page.dart';

class ShipOrderPage extends StatefulWidget {
  final String code;
  final bool isEditable;
  ShipOrderPage({@required this.code, this.isEditable = true});
  @override
  State<StatefulWidget> createState() => _ShipOrderState();
}

class _ShipOrderState extends State<ShipOrderPage> {
  ShipOrderBloc _shipOrderBloc;
  ShipRepository _shipRepository;
  final ShapeBorder _shape = const RoundedRectangleBorder(
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(16.0),
      topRight: Radius.circular(16.0),
      bottomLeft: Radius.circular(16.0),
      bottomRight: Radius.circular(16.0),
    ),
  );

  @override
  void initState() {
    _shipRepository = new ShipRepository();
    _shipOrderBloc = new ShipOrderBloc(
      shipRepository: _shipRepository,
    );
    _shipOrderBloc.add(new SearchEvent(code: widget.code));
    super.initState();
  }

  @override
  void dispose() {
    _shipOrderBloc.close();
    super.dispose();
  }

  void _onWidgetDidBuild(Function callback) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callback();
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return BlocBuilder<ShipOrderBloc, ShipOrderState>(
        bloc: _shipOrderBloc,
        builder: (BuildContext context, ShipOrderState state) {
          return Scaffold(
            appBar: AppBar(
              title: Text(widget.code),
            ),
            body: Builder(builder: (BuildContext context) {
              if (state is InitState) {
                return Container(
                  alignment: Alignment.center,
                  child: Text(
                    "无发货单${widget.code}！",
                    style: TextStyle(color: Colors.grey),
                  ),
                );
              }

              if (state is LoadingState) {
                return Container(
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(),
                );
              }

              if (state is LoadedState) {
                final ThemeData theme = Theme.of(context);
                final TextStyle titleStyle =
                    theme.textTheme.headline.copyWith(color: Colors.white);
                final TextStyle descriptionStyle = theme.textTheme.subhead;

                List<ListTile> _orderDetail =
                    state.shipOrder.info.map((Info info) {
                  return ListTile(
                      dense: true,
                      leading: Text(
                        info.name,
                        style: TextStyle(fontSize: 12),
                      ),
                      title: Text(
                        info.value,
                        style: TextStyle(fontSize: 12),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 5.0));
                }).toList();

                _orderDetail.insert(
                    0,
                    ListTile(
                      dense: true,
                      leading: Text(
                        "合同编号",
                        style: TextStyle(fontSize: 12),
                      ),
                      title: Text(
                        '${state.shipOrder.code}',
                        style: TextStyle(fontSize: 12),
                      ),
                    ));

                _orderDetail.insert(
                    0,
                    ListTile(
                        dense: true,
                        leading: Text(
                          "编号",
                          style: TextStyle(fontSize: 12),
                        ),
                        title: Text(
                          '${state.shipOrder.code}',
                          style: TextStyle(fontSize: 12),
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 5.0)));

                int index = 1;

                return Stack(
                  children: <Widget>[
                    Container(
                      color: Colors.grey[200],
                    ),
                    SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Card(
                            color: Colors.white,
                            borderOnForeground: true,
                            shape: _shape,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        16.0, 0, 16.0, 0),
                                    child: DefaultTextStyle(
                                      softWrap: false,
                                      overflow: TextOverflow.ellipsis,
                                      style: descriptionStyle,
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: ListTile.divideTiles(
                                                  context: context,
                                                  tiles: _orderDetail)
                                              .toList()),
                                    ),
                                  ),
                                ),
                                widget.isEditable?Container(
                                  alignment: Alignment.centerRight,
                                  margin: const EdgeInsets.only(right: 5),
                                  child: MaterialButton(
                                      color: Colors.red,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20)),
                                          side: BorderSide(
                                              color: Color(0xFFFFF00F),
                                              style: BorderStyle.solid,
                                              width: 0)),
                                      child: Text('修改'),
                                      onPressed: () {}),
                                ):Container()
                              ],
                            ),
                          ),
                          widget.isEditable?Column(
                            children: <Widget>[
                              Container(
                                  margin: const EdgeInsets.only(top: 5),
                                  color: Colors.white,
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Container(
                                            padding: const EdgeInsets.only(
                                                left: 10, top: 10),
                                            child: Icon(
                                              Icons.list,
                                              color: Colors.green,
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.only(
                                                left: 10, top: 10),
                                            child: Text("发货清单"),
                                          ),
                                        ],
                                      ),
                                      Divider()
                                    ],
                                  )),
                              Container(
                                color: Colors.white,
                                padding: const EdgeInsets.only(bottom: 20),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: ListTile.divideTiles(
                                      context: context,
                                      tiles: state.shipDetailList
                                          .map<Slidable>((ShipDetail detail) {
                                        return Slidable(
                                            key: new Key('{detail.id}'),
                                            closeOnScroll: true,
                                            delegate:
                                            new SlidableDrawerDelegate(),
                                            actionExtentRatio: 0.25,
                                            child: ListTile(
                                              dense: false,
                                              leading: ExcludeSemantics(
                                                  child: CircleAvatar(
                                                      child:
                                                      Text("${index++}"))),
                                              title: Text(detail.name),
                                              subtitle: Text("备注: 无"),
                                              trailing: Column(
                                                mainAxisAlignment:
                                                MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Text(
                                                      "计划 ${detail.quantity_plan} 台"),
                                                  Text(
                                                      "完成 ${detail.quantity_actual} 台")
                                                ],
                                              ),
                                              onTap: () {
                                                Navigator.push(context,
                                                    new MaterialPageRoute(
                                                        builder: (BuildContext
                                                        context) {
                                                          return new ShipDetailPage(
                                                            shipDetail: detail,
                                                            shipRepository:
                                                            _shipRepository,
                                                          );
                                                        })).then((v) {
                                                  _shipOrderBloc.add(
                                                      new SearchEvent(
                                                          code: widget.code));
                                                });
                                              },
                                            ),
                                            secondaryActions: <Widget>[
                                              new IconSlideAction(
                                                closeOnTap: true,
                                                caption: '删除',
                                                color: Colors.blue,
                                                icon: Icons.restore_from_trash,
                                                onTap: () {
                                                  //_shipDetailBlock.dispatch(new DeleteEvent(shipInfo:state.infoList[index], shipDetail: widget.shipDetail.id));
                                                },
                                              ),
                                            ]);
                                      }).toList())
                                      .toList(),
                                ),
                              ),
                            ],
                          ):Container(),
                          SizedBox(
                            height: 50,
                          )
                        ],
                      ),
                    ),
                  ],
                );
              }
            }),
//            floatingActionButton:FloatingActionButton(
//                 child: Icon(Icons.add),
//                 shape: new CircleBorder(),
//                 onPressed: () {
//                   Navigator.push<String>(context,
//                       new MaterialPageRoute(builder: (BuildContext context) {
//                         return new Scan(title: "流水号");
//                       })).then((String result) {
//                     print(result);
//                     if(result!=null)
//                      _shipOrderBloc.dispatch(new AddEvent(flowCode: result));
//                     //处理代码
//                   });
//                 },
//               ),
          );
        });
  }
}
