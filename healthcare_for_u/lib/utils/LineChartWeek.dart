import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'LineSeries.dart';


class LineChartWeek extends StatelessWidget {
  //This class is defined in order to display the weekly graph with charts_flutter
  final List<LineSeries> data;

  LineChartWeek({required this.data});
  @override
  Widget build(BuildContext context) {
    List<charts.Series<LineSeries, num>> series = [
      charts.Series(
        id: "Steps",
        data: data,
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (LineSeries series, _) => series.day,
        measureFn: (LineSeries series, _) => series.steps,
      )
    ];

    return Container(
      height: 300,
      padding: EdgeInsets.all(25),
      child: Card(
        child: Padding(padding: const EdgeInsets.all(9.0) ,
        child: Column(children: <Widget>[
          Expanded(child: charts.LineChart(series,animate: true, 
                //domainAxis is used to set the x-axis
                domainAxis: const charts.NumericAxisSpec(viewport: charts.NumericExtents(1,7),
                tickProviderSpec: charts.BasicNumericTickProviderSpec( 
                zeroBound: false,
                desiredMaxTickCount: 7,
               ))  , 
          defaultRenderer: charts.LineRendererConfig(includePoints: true), 
          //primaryMeasureAxis is used to set the y-axis
          primaryMeasureAxis: const charts.NumericAxisSpec(
                  tickProviderSpec: charts.BasicNumericTickProviderSpec(
                  dataIsInWholeNumbers: true,
                 desiredTickCount: 7)),
                  
))
          ]),)
      )
    );
  }
}