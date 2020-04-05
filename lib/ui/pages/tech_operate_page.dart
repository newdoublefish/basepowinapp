import 'package:flutter/material.dart';
import 'package:manufacture/beans/project.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manufacture/beans/technology.dart';
import 'package:manufacture/bloc/tech_operate_bloc.dart';
import 'package:manufacture/data/repository/tech_repository.dart';
import 'package:manufacture/ui/pages/scan_page.dart';
import 'package:manufacture/util/dialog_util.dart';
import 'package:manufacture/util/snackbar_util.dart';

class _TechWidget extends StatefulWidget {
  final TechnologyModal modal;
  _TechWidget({Key key, this.modal}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _TechWidgetState();
}

class _TechWidgetState extends State<_TechWidget> {
  Map<TechDetail, TextEditingController> controllerMap = {};
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  TextEditingController _getController(TechDetail detail) {
    if (controllerMap.containsKey(detail)) {
      return controllerMap[detail];
    } else {
      TextEditingController controller = new TextEditingController();
      controllerMap[detail] = controller;
      return controller;
    }
  }

  bool validate(){
    return _formKey.currentState.validate();
  }

  List<TechDetail> getResults(){
    List<TechDetail> results = [];
    for(TechDetailGroup group in widget.modal.detail){
      for(TechDetail detail in group.items){
        if (detail.type!=null && detail.type.compareTo("check") == 0) {
        } else {
          detail.value = _getController(detail).text;
        }
        results.add(detail);
      }
    }
    return results;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: widget.modal.detail.map((group) {
          return Container(
            color: Colors.white,
            margin: const EdgeInsets.only(top: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                ListTile(
                  dense: true,
                  title: Row(
                    children: <Widget>[
                      Icon(
                        Icons.group,
                        color: Colors.green,
                      ),
                      Text(
                        ' ${group.name}',
                        style: TextStyle(color: Colors.green),
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: group.items.map((item) {
                    if(item.type!=null && item.type.compareTo("check")==0){
                      return ListTile(
                        title: Text(item.name),
                        trailing: Checkbox(
                          value: item.value != null ? item.value : false,
                          onChanged: (v) {
                            item.value = v;
                            setState(() {});
                          },
                        ),
                      );
                    }else{
                      if(item.value!=null)
                        _getController(item).text = item.value;
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.all(10),
                              child: TextFormField(
                                controller: _getController(item),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return "内容不能为空";
                                  }

                                  if(item.reg!=null){
                                    RegExp exp =  new RegExp("${item.reg}");
                                    if(!exp.hasMatch(value)){
                                      return "请输入正确格式";
                                    }
                                  }

                                  return null;
                                },
                                decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.info),
                                    labelText: item.name,
                                    hintText: item.name,
                                    border: OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(20.0)),
                                    )),
                                autovalidate: false,
                              ),
                            ),
                          ),
                          Builder(
                            builder: (context) {
                              if (item.type != null) {
                                if (item.type.compareTo("select") == 0) {
                                  return DropdownButton<String>(
                                    value: item.choices[0],
                                    onChanged: (String newValue) {
                                      setState(() {
                                        _getController(item).text = newValue;
                                      });
                                    },
                                    items: item.choices
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                  );
                                }
                              }
                              return Container(
                                width: 50,
                                alignment: Alignment.center,
                                child: MaterialButton(
                                    child: Icon(
                                      Icons.dns,
                                      color: Theme.of(context).accentColor,
                                    ),
                                    onPressed: () {
                                      Navigator.push<String>(context,
                                          new MaterialPageRoute(
                                              builder: (BuildContext context) {
                                                return new Scan(title: item.name);
                                              })).then((String result) {
                                        setState(() {
                                          _getController(item).text = result;
                                          print(_formKey.currentState.validate());
                                        });
                                      });
                                    }),
                              );
                            },
                          ),
                        ],
                      );
                    }

                  }).toList(),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}



class TechOperate extends StatefulWidget{
  final String code;
  final int techModalId;
  TechOperate({Key key, this.code,this.techModalId}):super(key:key);
  @override
  State<StatefulWidget> createState() => _TechOperateState();
}

class _TechOperateState extends State<TechOperate>{
  TechOperateBloc _techOperateBloc;
  TechObjectRepository _techObjectRepository;
  GlobalKey<_TechWidgetState> _techWidgetKey =
  new GlobalKey<_TechWidgetState>();

  @override
  void initState() {
    _techObjectRepository = TechObjectRepository.init();
    _techOperateBloc = TechOperateBloc(techObjectRepository: _techObjectRepository);
    _techOperateBloc.add(LoadEvent(code: widget.code, modalId: widget.techModalId));
    super.initState();
  }

  @override
  void dispose() {
    _techOperateBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text(widget.code),),
      body: BlocListener<TechOperateBloc, TechOperateState>(
        bloc: _techOperateBloc,
        listener: (context,state){
          if(state is NodeSuchTechState){
            DialogUtil.alert(context, content: Text("${widget.code} 未注册二维码"),onPress: (){
              Navigator.pop(context);
            });
          }

          if(state is DoneState){
            if(state.isSuccess){
              DialogUtil.alert(context, content: Text("提交成功"),onPress: (){
                Navigator.pop(context);
              });
            }else{
              SnackBarUtil.fail(context: context,message: state.message);
            }
          }
        },
        child: BlocBuilder<TechOperateBloc, TechOperateState>(
          bloc: _techOperateBloc,
          condition: (previous, current){
            if(current is DoneState || current is NodeSuchTechState){
              return false;
            }


            return true;
          },
          builder: (context,state){
            if(state is LoadedState){
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
                        _TechWidget(key:_techWidgetKey,modal: state.technologyModal),
                        Container(
                          height: 20,
                          color: Colors.white,
                        ),
                        Container(
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                          child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                                  side: BorderSide(
                                      color: Colors.white,
                                      style: BorderStyle.solid,
                                      width: 2)),
                              color: Theme.of(context).accentColor,
                              child: Text("提交"),
                              onPressed: () {
                                if(_techWidgetKey.currentState.validate()){
                                  //print(_techWidgetKey.currentState.getResults());
                                  _techOperateBloc.add(CommitEvent(technologyModal:state.technologyModal, tech:state.tech,details: _techWidgetKey.currentState.getResults()),);
                                  Scaffold.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('提交中'),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                }
                              }),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }
            return Center(child: CircularProgressIndicator(),);
          },
        ),
      )
    );
  }
}