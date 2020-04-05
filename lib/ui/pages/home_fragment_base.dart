import 'package:flutter/material.dart';

class BasePage{
  BasePage({
    Widget icon,
    Widget activeIcon,
    String title,
    Color color,
    TickerProvider vsync,
    Widget naviPage,
  }) : _icon = icon,
        _color = color,
        _title = title,
        _naviPage = naviPage,
        item = BottomNavigationBarItem(
          icon: icon,
          activeIcon: activeIcon,
          title: Text(title),
          backgroundColor: color,
        ),
        controller = AnimationController(
          duration: kThemeAnimationDuration,
          vsync: vsync,
        ) {
    _animation = controller.drive(CurveTween(
      curve: const Interval(0.5, 1.0, curve: Curves.fastOutSlowIn),
    ));
  }

  final Widget _icon;
  final Color _color;
  final String _title;
  final BottomNavigationBarItem item;
  final AnimationController controller;
  final Widget _naviPage;
  Animation<double> _animation;

  Widget transition(BottomNavigationBarType type, BuildContext context) {
    Color iconColor;
    Widget showWidget;
    if (type == BottomNavigationBarType.shifting) {
      iconColor = _color;
    } else {
      final ThemeData themeData = Theme.of(context);
      iconColor = themeData.brightness == Brightness.light
          ? themeData.primaryColor
          : themeData.accentColor;
    }

    if(_naviPage!=null)
    {
      showWidget = _naviPage;
    }else{
      showWidget = Container(
        alignment: Alignment.center,
        child: Text(_title),
      );
    }
  return showWidget;
  }
}
