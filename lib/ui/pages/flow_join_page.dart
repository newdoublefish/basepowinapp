import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:manufacture/beans/req_response.dart';
import 'package:manufacture/data/repository/flow_repository.dart';
import 'package:manufacture/beans/http_response.dart';
import 'package:manufacture/util/snackbar_util.dart';

class FlowJoin extends StatefulWidget{
  final String flowCode;
  final String nodeCode;
  final FlowInstanceObjectRepository flowRepository;
  FlowJoin({Key key,this.flowCode,this.nodeCode,this.flowRepository}):super(key:key);
  @override
  State<StatefulWidget> createState() => FlowJoinState();

}

class FlowJoinState extends State<FlowJoin>{
  String barcode = "";
  final _formKey = GlobalKey<FormState>();
  final _codeInputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('请扫描或输入节点测试编号'),
      ),
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
                          padding: const EdgeInsets.only(
                              left: 50, right: 50),
                          child: TextFormField(
                            controller: _codeInputController,
                            validator: (value) {
                              if (value.isEmpty) {
                                return "编号不能为空";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.code),
                              hintText: "请输入节点测试编号",
                            ),
                          ),
                        )),
                    MaterialButton(
                      //color: Colors.blue,
                        child: Text("确定"),
                        onPressed: () async{
                          if (_formKey.currentState.validate()) {
                            print(
                                "--processing-------${_codeInputController
                                    .text}--------${_codeInputController
                                    .text}");
//                            Navigator.push(context, new MaterialPageRoute(
//                                builder: (BuildContext context) {
//                                  return new ProductDetailPage(flowInstanceCode:_codeInputController.text);
//                                }));
                            ReqResponse response = await widget.flowRepository.join(flowCode: widget.flowCode,nodeCode: widget.nodeCode,workCode: _codeInputController.text);
                            print(response);
                            Navigator.pop(context, response);
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
      String workcode = _parseDeviceSn(barcode);
      if (workcode != null) {
        await widget.flowRepository.join(flowCode: widget.flowCode,nodeCode: widget.nodeCode,workCode: workcode);
        Navigator.pop(context);
      } else {
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