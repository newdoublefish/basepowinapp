import 'package:flutter/material.dart';
import 'package:manufacture/beans/base_bean.dart';
import 'package:manufacture/beans/project.dart';
import 'package:manufacture/data/repository/detail_repository.dart';
import 'package:manufacture/data/repository/flow_modals_repository.dart';
import 'package:manufacture/beans/organization.dart';
import 'package:manufacture/data/repository/organization_repository.dart';
import '../../core/object_select_widget.dart';
import '../../core/object_add_edit_page.dart';

class DetailAddEditPage extends StatefulWidget {
  final Detail detail;
  final Project project;
  final DetailObjectRepository objectRepository;
  DetailAddEditPage({Key key, this.project, this.detail, this.objectRepository})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => _DetailAddEditPageState();
}

class _DetailAddEditPageState extends State<DetailAddEditPage> {
  ObjectSelectController<Procedure> _procedureSelectController =
      new ObjectSelectController<Procedure>();
  FlowModalsObjectRepository _flowModalsObjectRepository;
  ObjectSelectController<Organization> _organizationSelectController =
      new ObjectSelectController<Organization>();
  OrganizationObjectRepository _organizationObjectRepository;

  TextEditingController _nameController = new TextEditingController();
  TextEditingController _remarkController = new TextEditingController();
  TextEditingController _countController = new TextEditingController();

