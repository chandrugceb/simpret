/// Horizontal bar chart example
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HorizontalBarChart extends StatelessWidget {
  final List<charts.Series<OrdinalSales, String>> seriesList;
  bool animate = true;

  HorizontalBarChart(this.seriesList, {required this.animate});

  /// Creates a [BarChart] with sample data and no transition.
  factory HorizontalBarChart.withChartData(Map<DateTime, double> rawData) {
    return new HorizontalBarChart(
      chartData(rawData),
      animate: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    // For horizontal bar charts, set the [vertical] flag to false.
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: new charts.BarChart(
        seriesList,
        animate: animate,
        vertical: false,
        barRendererDecorator: new charts.BarLabelDecorator<String>(),
      ),
    );
  }

  static List<charts.Series<OrdinalSales, String>> chartData(
      Map<DateTime, double> rawData) {
    final DateFormat formatter = DateFormat('MMM-dd');
    var data = <OrdinalSales>[];
    rawData.forEach((key, value) {
      data.add(new OrdinalSales(key, value));
    });
    return [
      new charts.Series<OrdinalSales, String>(
          id: 'Sales',
          domainFn: (OrdinalSales sales, _) => formatter.format(sales.date),
          measureFn: (OrdinalSales sales, _) => sales.sales,
          data: data,
          labelAccessorFn: (OrdinalSales sales, _) {
            if (sales.sales > 0) {
              return '${NumberFormat.currency(locale: 'HI', symbol: "₹").format(sales.sales)}';
            } else {
              return "";
            }
          })
    ];
  }
}

class OrdinalSales {
  final DateTime date;
  final double sales;

  OrdinalSales(this.date, this.sales);
}
