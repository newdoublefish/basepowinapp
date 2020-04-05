import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manufacture/beans/base_bean.dart';
import 'package:manufacture/bloc/object_generate_bloc.dart';
import 'package:manufacture/data/repository/object_repository.dart';
import 'package:manufacture/util/dialog_util.dart';
import 'package:manufacture/util/snackbar_util.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:progress_dialog/progress_dialog.dart';

abstract class ObjectGenerateDelegate<T extends BaseBean> {
  String buildTitle();
  Widget build(BuildContext context);
  T buildObject(String code);
  bool onVerify(BuildContext context);
}

class ObjectGeneratePage<T extends BaseBean> extends StatefulWidget {
  final ObjectRepository<T> objectRepository;
  final ObjectGenerateDelegate<T> objectGenerateDelegate;
  ObjectGeneratePage(
      {Key key,
      @required this.objectRepository,
      @required this.objectGenerateDelegate})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => _ObjectGeneratePageState<T>();
}

class _ObjectGeneratePageState<T extends BaseBean>
    extends State<ObjectGeneratePage<T>> {
  ObjectGenerateBloc<T> _generateBloc;
  final _formKey = GlobalKey<FormState>();
  TextEditingController _prefixController = new TextEditingController();
  TextEditingController _suffixController = new TextEditingController();
  TextEditingController _startController = new TextEditingController();
  TextEditingController _endController = new TextEditingController();
  TextEditingController _countController = new TextEditingController();
  StringBuffer sb = new StringBuffer();

  @override
  void initState() {
    _generateBloc =
        ObjectGenerateBloc<T>(objectRepository: widget.objectRepository);
    super.initState();
  }

  @override
  void dispose() {
    _generateBloc.close();
    super.dispose();
  }

  void append(StringBuffer sb, int len, int num) {
    sb.clear();
    int zeroCnt = len - num.toString().length;
    for (int i = 0; i < zeroCnt; i++) {
      sb.write('0');
    }
    sb.write(num.toString());
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.objectGenerateDelegate.buildTitle()),
      ),
      body: BlocListener<ObjectGenerateBloc, GenerateState>(
        bloc: _generateBloc,
        listener: (context, state) {
          if (state is CommitState) {
            DialogUtil.show(context,
                title: Text("创建"),
                content: Container(
                  height: 100,
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("从 ${state.start}"),
                      Text("-"),
                      Text("到 ${state.end}"),
                      Text("数量:${state.total}")
                    ],
                  ),
                ), onPositive: () {

              if(!widget.objectGenerateDelegate.onVerify(context)){
                return;
              }
              List<T> _list = [];
              String _prefix = _prefixController.text.toString();
              String _suffix = _suffixController.text.toString();
              String _start = _startController.text.toString();
              int len = _start.length;
              int start = int.parse(_start);

              print(len);
              for (int i = 0; i < state.total; i++) {
                append(sb, len, start+i);
                String code =
                    "${_prefixController.text.toString()}${sb.toString()}${_suffixController.text.toString()}";
                print(code);
                _list.add(widget.objectGenerateDelegate.buildObject(code));
              }
              _generateBloc.add(ConfirmEvent(list: _list));
            });
          } else if (state is ParseErrorState) {
            SnackBarUtil.fail(context: context, message: state.message);
          } else if (state is CreatingState) {
//            if (pr.isShowing())
//              pr.update(progress: state.progress, message: "创建中...");
          } else if (state is CreatedState) {
//            if (pr.isShowing()) {
//              pr.update(progress: 100, message: "创建完成...");
//              pr.hide();
//            }
            DialogUtil.alert(context, content: Text("创建完成"), onPress: () {
              Navigator.pop(context, true);
            });
          } else if (state is CreateStartState) {
            //pr.show();
          }
        },
        child: BlocBuilder<ObjectGenerateBloc, GenerateState>(
          bloc: _generateBloc,
          builder: (context, state) {
            if(state is CreatingState){
              return Container(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("创建中..."),
                      CircularPercentIndicator(
                        radius: 150.0,
                        lineWidth: 8.0,
                        percent: state.progress/100,
                        center: new Text("${state.progress.toInt()}%"),
                        progressColor: Colors.green,
                      ),
                    ],
                  ),
                ),
              );
            }
            return SingleChildScrollView(
                child: Form(
              key: _formKey,
              child: Container(
                margin: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    TextFormField(
                      controller: _prefixController,
                      autofocus: false,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.code,
                          color: Theme.of(context).accentColor,
                        ),
                        labelText: '前缀',
                        //hintText: '编号',
                        //border: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(20.0)),)
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: TextFormField(
                            autofocus: false,
                            controller: _startController,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value.isEmpty) {
                                return "内容不能为空";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: '开始',
                              hintText: '开始',
                            ),
                          ),
                        ),
                        Container(
                            width: 10,
                            height: 1,
                            color: Colors.black,
                            margin: const EdgeInsets.only(left: 5, right: 5)),
                        Expanded(
                          flex: 1,
                          child: TextFormField(
                            autofocus: false,
                            controller: _endController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: '结束',
                              hintText: '结束',
                            ),
                          ),
                        )
                      ],
                    ),
                    TextFormField(
                      autofocus: false,
                      controller: _suffixController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.code,
                          color: Theme.of(context).accentColor,
                        ),
                        labelText: '后缀',
                        //hintText: '编号',
                        //border: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(20.0)),)
                      ),
                    ),
                    TextFormField(
                      autofocus: false,
                      controller: _countController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.format_list_numbered_rtl,
                          color: Theme.of(context).accentColor,
                        ),
                        labelText: '数量',
                      ),
                    ),
                    widget.objectGenerateDelegate != null
                        ? widget.objectGenerateDelegate.build!=null?widget.objectGenerateDelegate.build(context):Container()
                        : Container(),
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
                            if (_formKey.currentState.validate()) {
                              _generateBloc.add(
                                CommitEvent(
                                  start: _startController.text.toString(),
                                  end: _endController.text.toString(),
                                  prefix: _prefixController.text.toString(),
                                  suffix: _suffixController.text.toString(),
                                  count: _countController.text.toString(),
                                ),
                              );
                            }
                          }),
                    ),
                  ],
                ),
              ),
            ));
          },
        ),
      ),
    );
  }
}
