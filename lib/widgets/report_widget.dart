import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simpret/providers/chart_provider.dart';
import 'package:simpret/widgets/horizontalbar_widget.dart';

class ReportWidget extends StatefulWidget {

  late ChartProvider chartProvider;

  @override
  _ReportWidgetState createState() => _ReportWidgetState();
}

class _ReportWidgetState extends State<ReportWidget> {
  bool isLoading = true;
  static const spinkit = SpinKitRotatingCircle(
    color: Colors.blue,
    size: 100.0,
  );

  @override
  void initState() {
    getChart();
    super.initState();
  }

  Future<void> getChart() async{
    widget.chartProvider = new ChartProvider();
    await widget.chartProvider.getChartEntries();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "balki",
            style: GoogleFonts.righteous(
              textStyle: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 40,
                  letterSpacing: 10),
            ),
          ),
        ),
      ),
      body: isLoading? spinkit:HorizontalBarChart.withChartData(widget.chartProvider.chartEntries),
      /*
      Center(
        child: Text(
          'Report Widget',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
      ), */
    );
  }
}
