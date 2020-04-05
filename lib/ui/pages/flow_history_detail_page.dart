import 'package:flutter/material.dart';
import 'package:manufacture/beans/project.dart';
import 'package:manufacture/beans/test.dart';
import 'package:manufacture/bloc/flow_history_detail_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manufacture/data/repository/test_repository.dart';
import 'package:manufacture/data/repository/ship_repository.dart';
import 'package:manufacture/data/repository/tech_repository.dart';
import 'package:manufacture/data/repository/user_repository.dart';
import 'report_page.dart';

class FlowHistoryDetail extends StatefulWidget {
  final FlowHistory flowHistory;
  final UserRepository userRepository;
  FlowHistoryDetail({Key key, this.flowHistory, @required this.userRepository}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _FlowHistoryDetailState();
}

class _FlowHistoryDetailState extends State<FlowHistoryDetail> {
  HistoryBloc _historyBloc;

  @override
  void initState() {
    _historyBloc = new HistoryBloc(
        testRepository: TestRepository(),
        shipRepository: ShipRepository(),
        techRepository: TechRepository());
    _historyBloc.add(new FetchReportEvent(
        reportType: widget.flowHistory.work_type,
        id: widget.flowHistory.work_pk));
    super.initState();
  }

  @override
  void dispose() {
    _historyBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text("详情"),
        ),
        body: BlocBuilder<HistoryBloc, HistoryState>(
            bloc: _historyBloc,
            builder: (BuildContext context, HistoryState state) {
              if (state is InitState) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is TestReportLoaded) {
                return ReportPage(
                  test: state.test,
                  testItems: state.list,
                  userRepository: widget.userRepository,
                );
              } else if (state is ShipLoadedState) {
                return ListView(
                  children: state.shipOrder.info.map<ListTile>((i) {
                    return ListTile(
                      leading: Icon(
                        Icons.info,
                        color: Theme.of(context).accentColor,
                      ),
                      title: Text(i.name),
                      subtitle: Text(i.value),
                    );
                  }).toList(),
                );
              } else if (state is TechDetailLoaded) {
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
                                    leading: Text('测试类型:'),
                                    title: Text(state.tech.modalname),
                                  ),

                                  ListTile(
                                    dense: true,
                                    leading: Text('操作人员:'),
                                    title: Text(state.tech.username),
                                  ),
                                  ListTile(
                                    dense: true,
                                    leading: Text('操作时间:'),
                                    title: Text(state.tech.pub_date),
                                  ),
                                ],
                              ),
                            ),
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
                                            Icons.device_hub,
                                            color: Colors.green,
                                          ),
                                          Text(
                                            " 详情",
                                          )
                                        ],
                                      ),
                                    ),
                                    ListView(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      children: state.tech.detail.map<ListTile>((i) {
                                        return ListTile(
                                            dense: true,
                                            leading: Text(
                                              "${i.name}:",
                                            ),
                                            title: Builder(builder: (BuildContext context) {
                                              return Text(i.value!=null?i.value:"无");
                                            }));
                                      }).toList(),
                                    ),
                                  ],
                                ),
                            ),
                          ]),
                    ),

                  ],
                );
              }

              return Center(
                child: CircularProgressIndicator(),
              );
            }));
  }
}
