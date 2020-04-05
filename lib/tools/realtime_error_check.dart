import 'dart:async';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'realtime_error_detail.dart';

class RealtimeErrorCheck extends StatefulWidget {
  @override
  _RealtimeErrorCheckState createState() => new _RealtimeErrorCheckState();
}

class _RealtimeErrorCheckState extends State<RealtimeErrorCheck> {
  String barcode = "";
  final _formKey = GlobalKey<FormState>();
  final _codeInputController = TextEditingController();

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
          appBar: new AppBar(
            title: new Text('实时故障信息'),
          ),
          body: new SingleChildScrollView(
          child:new Container(
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Container(
//                  child: new MaterialButton(
//                      onPressed: scan, child: new Text("Scan")),

                  padding: const EdgeInsets.only(top: 100,
                      left: 100.0, right: 100.0, bottom: 50),
                  child: GestureDetector(
                    child: Image.asset(
                      "images/scan.jpg",
                      fit: BoxFit.cover,
                    ),
                    onTap: () {
                      scan();
                    },
                  ),
                ),
                new Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                          child: Container(
                        padding: const EdgeInsets.only(left: 50, right: 50),
                        child: TextFormField(
                          controller: _codeInputController,
                          validator: (value) {
                            if (value.isEmpty) {
                              return "编号不能为空";
                            }else{
                              RegExp reg = new RegExp(r"^\d{11}$");
                              if(!reg.hasMatch(value))
                                {
                                    return "必须为数字，或者长度有误！";
                                }
                            }
                          },
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.dashboard),
                            hintText: "请输入装置编号",
                            //border: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(20.0)),)
                          ),
                        ),
                      )),
                      MaterialButton(
                          //color: Colors.blue,
                          child: Text("确定"),
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              print(
                                  "--processing-------${_codeInputController.text}--------${_codeInputController.text}");
                              Navigator.push(context, new MaterialPageRoute(
                                  builder: (BuildContext context) {
                                    return new RealTimeErrorDetail(deviceSn: _codeInputController.text);
                                  }));
                            }
                          }),
                    ],
                  ),
                ),
                //new Text(barcode),
              ],
            ),
          )),
    );
  }

  String _parseDeviceSn(String barcode)
  {
    RegExp reg = new RegExp(r"http://www.gdmcmc.cn/qrcode.html\?qrcode=");
    if(reg.hasMatch(barcode))
    {
      List<String> list = barcode.split("=");
      if(list.length == 2)
      {
          return list[1].substring(0,list[1].length-1);
      }
    }
    return null;
  }

  Future scan() async {
    try {
      String barcode = await BarcodeScanner.scan();
      String deviceSn = _parseDeviceSn(barcode);
      if(deviceSn!=null)
      {
        Navigator.push(context, new MaterialPageRoute(
            builder: (BuildContext context) {
              return new RealTimeErrorDetail(deviceSn: deviceSn);
            }));
      }else{
        showDialog(
            builder: (context) => new AlertDialog(
              title: new Text('提示'),
              content: new Text('二维码格式有误'),
              actions: <Widget>[
                new FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: new Text('确定'))
              ],
            ),
            context: context);
      }
      //setState(() => this.barcode = barcode);
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          this.barcode = 'The user did not grant the camera permission!';
        });
      } else {
        setState(() => this.barcode = 'Unknown error: $e');
      }
    } on FormatException {
      setState(() => this.barcode =
          'null (User returned using the "back"-button before scanning anything. Result)');
    } catch (e) {
      setState(() => this.barcode = 'Unknown error: $e');
    }
  }
}
