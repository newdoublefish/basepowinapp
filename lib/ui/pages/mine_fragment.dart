import 'package:flutter/material.dart';
import 'package:manufacture/beans/global_info.dart';
import 'package:manufacture/beans/user_bean.dart';
import 'package:manufacture/ui/pages/about.dart';
import 'package:manufacture/ui/pages/login_page.dart';
import 'package:manufacture/ui/pages/localization_page.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:manufacture/bloc/authentication_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manufacture/data/repository/user_repository.dart';
import 'package:manufacture/data/repository/version_repository.dart';
import 'package:manufacture/ui/pages/password_change_page.dart';
import 'update_page.dart';

enum AppBarBehavior { normal, pinned, floating, snapping }

class _CategorySetting extends StatelessWidget {
  _CategorySetting({Key key, this.title, this.widget, this.icon, this.onTap})
      : super(key: key);
  final String title;
  final Widget widget;
  final Widget icon;
  final GestureTapCallback onTap;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      //color: Colors.white,
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.grey[300], width: 2))),
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          icon,
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 10),
              child: Text(title),
            ),
          ),
          GestureDetector(
              child: Icon(Icons.keyboard_arrow_right),
              onTap: () {
                if(onTap!=null){
                  onTap();
                }else if(widget != null) {
                  Navigator.push(context,
                      new MaterialPageRoute(builder: (BuildContext context) {
                    return widget;
                  }));
                }
              }),
        ],
      ),
    );
  }
}

class _CategoryItem extends StatelessWidget {
  _CategoryItem({Key key, this.title, this.value, this.icon}) : super(key: key);
  final String title;
  final String value;
  final Widget icon;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      //color: Colors.white,
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.grey[300], width: 2))),
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          icon,
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 10),
              child: Text(title),
            ),
          ),
          Text(value),
        ],
      ),
    );
  }
}

class _Category extends StatelessWidget {
  _Category({Key key, this.children}) : super(key: key);
  List<Widget> children;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if (children == null)
      children = [
        _CategoryItem(
          title: "公司",
          value: "广州万城万充",
          icon: Icon(Icons.grain, color: Colors.redAccent,),
        ),
        _CategoryItem(
          title: "部门",
          value: "运维中心",
          icon: Icon(Icons.grain, color: Colors.redAccent,),
        ),
        _CategoryItem(
          title: "职位",
          value: "运维工程师",
          icon: Icon(Icons.grain),
        ),
      ];
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Container(
            decoration: BoxDecoration(
                border: Border(
                    top: BorderSide(color: Colors.grey[300], width: 15))),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: children))
      ],
    );
  }
}

class MinePageState extends State<MinePage> with AutomaticKeepAliveClientMixin {
  static final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>();
  AppBarBehavior _appBarBehavior = AppBarBehavior.pinned;
  final double _appBarHeight = 256.0;
  AuthenticationBloc _authenticationBloc;

