import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manufacture/beans/base_bean.dart';
import 'package:manufacture/data/repository/object_repository.dart';
import 'package:manufacture/bloc/object_add_edit_bloc.dart';
import 'package:manufacture/util/snackbar_util.dart';

typedef BuildBody = Widget Function(BuildContext context);
typedef BuildObject<T> = T Function();
enum ObjectOperateType{
  CREATE,
  MODIFY,
}

class ObjectCreateModifyPage<T extends BaseBean> extends StatefulWidget {
  final ObjectRepository<T> objectRepository;
  final BuildBody buildBody;
  final BuildObject<T> buildObject;
  final String title;
  final ObjectOperateType type;
  ObjectCreateModifyPage({
    Key key,
    this.objectRepository,
    this.title,
    this.buildBody,
    this.buildObject,
    this.type=ObjectOperateType.CREATE,
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() => _ObjectAddEditPageState<T>();
}

class _ObjectAddEditPageState<T extends BaseBean>
    extends State<ObjectCreateModifyPage> {
  ObjectAddEditBloc<T> _objectAddEditBloc;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _objectAddEditBloc = ObjectAddEditBloc<T>(
        objectRepository: widget.objectRepository);
    super.initState();
  }

  @override
  void dispose() {
    _objectAddEditBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: widget.type == ObjectOperateType.MODIFY
              ? Text("修改${widget.title}")
              : Text("增加${widget.title}"),
        ),
        body: Container(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: BlocListener<ObjectAddEditBloc, ObjectAddEditState>(
                bloc: _objectAddEditBloc,
                listener: (context, state) {
                  if (state is DoneState) {
                    if (state.isSuccess == true) {
                      Navigator.pop(context, true);
                    } else {
                      SnackBarUtil.fail(
                          context: context, message: state.message);
                    }
                  }
                },
                child: BlocBuilder<ObjectAddEditBloc, ObjectAddEditState>(
                  condition: (pre, current) {
                    return true;
                  },
                  bloc: _objectAddEditBloc,
                  builder: (context, state) {
                    return SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          widget.buildBody != null
                              ? widget
                                  .buildBody(context)
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
                                    if (widget.type == ObjectOperateType.MODIFY) {
                                      _objectAddEditBloc.add(
                                          ModifyEvent<T>(
                                              object: widget
                                                  .buildObject()));
                                    } else {
                                      _objectAddEditBloc.add(AddEvent<T>(
                                          object: widget
                                              .buildObject()));
                                    }
                                  }
                                }),
                          ),
                        ],
                      ),
                    );
                  },
                )),
          ),
        ));
  }
}
