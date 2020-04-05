import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manufacture/beans/user_bean.dart';
import 'package:manufacture/bloc/password_change_bloc.dart';
import 'package:manufacture/data/repository/user_repository.dart';
import 'package:manufacture/main.dart';
import 'package:manufacture/util/dialog_util.dart';
import 'package:manufacture/util/snackbar_util.dart';

class PasswordChangePage extends StatefulWidget {
  final UserBean userBean;
  final UserObjectRepository objectRepository;
  PasswordChangePage({Key key, this.userBean, this.objectRepository})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => _PasswordChangeState();
}

class _PasswordChangeState extends State<PasswordChangePage> {
  PasswordChangeBloc _bloc;
  final _formKey = GlobalKey<FormState>();
  TextEditingController _oldPasswordController = new TextEditingController();
  TextEditingController _newPasswordController = new TextEditingController();
  TextEditingController _newConfirmPasswordController = new TextEditingController();

  @override
  void initState() {
    _bloc = PasswordChangeBloc(userObjectRepository: widget.objectRepository);
    super.initState();
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("修改密码"),
      ),
      body: BlocListener<PasswordChangeBloc, PasswordChangeState>(
        bloc: _bloc,
        listener: (context, state) {
          if(state is CommitedState){
             if(state.isSuccess){
               DialogUtil.alert(context,content: Text("修改密码成功"),onPress: (){
                 Navigator.pop(context, true);
               });
             }else{
                SnackBarUtil.fail(context: context, message: "修改失败");
             }
          }
        },
        child: BlocBuilder<PasswordChangeBloc, PasswordChangeState>(
          bloc: _bloc,
          builder: (context, state) {
            return Container(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      SizedBox(height: 16,),
                      TextFormField(
                        controller:_oldPasswordController,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "内容不能为空";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: '旧密码',
                        ),
                      ),
                      SizedBox(height: 16,),
                      TextFormField(
                        controller:_newPasswordController,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "内容不能为空";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: '新密码',
                        ),
                      ),
                      SizedBox(height: 16,),
                      TextFormField(
                        controller:_newConfirmPasswordController,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "内容不能为空";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: '新密码确认',
                        ),
                      ),
                      SizedBox(height: 16,),
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
                                _bloc.add(CommitEvent(userBean: widget.userBean,oldPassword: _oldPasswordController.text.toString(),
                                newPassword: _newConfirmPasswordController.text.toString()));
                              }
                            }),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
