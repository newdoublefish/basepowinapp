import 'package:flutter/material.dart';
import 'package:manufacture/ui/pages/home_page.dart';
import 'package:dio/dio.dart';
import 'package:manufacture/data/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:manufacture/data/apis.dart';
import 'package:manufacture/data/repository.dart';
import 'package:manufacture/beans/global_info.dart';
import 'package:manufacture/util/preference_util.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manufacture/bloc/authentication_bloc.dart';
import 'package:manufacture/data/repository/user_repository.dart';
import 'package:manufacture/bloc/login_bloc.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

class LoginPageState extends State<LoginPage> {
  bool _selected = false;
  final _formKey = GlobalKey<FormState>();
  final _userNameController = TextEditingController();
  final _passWdController = TextEditingController();

  UserRepository get userRepository => widget.userRepository;
  AuthenticationBloc _authenticationBloc;
  LoginBloc _loginBloc;

  @override
  void initState() {
    _authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    _loginBloc = LoginBloc(authenticationBloc: _authenticationBloc,
        userRepository: userRepository);
    super.initState();
    // _loadCount();
  }

  _showDialog() {
    showDialog(
        builder: (context) =>
        new AlertDialog(
          //title: new Text('提示'),
          content: new Text("${FlutterI18n.translate(context, "login")} ${FlutterI18n.translate(context, "fail")}"),
          actions: <Widget>[
            new FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: new Text(FlutterI18n.translate(context, "sure")))
          ],
        ),
        context: context);
  }

  void _onWidgetDidBuild(Function callback) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callback();
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return BlocBuilder<LoginBloc, LoginState>(
        bloc: _loginBloc,
        builder: (BuildContext context,
            LoginState state,) {

          if(state is LoginFailure){
            _onWidgetDidBuild(_showDialog);
          }

          return Scaffold(
            //resizeToAvoidBottomPadding: false,
              body: Stack(
                children: <Widget>[
                  Container(
                    //color: Colors.grey[300],
                  ),
                  SafeArea(
                    child: Form(
                      key: _formKey,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Container(
                              height: 200,
                              //color: Colors.green,
                              alignment: Alignment.center,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  //Image.asset("images/mcmc.png", fit: BoxFit.none),
                                  Container(
                                    width: 100,
                                    height: 100,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          image: AssetImage("images/logo.jpg"),
                                          fit: BoxFit.cover),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(top: 20),
                                    child: Text(FlutterI18n.translate(context,"app_name")),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(10),
                              //margin: EdgeInsets.only(top: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                    child: TextFormField(
                                      controller: _userNameController,
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return "${FlutterI18n.translate(context, "username")} ${FlutterI18n.translate(context, "empty_error")}";
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(Icons.account_circle),
                                        hintText: FlutterI18n.translate(context, "username"),
                                        //border: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(20.0)),)
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                    child: TextFormField(
                                      obscureText: true,
                                      controller: _passWdController,
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return "${FlutterI18n.translate(context, "password")} ${FlutterI18n.translate(context, "empty_error")}";
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(Icons.vpn_key),
                                        hintText: FlutterI18n.translate(context, "password"),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                              child: RaisedButton(
                                  color: Theme.of(context).accentColor,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                      ),
                                  child: Text(FlutterI18n.translate(context, "login")),
                                  onPressed: () {
                                    if (_formKey.currentState.validate()) {
                                      _loginBloc.add(LoginButtonPressed(
                                          username: _userNameController.text,
                                          password: _passWdController.text,
                                          persist: _selected));
                                    }
                                  }),
                            ),
                            Container(
                              alignment: Alignment.center,
                              margin: const EdgeInsets.only(right: 30),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Text(FlutterI18n.translate(context, "remember")),
                                  Checkbox(
                                    value: _selected,
                                    onChanged: (bool flag) {
                                      setState(() {
                                        _selected = flag;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ));;
        });
  }
}

class LoginPage extends StatefulWidget {
  final UserRepository userRepository;
  LoginPage({Key key,@required this.userRepository}):super(key:key);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new LoginPageState();
  }
}
