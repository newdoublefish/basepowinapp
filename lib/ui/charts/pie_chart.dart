import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'dart:math';

class PieItem {
  final String name;
  final Color color;
  final int count;
  PieItem({this.name, this.color, this.count});
}

class PiePositive extends PieItem {
  PiePositive({String name, Color color = Colors.green, int count})
      : super(name: name, color: color, count: count);
}

class PieNegative extends PieItem {
  PieNegative({String name, Color color = Colors.red, int count})
      : super(name: name, color: color, count: count);
}

class PieCharts extends StatelessWidget {
  //final List<charts.Series> seriesList;
  final bool animate;
  final PiePositive piePositive;
  final PieNegative pieNegative;

  PieCharts({this.piePositive, this.pieNegative, this.animate});

  @override
  Widget build(BuildContext context) {
    List<charts.Series> seriesList = [
      new charts.Series<PieItem, String>(
        id: 'Sales',
        domainFn: (PieItem sales, _) => sales.name,
        measureFn: (PieItem sales, _) => sales.count,
        data: [piePositive, pieNegative],
      )
    ];

    return Stack(
      children: <Widget>[
        new charts.PieChart(seriesList,
            animate: animate,
            defaultRenderer: new charts.ArcRendererConfig(
                arcWidth: 30, startAngle: 4 / 5 * pi, arcLength: 7 / 5 * pi)),
        Align(
          alignment: Alignment.center,
          child: Text(
            '${((piePositive.count * 100) / (piePositive.count + pieNegative.count)).toInt()}%',
            style: TextStyle(fontSize: 18),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Icon(
                    Icons.insert_chart,
                    color: pieNegative.color,
                  ),
                  Text('${pieNegative.name}: ${pieNegative.count}'),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Icon(
                    Icons.insert_chart,
                    color: piePositive.color,
                  ),
                  Text('${piePositive.name}: ${piePositive.count}'),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}