import 'package:flutter/material.dart';
import 'package:manufacture/beans/project.dart';
import 'package:manufacture/data/repository/object_repository.dart';
import '../../core/object_add_edit_page.dart';

class FlowModalAddEditPage extends StatefulWidget{
  final Procedure object;
  final ObjectRepository<Procedure> objectRepository;
  FlowModalAddEditPage({Key key, this.object,this.objectRepository}):super(key:key);
  @override
  State<StatefulWidget> createState() => _FlowModalAddEditPageState();
}

class _FlowModalAddEditPageState extends State<FlowModalAddEditPage>{
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _codeController = new TextEditingController();
  TextEditingController _descriptionController = new TextEditingController();

  @override
  void initState() {
    if(widget.object!=null){
      _codeController.text = widget.object.code;
      _nameController.text = widget.object.name;
      _descriptionController.text = widget.object.description;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ObjectAddEditPage<Procedure>(
      object: widget.object,
      objectRepository: widget.objectRepository,
      objectCallback: (){
        if(widget.object!=null){
          widget.object.name = _nameController.text.toString();
          widget.object.code = _codeController.text.toString();
          widget.object.description = _descriptionController.text.toString();
          return widget.object;
        }else{
          Procedure procedure = new Procedure()..name=_nameController.text.toString()
            ..code=_codeController.text.toString()..description=_descriptionController.text.toString();
          return procedure;
        }
      },
      builder: (context){
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextFormField(
              controller:_codeController,
              validator: (value) {
                if (value.isEmpty) {
                  return "内容不能为空";
                }
                return null;
              },
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.mode_edit,
                  color: Theme.of(context).accentColor,
                ),
                labelText: '编号',
                //hintText: '名称',
                //border: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(20.0)),)
              ),
            ),
            TextFormField(
              controller:_nameController,
              validator: (value) {
                if (value.isEmpty) {
                  return "内容不能为空";
                }
                return null;
              },
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.mode_edit,
                  color: Theme.of(context).accentColor,
                ),
                labelText: '名称',
                //hintText: '名称',
                //border: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(20.0)),)
              ),
            ),
            TextFormField(
              controller:_descriptionController,
              validator: (value) {
                if (value.isEmpty) {
                  return "内容不能为空";
                }
                return null;
              },
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.mode_edit,
                  color: Theme.of(context).accentColor,
                ),
                labelText: '简称',
              ),
            ),
          ],
        );
      },
    );
  }
}

//enum FlowModalPageType{
//  CREATE,
//  MODIFY,
//  VIEW
//}
//
//class FlowModalPage extends StatefulWidget {
//  final FlowModalsRepository flowModalsRepository;
//  final Procedure procedure;
//  final FlowModalPageType flowModalPageType;
//  FlowModalPage({Key key, this.flowModalsRepository,this.procedure,this.flowModalPageType=FlowModalPageType.CREATE}) : super(key: key);
//  @override
//  State<StatefulWidget> createState() => _FlowModalAddState();
//}
//
//class _FlowModalAddState extends State<FlowModalPage> {
//  final _formKey = GlobalKey<FormState>();
//  TextEditingController _nameController = new TextEditingController();
//  TextEditingController _codeController = new TextEditingController();
//  TextEditingController _descriptionController = new TextEditingController();
//
//  _showDialog(String mention) {
//    showDialog(
//        builder: (context) => new AlertDialog(
//          title: new Text('提示'),
//          content: new Text('$mention成功'),
//          actions: <Widget>[
//            new FlatButton(
//                onPressed: () {
//                  Navigator.pop(context,true);
//                  Navigator.pop(context,true);
//                },
//                child: new Text('确定'))
//          ],
//        ),
//        context: context);
//  }
//
//  @override
//  void initState() {
//    if(widget.flowModalPageType==FlowModalPageType.MODIFY){
//      _nameController.text = widget.procedure.name;
//      _codeController.text = widget.procedure.code;
//      _descriptionController.text = widget.procedure.description;
//    }
//    super.initState();
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        title: Text(widget.flowModalPageType==FlowModalPageType.CREATE?'增加模型':"修改模型"),
//      ),
//      body: Form(
//        key: _formKey,
//        child: SingleChildScrollView(
//          child: Column(
//            mainAxisAlignment: MainAxisAlignment.start,
//            crossAxisAlignment: CrossAxisAlignment.stretch,
//            children: <Widget>[
//              TextFormField(
//                controller: _codeController,
//                validator: (value) {
//                  if (value.isEmpty) {
//                    return "内容不能为空";
//                  }
//                  return null;
//                },
//                decoration: InputDecoration(
//                  prefixIcon: Icon(
//                    Icons.code,
//                    color: Theme.of(context).accentColor,
//                  ),
//                  labelText: '编号',
//                  //hintText: '编号',
//                  //border: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(20.0)),)
//                ),
//              ),
//              TextFormField(
//                controller: _nameController,
//                validator: (value) {
//                  if (value.isEmpty) {
//                    return "内容不能为空";
//                  }
//                  return null;
//                },
//                decoration: InputDecoration(
//                  prefixIcon: Icon(
//                    Icons.mode_edit,
//                    color: Theme.of(context).accentColor,
//                  ),
//                  labelText: '名称',
//                  //hintText: '名称',
//                  //border: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(20.0)),)
//                ),
//              ),
//              TextFormField(
//                controller: _descriptionController,
//                validator: (value) {
//                  if (value.isEmpty) {
//                    return "内容不能为空";
//                  }
//                  return null;
//                },
//                decoration: InputDecoration(
//                  prefixIcon: Icon(
//                    Icons.comment,
//                    color: Theme.of(context).accentColor,
//                  ),
//                  labelText: '备注',
//                  //hintText: '备注',
//                  //border: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(20.0)),)
//                ),
//              ),
//              SizedBox(
//                height: 20,
//              ),
//              Builder(
//                builder: (context) {
//                  return RaisedButton(
//                      color: Theme.of(context).accentColor,
//                      child: Text("确认"),
//                      shape: RoundedRectangleBorder(
//                          borderRadius: BorderRadius.all(Radius.circular(20)),
//                          side: BorderSide(
//                              color: Color(0xFFFFF00F),
//                              style: BorderStyle.solid,
//                              width: 2)),
//                      onPressed: () async {
//                        if (_formKey.currentState.validate()) {
//                          Procedure procedure = Procedure();
//                          procedure.code = _codeController.text.toString();
//                          procedure.name = _nameController.text.toString();
//                          procedure.description =
//                              _descriptionController.text.toString();
//
//                          bool flag = false;
//                          if(widget.flowModalPageType==FlowModalPageType.CREATE){
//                           flag =
//                              await widget.flowModalsRepository.create(procedure: procedure);}
//                          else{
//                            procedure.id = widget.procedure.id;
//                            flag =
//                            await widget.flowModalsRepository.put(procedure: procedure);
//                          }
//                          if (flag) {
//                            //Navigator.pop(context, flag);
//                            _showDialog("创建");
//                          } else {
//                            SnackBarUtil.fail(
//                                context: context, message: "提交失败");
//                          }
//                        }
//                      });
//                },
//              )
//            ],
//          ),
//        ),
//      ),
//    );
//  }
//}
