import 'package:permission_handler/permission_handler.dart';
import 'dart:async';

class PermissionRequest{
  static Future<void> checkRequest() async{
    await checkRequestStorage();
    await checkRequestPhoto();
  }

  static Future<void> checkRequestStorage() async{
    PermissionStatus permission = await PermissionHandler().checkPermissionStatus(PermissionGroup.storage);
    print(permission);
    if(permission==PermissionStatus.denied){
      Map<PermissionGroup, PermissionStatus> permissions = await PermissionHandler().requestPermissions([PermissionGroup.storage]);
      print(permissions);
    }
  }

  static Future<void> checkRequestPhoto() async{
    PermissionStatus permission = await PermissionHandler().checkPermissionStatus(PermissionGroup.camera);
    print(permission);
    if(permission==PermissionStatus.denied){
      Map<PermissionGroup, PermissionStatus> permissions = await PermissionHandler().requestPermissions([PermissionGroup.camera]);
      print(permissions);
    }
  }
}