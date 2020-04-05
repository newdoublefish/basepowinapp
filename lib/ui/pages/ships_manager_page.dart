import 'package:flutter/material.dart';
import 'tabbled_component_scaffold.dart';
import 'package:manufacture/bloc/ship_manager_bloc.dart';
import 'package:manufacture/data/repository/ship_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manufacture/beans/ship.dart';
import 'ship_order_page.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'ship_create_page.dart';

class ShipsManager extends StatefulWidget {
  final String title;
  ShipsManager({Key key, @required this.title}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _ShipManagerState();
}

class _ShipManagerState extends State<ShipsManager> {
  List<ComponentTabData> _list = [];
  ShipManagerBloc _shipManagerBloc;

  @override
  void initState() {
    _shipManagerBloc = ShipManagerBloc(shipRepository: new ShipRepository());
    _shipManagerBloc.add(LoadEvent());
    super.initState();
  }

  @override
  void dispose() {
    _shipManagerBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _list.clear();
    _list.addAll([
      ComponentTabData(
        tabName: "未完成",
        widget: _ShipPage(shipManagerBloc: _shipManagerBloc, finished: false,),
      ),
      ComponentTabData(
        tabName: "已完成",
        widget: _ShipPage(shipManagerBloc: _shipManagerBloc, finished: true,),
      ),
    ]);
    return TabbedComponentScaffold(
      components: _list,
      title: widget.title,
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            Navigator.push<String>(context,new MaterialPageRoute(builder: (BuildContext context){
              return new CreateOrder();
            })).then((String result){
              if(result!=null)
                _shipManagerBloc.add(LoadEvent());
            });
          },
        ),
      ],
    );
  }
}

class _ShipPage extends StatefulWidget {
  final ShipManagerBloc shipManagerBloc;
  final bool finished;
  _ShipPage({@required this.shipManagerBloc, @required this.finished});

  @override
  State<StatefulWidget> createState() => _ShipPageState();
}

class _ShipPageState extends State<_ShipPage>  with AutomaticKeepAliveClientMixin{
  ScrollController _scrollController = ScrollController();
  List<Slidable> _list = [];

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        print('滑动到了最底部');
      }
    });
    super.initState();
  }

  void _showSnackBar(BuildContext context, String text) {
    Scaffold.of(context).showSnackBar(SnackBar(content: new Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return BlocBuilder<ShipManagerBloc, ShipManagerState>(
        bloc: widget.shipManagerBloc,
        builder: (BuildContext context, ShipManagerState state) {
          if(state is LoadedState){
             _list = state.shipOrderList.where((ShipOrder order){
               if(order.finished == widget.finished){
                 return true;
               }else{
                 return false;
               }
             }).map((ShipOrder order){
               return Slidable(
                 key: new Key(order.code),
                 closeOnScroll: true,
                 /*slideToDismissDelegate: new SlideToDismissDrawerDelegate(
                     onWillDismiss: (actionType) {
                       return showDialog<bool>(
                         context: context,
                         builder: (context) {
                           print("-----onWillDismiss-----");
                           return new AlertDialog(
                             title: new Text('Delete'),
                             content: new Text('Item will be deleted'),
                             actions: <Widget>[
                               new FlatButton(
                                 child: new Text('Cancel'),
                                 onPressed: () => Navigator.of(context).pop(false),
                               ),
                               new FlatButton(
                                 child: new Text('Ok'),
                                 onPressed: () => Navigator.of(context).pop(true),
                               ),
                             ],
                           );
                         },
                       );
                     }),*/
                 delegate: new SlidableDrawerDelegate(),
                 actionExtentRatio: 0.25,
                 child: new Container(
                   color: Colors.white,
                   child: ListTile(
                     leading: Icon(Icons.assignment, color: Theme.of(context).accentColor,),
                     title: Text(order.code),
                     onTap: (){
                       Navigator.push(context,new MaterialPageRoute(builder: (BuildContext context){
                         return new ShipOrderPage(code: order.code,);
                       }));
                     },
                   ),
                 ),
                 actions: <Widget>[
                   new IconSlideAction(
                     closeOnTap: true,
                     caption: '标记为完成',
                     color: Colors.blue,
                     icon: Icons.archive,
                     onTap: ()=>_showSnackBar(context, "标记为完成"),
                   ),
//                   new IconSlideAction(
//                     caption: 'Share',
//                     color: Colors.indigo,
//                     icon: Icons.share,
//                     onTap: () => (){
//                       Scaffold.of(context).showSnackBar(
//                         SnackBar(
//                           content: Text('Share'),
//                           backgroundColor: Colors.green,
//                         ),
//                       );
//                     },
//                   ),
                 ],
                 secondaryActions: <Widget>[
//                   new IconSlideAction(
//                     caption: 'More',
//                     color: Colors.black45,
//                     icon: Icons.more_horiz,
//                     onTap: () => (){
//                       Scaffold.of(context).showSnackBar(
//                         SnackBar(
//                           content: Text('More'),
//                           backgroundColor: Colors.green,
//                         ),
//                       );
//                     },
//                   ),
                   new IconSlideAction(
                     caption: 'Delete',
                     color: Colors.red,
                     icon: Icons.delete,
                     onTap: (){
                       print("-----delete-----");
                       Scaffold.of(context).showSnackBar(
                         SnackBar(
                           content: Text('Delete'),
                           backgroundColor: Colors.green,
                         ),
                       );
                     },
                   ),
                 ],
               );
//               return ListTile(
//                 leading: Icon(Icons.assignment, color: Colors.deepOrange,),
//                 title: Text(order.code),
//                 onTap: (){
//                   Navigator.push(context,new MaterialPageRoute(builder: (BuildContext context){
//                     return new ShipOrderPage(code: order.code,);
//                   }));
//                 },
//               );
             }).toList();
          }

          return RefreshIndicator(
            onRefresh: () async{
              print("----onRefresh---");
            },
            child: ListView.builder(
              physics: new AlwaysScrollableScrollPhysics(), //修复条目过少的时候不刷新
              itemBuilder: (context, index) {
                return _list[index];
              },
              itemCount: _list.length,
              controller: _scrollController,
            ),
          );
        });
  }
}
