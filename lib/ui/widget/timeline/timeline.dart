import 'package:flutter/material.dart';
import 'package:manufacture/ui/widget/timeline/model/timeline_model.dart';
import 'timeline_element.dart';
typedef TimeLineComponentCallback = void Function(TimelineModel model);
class TimelineComponent extends StatefulWidget {

  final List<TimelineModel> timelineList;

  final Color lineColor;

  final Color backgroundColor;

  final Color headingColor;

  final Color descriptionColor;

  final TimeLineComponentCallback callback;

  const TimelineComponent({Key key, this.timelineList, this.lineColor, this.backgroundColor, this.headingColor, this.descriptionColor, this.callback}) : super(key: key);

  @override
  TimelineComponentState createState() {
    return new TimelineComponentState();
  }
}



class TimelineComponentState extends State<TimelineComponent> with SingleTickerProviderStateMixin{

  Animation<double> animation;
  AnimationController controller;
  double fraction = 0.0;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 1000),
        vsync: this);
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new ListView.builder(
        itemCount: widget.timelineList.length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (_, index) {
          return new GestureDetector(
            onTap: (){
              if(widget.callback != null) {
                widget.callback(widget.timelineList[index]);
              }

              if(widget.timelineList[index].onPressed!=null) {
                widget.timelineList[index].onPressed();
              }

            },
            child: TimelineElement(
              lineColor: widget.lineColor==null?Theme.of(context).accentColor:widget.lineColor,
              backgroundColor: widget.backgroundColor==null?Colors.white:widget.backgroundColor,
              model: widget.timelineList[index],
              firstElement: index==0,
              lastElement: widget.timelineList.length==index+1,
              controller: controller,
              headingColor: widget.headingColor,
              descriptionColor: widget.descriptionColor,
            )
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

}