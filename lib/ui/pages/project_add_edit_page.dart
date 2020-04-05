import 'package:flutter/material.dart';
import 'package:manufacture/beans/project.dart';
import 'package:manufacture/data/repository/object_repository.dart';
import 'package:manufacture/ui/widget/time_picker/date_time_picker.dart';
import '../../core/object_add_edit_page.dart';

class ProjectAddEditPage extends StatefulWidget {
  final Project project;
  final ObjectRepository<Project> objectRepository;
  ProjectAddEditPage({this.project, this.objectRepository});
  @override
  State<StatefulWidget> createState() => _ProjectAddEditState();
}

class _ProjectAddEditState extends State<ProjectAddEditPage> {
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _codeController = new TextEditingController();
  int _status;

  DateTime _startDate;
  TimeOfDay _startTime;

  DateTime _endDate;
  TimeOfDay _endTime;

  static String _twoDigits(int n) {
    if (n >= 10) return "${n}";
    return "0${n}";
  }

  @override
  void initState() {
    if (widget.project != null) {
      _nameController.text = widget.project.name;
      _codeController.text = widget.project.code;
      _status = widget.project.status;
      _startDate = DateTime.parse(widget.project.start).toLocal();
      _startTime = TimeOfDay.fromDateTime(_startDate);
      _endDate = DateTime.parse(widget.project.end).toLocal();
      _endTime = TimeOfDay.fromDateTime(_endDate);
    } else {
      _startDate = DateTime.now();
      _startTime = TimeOfDay.now();
      _endDate = DateTime.now();
      _endTime = TimeOfDay.now();
      _status = 0;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ObjectAddEditPage<Project>(
      object: widget.project,
      objectRepository: widget.objectRepository,
      objectCallback: () {
        if (widget.project != null) {
          widget.project.code = _codeController.text.toString();
          widget.project.name = _nameController.text.toString();
          widget.project.status = _status;
          widget.project.start =
              "${_startDate.year}-${_twoDigits(_startDate.month)}-${_twoDigits(_startDate.day)}T${_twoDigits(_startTime.hour)}:${_twoDigits(_startTime.minute)}:00+08:00";
          widget.project.end =
              "${_endDate.year}-${_twoDigits(_endDate.month)}-${_twoDigits(_endDate.day)}T${_twoDigits(_endDate.hour)}:${_twoDigits(_endDate.minute)}:00+08:00";
          return widget.project;
        } else {
          Project project = new Project();
          project.code = _codeController.text.toString();
          project.name = _nameController.text.toString();
          project.status = _status;
          project.start =
              "${_startDate.year}-${_twoDigits(_startDate.month)}-${_twoDigits(_startDate.day)}T${_twoDigits(_startTime.hour)}:${_twoDigits(_startTime.minute)}:00+08:00";
          project.end =
              "${_endDate.year}-${_twoDigits(_endDate.month)}-${_twoDigits(_endDate.day)}T${_twoDigits(_endDate.hour)}:${_twoDigits(_endDate.minute)}:00+08:00";

          return project;
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
              controller: _codeController,
              validator: (value) {
                if (value.isEmpty) {
                  return "内容不能为空";
                }
                return null;
              },
              decoration: InputDecoration(
                filled: true,
                icon: Icon(
                  Icons.code,
                  color: Theme.of(context).accentColor,
                ),
                labelText: '编号',
                //hintText: '编号',
                //border: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(20.0)),)
              ),
            ),
            SizedBox(
              height: 24,
            ),
            TextFormField(
              controller: _nameController,
              validator: (value) {
                if (value.isEmpty) {
                  return "内容不能为空";
                }
                return null;
              },
              decoration: InputDecoration(
                filled: true,
                icon: Icon(
                  Icons.mode_edit,
                  color: Theme.of(context).accentColor,
                ),
                labelText: '名称',
                //hintText: '名称',
                //border: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(20.0)),)
              ),
            ),
            SizedBox(
              height: 24,
            ),
            DateTimePicker(
              labelText: '开始时间',
              selectedDate: _startDate,
              selectedTime: _startTime,
              selectDate: (DateTime date) {
                setState(() {
                  _startDate = date;
                });
              },
              selectTime: (TimeOfDay time) {
                setState(() {
                  _startTime = time;
                });
              },
            ),
            SizedBox(
              height: 24,
            ),
            DateTimePicker(
              labelText: '结束时间',
              selectedDate: _endDate,
              selectedTime: _endTime,
              selectDate: (DateTime date) {
                setState(() {
                  _endDate = date;
                });
              },
              selectTime: (TimeOfDay time) {
                setState(() {
                  _endTime = time;
                });
              },
            ),
            SizedBox(
              height: 24,
            ),
            DropdownButtonFormField<int>(
              onChanged: (int value) {
                setState(() {
                  _status = value;
                });
              },
              value: _status,
              items: [
                DropdownMenuItem<int>(
                  value: 0,
                  child: Text(Project.getStatus(0)),
                ),
                DropdownMenuItem<int>(
                  value: 1,
                  child: Text(Project.getStatus(1)),
                ),
                DropdownMenuItem<int>(
                  value: 2,
                  child: Text(Project.getStatus(2)),
                ),
              ],
            ),
            SizedBox(
              height: 24,
            ),
          ],
        );
      },
    );
  }
}

