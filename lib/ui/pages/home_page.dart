import 'package:flutter/material.dart';
import 'package:manufacture/ui/pages/task_manage_page.dart';
import 'home_fragment_base.dart';
import 'mine_fragment.dart';
import 'first_fragment.dart';
import 'knowledge_page.dart';
import 'package:flutter/services.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:manufacture/data/repository/user_repository.dart';
import 'package:manufacture/data/repository/version_repository.dart';
import 'work_fragment.dart';

class HomePageState extends State<HomePage> with TickerProviderStateMixin {
  List<BasePage> _baseList;
  int _currentIndex = 0;
  BottomNavigationBarType _type = BottomNavigationBarType.fixed;
  PageController _controller;

  void _pageChange(int index) {
    setState(() {
      if (index != _currentIndex) {
        _currentIndex = index;
      }
    });
  }


  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    for (BasePage view in _baseList) view.controller.dispose();
    _controller.dispose();
    super.dispose();
  }

  _showDialog() {
    showDialog<Null>(
      context: context,
      builder: (context) =>
          new AlertDialog(content: new Text('退出app'), actions: <Widget>[
            new FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  } else {
                    //SystemNavigator.pop();
                    SystemNavigator.pop();
                  }
                },
                child: new Text('确定'))
          ]),
    );
  }

  Future<bool> _requestPop() {
    _showDialog();
    return new Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    _baseList = <BasePage>[
      BasePage(
        icon: const Icon(Icons.home),
        title: FlutterI18n.translate(context, "first_page"),
        color: Colors.deepPurple,
        vsync: this,
        naviPage: HomeMain(userRepository: widget.userRepository,),
      ),
      BasePage(
        icon: const Icon(Icons.dashboard),
        title: FlutterI18n.translate(context, "work"),
        color: Colors.deepPurple,
        vsync: this,
        naviPage: Center(child: Text("hello world"),),
      ),
      BasePage(
        icon: const Icon(Icons.account_circle),
        title: FlutterI18n.translate(context, "me"),
        color: Colors.deepPurple,
        vsync: this,
        naviPage: MinePage(userRepository:widget.userRepository, versionRepository: widget.versionRepository,),
      ),
    ];
    // TODO: implement build
    return new WillPopScope(
        onWillPop: _requestPop,
        child: Scaffold(
          //appBar: AppBar(automaticallyImplyLeading: false,title: Text("home"),),
          //body: _buildTransitionsStack(),
          body: PageView.builder(
              physics: NeverScrollableScrollPhysics(),
              onPageChanged: _pageChange,
              controller: _controller,
              //itemCount: _baseList.length,
              itemBuilder: (context, index) =>
                  _baseList[index].transition(_type, context)),
          bottomNavigationBar: BottomNavigationBar(
              items: _baseList
                  .map<BottomNavigationBarItem>((BasePage base) => base.item)
                  .toList(),
              currentIndex: _currentIndex,
              type: _type,
              onTap: (int index) {
                _controller.jumpToPage(index);
//            setState((){
//              //_baseList[_currentIndex].controller.reverse();
//              _currentIndex = index;
//              //_baseList[_currentIndex].controller.forward();
//            });
              }),
        ));
  }
}

class HomePage extends StatefulWidget {
  final UserRepository userRepository;
  final VersionRepository versionRepository;

  HomePage({Key key,@required this.userRepository, @required this.versionRepository}):super(key:key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new HomePageState();
  }
}
