import 'package:flutter/material.dart';
import 'package:manufacture/beans/organization.dart';
import 'package:manufacture/data/repository/object_repository.dart';
import '../../core/object_add_edit_page.dart';

class OrganizationAddEditPage extends StatefulWidget{
  final Organization organization;
  final ObjectRepository<Organization> objectRepository;
  OrganizationAddEditPage({Key key, this.organization,this.objectRepository}):super(key:key);
  @override
  State<StatefulWidget> createState() => _OrganizationAddEditPageState();
}

class _OrganizationAddEditPageState extends State<OrganizationAddEditPage>{
  TextEditingController _codeController = new TextEditingController();
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _shortController = new TextEditingController();

  @override
  void initState() {
    if(widget.organization!=null){
      _codeController.text = widget.organization.code;
      _nameController.text = widget.organization.name;
      _shortController.text = widget.organization.short;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ObjectAddEditPage<Organization>(
       object: widget.organization,
       objectRepository: widget.objectRepository,
       objectCallback: (){
         if(widget.organization!=null){
            widget.organization.name = _nameController.text.toString();
            widget.organization.code = _codeController.text.toString();
            widget.organization.short = _shortController.text.toString();
            return widget.organization;
         }else{
           Organization organization = new Organization()..name=_nameController.text.toString()
         ..code=_codeController.text.toString()..short=_shortController.text.toString();
           return organization;
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
               controller:_shortController,
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