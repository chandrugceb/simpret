/// Horizontal bar chart example
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HorizontalBarChart extends StatelessWidget {
  final List<charts.Series<DailySales, String>> seriesList;
  Function(DateTime) drillDownByDate;
  bool animate = true;

  HorizontalBarChart(this.seriesList, {required this.animate, required this.drillDownByDate});

  /// Creates a [BarChart] with sample data and no transition.
  factory HorizontalBarChart.withChartData(Map<DateTime, Map<int, double>> rawData, Function(DateTime) drillDownByDate) {
    return new HorizontalBarChart(
      chartData(rawData),
      animate: true,
      drillDownByDate: drillDownByDate,
    );
  }

  @override
  Widget build(BuildContext context) {
    // For horizontal bar charts, set the [vertical] flag to false.
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 5, 50,5),
      child: new charts.BarChart(
        seriesList,
        animate: animate,
        vertical: false,
        barRendererDecorator: new charts.BarLabelDecorator<String>(
            labelPosition: charts.BarLabelPosition.outside
        ),
        barGroupingType: charts.BarGroupingType.stacked,
        behaviors: [new charts.PanAndZoomBehavior()],
        selectionModels: [
          charts.SelectionModelConfig(
              changedListener: (charts.SelectionModel model) {
                if(model.hasDatumSelection)
                  print(model.selectedSeries[0].data[model.selectedDatum[0].index].date);
                if(model.selectedSeries[0].data.length > 24 ){
                  this.drillDownByDate(model.selectedSeries[0].data[model.selectedDatum[0].index].date);
                }
              }
          )
        ],
      ),
    );
  }

  static List<charts.Series<DailySales, String>> chartData(
      Map<DateTime, Map<int, double>> rawData) {
    final DateFormat formatter;
    if(rawData.length > 24){
      formatter = DateFormat('MMM-d');
    }else{
      formatter = DateFormat('h a');
    }

    var data = <DailySales>[];
    rawData.forEach((key, value) {
      double paid, total;
      paid = value[0]??0;
      total = value[1]??0;
      data.add(new DailySales(key, paid, total));
    });

    return [
      new charts.Series<DailySales, String>(
        id: 'Paid',
        domainFn: (DailySales sales, _) => formatter.format(sales.date),
        measureFn: (DailySales sales, _) => sales.paid,
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        data: data,
        labelAccessorFn: (DailySales sales, _) => "",
      ),
      new charts.Series<DailySales, String>(
        id: 'loan',
        domainFn: (DailySales sales, _) => formatter.format(sales.date),
        measureFn: (DailySales sales, _) => sales.loan,
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        data: data,
        labelAccessorFn: (DailySales sales, _) => "",
      ),
      new charts.Series<DailySales, String>(
        id: 'excess',
        domainFn: (DailySales sales, _) => formatter.format(sales.date),
        measureFn: (DailySales sales, _) => sales.excess,
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        data: data,
        labelAccessorFn: (DailySales sales, _) => '${getCurrencyLabelText(sales)}',
      )
    ];
  }

  static String getCurrencyLabelText(DailySales sales){
    String paidText = "";
    String totalText = "";

    double paid = sales.paid + sales.excess;
    double total = sales.total;

    if (paid > 0) {
      if(paid > 1000 && paid < 100000){
        paidText = '₹${(paid/1000).toStringAsFixed(0)}K';
      }
      else if(paid >= 100000){
        paidText = '₹${(paid/100000).toStringAsFixed(2)}L';
      }
      else if(paid >= 10000000){
        paidText = '₹${(paid/10000000).toStringAsFixed(2)}C';
      }
      else{
        paidText = '₹${paid.toStringAsFixed(0)}';
      }
    }
    if (total > 0) {
      if(total > 1000 && total < 100000){
        totalText = '₹${(total/1000).toStringAsFixed(0)}K';
      }
      else if(total >= 100000){
        totalText = '₹${(total/100000).toStringAsFixed(2)}L';
      }
      else if(total >= 10000000){
        totalText = '₹${(total/10000000).toStringAsFixed(2)}C';
      }
      else{
        totalText = '₹${total.toStringAsFixed(0)}';
      }
    }

    if(paidText != "" && totalText !=""){
      return paidText + " / " + totalText;
    }
    return "";
  }
}

class DailySales {
  final DateTime date;
  double paid;
  final double total;
  double loan = 0;
  double excess = 0;

  DailySales(this.date, this.paid, this.total){
    if(total == paid){
      loan = 0;
      excess = 0;
    }
    else if(total > paid){
      loan = total - paid;
      excess = 0;
    }
    else{
      loan = 0;
      excess = paid - total;
      paid = paid - excess;
    }
  }
}

//some dummy commit