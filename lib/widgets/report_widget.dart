import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ReportWidget extends StatelessWidget {
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
      body: Center(
        child: Text(
          'Report Widget',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
