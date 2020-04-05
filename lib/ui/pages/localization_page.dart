import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalizationPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => LocalizationPageState();
}

class LocalizationPageState extends State<LocalizationPage>{
  int selectedValue=1;

  _init() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedValue = prefs.getInt("locale");
    });
  }

  @override
  void initState()
  {
    super.initState();
    _init();

  }

  void updateGroupValue(int v){
    setState(() {
      selectedValue=v;
    });
  }

  Widget _buildRadioRow(String title,int value)
  {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: 20),
            child: Text(title),
          ),
          Radio(
            value: value,
            groupValue: selectedValue,
            activeColor: Colors.red,
            onChanged: (T){
              updateGroupValue(T);
            },
          ),
        ],
      );
  }

  _saveLang() async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt("locale", selectedValue);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text('语言选择'),actions: <Widget>[
        MaterialButton(
          child: Text('确定',style: TextStyle(color: Colors.white),),
          onPressed: (){
            //widget.callback(selectedValue);

            print("---ontap $selectedValue");
            if(selectedValue == 1)
            {
              FlutterI18n.refresh(context, "zh_CH");//如切换英语
            }else if(selectedValue == 2){
              FlutterI18n.refresh(context, "en_US");//如切换英语
            }
            _saveLang();
            Navigator.pop(context);
          },
        )
      ],),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _buildRadioRow("中文",1),
          _buildRadioRow("英文",2),
        ],
      ),
    );
  }
}