import 'package:flutter/material.dart';
import 'package:manufacture/beans/base_bean.dart';
import 'package:manufacture/beans/project.dart';
import 'package:manufacture/core/object_select_widget.dart';
import 'package:manufacture/data/repository/detail_repository.dart';
import 'package:manufacture/data/repository/project_respository.dart';
import 'package:manufacture/main.dart';
import 'package:progress_dialog/progress_dialog.dart';

import '../../core/object_select_dialog.dart';
import '../../core/object_selector.dart';

class TempPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => TempTest();
}

class TempPageState extends State<TempPage> {
  DetailObjectRepository _detailObjectRepository =
      DetailObjectRepository.init();
  ProjectObjectRepository _projectObjectRepository = ProjectObjectRepository.init();
  ObjectSelectController<Detail> _objectSelectController =
      new ObjectSelectController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("temp"),
      ),
      body: Column(
        children: <Widget>[
          ObjectSelector<Detail>(
            objectRepository: _detailObjectRepository,
            title: "任务选择",
            buildValueText: (BaseBean detail) {
              return (detail as Detail).name;
            },
            //object: Detail()..id = 1,
            controller: _objectSelectController,
            objectSelectDialog: ObjectSelectDialog(tobeSelectList: [
              ObjectTobeSelect<Project>(
                  title: "项目",
                  buildQueryParam: (BaseBean t) {
                    return null;
                  },
                  objectRepository: _projectObjectRepository,
                  buildObjectItem: (BaseBean t) {
                    return Text(((t as Project).code));
                  }),
              ObjectTobeSelect<Detail>(
                  title: "任务",
                  buildQueryParam: (BaseBean t) {
                    return {"project":t.id};
                  },
                  objectRepository: _detailObjectRepository,
                  buildObjectItem: (BaseBean t) {
                    return Text(((t as Detail).name));
                  }),
            ]),
          )
        ],
      ),
    );
  }
}


class TempTest extends State<TempPage> {
  double percentage = 0.0;
  ProgressDialog pr;


  @override
  void initState() {

    pr = new ProgressDialog(context, type: ProgressDialogType.Download);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    pr.style(
      message: 'Downloading file...',
      borderRadius: 10.0,
      backgroundColor: Colors.white,
      progressWidget: CircularProgressIndicator(),
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
      progress: 0.0,
      maxProgress: 100.0,
      progressTextStyle: TextStyle(
          color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
      messageTextStyle: TextStyle(
          color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600),
    );

   //pr.show();

    return Scaffold(
      body: Center(
        child: RaisedButton(
            child: Text(
              'Show Dialog',
              style: TextStyle(color: Colors.white),
            ),
            color: Colors.blue,
            onPressed: () {
              pr.show();

              Future.delayed(Duration(seconds: 2)).then((onvalue) {
                percentage = percentage + 30.0;
                print(percentage);

                pr.update(
                  progress: percentage,
                  message: "Please wait...",
                  progressWidget: Container(
                      padding: EdgeInsets.all(8.0), child: CircularProgressIndicator()),
                  maxProgress: 100.0,
                  progressTextStyle: TextStyle(
                      color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
                  messageTextStyle: TextStyle(
                      color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600),
                );

                Future.delayed(Duration(seconds: 2)).then((value) {
                  percentage = percentage + 30.0;
                  pr.update(
                      progress: percentage, message: "Few more seconds...");
                  print(percentage);
                  Future.delayed(Duration(seconds: 2)).then((value) {
                    percentage = percentage + 30.0;
                    pr.update(progress: percentage, message: "Almost done...");
                    print(percentage);

                    Future.delayed(Duration(seconds: 2)).then((value) {
                      pr.hide();
                      percentage = 0.0;
                    });
                  });
                });
              });

            }),
      ),
    );
  }
}