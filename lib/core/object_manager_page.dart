import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manufacture/beans/base_bean.dart';
import 'package:manufacture/data/repository/object_repository.dart';
import 'package:manufacture/bloc/object_manager_bloc.dart';
import 'package:manufacture/util/dialog_util.dart';
import 'package:manufacture/util/snackbar_util.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:manufacture/ui/widget/smart_filter_page/smart_filter_page.dart';
import 'object_batch_operate_page.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter/cupertino.dart';

typedef OnObjectTap<T extends BaseBean> = void Function(T value);
typedef AddEditPageWidget<T extends BaseBean> = Widget Function(
    BuildContext context, T object);
typedef ItemWidgetBuilder<T extends BaseBean> = Widget Function(
    BuildContext context, T object);
typedef ListWidgetBuilder<T extends BaseBean> = List<Widget> Function(
    BuildContext context, T object);
typedef CustomWidgetBuilder<T extends BaseBean> = Widget Function(
    BuildContext context, List<T> object);

class ObjectManagerController extends ValueNotifier<String>{
  ObjectManagerController(String text) : super(text);

  void requestRefresh(){
    value = "refresh";
    notifyListeners();
  }
}

class ObjectManagerPage<T extends BaseBean> extends StatefulWidget {
  final ObjectRepository<T> objectRepository;
  final Map<String, dynamic> initQueryParams;
  final String title;
  final List<FilterGroup> filterGroupList;
  final OnObjectTap<T> onTap;
  final AddEditPageWidget<T> addEditPageBuilder;
  final ItemWidgetBuilder<T> itemWidgetBuilder;
  final List<Widget> extraPopupButton;
  final ListWidgetBuilder<T> extraBottomItemsBuilder;
  final CustomWidgetBuilder<T> customWidgetBuilder;
  final bool enablePullDown;
  final bool enablePullUp;
  final bool canDeleteBatch; //能否批量删除
  final bool canDeleteSingle;
  final bool canAddEditObject;
  final ObjectManagerController objectManagerController;
  final bool showAppBar;

  factory ObjectManagerPage.custom({
    Key key,
    ObjectRepository<T> objectRepository,
    Map<String, dynamic> initQueryParams,
    List<FilterGroup> filterGroupList,
    String title,
    List<Widget> extraPopupButton,
    @required CustomWidgetBuilder<T> customWidgetBuilder,
    bool enablePullDown=true,
    bool enablePullUp=true,
    bool canDeleteBatch = false,
    ObjectManagerController objectManagerController,
    bool showAppBar=false,
  }) {
    return ObjectManagerPage(
      key: key,
      objectRepository: objectRepository,
      title: title,
      filterGroupList: filterGroupList,
      onTap: null,
      addEditPageBuilder: null,
      itemWidgetBuilder: null,
      extraBottomItemsBuilder: null,
      initQueryParams: initQueryParams,
      extraPopupButton: extraPopupButton,
      customWidgetBuilder: customWidgetBuilder,
      enablePullUp: enablePullUp,
      enablePullDown: enablePullDown,
      canDeleteBatch: canDeleteBatch,
      objectManagerController: objectManagerController,
      showAppBar: showAppBar,
    );
  }

