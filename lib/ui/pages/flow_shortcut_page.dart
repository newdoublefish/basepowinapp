import 'package:flutter/material.dart';
import 'scan_page.dart';
import 'flow_process_page.dart';
import 'package:manufacture/data/repository/user_repository.dart';

class FlowShortcut extends StatelessWidget {
  bool byProduct = false;
  bool byFlow = true;
  UserRepository userRepository;

  FlowSearchTypeEnum flowSearchType = FlowSearchTypeEnum.flow;
  //String source = "http://www.gdmcmc.cn/qrcode.html?qrcode=880051010061";
  RegExp exp =
      new RegExp(r"(http)(://www.gdmcmc.cn/qrcode.html)?([^# ]*)(\d{12})");

  FlowShortcut({@required this.userRepository});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    print('build');
    return Scaffold(
      appBar: AppBar(
        title: Text('流水查询'),
        actions: <Widget>[
          PopupMenuButton(
            itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
                  PopupMenuItem<String>(
                    child: Row(
                      children: <Widget>[
                        Text('通过流水号查询'),
                        Checkbox(
                          value: byFlow,
                          onChanged: (value) {},
                        ),
                      ],
                    ),
                    value: "flow",
                  ),
                  PopupMenuItem<String>(
                    child: Row(
                      children: <Widget>[
                        Text('通过产品号查询'),
                        Checkbox(
                          value: byProduct,
                          onChanged: (value) {},
                        ),
                      ],
                    ),
                    value: "product",
                  ),
                ],
            onSelected: (String action) {
              switch (action) {
                case "flow":
                  byFlow = true;
                  byProduct = false;
                  flowSearchType = FlowSearchTypeEnum.flow;
                  break;
                case "product":
                  byProduct = true;
                  byFlow = false;
                  flowSearchType = FlowSearchTypeEnum.product;
                  break;
              }
            },
            onCanceled: () {
              print("onCanceled");
            },
          )
        ],
      ),
      body: Scan(
        callback: (context, code) {
          if (flowSearchType == FlowSearchTypeEnum.product) {
            if (exp.hasMatch(code)) {
              //print(code.split("=")[1].substring(5, 11));
              code = code.split("=")[1].substring(5, 11);
            }else{

            }
          }
          Navigator.push(context,
              new MaterialPageRoute(builder: (BuildContext context) {
            return new FlowProcessPage(
              code: code,
              type: flowSearchType,
              userRepository: userRepository,
            );
          }));
        },
      ),
    );
  }
}
