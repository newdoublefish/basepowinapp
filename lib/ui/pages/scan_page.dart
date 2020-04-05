import 'dart:async';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'flow_detail_page.dart';
import 'flow_process_page.dart';

typedef ScanCallback = void Function(BuildContext context, String result);
class Scan extends StatefulWidget {
  final String title;
  final Icon icon;
  final String img;
  final ScanCallback callback;
  Scan({Key key,this.title,this.icon, this.img, this.callback}):super(key:key);
  @override
  State<StatefulWidget> createState() => _ScanState();
}

class _ScanState extends State<Scan> {
  String barcode = "";
  final _formKey = GlobalKey<FormState>();
  final _codeInputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
//      appBar: new AppBar(
//        title: new Text(widget.title!=null?'扫码或者输入${widget.title}':"扫码或者输入编码"),
//      ),
      appBar: widget.title!=null?AppBar(title: Text(widget.title),):null,
      body:new SingleChildScrollView(
        child: new Container(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Container(
                padding: const EdgeInsets.only(
                    top: 100, left: 100.0, right: 100.0, bottom: 50),
                child: GestureDetector(
                  child: Image.asset(
                    widget.img!=null?widget.img:"images/scan.jpg",
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
                          padding: const EdgeInsets.only(
                              left: 50, right: 50),
                          child: TextFormField(
                            controller: _codeInputController,
                            validator: (value) {
                              if (value.isEmpty) {
                                return widget.title!=null?"${widget.title}编号不能为空":"编号不能为空";
                              }
                            },
                            decoration: InputDecoration(
                              prefixIcon: widget.icon!=null?widget.icon:Icon(Icons.dashboard),
                              hintText: widget.title!=null?"请输入${widget.title}":"请输入编号",
                            ),
                          ),
                        )),
                    MaterialButton(
                      //color: Colors.blue,
                        child: Text("确定"),
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            if(widget.callback!=null){
                                widget.callback(context, _codeInputController.text);
                            }else{
                              Navigator.pop(context,_codeInputController.text);
                            }
                          }
                        }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _parseDeviceSn(String barcode) {
    return barcode;
//    RegExp reg = new RegExp(r"http://www.gdmcmc.cn/qrcode.html\?qrcode=");
//    if(reg.hasMatch(barcode))
//    {
//      List<String> list = barcode.split("=");
//      if(list.length == 2)
//      {
//        return list[1].substring(0,list[1].length-1);
//      }
//    }
//    return null;
  }

  Future scan() async {
    try {
      String barcode = await BarcodeScanner.scan();
      String deviceSn = _parseDeviceSn(barcode);
      print(deviceSn);
      if (deviceSn != null) {
        if(widget.callback!=null){
          widget.callback(context, deviceSn);
        }else
          Navigator.pop(context,deviceSn);
//        Navigator.push(context, new MaterialPageRoute(
//            builder: (BuildContext context) {
//              return new RealTimeErrorDetail(deviceSn: deviceSn);
//            }));
      } else {
        showDialog(
            builder: (context) => new AlertDialog(
              title: new Text('提示'),
              content: new Text('二维码格式有误'),
              actions: <Widget>[
                new FlatButton(
                    onPressed: () {
                      Navigator.pop(context,barcode);
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
