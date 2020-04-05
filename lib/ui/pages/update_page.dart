import 'package:flutter/material.dart';
import 'package:manufacture/beans/version.dart';
import 'package:flutter/services.dart';
import 'package:manufacture/bloc/authentication_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manufacture/bloc/upload_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:install_plugin/install_plugin.dart';

class UpdatePage extends StatefulWidget {
  final Version currentVersion;
  final Version latestVersion;
  final bool popPageIfDoNotUpdate;
  UpdatePage(
      {Key key,
      @required this.currentVersion,
      @required this.latestVersion,
      this.popPageIfDoNotUpdate = false})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => UpdatePageState();
}

class UpdatePageState extends State<UpdatePage> {
  AuthenticationBloc _authenticationBloc;
  UpdateBloc _updateBloc;
  ProgressDialog pr;
  var taskId;

  @override
  void initState() {
    // TODO: implement initState
    _authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    _updateBloc = UpdateBloc();
    pr = new ProgressDialog(context, type:ProgressDialogType.Download);
    //pr.setMessage('下载文件...');
    super.initState();
  }

  @override
  void dispose(){
    _updateBloc.close();
    super.dispose();
  }

  Future<String> _findLocalPath(platform) async {
    final directory = platform == TargetPlatform.android
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
    return directory.path;
  }


  _downLoadFile({String downLoadUrl, platform}) async {
    //开始下载
//    _updateBloc.dispatch(StartUpdateEvent());
//    String path = await _findLocalPath(platform);
//    await Future.delayed(Duration(seconds: 2));
//    _updateBloc.dispatch(RefreshUpdateProgressEvent(progress: 20));
//    await Future.delayed(Duration(seconds: 2));
//    print(path);
//    _updateBloc.dispatch(UpdateFinishEvent());

    _updateBloc.add(StartUpdateEvent());
    String path = await _findLocalPath(platform);
    taskId = await FlutterDownloader.enqueue(
        url: downLoadUrl,
        savedDir: path,
        showNotification: true,
        openFileFromNotification: true);
    FlutterDownloader.registerCallback((id, status, progress) {
      // 下载中
      if (taskId == id) {
        print(progress);
        _updateBloc.add(
            RefreshUpdateProgressEvent(progress: progress.toDouble()));
      }

      if (taskId == id && status == DownloadTaskStatus.complete) {
        // 下载完成
        _updateBloc.add(UpdateFinishEvent());
        InstallPlugin.installApk('$path/manufacture${widget.latestVersion.version}.apk', 'pro.tcce.immsapp')
            .then((result) {
          print('install apk $result');
        }).catchError((error) {
          print('install apk error: $error');
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(body: Builder(builder: (context) {
      return BlocListener(
        bloc: _updateBloc,
        listener: (context, state) {
          print(state);
          if (state is UpdatingState) {
            if (pr.isShowing())
              pr.update(progress: state.progress, message: "下载中...");
            else
              FlutterDownloader.cancel(taskId: taskId);
          } else if (state is UpdatedState) {
            if (pr.isShowing()) {
              pr.update(progress: 100, message: "下载完成...");
              pr.hide();
            } else {
              FlutterDownloader.cancel(taskId: taskId);
            }
          } else if (state is UpdateStartState) {
            pr.show();
          }
        },
        child: BlocBuilder(
            bloc: _updateBloc,
            builder: (context, state) {
              if (state is InitState) {
                  if(widget.currentVersion != null){
                    if (widget.currentVersion.version
                        .compareTo(widget.latestVersion.version) !=
                        0) {
                      return Container(
                          color: Theme.of(context).accentColor,
                          alignment: Alignment.center,
                          child: Column(
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  alignment: Alignment.center,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        '有新的版本 v${widget.latestVersion.version} 更新啦！',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(top: 20),
                                        child: Text(
                                          '当前 v${widget.currentVersion.version}',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                  alignment: Alignment.bottomCenter,
                                  margin: const EdgeInsets.only(bottom: 20),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      RaisedButton(
                                        //color: Theme.of(context).accentColor,
                                          color: Colors.white,
                                          child: Text("确认"),
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20)),
                                              side: BorderSide(
                                                  color: Colors.white,
                                                  style: BorderStyle.solid,
                                                  width: 2)),
                                          onPressed: () async {
                                            // TODO: 升级
//                                        _updateBloc.dispatch(Update(
//                                            platform: Theme.of(context)
//                                                .platform));
                                            await _downLoadFile(
                                                downLoadUrl:
                                                "http://47.107.182.100:9000/media/manufacture${widget.latestVersion.version}.apk",
                                                platform:
                                                Theme.of(context).platform);
//                                                .platform);
                                          }),
                                      RaisedButton(
                                        //color: Theme.of(context).accentColor,
                                          color: Colors.white,
                                          child: Text("取消"),
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20)),
                                              side: BorderSide(
                                                  color: Colors.white,
                                                  style: BorderStyle.solid,
                                                  width: 2)),
                                          onPressed: () async {
                                            if (!widget.currentVersion.is_valid) {
                                              showDialog(
                                                  builder: (context) =>
                                                  new AlertDialog(
                                                    title: new Text('提示'),
                                                    content: new Text(
                                                        '当前版本不可用,确定要退出?'),
                                                    actions: <Widget>[
                                                      new FlatButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                            SystemNavigator
                                                                .pop();
                                                          },
                                                          child:
                                                          new Text('确定')),
                                                      new FlatButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: new Text('取消'))
                                                    ],
                                                  ),
                                                  context: context);
                                            } else {
                                              if (widget.popPageIfDoNotUpdate) {
                                                Navigator.pop(context);
                                              } else {
                                                _authenticationBloc.add(
                                                    AuthenticationUpdateEvent());
                                              }
                                            }
                                          }),
                                    ],
                                  ))
                            ],
                          ));
                    } else {
                      return Container(
                          color: Theme.of(context).accentColor,
                          alignment: Alignment.center,
                          child: Column(
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  alignment: Alignment.center,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        'v${widget.latestVersion.version} 已经是最新版本！',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                  alignment: Alignment.bottomCenter,
                                  margin: const EdgeInsets.only(bottom: 20),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      RaisedButton(
                                        //color: Theme.of(context).accentColor,
                                          color: Colors.white,
                                          child: Text("返回"),
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20)),
                                              side: BorderSide(
                                                  color: Colors.white,
                                                  style: BorderStyle.solid,
                                                  width: 2)),
                                          onPressed: () async {
                                            Navigator.pop(context);
                                          }),
                                    ],
                                  ))
                            ],
                          ));
                    }
                  }
              }
              return Container(
                color: Theme.of(context).accentColor,
                child: Center(
                  child: Text('当前程序不再更新维护！',style: TextStyle(color: Colors.white),),
                ),
              );

            }),
      );
    }));
  }
}