//
//enum ProjectAddEditPageType{
//  CREATE,
//  MODIFY,
//  VIEW
//}
//
//class ProjectAddEditPage extends StatefulWidget{
//  final Project project;
//  final ProjectAddEditPageType type;
//  final ProjectRepository projectRepository;
//  ProjectAddEditPage({this.project, this.type=ProjectAddEditPageType.MODIFY, @required this.projectRepository});
//  @override
//  State<StatefulWidget> createState() => _ProjectAddEditState();
//}
//
//class _ProjectAddEditState extends State<ProjectAddEditPage>{
//  ProjectAddEditBloc _projectAddEditBloc;
//  final _formKey = GlobalKey<FormState>();
//  TextEditingController _nameController = new TextEditingController();
//  TextEditingController _codeController = new TextEditingController();
//  int _status;
//
//  DateTime _startDate;
//  TimeOfDay _startTime;
//
//
//  DateTime _endDate;
//  TimeOfDay _endTime;
//
//  static String _twoDigits(int n) {
//    if (n >= 10) return "${n}";
//    return "0${n}";
//  }
//
//  @override
//  void initState() {
//    _projectAddEditBloc = ProjectAddEditBloc(projectRepository: widget.projectRepository);
//    if(widget.type == ProjectAddEditPageType.MODIFY){
//      _nameController.text = widget.project.name;
//      _codeController.text = widget.project.code;
//      _status = widget.project.status;
//      _startDate = DateTime.parse(widget.project.start).toLocal();
//      _startTime = TimeOfDay.fromDateTime(_startDate);
//      _endDate = DateTime.parse(widget.project.end).toLocal();
//      _endTime = TimeOfDay.fromDateTime(_endDate);
//    }else{
//      _startDate = DateTime.now();
//      _startTime = TimeOfDay.now();
//      _endDate = DateTime.now();
//      _endTime = TimeOfDay.now();
//      _status=0;
//    }
//    super.initState();
//  }
//
//  @override
//  void dispose() {
//    _projectAddEditBloc.dispose();
//    super.dispose();
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(title: Text("项目"),),
//      body: Container(
//        padding: const EdgeInsets.all(10),
//        child: Form(
//          key: _formKey,
//          child: BlocListener<ProjectAddEditBloc, ProjectAddEditState>(
//              bloc: _projectAddEditBloc,
//              listener: (context, state){
//                if(state is DoneState){
//                  if(state.isSuccess==true){
//                    Navigator.pop(context,true);
//                  }else{
//                    SnackBarUtil.fail(context: context, message: state.message);
//                  }
//                }
//              },
//              child: BlocBuilder<ProjectAddEditBloc, ProjectAddEditState>(
//                condition: (pre,current){
//                  return true;
//                },
//                bloc: _projectAddEditBloc,
//                builder: (context,state){
//                  return SingleChildScrollView(
//                    child: Column(
//                      mainAxisAlignment: MainAxisAlignment.start,
//                      crossAxisAlignment: CrossAxisAlignment.stretch,
//                      children: <Widget>[
//                        TextFormField(
//                          controller: _codeController,
//                          validator: (value) {
//                            if (value.isEmpty) {
//                              return "内容不能为空";
//                            }
//                            return null;
//                          },
//                          decoration: InputDecoration(
//                            prefixIcon: Icon(
//                              Icons.code,
//                              color: Theme.of(context).accentColor,
//                            ),
//                            labelText: '编号',
//                            //hintText: '编号',
//                            //border: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(20.0)),)
//                          ),
//                        ),
//                        TextFormField(
//                          controller: _nameController,
//                          validator: (value) {
//                            if (value.isEmpty) {
//                              return "内容不能为空";
//                            }
//                            return null;
//                          },
//                          decoration: InputDecoration(
//                            prefixIcon: Icon(
//                              Icons.mode_edit,
//                              color: Theme.of(context).accentColor,
//                            ),
//                            labelText: '名称',
//                            //hintText: '名称',
//                            //border: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(20.0)),)
//                          ),
//                        ),
//                        DateTimePicker(
//                          labelText: '开始时间',
//                          selectedDate: _startDate,
//                          selectedTime: _startTime,
//                          selectDate: (DateTime date) {
//                            setState(() {
//                              _startDate = date;
//                            });
//                          },
//                          selectTime: (TimeOfDay time) {
//                            setState(() {
//                              _startTime = time;
//                            });
//                          },
//                        ),
//                        DateTimePicker(
//                          labelText: '结束时间',
//                          selectedDate: _endDate,
//                          selectedTime: _endTime,
//                          selectDate: (DateTime date) {
//                            setState(() {
//                              _endDate = date;
//                            });
//                          },
//                          selectTime: (TimeOfDay time) {
//                            setState(() {
//                              _endTime = time;
//                            });
//                          },
//                        ),
//                        DropdownButtonFormField<int>(
//                          onChanged: (int value){
//                            setState(() {
//                              _status = value;
//                            });
//                          },
//                          value: _status,
//                          items: [
//                            DropdownMenuItem<int>(value: 0, child: Text(Project.getStatus(0)),),
//                            DropdownMenuItem<int>(value: 1, child: Text(Project.getStatus(1)),),
//                            DropdownMenuItem<int>(value: 2, child: Text(Project.getStatus(2)),),
//                          ],
//                        ),
//                        Container(
//                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
//                          child: RaisedButton(
//                              shape: RoundedRectangleBorder(
//                                  borderRadius:
//                                  BorderRadius.all(Radius.circular(20)),
//                                  side: BorderSide(
//                                      color: Colors.white,
//                                      style: BorderStyle.solid,
//                                      width: 2)),
//                              color: Theme.of(context).accentColor,
//                              child: Text("提交"),
//                              onPressed: () {
//                                if(_formKey.currentState.validate()){
//                                  if(widget.type == ProjectAddEditPageType.CREATE){
//                                    print("1111");
//                                    Project project=new Project();
//                                    project.code = _codeController.text.toString();
//                                    project.name = _nameController.text.toString();
//                                    project.status = _status;
//                                    project.start = "${_startDate.year}-${_twoDigits(_startDate.month)}-${_twoDigits(_startDate.day)}T${_twoDigits(_startTime.hour)}:${_twoDigits(_startTime.minute)}:00+08:00";
//                                    project.end = "${_endDate.year}-${_twoDigits(_endDate.month)}-${_twoDigits(_endDate.day)}T${_twoDigits(_endDate.hour)}:${_twoDigits(_endDate.minute)}:00+08:00";
//                                    _projectAddEditBloc.dispatch(AddEvent(project: project));
//                                  }else if(widget.type == ProjectAddEditPageType.MODIFY && widget.project!=null){
//                                    widget.project.code = _codeController.text.toString();
//                                    widget.project.name = _nameController.text.toString();
//                                    widget.project.status = _status;
//                                    widget.project.start = "${_startDate.year}-${_twoDigits(_startDate.month)}-${_twoDigits(_startDate.day)}T${_twoDigits(_startTime.hour)}:${_twoDigits(_startTime.minute)}:00+08:00";
//                                    widget.project.end = "${_endDate.year}-${_twoDigits(_endDate.month)}-${_twoDigits(_endDate.day)}T${_twoDigits(_endDate.hour)}:${_twoDigits(_endDate.minute)}:00+08:00";
//                                    _projectAddEditBloc.dispatch(ModifyEvent(project: widget.project));
//                                  }
//                                }
//
//                              }),
//                        ),
//                      ],
//                    ),
//                  );
//                },
//              )
//          ),
//        ),
//      )
//    );
//  }
//}
