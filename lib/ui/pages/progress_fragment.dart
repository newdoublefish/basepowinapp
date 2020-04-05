import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:manufacture/bloc/project_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Progress extends StatelessWidget {
  final List<LinearProducts> data = [
  new LinearProducts("已完成", 0),
  new LinearProducts("未完成", 0),
  ];
  final bool animate;
  final ProjectBloc projectBloc;

  Progress({this.animate, this.projectBloc});

  /// Creates a [PieChart] with sample data and no transition.
  factory Progress.withSampleData(ProjectBloc bloc) {
    return new Progress(
      // Disable animations for image tests.
      animate: false,
      projectBloc: bloc,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProjectBloc, ProjectState>(
        bloc: projectBloc,
        builder: (BuildContext context, ProjectState state) {
          return new charts.PieChart(_createData(data),
              animate: animate,
              defaultRenderer: new charts.ArcRendererConfig(
                  arcWidth: 100,
                  arcRendererDecorators: [new charts.ArcLabelDecorator()]));
        });

  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<LinearProducts, String>> _createData(List<LinearProducts> data) {
    return [
      new charts.Series<LinearProducts, String>(
        id: 'Sales',
        domainFn: (LinearProducts sales, _) => sales.name,
        measureFn: (LinearProducts sales, _) => sales.count,
        displayName: "完成情况",
        data: data,
        // Set a label accessor to control the text of the arc label.
        labelAccessorFn: (LinearProducts row, _) => '${row.name}: ${row.count}',
      )
    ];
  }
}

/// Sample linear data type.
class LinearProducts {
  final String name;
  int count;

  LinearProducts(this.name, this.count);
}
