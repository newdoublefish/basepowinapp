import 'package:flutter/material.dart';
import 'package:manufacture/beans/project.dart';
import 'package:manufacture/bloc/flow_manager_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manufacture/data/repository/project_respository.dart';
import 'package:manufacture/ui/widget/timeline/model/timeline_model.dart';
import 'package:manufacture/ui/widget/timeline/timeline.dart';
import 'flow_process_page.dart';
import 'progress_fragment.dart';
import 'tabbled_component_scaffold.dart';
//import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:manufacture/ui/widget/easyrefresh/easy_refresh.dart';
import 'dart:async';
import 'filter_page.dart';
import 'product_manager_page.dart';
import 'package:manufacture/data/repository/user_repository.dart';
import 'package:manufacture/data/repository/flow_nodes_repository.dart';

class BottomLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Center(
        child: SizedBox(
          width: 33,
          height: 33,
          child: CircularProgressIndicator(
            strokeWidth: 1.5,
          ),
        ),
      ),
    );
  }
}

class FlowManager extends StatefulWidget {
  final Detail detail;
  final UserRepository userRepository;
  FlowManager({Key key, @required this.detail, @required this.userRepository}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _FlowManagerState();
}

class _FlowManagerState extends State<FlowManager> {
  List<ComponentTabData> _list = [];
  FlowManagerBloc _flowManagerBloc;
  ProjectRepository _projectRepository;
  FlowNodesRepository _flowNodesRepository;

  @override
  void initState() {
    // TODO: implement initState
    _projectRepository = ProjectRepository();
    _flowNodesRepository = FlowNodesRepository();
    _flowManagerBloc = FlowManagerBloc(projectRepository: _projectRepository, flowNodesRepository: _flowNodesRepository);
    _flowManagerBloc.add(RefreshProductEvent(detail: widget.detail, filterString: "全部"));
    super.initState();
  }

  @override
  void dispose() {
    _flowManagerBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    _list.clear();
    _list.addAll([
//      ComponentTabData(
//        tabName: "产品信息",
//        widget: ProductPage(detail: widget.detail,userRepository: widget.userRepository,),
//      ),
      ComponentTabData(
        tabName: "流水信息",
        widget: ProductComponent(
          userRepository: widget.userRepository,
          detail: widget.detail,
          flowManagerBloc: _flowManagerBloc,
          flowNodesRepository: _flowNodesRepository,
        ),
      ),
    ]);
    return TabbedComponentScaffold(
      components: _list,
      title: "详情",
    );
  }
}

class ProductComponent extends StatefulWidget {
  final Detail detail;
  final FlowManagerBloc flowManagerBloc;
  final UserRepository userRepository;
  final FlowNodesRepository flowNodesRepository;
  //final bool finish;
  //final List<Node> nodeList;

