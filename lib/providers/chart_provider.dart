import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class ChartProvider extends ChangeNotifier {
  Map<DateTime, Map<int, double>> chartEntries = new Map();

  Future<void> getChartEntries() async {
    var queryParameters = {'method': 'chart_30d'};
    var uri = Uri.https(
        "script.google.com",
        "/macros/s/AKfycbz-ZsZl2bBIpc2mGTSLNHt0ad-vDYbz90NQrH1r3h24BAMQMzgxWt_2Mu-ks1sQlx4Q/exec",
        queryParameters);

    await http.get(uri).then((resp) {
      this.chartEntries.clear();
      Map jsonList = convert.jsonDecode(resp.body);
      jsonList.forEach((key, value) {
        var date = new DateTime.fromMicrosecondsSinceEpoch(int.parse(key)*1000);
        chartEntries[date] = new Map<int, double>();
        if (value[0].runtimeType == int) {
          chartEntries[date]![0] = value[0].toDouble();
        } else {
          chartEntries[date]![0] = value[0];
        }
        if (value[1].runtimeType == int) {
          chartEntries[date]![1] = value[1].toDouble();
        } else {
          chartEntries[date]![1] = value[1];
        }
        if (value[2].runtimeType == int) {
          chartEntries[date]![2] = value[2].toDouble();
        } else {
          chartEntries[date]![2] = value[2];
        }
        if (value[3].runtimeType == int) {
          chartEntries[date]![3] = value[3].toDouble();
        } else {
          chartEntries[date]![3] = value[3];
        }
      });
    });
    print(chartEntries);
  }

  Future<void> drillDownByDate(DateTime date) async{
    int start = double.parse(this.chartEntries[date]![2].toString()).toInt();
    int end = double.parse(this.chartEntries[date]![3].toString()).toInt();
    var queryParameters = {'method': 'chart_24h', 'start':start.toString(), 'end':end.toString()};
    var uri = Uri.https(
        "script.google.com",
        "/macros/s/AKfycbz-ZsZl2bBIpc2mGTSLNHt0ad-vDYbz90NQrH1r3h24BAMQMzgxWt_2Mu-ks1sQlx4Q/exec",
        queryParameters);

    await http.get(uri).then((resp) {
      this.chartEntries.clear();
      Map jsonList = convert.jsonDecode(resp.body);
      jsonList.forEach((key, value) {
        var date = new DateTime.fromMicrosecondsSinceEpoch(int.parse(key)*1000);
        chartEntries[date] = new Map<int, double>();
        if (value[0].runtimeType == int) {
          chartEntries[date]![0] = value[0].toDouble();
        } else {
          chartEntries[date]![0] = value[0];
        }
        if (value[1].runtimeType == int) {
          chartEntries[date]![1] = value[1].toDouble();
        } else {
          chartEntries[date]![1] = value[1];
        }
      });
    });
  }
}