  ObjectManagerPage({
    Key key,
    this.title,
    this.objectRepository,
    this.initQueryParams,
    this.filterGroupList,
    this.onTap,
    @required this.itemWidgetBuilder,
    this.extraPopupButton,
    this.extraBottomItemsBuilder,
    this.customWidgetBuilder,
    this.addEditPageBuilder,
    this.enablePullDown = true,
    this.enablePullUp = true,
    this.canDeleteBatch = true,
    this.objectManagerController,
    this.showAppBar=true,
    this.canAddEditObject = true,
    this.canDeleteSingle = true,
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() => _ObjectManagerPage<T>();
}

class _ObjectManagerPage<T extends BaseBean> extends State<ObjectManagerPage> {
  ObjectManagerBloc _objectManagerBloc;
  Map<String, dynamic> queryParams = {};
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  List<PopupMenuEntry<void>> popItems = [];
  _buildPopMenu() {
    if (widget.addEditPageBuilder != null && widget.canAddEditObject) {
      popItems.add(PopupMenuItem<void>(
        child: ListTile(
          leading: Icon(Icons.add_circle),
          title: Text('添加'),
          onTap: () {
            Navigator.pop(context);
            if (widget.addEditPageBuilder != null) {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return widget.addEditPageBuilder(context, null);
              })).then((result) async {
                if (result != null) _refreshController.requestRefresh();
                if (widget.initQueryParams != null)
                  queryParams.addAll(widget.initQueryParams);
                _objectManagerBloc
                    .add(RefreshEvent(queryParams: queryParams));
              });
            }
          },
        ),
      ));
    }
    if (widget.canDeleteBatch)
      popItems.add(PopupMenuItem<void>(
        child: ListTile(
            leading: Icon(Icons.format_list_bulleted),
            title: Text('管理'),
            onTap: () {
              Navigator.pop(context);
              if (_objectManagerBloc.state is LoadedState) {
                Navigator.push<List<T>>(context,
                    MaterialPageRoute(builder: (context) {
                  return ObjectBatchOperate<T>(
                    objectList:
                        (_objectManagerBloc.state as LoadedState).list,
                    itemBuilder: widget.itemWidgetBuilder,
                  );
                })).then((value) {
                  if (value != null) {
                    if (value.length != 0)
                      _objectManagerBloc
                          .add(DeleteEvent(instanceList: value));
                  }
                });
              }
            }),
      ));
    if (widget.extraPopupButton != null && widget.canAddEditObject) {
      popItems.add(PopupMenuDivider());
      widget.extraPopupButton.forEach((item) {
        popItems.add(item);
      });
    }
  }

  @override
  void didUpdateWidget(ObjectManagerPage<BaseBean> oldWidget) {
    super.didUpdateWidget(oldWidget);
//    if (widget.objectManagerController != oldWidget.objectManagerController) {
//      oldWidget.objectManagerController.notifier.removeListener(handleValueChanged);
//      widget.objectManagerController.notifier.addListener(handleValueChanged);
//    }
  }

  @override
  void initState() {
    _buildPopMenu();
    _objectManagerBloc =
        ObjectManagerBloc<T>(objectRepository: widget.objectRepository);
    _objectManagerBloc
        .add(RefreshEvent(queryParams: widget.initQueryParams));
    if(widget.objectManagerController!=null){
      widget.objectManagerController.addListener(handleValueChanged);
    }
    super.initState();
  }

  void handleValueChanged(){
    if(widget.objectManagerController.value.compareTo("refresh")==0)
        _refreshController.requestRefresh();
  }

  @override
  void dispose() {
    if(widget.objectManagerController!=null)
      widget.objectManagerController.removeListener(handleValueChanged);
    _objectManagerBloc.close();
    super.dispose();
  }

  void _onRefresh() async {
    if (widget.initQueryParams != null)
      queryParams.addAll(widget.initQueryParams);
    _objectManagerBloc.add(RefreshEvent(queryParams: queryParams));
  }

  void _onLoading() async {
    _objectManagerBloc.add(LoadMoreEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.showAppBar?AppBar(
          title: BlocBuilder<ObjectManagerBloc, ObjectManagerState>(
            condition: (previous, current) {

              if (current is LoadedState) {
                return true;
              }
              return false;
            },
            bloc: _objectManagerBloc,
            builder: (context, state) {
              if (state is LoadedState) {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Text(
                      "(${state.currentCount}/${state.totalCount})${widget.title != null ? widget.title : ""}"),
                );
              }
              return Text(widget.title != null ? widget.title : "");
            },
          ),
          centerTitle: false,
          actions: <Widget>[
            popItems.length>0?PopupMenuButton(
              itemBuilder: (BuildContext context) => popItems,
            ):Container()
          ]):null,
      body: BlocListener<ObjectManagerBloc, ObjectManagerState>(
        bloc: _objectManagerBloc,
        listener: (context, state) {
          if (state is NoMoreState) {
            _refreshController.loadNoData();
          } else if (state is MoreLoadedState) {
            _refreshController.loadComplete();
          } else if (state is RefreshedState) {
            _refreshController.refreshCompleted();
            _refreshController.resetNoData();
          } else if (state is DoneState) {
            SnackBarUtil.show(
                context: context,
                message: state.message,
                isSuccess: state.isSuccess);
          } else if (state is DeletingState) {

          } else if (state is DeletedState) {
            _refreshController.requestRefresh();//删除完成后刷新
          } else if (state is DeleteStartState) {

          }
        },
        child: BlocBuilder<ObjectManagerBloc, ObjectManagerState>(
          bloc: _objectManagerBloc,
          condition: (previousState, currentState) {
            if (currentState is NoMoreState ||
                currentState is MoreLoadedState ||
                currentState is RefreshedState ||
                currentState is DoneState ||
                currentState is DeleteStartState ||
                //currentState is DeletingState ||
                currentState is DeletedState) {
              return false;
            }
            return true;
          },
          builder: (context, state) {
            if(state is DeletingState){
              return Container(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("删除中..."),
                      CircularPercentIndicator(
                        radius: 150.0,
                        lineWidth: 8.0,
                        percent: state.progress/100,
                        center: new Text("${state.progress.toInt()}%"),
                        progressColor: Colors.redAccent,
                      ),
                    ],
                  ),
                ),
              );
            }

            return SmartFilterPage(
              filterGroupList: widget.filterGroupList,
              onFilterChange: (filterMap) {
                print(filterMap);
                queryParams = filterMap;
                _refreshController.requestRefresh();
                if (widget.initQueryParams != null)
                  queryParams.addAll(widget.initQueryParams);
                _objectManagerBloc.add(RefreshEvent(
                  queryParams: queryParams,
                ));
              },
              child: Builder(builder: (context) {
                if (state is LoadedState) {
                  return SmartRefresher(
                      enablePullDown: widget.enablePullDown,
                      enablePullUp: widget.enablePullUp,
                      controller: _refreshController,
                      onRefresh: _onRefresh,
                      onLoading: _onLoading,
                      header: ClassicHeader(
                        refreshingText: "刷新中...",
                        idleText: "下拉刷新",
                        completeText: "刷新完成",
                        releaseText: "释放刷新",
                      ),
                      footer: CustomFooter(
                        builder: (BuildContext context, LoadStatus mode) {
                          Widget body;
                          if (mode == LoadStatus.idle) {
                            body = Text("上拉加载更多");
                          } else if (mode == LoadStatus.loading) {
                            body = CupertinoActivityIndicator();
                          } else if (mode == LoadStatus.failed) {
                            body = Text("Load Failed!Click retry!");
                          } else {
                            body = Text("无更多数据");
                          }
                          return Container(
                            height: 55.0,
                            child: Center(child: body),
                          );
                        },
                      ),
                      child: widget.itemWidgetBuilder != null
                          ? ListView.builder(
                              physics: new AlwaysScrollableScrollPhysics(),
                              itemBuilder: (context, i) {
                                return GestureDetector(
                                  child: widget.itemWidgetBuilder != null
                                      ? widget.itemWidgetBuilder(
                                          context, state.list[i])
                                      : ListTile(
                                          title: Text("item $i"),
                                        ),
                                  onTap: () {
                                    if (widget.onTap != null)
                                      widget.onTap(state.list[i]);
                                  },
                                  onLongPress: () {
                                    showModalBottomSheet<void>(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return Container(
                                              child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: <Widget>[
                                              widget.addEditPageBuilder != null
                                                  ? ListTile(
                                                      leading:
                                                          Icon(Icons.mode_edit),
                                                      title: Text("修改"),
                                                      onTap: () {
                                                        Navigator.pop(context);
                                                        if (widget
                                                                .addEditPageBuilder !=
                                                            null) {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) {
                                                            return widget
                                                                .addEditPageBuilder(
                                                                    context,
                                                                    state.list[
                                                                        i]);
                                                          })).then(
                                                              (result) async {
                                                            if (result !=
                                                                null) {
                                                              _refreshController
                                                                  .requestRefresh();
                                                              if (widget
                                                                      .initQueryParams !=
                                                                  null)
                                                                queryParams
                                                                    .addAll(widget
                                                                        .initQueryParams);
                                                              _objectManagerBloc
                                                                  .add(RefreshEvent(
                                                                      queryParams:
                                                                          queryParams));
                                                            }
                                                          });
                                                        }
                                                      },
                                                    )
                                                  : Container(),
                                              widget.canDeleteSingle?ListTile(
                                                leading: Icon(
                                                  Icons.delete,
                                                  color: Colors.red,
                                                ),
                                                title: Text("删除"),
                                                onTap: () {
                                                  Navigator.pop(context);
                                                  DialogUtil.show(context,
                                                      content: Text("确定要删除"),
                                                      onPositive: () {
                                                    _objectManagerBloc.add(
                                                        DeleteSingleEvent(
                                                            instance:
                                                                state.list[i]));
                                                  });
                                                },
                                              ):Container(),
                                              Builder(
                                                builder: (context) {
                                                  if (widget
                                                          .extraBottomItemsBuilder !=
                                                      null) {
                                                    List<Widget> _list = widget
                                                        .extraBottomItemsBuilder(
                                                            context,
                                                            state.list[i]);
                                                    if (_list.length > 0)
                                                      _list.insert(
                                                          0, Divider());
                                                    return Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .stretch,
                                                      children: _list,
                                                    );
                                                  }
                                                  return Container();
                                                },
                                              ),
                                              SizedBox(
                                                height: 16,
                                              )
                                            ],
                                          ));
                                        });
//                            showBottomSheet(context: context, builder: (context){
//                              return Column(
//                                mainAxisSize: MainAxisSize.min,
//                                children: <Widget>[
//                                  ListTile(leading:Icon(Icons.edit), title: Text("修改"),),
//                                  ListTile(title: Text("删除"),),
//                                ],
//                              );
//                            });
//                            showMenu(
//                              context: context,
//                              position: RelativeRect.fromLTRB(100.0, 200.0, 100.0, 100.0),
//                              items:<PopupMenuEntry>[
//                                PopupMenuItem(
//                                  value: '1',
//                                  child: ListTile(
//                                    leading: Icon(Icons.mode_edit),
//                                    title:Text("修改"),
//                                  ),
//                                ),
//                              ]
//                            );
//                            return PopupMenuButton(
//                              itemBuilder: (BuildContext context) =>
//                              <PopupMenuItem<String>>[
//                                PopupMenuItem<String>(
//                                  value: "modify",
//                                  child: Row(
//                                    mainAxisAlignment:
//                                    MainAxisAlignment.start,
//                                    crossAxisAlignment:
//                                    CrossAxisAlignment.center,
//                                    children: <Widget>[
//                                      Icon(
//                                        Icons.mode_edit,
//                                        color:
//                                        Theme.of(context).accentColor,
//                                      ),
//                                      Container(
//                                        margin: const EdgeInsets.all(10),
//                                        child: Text('修改'),
//                                      )
//                                    ],
//                                  ),
//                                ),
//                                PopupMenuItem<String>(
//                                  value: "remove",
//                                  child: Row(
//                                    mainAxisAlignment:
//                                    MainAxisAlignment.start,
//                                    crossAxisAlignment:
//                                    CrossAxisAlignment.center,
//                                    children: <Widget>[
//                                      Icon(
//                                        Icons.delete_forever,
//                                        color: Colors.red,
//                                      ),
//                                      Container(
//                                        margin: const EdgeInsets.all(10),
//                                        child: Text('删除'),
//                                      )
//                                    ],
//                                  ),
//                                ),
//                              ],
//                              onSelected: (String result) {
//                                if (result.compareTo("modify") == 0) {
//                                  if (widget.addEditPageBuilder != null) {
//                                    Navigator.push(context,
//                                        MaterialPageRoute(
//                                            builder: (context) {
//                                              return widget.addEditPageBuilder(
//                                                  context, state.list[i]);
//                                            })).then((result) async {
//                                      if (result != null)
//                                        _refreshController.requestRefresh();
//                                      if (widget.initQueryParams != null)
//                                        queryParams.addAll(
//                                            widget.initQueryParams);
//                                      _objectManagerBloc
//                                          .dispatch(RefreshEvent());
//                                    });
//                                  }
//                                }
//                                if (result.compareTo('remove') == 0) {
//                                  DialogUtil.show(context,
//                                      content: Text("确定要删除"),
//                                      onPositive: () {
//                                        _objectManagerBloc.dispatch(
//                                            DeleteSingleEvent(
//                                                instance: state.list[i]));
//                                      });
//                                }
//                              },
//                            );
                                  },
                                );
                              },
                              itemCount: state.list.length,
                            )
                          : widget.customWidgetBuilder != null
                              ? widget.customWidgetBuilder(context, state.list)
                              : Center(
                                  child: Text("no widget define"),
                                ));