  ProductComponent(
      {Key key, this.detail, this.flowManagerBloc,@required this.userRepository,this.flowNodesRepository})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => ProductComponentState();
}

class ProductComponentState extends State<ProductComponent>
    with AutomaticKeepAliveClientMixin {
  ScrollController _controller = new ScrollController();
  final _scrollThreshold = 200.0;
  GlobalKey<EasyRefreshState> _easyRefreshKey =
      new GlobalKey<EasyRefreshState>();
  GlobalKey<RefreshHeaderState> _headerKey =
      new GlobalKey<RefreshHeaderState>();
  GlobalKey<RefreshFooterState> _footerKey =
      new GlobalKey<RefreshFooterState>();
  String _filterString = "全部";

  @override
  void initState() {
    super.initState();
  }

//  String calcPercent(int nodeId) {
//    print(widget.nodeList);
//    int len = widget.nodeList.length;
//    for (int i = 0; i < len; i++) {
//      if (widget.nodeList[i].id == nodeId) {
//        return "${i * 100 / len}%";
//      }
//    }
//    return "0%";
//  }

  @override
  bool get wantKeepAlive => true;
  
  Icon getIcon(String status){
    if(status.compareTo("未开始")==0){
      return Icon(Icons.clear,
        color: Theme.of(context).accentColor,);
    }else if(status.compareTo("进行中")==0){
      return Icon(Icons.directions_run,
        color: Theme.of(context).accentColor,);
    }else if(status.compareTo("结束")==0){
      return Icon(Icons.check,
        color: Theme.of(context).accentColor,);
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return BlocBuilder<FlowManagerBloc, ProjectState>(
        bloc: widget.flowManagerBloc,
        builder: (BuildContext context, ProjectState state) {
          //TODO: https://juejin.im/post/5c73ad886fb9a049d61e2cd3 查询
          return FilterPage(
            filterList: [
              '全部',
              '未开始',
              '进行中',
              '已结束',
            ],
            filterChange: (filterString) {
              _filterString = filterString;
              widget.flowManagerBloc
                  .add(RefreshProductEvent(detail: widget.detail, filterString: _filterString));
            },
            child: Column(
             children: <Widget>[
               Expanded(
                 child: Builder(builder: (context){
                   if (state is DataLoadedState) {
                     List<ListTile> list = state.flowInstanceList.map<ListTile>((FlowInstance flow) {
                       return ListTile(
                         leading: getIcon(flow.status),
                         title: Text(flow.code,style: TextStyle(fontSize: 14),),
                         //subtitle: flow.product_code==null?Text("产品编号:未分配"):Text("产品编号:${flow.product_code}"),//Text("产品编号:" + flow.product_code!=null?flow.product_code:"未分配"),
                         trailing: Text(flow.status),
                         onTap: () async {
                           await Navigator.push(context,
                               new MaterialPageRoute(builder: (BuildContext context) {
                                 return new FlowProcessPage(
                                     userRepository: widget.userRepository,
                                     flowNodesRepository: widget.flowNodesRepository,
                                     code: flow.code);
                               }));
                           widget.flowManagerBloc
                               .add(RefreshProductEvent(detail: widget.detail,filterString: _filterString));
                         },
                       );
                     }).toList();

                     if(_easyRefreshKey.currentState!=null)
                     {
                       if(state is ProductRefreshed)
                       {
                         _easyRefreshKey.currentState.callRefreshFinish();
                       }else{
                         _easyRefreshKey.currentState.callLoadMoreFinish();
                       }

                     }

                     return EasyRefresh(
                       key: _easyRefreshKey,
                       autoControl: false,
                       refreshHeader: ClassicsHeader(
                         key: _headerKey,
                         isFloat: true,
                         refreshText: "下拉刷新",
                         refreshReadyText: "释放刷新",
                         refreshingText: "刷新中",
                         refreshedText: "刷新完成",
                         bgColor: Theme.of(context).accentColor,
                       ),
                       refreshFooter: ClassicsFooter(
                           key: _footerKey,
                           isFloat: true,
                           loadHeight: 50.0,
                           loadText: "上拉加载",
                           loadReadyText: "释放加载",
                           loadingText: "加载中",
                           loadedText: "加载完成了",
                           noMoreText: "没有更多了",
                           moreInfo: "updateAt",
                           bgColor: Colors.orange),
                       child: new ListView.builder(
                         //ListView的Item
                           itemCount: list.length,
                           itemBuilder: (BuildContext context, int index) {
                             return Column(
                               children: <Widget>[
                                 list[index],
                                 Divider()
                               ],
                             );
                           }),
                       onRefresh: () {
                         Future.delayed(const Duration(seconds: 1), () {
                           widget.flowManagerBloc
                               .add(RefreshProductEvent(detail: widget.detail, filterString: _filterString));
                         });
                       },
                       loadMore: () {
                         Future.delayed(const Duration(seconds: 1), () {
                           widget.flowManagerBloc
                               .add(LoadMoreProductEvent(detail: widget.detail));
                         });
                       },
                     );
                   } else if (state is ProjectLoading) {
                     return Center(child: CircularProgressIndicator());
                   } else {
                     return Center(child: CircularProgressIndicator());
                   }
                 }),
               )
             ],
           ),
          );

        });
  }
}

class ProcedureComponent extends StatefulWidget {
  final List<Node> nodeList;
  ProcedureComponent({@required this.nodeList});
  @override
  State<StatefulWidget> createState() => ProcedureComponentState();
}

class ProcedureComponentState extends State<ProcedureComponent>
    with AutomaticKeepAliveClientMixin {
  List<Node> nodeList;
  @override
  void initState() {
    //nodeList =_buildFlow();
    super.initState();
  }

  @override
  bool get wantKeepAlive => true;

  void onClickTimeLine(TimelineModel model) {
    print(model.title);
  }

  @override
  Widget build(BuildContext context) {
    return new TimelineComponent(
      timelineList: widget.nodeList.map<TimelineModel>((Node node) {
        return TimelineModel(title: node.name);
      }).toList(),
      callback: onClickTimeLine,
    );
  }
}
