import 'package:flutter/material.dart';

/// Bar chart with series legend example
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manufacture/bloc/progress_bloc.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:manufacture/beans/progress.dart';
import 'package:manufacture/data/repository/progress_repository.dart';
import 'dart:math';
import 'package:manufacture/beans/project.dart';
import 'package:manufacture/ui/charts/pie_chart.dart';

class SimpleSeriesLegend extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  SimpleSeriesLegend(this.seriesList, {this.animate});

  factory SimpleSeriesLegend.withSampleData(
      List<ProgressDetail> finishedList, int total) {
    return new SimpleSeriesLegend(
      _createSampleData(finishedList, total),
      // Disable animations for image tests.
      animate: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new charts.BarChart(
      seriesList,
      animate: animate,
      vertical: false,
      barRendererDecorator: new charts.BarLabelDecorator<String>(),
      // Hide domain axis.
      domainAxis:
          new charts.OrdinalAxisSpec(renderSpec: new charts.NoneRenderSpec()),
    );
  }

  /// Create series list with multiple series
  static List<charts.Series<ProgressDetail, String>> _createSampleData(
      List<ProgressDetail> finishedList, int total) {
    return [
      new charts.Series<ProgressDetail, String>(
        id: '已完成',
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        domainFn: (ProgressDetail sales, _) => sales.name,
        measureFn: (ProgressDetail sales, _) => sales.count,
        data: finishedList,
        labelAccessorFn: (ProgressDetail sales, _) =>
            "${sales.name} ${sales.count}/$total",
      ),
    ];
  }
}



class ProgressStatus extends StatefulWidget {
  final Detail detail;
  ProgressStatus({Key key, @required this.detail}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _ProgressStatusState();
}

class _ProgressStatusState extends State<ProgressStatus> {
  ProgressBloc _bloc;

  @override
  void initState() {
    // TODO: implement initState
    _bloc = ProgressBloc(progressRepository: new ProgressRepository());
    _bloc.add(FetchProgressEvent(detailId: widget.detail.id));
    super.initState();
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return BlocBuilder<ProgressBloc, ProgressState>(
      bloc: _bloc,
      builder: (BuildContext context, ProgressState state) {
        return Scaffold(
            appBar: AppBar(
              title: Text("进度详情"),
            ),
            body: Builder(builder: (BuildContext context) {
              if (state is LoadingState) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is ProgressLoadedState) {
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
                          Container(
                            margin: const EdgeInsets.only(top: 10),
                            padding: const EdgeInsets.only(top: 10),
                            color:Colors.white,
                            child: Column(
                              children: <Widget>[
                                Container(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.info,
                                          color: Colors.green,
                                        ),
                                        Container(
                                          margin: const EdgeInsets.only(left: 10),
                                          child: Text('基本信息'),
                                        )
                                      ],
                                    )),
                                Container(
                                  margin: const EdgeInsets.only(left: 10),
                                  child: Column(
                                    children: <Widget>[
                                      ListTile(
                                          dense: true,
                                          leading: Text(
                                            '项目',
                                            style: TextStyle(fontSize: 14),
                                          ),
                                          title: Text(
                                            "${widget.detail.project_name}",
                                            style: TextStyle(fontSize: 14),
                                          ),
                                          contentPadding:
                                          EdgeInsets.symmetric(horizontal: 5.0)),
                                      ListTile(
                                          dense: true,
                                          leading: Text(
                                            '厂家',
                                            style: TextStyle(fontSize: 14),
                                          ),
                                          title: Text(
                                            "${widget.detail.odm_name}",
                                            style: TextStyle(fontSize: 14),
                                          ),
                                          contentPadding:
                                          EdgeInsets.symmetric(horizontal: 5.0)),
                                      ListTile(
                                          dense: true,
                                          leading: Text(
                                            '计划数量',
                                            style: TextStyle(fontSize: 14),
                                          ),
                                          title: Text(
                                            '${widget.detail.count}',
                                            style: TextStyle(fontSize: 14),
                                          ),
                                          contentPadding:
                                          EdgeInsets.symmetric(horizontal: 5.0)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 10),
                            padding: const EdgeInsets.only(top: 10),
                            color: Colors.white,
                            child: Column(
                              children: <Widget>[
                                Container(
                                    margin: const EdgeInsets.only(left: 10),
                                    child: Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.local_shipping,
                                          color: Colors.green,
                                        ),
                                        Container(
                                          margin: const EdgeInsets.only(left: 10),
                                          child: Text('发货情况'),
                                        )
                                      ],
                                    )),
                                Container(
                                  height: 300,
                                  child: Container(
                                    margin: EdgeInsets.all(10),
                                    child: PieCharts(
                                      pieNegative: PieNegative(
                                          name: "未发货",
                                          count: state.progress.total -
                                              state.progress.delivered,
                                          color: Colors.red),
                                      piePositive: PiePositive(
                                          name: "已发货",
                                          count: state.progress.delivered,
                                          color: Colors.green),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 10),
                            padding: const EdgeInsets.only(top: 10),
                            color: Colors.white,
                            child: Column(
                              children: <Widget>[
                                Container(
                                    margin: const EdgeInsets.only(left: 10),
                                    child: Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.pie_chart,
                                          color: Colors.green,
                                        ),
                                        Container(
                                          margin: const EdgeInsets.only(left: 10),
                                          child: Text('流程完成情况'),
                                        )
                                      ],
                                    )),
                                Container(
                                  height: 300,
                                  child: Container(
                                    margin: EdgeInsets.all(10),
                                    child: PieCharts(
                                      pieNegative: PieNegative(
                                          name: "未完成",
                                          count: state.progress.total -
                                              state.progress.finished,
                                          color: Colors.red),
                                      piePositive: PiePositive(
                                          name: "已完成",
                                          count: state.progress.finished,
                                          color: Colors.green),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 10),
                            padding: const EdgeInsets.only(top: 10),
                            color: Colors.white,
                            child: Column(
                              children: <Widget>[
                                Container(
                                    margin: const EdgeInsets.only(left: 10),
                                    child: Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.calendar_view_day,
                                          color: Colors.green,
                                        ),
                                        Container(
                                          margin: const EdgeInsets.only(left: 10),
                                          child: Text('流程工序详情'),
                                        )
                                      ],
                                    )),
                                Container(
                                  height:
                                  (state.progress.detail.length) * 100.toDouble(),
                                  child: Container(
                                    margin:
                                    const EdgeInsets.only(left: 10, right: 10),
                                    child: SimpleSeriesLegend.withSampleData(
                                        state.progress.detail, state.progress.total),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 30,)
                        ],
                      ),
                    ),
                  ],
                );
              }
              return CircularProgressIndicator();
            }));
      },
    );
  }
}