  @override
  void initState() {
    _flowModalsObjectRepository = FlowModalsObjectRepository.init();
    _organizationObjectRepository = OrganizationObjectRepository.init();
    if (widget.detail != null) {
      _nameController.text = widget.detail.name;
      _remarkController.text = widget.detail.remark;
      _countController.text = "${widget.detail.count}";
      _procedureSelectController.selectObject = Procedure()
        ..id = widget.detail.flow;
      _organizationSelectController.selectObject = Organization()
        ..id = widget.detail.odm;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ObjectAddEditPage<Detail>(
      object: widget.detail,
      objectRepository: widget.objectRepository,
      objectCallback: () {
        if (widget.detail != null) {
          widget.detail.name = _nameController.text.toString();
          widget.detail.remark = _remarkController.text.toString();
          widget.detail.project = widget.project.id;
          widget.detail.count = int.parse(_countController.text.toString());
          //widget.detail.flow = (_procedureSelectBloc.currentState as ProcedureLoadState).current.id;
          widget.detail.flow = _procedureSelectController.selectObject.id;
          widget.detail.odm = _organizationSelectController.selectObject.id;
          return widget.detail;
        } else {
          Detail detail = new Detail();
          detail.name = _nameController.text.toString();
          detail.remark = _remarkController.text.toString();
          detail.project = widget.project.id;
          detail.count = int.parse(_countController.text.toString());
          //detail.flow = (_procedureSelectBloc.currentState as ProcedureLoadState).current.id;
          detail.flow = _procedureSelectController.selectObject.id;
          detail.odm = _organizationSelectController.selectObject.id;
          return detail;
        }
      },
      builder: (context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(
              height: 24,
            ),
            TextFormField(
              textCapitalization: TextCapitalization.words,
              controller: _nameController,
              validator: (value) {
                if (value.isEmpty) {
                  return "内容不能为空";
                }
                return null;
              },
              decoration: InputDecoration(
                border: UnderlineInputBorder(),
                filled: true,
                icon: Icon(Icons.edit),
//                prefixIcon: Icon(
//                  Icons.mode_edit,
//                  color: Theme.of(context).accentColor,
//                ),
                labelText: '名称',
                //hintText: '名称',
                //border: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(20.0)),)
              ),
            ),
            const SizedBox(height: 24.0),
            TextFormField(
              controller: _countController,
              validator: (value) {
                if (value.isEmpty) {
                  return "内容不能为空";
                }
                return null;
              },
              decoration: InputDecoration(
                border: UnderlineInputBorder(),
                filled: true,
                icon: Icon(
                  Icons.art_track,
                ),
                labelText: '数量',
                //hintText: '名称',
                //border: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(20.0)),)
              ),
            ),
            const SizedBox(height: 24.0),
            TextFormField(
              controller: _remarkController,
              validator: (value) {
                if (value.isEmpty) {
                  return "备注不能为空";
                }
                return null;
              },
              maxLines: 3,
              decoration: InputDecoration(
                border: UnderlineInputBorder(),
                filled: true,
                labelText: '备注',
                //hintText: '编号',
                //border: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(20.0)),)
              ),
            ),
            const SizedBox(height: 24.0),
            ListTile(
              leading: Text("制造流程"),
              dense: false,
              title: ObjectSelect<Procedure>(
                controller: _procedureSelectController,
                objectRepository: _flowModalsObjectRepository,
                onItemShowName: (BaseBean value) {
                  return (value as Procedure).name;
                },
              ),
            ),
            const SizedBox(height: 24.0),
            ListTile(
              leading: Text("生产组织"),
              dense: true,
              title: ObjectSelect<Organization>(
                controller: _organizationSelectController,
                objectRepository: _organizationObjectRepository,
                onItemShowName: (BaseBean value) {
                  return (value as Organization).name;
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

//enum ProjectDetailAddEditPageType { CREATE, MODIFY, VIEW }
//
//class ProjectDetailAddEditPage extends StatefulWidget {
//  final Detail detail;
//  final Project project;
//  final ProjectDetailAddEditPageType type;
//  final DetailRepository detailRepository;
//  ProjectDetailAddEditPage({
//    this.detail,
//    this.project,
//    this.type = ProjectDetailAddEditPageType.MODIFY,
//    @required this.detailRepository,
//  });
//  @override
//  State<StatefulWidget> createState() => _ProjectDetailAddEditState();
//}
//
//class _ProjectDetailAddEditState extends State<ProjectDetailAddEditPage> {
//  ProjectDetailAddEditBloc _detailAddEditBloc;
//  //ProcedureSelectBloc _procedureSelectBloc;
////  ObjectSelectBloc<Procedure> _procedureSelectBloc;
//  ObjectSelectController<Procedure> _procedureSelectController =
//      new ObjectSelectController<Procedure>();
//  FlowModalsObjectRepository _flowModalsObjectRepository;
//  ObjectSelectController<Organization> _organizationSelectController =
//      new ObjectSelectController<Organization>();
//  OrganizationObjectRepository _organizationObjectRepository;
//
//  final _formKey = GlobalKey<FormState>();
//  TextEditingController _nameController = new TextEditingController();
//  TextEditingController _remarkController = new TextEditingController();
//  TextEditingController _countController = new TextEditingController();
//  Procedure selectProcedure;
//
//  @override
//  void initState() {
//    _detailAddEditBloc =
//        ProjectDetailAddEditBloc(detailRepository: widget.detailRepository);
////    _procedureSelectBloc =
////        ProcedureSelectBloc(repository: FlowModalsRepository());
//    _flowModalsObjectRepository = FlowModalsObjectRepository.init();
//    _organizationObjectRepository = OrganizationObjectRepository.init();
//
//    if (widget.type == ProjectDetailAddEditPageType.MODIFY) {
//      _nameController.text = widget.detail.name;
//      _remarkController.text = widget.detail.remark;
//      _countController.text = "${widget.detail.count}";
//      _procedureSelectController.selectObject = Procedure()
//        ..id = widget.detail.flow;
//      _organizationSelectController.selectObject = Organization()
//        ..id = widget.detail.odm;
//    }
//    super.initState();
//  }
//
//  @override
//  void dispose() {
//    _detailAddEditBloc.dispose();
//    super.dispose();
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//        appBar: AppBar(
//          title: Text("项目明细"),
//        ),
//        body: Container(
//          padding: const EdgeInsets.all(10),
//          child: Form(
//            key: _formKey,
//            child: BlocListener<ProjectDetailAddEditBloc,
//                    ProjectDetailAddEditState>(
//                bloc: _detailAddEditBloc,
//                listener: (context, state) {
//                  if (state is DoneState) {
//                    if (state.isSuccess == true) {
//                      Navigator.pop(context, true);
//                    } else {
//                      SnackBarUtil.fail(
//                          context: context, message: state.message);
//                    }
//                  }
//                },
//                child: BlocBuilder<ProjectDetailAddEditBloc,
//                    ProjectDetailAddEditState>(
//                  condition: (pre, current) {
//                    return true;
//                  },
//                  bloc: _detailAddEditBloc,
//                  builder: (context, state) {
//                    return SingleChildScrollView(
//                      child: Column(
//                        mainAxisAlignment: MainAxisAlignment.start,
//                        crossAxisAlignment: CrossAxisAlignment.stretch,
//                        children: <Widget>[
//                          TextFormField(
//                            controller: _nameController,
//                            validator: (value) {
//                              if (value.isEmpty) {
//                                return "内容不能为空";
//                              }
//                              return null;
//                            },
//                            decoration: InputDecoration(
//                              prefixIcon: Icon(
//                                Icons.mode_edit,
//                                color: Theme.of(context).accentColor,
//                              ),
//                              labelText: '名称',
//                              //hintText: '名称',
//                              //border: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(20.0)),)
//                            ),
//                          ),
//                          TextFormField(
//                            controller: _countController,
//                            validator: (value) {
//                              if (value.isEmpty) {
//                                return "内容不能为空";
//                              }
//                              return null;
//                            },
//                            decoration: InputDecoration(
//                              prefixIcon: Icon(
//                                Icons.art_track,
//                                color: Theme.of(context).accentColor,
//                              ),
//                              labelText: '数量',
//                              //hintText: '名称',
//                              //border: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(20.0)),)
//                            ),
//                          ),
//                          TextFormField(
//                            controller: _remarkController,
//                            validator: (value) {
//                              if (value.isEmpty) {
//                                return "备注不能为空";
//                              }
//                              return null;
//                            },
//                            decoration: InputDecoration(
//                              prefixIcon: Icon(
//                                Icons.code,
//                                color: Theme.of(context).accentColor,
//                              ),
//                              labelText: '备注',
//                              //hintText: '编号',
//                              //border: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(20.0)),)
//                            ),
//                          ),
//                          ListTile(
//                            leading: Text("制造流程"),
//                            dense: false,
//                            title: ObjectSelect<Procedure>(
//                              controller: _procedureSelectController,
//                              objectRepository: _flowModalsObjectRepository,
//                              onItemShowName: (BaseBean value) {
//                                return (value as Procedure).name;
//                              },
//                            ),
//                          ),
//                          ListTile(
//                            leading: Text("生产组织"),
//                            dense: true,
//                            title: ObjectSelect<Organization>(
//                              controller: _organizationSelectController,
//                              objectRepository: _organizationObjectRepository,
//                              onItemShowName: (BaseBean value) {
//                                return (value as Organization).name;
//                              },
//                            ),
//                          ),
//                          Container(
//                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
//                            child: RaisedButton(
//                                shape: RoundedRectangleBorder(
//                                    borderRadius:
//                                        BorderRadius.all(Radius.circular(20)),
//                                    side: BorderSide(
//                                        color: Colors.white,
//                                        style: BorderStyle.solid,
//                                        width: 2)),
//                                color: Theme.of(context).accentColor,
//                                child: Text("提交"),
//                                onPressed: () {
//                                  if (_formKey.currentState.validate()) {
//                                    if (widget.type ==
//                                        ProjectDetailAddEditPageType.CREATE) {
//                                      Detail detail = new Detail();
//                                      detail.name =
//                                          _nameController.text.toString();
//                                      detail.remark =
//                                          _remarkController.text.toString();
//                                      detail.project = widget.project.id;
//                                      detail.count = int.parse(
//                                          _countController.text.toString());
//                                      //detail.flow = (_procedureSelectBloc.currentState as ProcedureLoadState).current.id;
//                                      detail.flow = _procedureSelectController
//                                          .selectObject.id;
//                                      detail.odm = _organizationSelectController
//                                          .selectObject.id;
//
//                                      _detailAddEditBloc
//                                          .dispatch(AddEvent(detail: detail));
//                                    } else if (widget.type ==
//                                            ProjectDetailAddEditPageType
//                                                .MODIFY &&
//                                        widget.detail != null) {
//                                      widget.detail.name =
//                                          _nameController.text.toString();
//                                      widget.detail.remark =
//                                          _remarkController.text.toString();
//                                      widget.detail.project = widget.project.id;
//                                      widget.detail.count = int.parse(
//                                          _countController.text.toString());
//                                      //widget.detail.flow = (_procedureSelectBloc.currentState as ProcedureLoadState).current.id;
//                                      widget.detail.flow =
//                                          _procedureSelectController
//                                              .selectObject.id;
//                                      widget.detail.odm =
//                                          _organizationSelectController
//                                              .selectObject.id;
//                                      _detailAddEditBloc.dispatch(
//                                          ModifyEvent(detail: widget.detail));
//                                    }
//                                  }
//                                }),
//                          ),
//                        ],
//                      ),
//                    );
//                  },
//                )),
//          ),
//        ));
//  }
//}
