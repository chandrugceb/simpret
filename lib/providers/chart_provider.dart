import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class ChartProvider extends ChangeNotifier {
  Map<DateTime, double> chartEntries = new Map();

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
        if (value.runtimeType == int) {
          chartEntries[date] = value.toDouble();
        } else {
          chartEntries[date] = value;
        }
      });
    });
  }
}
