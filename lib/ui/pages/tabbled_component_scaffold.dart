import 'package:flutter/material.dart';

class ComponentTabData {
  final String tabName;
  final Widget widget;
  ComponentTabData({this.tabName, this.widget});
}

class TabbedComponentScaffold extends StatelessWidget {
  final List<ComponentTabData> components;
  final String title;
  final List<Widget> actions;

  const TabbedComponentScaffold({this.components, this.title, this.actions});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return DefaultTabController(
      length: components.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
          actions: actions != null ? actions : null,
          bottom: TabBar(
               onTap: (value){
                 print(value);
               },
              isScrollable: false,
              tabs: components
                  .map<Widget>((ComponentTabData data) => Tab(
                        text: data.tabName,
                      ))
                  .toList()),
        ),
        body: TabBarView(
            physics: new NeverScrollableScrollPhysics(),
            children: components.map<Widget>((ComponentTabData data) {
              return SafeArea(
                top: false,
                bottom: false,
                child: data.widget == null
                    ? Center(
                        child: Text(data.tabName),
                      )
                    : data.widget,
              );
            }).toList()),
      ),
    );
  }
}
