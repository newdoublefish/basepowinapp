import 'dart:async';
import 'package:flutter/material.dart';
import 'package:manufacture/ui/pages/login_page.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:manufacture/data/repository.dart';
import 'package:manufacture/beans/global_info.dart';
import 'package:manufacture/ui/pages/home_page.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

class Splash extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => SplashState();
}

class SplashState extends State<Splash>{
  @override
  void initState()
  {
    super.initState();
  }

  @override
  void dispose()
  {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Container(
        color: Theme.of(context).accentColor,
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                alignment: Alignment.center,
                //color: Colors.grey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Image.asset('images/logo.jpg',fit: BoxFit.fill,),
                    SizedBox(
                      height: 10,
                    ),
                    Text(FlutterI18n.translate(context,"app_name"),style: TextStyle(color: Colors.white),),
                  ],
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: Text(FlutterI18n.translate(context,"copyright"),style: TextStyle(color: Colors.white),),
            )
          ],
        ),
      ),
    );
  }

}