  @override
  void initState() {
    // TODO: implement initState
    _authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    super.initState();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    //Color _color = Theme.of(context).accentColor;
    return Theme(
      data: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.green,
        //primarySwatch: Theme.of(context).accentColor,
        platform: Theme.of(context).platform,
      ),
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.grey[300],
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              expandedHeight: _appBarHeight,
              pinned: _appBarBehavior == AppBarBehavior.pinned,
              floating: _appBarBehavior == AppBarBehavior.floating ||
                  _appBarBehavior == AppBarBehavior.snapping,
              snap: _appBarBehavior == AppBarBehavior.snapping,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(widget.userRepository.user.name),
                background: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
//                    Image.asset(
//                      'images/lake.jpg',
//                      fit: BoxFit.cover,
//                      height: _appBarHeight,
//                    ),
//                    CircleAvatar(
//                      backgroundImage: AssetImage('images/lake.jpg'),
//                    ),
                    Container(
                        alignment: Alignment.center,
                        color: Theme.of(context).accentColor,
                        child: Container(
                          //color: Colors.white,
                          height: 150,
                          width: 150,
                          child: CircleAvatar(
                            backgroundImage: AssetImage('images/logo.jpg'),
                          ),
                        )),
                    // This gradient ensures that the toolbar icons are distinct
                    // against the background image.
                    const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment(0.0, -1.0),
                          end: Alignment(0.0, -0.4),
                          colors: <Color>[Color(0x60000000), Color(0x00000000)],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(<Widget>[
                _Category(
                  children: <Widget>[
                    _CategoryItem(
                      title: FlutterI18n.translate(context, "position"),
                      value: widget.userRepository.user.role,
                      icon: Icon(Icons.work, color: Theme.of(context).accentColor,),
                    ),
                    _CategoryItem(
                      title: FlutterI18n.translate(context, "department"),
                      value: widget.userRepository.user.department,
                      icon: Icon(Icons.games, color: Theme.of(context).accentColor,),
                    ),
                    _CategoryItem(
                      title: FlutterI18n.translate(context, "tel"),
                      value: widget.userRepository.user.mobile,
                      icon: Icon(Icons.phone,color: Theme.of(context).accentColor,),
                    ),
                    //_CategoryItem(title: '创建时间',value: user.createAt, icon: Icon(Icons.timeline),),
                  ],
                ),
                _Category(
                  children: <Widget>[
                    _CategorySetting(
                      icon: Icon(Icons.settings, color: Theme.of(context).accentColor,),
                      title: FlutterI18n.translate(context, "lang"),
                      widget: LocalizationPage(),
                    ),
                    _CategorySetting(
                      icon: Icon(Icons.vpn_key,color: Theme.of(context).accentColor,),
                      title: "修改密码",
                      //widget: LocalizationPage(),
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context){
                          return PasswordChangePage(
                            userBean: UserBean()..id=widget.userRepository.user.id,
                            objectRepository: UserObjectRepository.init(),
                          );
                        })).then((flag){
                          if(flag!=null && flag == true){
                            _authenticationBloc
                                .add(LoggedOut());
                          }
                        });
                      },
                    ),
                    _CategorySetting(
                      icon: Icon(Icons.comment, color: Theme.of(context).accentColor,),
                      title: "关于",
                      widget: AboutPage(),
                    ),
                  ],
                ),
                _Category(
                  children: <Widget>[
                    _CategorySetting(
                      icon: Builder(builder: (context) {
                        if (widget.versionRepository.currentVersion.version
                                .compareTo(widget
                                    .versionRepository.latestVersion.version) !=
                            0) {
                          return Row(children: <Widget>[
                            Icon(Icons.view_array, color: Theme.of(context).accentColor,),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(20)),
                              ),
                              child: Text("NEW",style: TextStyle(color: Theme.of(context).accentColor),),
                              padding: const EdgeInsets.all(2),
                              //color: Colors.green,
                            )
                          ]);
                        }else{
                          return Icon(Icons.view_array, color: Theme.of(context).accentColor,);
                        }
                      }),
                      title: "${FlutterI18n.translate(context, "version")}(${widget.versionRepository.currentVersion.version})",
                      widget: Builder(builder: (context){
                        return UpdatePage(currentVersion: widget.versionRepository.currentVersion, latestVersion: widget.versionRepository.latestVersion, popPageIfDoNotUpdate: true,);
                      }),
                    ),
                  ],
                ),
                _Category(
                  children: <Widget>[
                    Container(
                      //color: Colors.white,
                      //alignment: Alignment.center,
                      child: RaisedButton(
                          color: Colors.white,
                          child: Text(
                            '退出',
                            style: TextStyle(color: Colors.red),
                          ),
                          onPressed: () {
                            showDialog(
                                builder: (context) => new AlertDialog(
                                      title: new Text('提示'),
                                      content: new Text('确定要退出'),
                                      actions: <Widget>[
                                        new FlatButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                              _authenticationBloc
                                                  .add(LoggedOut());
                                            },
                                            child: new Text('确定')),
                                        new FlatButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: new Text('取消'))
                                      ],
                                    ),
                                context: context);
                          }),
                    ),
                  ],
                ),
                SizedBox(
                  height: 200,
                )
              ]),
            )
          ],
        ),
      ),
    );
  }
}

class MinePage extends StatefulWidget {
  final UserRepository userRepository;
  final VersionRepository versionRepository;

  MinePage(
      {Key key,
      @required this.userRepository,
      @required this.versionRepository})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => MinePageState();
}
