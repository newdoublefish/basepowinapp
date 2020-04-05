import 'dart:async';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manufacture/bloc/flow_query_bloc.dart';
import 'package:manufacture/data/repository/flow_repository.dart';
import 'flow_process_page.dart';

class FlowDetail extends StatefulWidget{
  final String code;
  FlowDetail({Key key, @required this.code}):super(key:key);
  @override
  State<StatefulWidget> createState() => FlowDetailState();
}

class FlowDetailState extends State<FlowDetail>{
  FlowQueryBloc _flowQueryBloc;

  @override
  void initState() {
    _flowQueryBloc = FlowQueryBloc(flowRepository: new FlowRepository());
    _flowQueryBloc.add(FetchFlowQueryEventByFlowCode(flowInstanceText: widget.code));
    super.initState();
  }

  @override
  void dispose() {
    _flowQueryBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return BlocBuilder<FlowQueryBloc, FlowQueryState>(
      bloc: _flowQueryBloc,
      builder: (BuildContext context, FlowQueryState state) {
        if (state is FlowQueryLoadingState) {
          print("-------FlowQueryLoadingState");
          return Center(child: CircularProgressIndicator());
        }
        if (state is FlowQueryLoaded) {
          //return ProductDetailPage(nodeList: state.nodeList, flowInstance: state.flowInstance,);
        }

        return null;
      });
  }
}
