import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter_i18n/flutter_i18n.dart';

class AboutPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  @override
  void initState() {
    _controller = AnimationController(duration: Duration(seconds: 20), vsync: this)..repeat();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      backgroundColor: Theme.of(context).accentColor,
      body: Column(
        children: <Widget>[
          Expanded(
            child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    AnimatedBuilder(
                      animation: _controller,
                      child: CircleAvatar(
                        radius: 100,
                        backgroundImage: AssetImage('images/logo.jpg'),
                      ),
                      builder: (context, Widget child){
                        //print(_controller.value);
                        return Transform.rotate(
                          angle: _controller.value * 2.0 * math.pi,
                          child: child,
                        );
                      },
                    ),
                    SizedBox(height: 20,),
                    Text(FlutterI18n.translate(context,"app_name"),style: TextStyle(color: Colors.white),),
                  ],
                )
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            child: Text(FlutterI18n.translate(context,"copyright"),style: TextStyle(color: Colors.white),),
          )
        ],
      )
    );
  }
}