//                  return SmartEditableListView<T>(
//                      key: _editableListKey,
//                      list: state.list,
//                      onLoading: _onLoading,
//                      onRefresh: _onRefresh,
//                      onTapDelete: (list) {
//                        DialogUtil.show(context, content: Text("确认删除?"),
//                            onPositive: () {
//                          _objectManagerBloc
//                              .dispatch(DeleteEvent(instanceList: list));
//                        });
//                      },
//                      itemBuilder: (context, i) {
//                        return Card(
//                          child: ListTile(
//                              title: Text(state.list[i].code),
//                              dense: false,
//                              onTap: () {
//                                if (widget.onTap != null) {
//                                  widget.onTap(state.list[i]);
//                                }
//                              },
//                              trailing: Builder(
//                                builder: (context) {
//                                  return PopupMenuButton(
//                                    itemBuilder: (BuildContext context) =>
//                                        <PopupMenuItem<String>>[
//                                      PopupMenuItem<String>(
//                                        value: "modify",
//                                        child: Row(
//                                          mainAxisAlignment:
//                                              MainAxisAlignment.start,
//                                          crossAxisAlignment:
//                                              CrossAxisAlignment.center,
//                                          children: <Widget>[
//                                            Icon(
//                                              Icons.mode_edit,
//                                              color:
//                                                  Theme.of(context).accentColor,
//                                            ),
//                                            Container(
//                                              margin: const EdgeInsets.all(10),
//                                              child: Text('修改'),
//                                            )
//                                          ],
//                                        ),
//                                      ),
//                                      PopupMenuItem<String>(
//                                        value: "remove",
//                                        child: Row(
//                                          mainAxisAlignment:
//                                              MainAxisAlignment.start,
//                                          crossAxisAlignment:
//                                              CrossAxisAlignment.center,
//                                          children: <Widget>[
//                                            Icon(
//                                              Icons.delete_forever,
//                                              color: Colors.red,
//                                            ),
//                                            Container(
//                                              margin: const EdgeInsets.all(10),
//                                              child: Text('删除'),
//                                            )
//                                          ],
//                                        ),
//                                      ),
//                                    ],
//                                    onSelected: (String result) {
//                                      if (result.compareTo("modify") == 0) {
//                                        if (widget.addEditPageBuilder != null) {
//                                          Navigator.push(context,
//                                              MaterialPageRoute(
//                                                  builder: (context) {
//                                            return widget.addEditPageBuilder(
//                                                context, state.list[i]);
//                                          })).then((result) async {
//                                            if (result != null)
//                                              _editableListKey.currentState
//                                                  .requestRefresh();
//                                            if (widget.initQueryParams != null)
//                                              queryParams.addAll(
//                                                  widget.initQueryParams);
//                                            _objectManagerBloc
//                                                .dispatch(RefreshEvent());
//                                          });
//                                        }
//                                      }
//                                      if (result.compareTo('remove') == 0) {
//                                        DialogUtil.show(context,
//                                            content: Text("确定要删除"),
//                                            onPositive: () {
//                                          _objectManagerBloc.dispatch(
//                                              DeleteSingleEvent(
//                                                  instance: state.list[i]));
//                                        });
//                                      }
//                                    },
//                                  );
//                                },
//                              )),
//                        );
//                      });
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }),
            );
          },
        ),
      ),
    );
  }
}
