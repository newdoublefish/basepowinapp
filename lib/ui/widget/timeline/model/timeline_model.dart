import 'package:flutter/material.dart';
class TimelineModel {
  //final String id;
  final String title;
  final Color titleColor;
  final String description;
  final Widget customWidget;
  final bool isCurrent;
  final Icon currentIcon;
  final VoidCallback onPressed;

  const TimelineModel({this.title, this.titleColor, this.description,this.customWidget,this.isCurrent,this.onPressed,this.currentIcon});
}