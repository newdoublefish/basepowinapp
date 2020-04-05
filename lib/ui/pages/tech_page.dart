import 'package:flutter/material.dart';
import 'package:manufacture/beans/project.dart';
import 'package:manufacture/beans/technology.dart';
import 'package:manufacture/bloc/tech_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manufacture/data/repository/tech_repository.dart';
import 'package:manufacture/util/snackbar_util.dart';
import 'scan_page.dart';

class Tech extends StatefulWidget {
  final FlowInstance flowInstance;
  final Node node;

  Tech({Key key, @required this.flowInstance, @required this.node})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _TechState();
}

class _CheckListTitleValue {
  bool value;
  String title;
  CheckboxListTile checkboxListTile;
  _CheckListTitleValue({this.value, this.title}) : assert(value != null);
  init() {
    checkboxListTile = new CheckboxListTile(
        value: this.value,
        title: Text(this.title),
        controlAffinity: ListTileControlAffinity.platform,
        secondary: Icon(Icons.info),
        onChanged: (flag) {
          value = flag;
        });
  }
}

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

  bool validate() {
    return _formKey.currentState.validate();
  }

  List<TechDetail> getResults() {
    List<TechDetail> results = [];
    for (TechDetailGroup group in widget.modal.detail) {
      for (TechDetail detail in group.items) {

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
                    if (item.type != null &&
                        item.type.compareTo("check") == 0) {
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
                    }
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

                                if (item.reg != null) {
                                  RegExp exp = new RegExp("${item.reg}");
                                  if (!exp.hasMatch(value)) {
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

class _TechState extends State<Tech> {
  TechBloc _techBloc;
  GlobalKey<_TechWidgetState> _techWidgetKey =
      new GlobalKey<_TechWidgetState>();

  @override
  void initState() {
    _techBloc = TechBloc(techRepository: TechRepository());
    _techBloc.add(GetTechModalEvent(modalId: widget.node.type_id));
    super.initState();
  }

  @override
  void dispose() {
    _techBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.node.name),
      ),
      body: BlocListener(
        bloc: _techBloc,
        listener: (context, state) {
          if (state is TechCommitSuccess) {
            Navigator.pop(context);
          } else if (state is TechCommitError) {
            SnackBarUtil.fail(context: context, message: "创建失败");
          }
        },
        child: BlocBuilder(
            bloc: _techBloc,
            condition: (previous, current) {
              if (current is TechCommitError || current is TechCommitSuccess) {
                return false;
              }
              return true;
            },
            builder: (context, state) {
              if (state is TechModalLoaded) {
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
                          _TechWidget(key: _techWidgetKey, modal: state.modal),
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
                                  if (_techWidgetKey.currentState.validate()) {
                                    //print(_techWidgetKey.currentState.getResults());
                                    _techBloc.add(CommitTechEvent(
                                        instance: widget.flowInstance,
                                        node: widget.node,
                                        details: _techWidgetKey.currentState
                                            .getResults(),
                                        modalId: widget.flowInstance.modal));
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
              } else if (state is TechLoading) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return Container();
              }
            }),
      ),
    );
  }
}
