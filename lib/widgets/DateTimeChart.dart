import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:schedular/bloc/PlanBloc.dart';
import 'package:schedular/bloc/PlanListBloc.dart';
import 'package:schedular/utils/Provider.dart';

class DateTimeChart extends StatelessWidget {
  List<charts.Series<PlanBloc, DateTime>> _getSeries(
      List<PlanBloc> planListBloc) {
    //* Sorting the planbloc based on the start time
    List<PlanBloc> sortedList = planListBloc.map((element) => element).toList();
    sortedList.sort((PlanBloc arg1, PlanBloc arg2) {
      if (arg1.getFromTime().isBefore(arg2.getFromTime())) return (-1);
      return (1);
    });
    return [
      new charts.Series<PlanBloc, DateTime>(
        id: 'Statistics',
        data: sortedList,
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        //* This is x-axis
        domainFn: (PlanBloc planBloc, _) => planBloc.getFromTime(),
        //* This is the y-axis
        measureFn: (PlanBloc planBloc, _) => planBloc.getRating(),
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    final PlanListBloc _planListBloc = Provider.of<PlanListBloc>(context);
    return Scaffold(
      body: StreamBuilder<List<PlanBloc>>(
          stream: _planListBloc.allPlanObservable,
          builder: (context, AsyncSnapshot<List<PlanBloc>> snapshot) {
            return (snapshot.hasData
                ? charts.TimeSeriesChart(
                    this._getSeries(snapshot.data),
                    animate: true,
                    defaultRenderer: new charts.LineRendererConfig<DateTime>(
                        includePoints: true),
                    dateTimeFactory: const charts.LocalDateTimeFactory(),
                    primaryMeasureAxis: charts.AxisSpec(showAxisLine: true),
                    //secondaryMeasureAxis: charts.AxisSpec(showAxisLine: true),
                    // domainAxis: charts.DateTimeAxisSpec(
                    //     showAxisLine: true,
                    //     tickFormatterSpec: charts.AutoDateTimeTickFormatterSpec(
                    //       hour: charts.TimeFormatterSpec(),
                    //       //minute: charts.TimeFormatterSpec(format: 'm'),
                    //       //`day : charts.TimeFormatterSpec(format: "")
                    //     )),
                    behaviors: [
                      new charts.SlidingViewport(),
                      new charts.PanAndZoomBehavior(),
                    ],
                  )
                : Container());
          }),
    );
  }
}
