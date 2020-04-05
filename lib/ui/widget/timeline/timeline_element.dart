import 'package:flutter/material.dart';
import 'package:manufacture/ui/widget/timeline/model/timeline_model.dart';
import 'timeline_painter.dart';

class TimelineElement extends StatelessWidget {

  final Color lineColor;
  final Color backgroundColor;
  final TimelineModel model;
  final bool firstElement;
  final bool lastElement;
  final Animation<double> controller;
  final Color headingColor;
  final Color descriptionColor;

  TimelineElement({
    @required this.lineColor,
    @required this.backgroundColor,
    @required this.model,
    this.firstElement = false,
    this.lastElement = false,
    this.controller,
    this.headingColor,
    this.descriptionColor
  });

  Widget _buildLine(BuildContext context, Widget child) {
    return new Container(
      width: 40.0,
      child: new CustomPaint(
        painter: new TimelinePainter(
            lineColor: model.titleColor!=null?model.titleColor:lineColor,
            backgroundColor: backgroundColor,
            firstElement: firstElement,
            lastElement: lastElement,
            controller: controller
        ),
      ),
    );
  }

  Widget _buildContentColumn(BuildContext context) {
    return new Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new Container(
          padding: const EdgeInsets.only(bottom: 8.0, top: 8.0),
          child: new Text(
            model.title.length>47?model.title.substring(0,47)+"...":model.title,
            style: new TextStyle(
              fontWeight: FontWeight.bold,
              color: model.titleColor!=null?model.titleColor:(headingColor!=null?headingColor:Colors.black),
            ),
          ),
        ),
        new Expanded(
          child: model.customWidget!=null?model.customWidget:new Text(
            model.description!=null?(model.description.length>50?model.description.substring(0,50)+"...":model.description):"", // To prevent overflowing of text to the next element, the text is truncated if greater than 75 characters
            style: new TextStyle(
              color: descriptionColor!=null?descriptionColor:Colors.grey,
            ),
          ),
        )
      ],
    );
  }

  Widget _buildRow(BuildContext context)
  {
    return new Container(
      height: 80.0,
      color: backgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            width: 12,
            padding: const EdgeInsets.only(left: 2),
            child: Builder(builder: (context){
              if(model.isCurrent){
                if(model.currentIcon!=null){
                  return model.currentIcon;
                }else{
                  return Icon(Icons.directions_car, color:Colors.green,);
                }
              }else{
                return Container();
              }
            }),
          ),
          new AnimatedBuilder(
            builder: _buildLine,
            animation: controller,
          ),
          new Expanded(
            child: _buildContentColumn(context),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildRow(context);
  }
}