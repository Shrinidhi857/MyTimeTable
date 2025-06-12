import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mytimetable/components/colorchangingfont.dart';
import 'package:mytimetable/helper/chartdata.dart';
import 'package:syncfusion_flutter_charts/charts.dart';


class StatPage extends StatelessWidget {
  const StatPage({super.key});


  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;


    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text("Statistics", style: GoogleFonts.roboto(
          color: Theme.of(context).colorScheme.inversePrimary,
          fontWeight: FontWeight.w900,
          fontSize: 25,
          )
        )
      ),
      body:  SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Container(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Circular Chart
                    SfCircularChart(
                      series: <RadialBarSeries<ChartData, int>>[
                        RadialBarSeries<ChartData, int>(
                          useSeriesColor: true,
                          trackOpacity: 0.3,
                          cornerStyle: CornerStyle.bothCurve,
                          dataSource: chartData,
                          pointRadiusMapper: (ChartData data, _) => data.text,
                          pointColorMapper: (ChartData data, _) => data.color,
                          xValueMapper: (ChartData sales, _) => sales.x,
                          yValueMapper: (ChartData sales, _) => sales.y,
                        ),
                      ],
                    ),
                    // Centered Image
                    Positioned(
                      child: Container(
                        padding: EdgeInsets.all(20), // Adjust padding if necessary
                        alignment: Alignment.center,
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: user?.photoURL != null ? NetworkImage(user!.photoURL!) : null,
                          backgroundColor: Colors.grey,
                          child: user?.photoURL == null ? Icon(Icons.person, size: 50, color: Colors.white) : null,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.all(12),
                height: 150,
                width: 400,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.secondary,
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Attended classes",
                          style: GoogleFonts.robotoSlab(
                            color: Theme.of(context).colorScheme.secondary,
                            fontWeight: FontWeight.w900,
                            fontSize: 15,
                          ),
                        ),
                        colorChangingText(
                          text: "000",
                          fontSize: 60,
                          fontWeight: FontWeight.w900,
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "000",
                          style: GoogleFonts.roboto(
                            color: Theme.of(context).colorScheme.inversePrimary,
                            fontWeight: FontWeight.w900,
                            fontSize: 25,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
