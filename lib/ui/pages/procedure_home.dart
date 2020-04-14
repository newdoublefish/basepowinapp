import 'package:flutter/material.dart';

class ProcedureHomePage extends StatefulWidget {
  @override
  _ProcedureHomePageState createState() => _ProcedureHomePageState();
}

class _ProcedureHomePageState extends State<ProcedureHomePage> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    Center(child: Icon(Icons.access_alarm),),
    Center(child: Icon(Icons.access_alarm),),
    Center(child: Icon(Icons.access_alarm),),
  ];

  final List<BottomNavigationBarItem> _list = <BottomNavigationBarItem>[
    BottomNavigationBarItem(
      icon: Icon(Icons.home),
      title: Text('任务'),
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.book),
      title: Text('接收单'),
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.music_video),
      title: Text('发送单'),
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold( //构建底部导航，并添加点击事件
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: onTabTapped,
        currentIndex: _currentIndex,//点击索引
        items: _list,
      ),
      body: _children[_currentIndex],
    );
  }

  void onTabTapped(int index) {
    //通过setState告诉Scaffold，你点击了哪一个，它在显示哪一个了
    setState(() {
      _currentIndex = index;
    });
  }
}
