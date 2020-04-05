import 'package:flutter/material.dart';

const Color _kErrorLight = Colors.red;
final Color _kErrorDark = Colors.red.shade400;
const Color _kCircleActiveLight = Colors.white;
const Color _kCircleActiveDark = Colors.black87;
const Color _kDisabledLight = Colors.black38;
const Color _kDisabledDark = Colors.white38;
const double _kStepSize = 24.0;
const double _kTriangleHeight = _kStepSize * 0.866025; // Triangle height. sqrt(3.0) / 2.0

class Station {
  final String title;
  final Widget content;
  final Color color;
  final Icon customIcon;
  final IndexedWidgetBuilder actionBuilder;
  final GestureTapCallback onTap;
  Station({this.title,this.content,this.color,this.customIcon,this.actionBuilder,this.onTap});

  @override
  String toString() {
    return super.toString();
  }
}

class RailWay extends StatefulWidget {
  final List<Station> stations;
  final IndexedWidgetBuilder actionBuilder;
  final ScrollPhysics physics;
  RailWay({Key key, this.stations, this.actionBuilder,this.physics = const AlwaysScrollableScrollPhysics()}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _RailWay();
}

class _RailWay extends State<RailWay> {
  Widget _buildLine(bool visible) {
    return Container(
      width: visible ? 1.0 : 0.0,
      height: 16.0,
      color: Colors.grey.shade400,
    );
  }

  Widget _buildCircle(int index, bool oldState) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      width: _kStepSize,
      height: _kStepSize,
      child: widget.stations[index].customIcon!=null?widget.stations[index].customIcon:AnimatedContainer(
        curve: Curves.fastOutSlowIn,
        duration: kThemeAnimationDuration,
        decoration: BoxDecoration(
          //color: Theme.of(context).accentColor,
          color: widget.stations[index].color!=null?widget.stations[index].color:Theme.of(context).accentColor,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
          '${index + 1}',
            style: TextStyle(color: Colors.white),
        ),
        ),
      ),
    );
  }

  Widget _buildIcon(int index) {
    return _buildCircle(index, false);
  }

  bool _isFirst(int index) {
    return index == 0;
  }

  bool _isLast(int index) {
    return widget.stations.length - 1 == index;
  }

  Widget _buildHeaderText(int index) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(widget.stations[index].title),
      ],
    );
  }

  Widget _buildVerticalHeader(int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        children: <Widget>[
          Column(
            children: <Widget>[
              // Line parts are always added in order for the ink splash to
              // flood the tips of the connector lines.
              _buildLine(!_isFirst(index)),
              _buildIcon(index),
              _buildLine(!_isLast(index)),
            ],
          ),
          Container(
            margin: const EdgeInsetsDirectional.only(start: 12.0),
            child: _buildHeaderText(index),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.bottomRight,
              //child: widget.actionBuilder!=null?widget.actionBuilder(context,index):Container(),
              child: widget.stations[index].actionBuilder!=null?widget.stations[index].actionBuilder(context,index):widget.actionBuilder!=null?widget.actionBuilder(context,index):Container(),
              //child: widget.stations.!=null?widget.extraAction:Container(),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildVerticalBody(int index) {
    return Stack(
      children: <Widget>[
        PositionedDirectional(
          start: 24.0,
          top: 0.0,
          bottom: 0.0,
          child: SizedBox(
            width: 24.0,
            child: Center(
              child: SizedBox(
                width: _isLast(index) ? 0.0 : 1.0,
                child: Container(
                  color: Colors.grey.shade400,
                ),
              ),
            ),
          ),
        ),
        Container(
          margin: const EdgeInsetsDirectional.only(
            start: 50.0,
//            end: 24.0,
//            bottom: 24.0,
          ),
          child: widget.stations[index].content,
//          child: Column(
//            mainAxisAlignment: MainAxisAlignment.start,
//            crossAxisAlignment: CrossAxisAlignment.stretch,
//            children: <Widget>[
//              widget.stations[index].content,
//            ],
//          ),
        ),
      ],
    );
  }

  _buildVertical() {
    final List<Widget> children = <Widget>[];
    for (int i = 0; i < widget.stations.length; i += 1) {
      children.add(Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _buildVerticalHeader(i),
          _buildVerticalBody(i),
        ],
      ));
    }

      print(children.length);

      return ListView(
        shrinkWrap: true,
        //physics: NeverScrollableScrollPhysics(),
        physics: widget.physics,
        children: children,
      );
  }

  @override
  Widget build(BuildContext context) {
    return _buildVertical();
  }
}
