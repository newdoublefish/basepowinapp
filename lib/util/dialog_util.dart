import 'package:flutter/material.dart';


class DialogUtil{
  static void show(BuildContext context, {Widget title, Widget content, VoidCallback onPositive,VoidCallback onNegative}){
    showDialog(
        builder: (context) => new AlertDialog(
          title: title!=null?title:Text("提示"),
          content: content!=null?content:Container(),
          actions: <Widget>[
            new FlatButton(
                onPressed: (){
                  Navigator.pop(context);
                  if(onPositive!=null){
                    onPositive();
                  }

                },
                child: new Text('确定')),
            new FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                  if(onNegative!=null){
                    onNegative();
                  }

                },
                child: new Text('取消'))
          ],
        ),
        context: context);
  }

  static void alert(BuildContext context, {Widget title, Widget content, VoidCallback onPress}){
    showDialog(
        builder: (context) => new AlertDialog(
          title: title!=null?title:Text("提示"),
          content: content!=null?content:Container(),
          actions: <Widget>[
            new FlatButton(
                onPressed: (){
                  Navigator.pop(context);
                  if(onPress!=null){
                    onPress();
                  }

                },
                child: new Text('确定')),
          ],
        ),
        context: context);
  }
}