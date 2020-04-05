import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:manufacture/bloc/object_select_bloc.dart';
import 'package:manufacture/beans/base_bean.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manufacture/data/repository/object_repository.dart';
import 'package:manufacture/beans/project.dart';

typedef OnObjectShow<T> = String Function(T value);
typedef OnSelectCallBack<T>=void Function(T value);

class ObjectSelectController<T>{
  T selectObject;
}

class ObjectSelect<T extends BaseBean> extends StatefulWidget{
  final ObjectRepository<T> objectRepository;
  final OnObjectShow<T> onItemShowName;
  final ObjectSelectController<T> controller;
  final OnSelectCallBack<T> onSelectCallBack;
  final Map<String, dynamic> initQueryParams;

  ObjectSelect({Key key, @required this.objectRepository, this.initQueryParams, this.onItemShowName, @required this.controller,this.onSelectCallBack}):super(key:key);

  @override
  State<StatefulWidget> createState() => ObjectSelectPageState<T>();
}

class ObjectSelectPageState<T extends BaseBean> extends State<ObjectSelect>{
  ObjectSelectBloc<T> _objectSelectBloc;

  @override
  void initState() {
    _objectSelectBloc = ObjectSelectBloc<T>(objectRepository: widget.objectRepository);
    _objectSelectBloc.add(LoadEvent(queryParams:widget.initQueryParams));
    if(widget.controller!=null)
      if(widget.controller.selectObject!=null)
        _objectSelectBloc.add(DoSelectEvent(obj: widget.controller.selectObject));
    super.initState();
  }

  @override
  void dispose() {
    _objectSelectBloc.close();
    super.dispose();
  }

  void reload(Map<String, dynamic> initQueryParams){
    print(initQueryParams);
    _objectSelectBloc.add(ReLoadEvent(queryParams:initQueryParams));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      child: BlocBuilder<ObjectSelectBloc<T>,
          ObjectSelectState>(
        bloc: _objectSelectBloc,
        builder: (context, state) {
          if (state is LoadState) {
            widget.controller.selectObject = state.current;
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DropdownButton<T>(
                value: state.current,
                onChanged: (T newValue) {
                  if(widget.controller!=null){
                    widget.controller.selectObject = newValue;
                  }
                  if(widget.onSelectCallBack!=null){
                    widget.onSelectCallBack(newValue);
                  }
                  _objectSelectBloc.add(
                      DoSelectEvent(
                          obj: newValue));
                },
                items: state.objects
                    .map<DropdownMenuItem<T>>(
                        (value) {
                      //print(TypeMatcher<Project>().check(value));
                      return DropdownMenuItem<T>(
                        value: value,
//                      child: SingleChildScrollView(
//                        scrollDirection: Axis.horizontal,
//                        child: widget.onItemShowName!=null?Text(widget.onItemShowName(value)):Text("${value.id}"),
//                        //child:Text("11111111111111111111111111111111111111111111111111111111111111111111")
//                      ),
                        child: widget.onItemShowName!=null?Text(widget.onItemShowName(value),):Text("${value.id}"),
                      );
                    }).toList(),
              ),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}