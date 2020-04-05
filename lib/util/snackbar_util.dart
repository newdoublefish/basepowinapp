import 'package:flutter/material.dart';
class SnackBarUtil{

  static show({@required BuildContext context,@required String message,@required bool isSuccess}){
    if(isSuccess){
      success(context: context,message: message);
    }else{
      fail(context: context,message: message);
    }
  }


  static success({@required BuildContext context,@required String message, Color backgroundColor=Colors.green}){
    return Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
      ),
    );
  }

  static fail({BuildContext context,String message, Color backgroundColor=Colors.red}){
    return Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
      ),
    );
  }

  static info({BuildContext context,String message}){
    return Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

}