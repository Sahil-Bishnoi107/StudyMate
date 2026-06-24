import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

Widget homePageChart(double height,double width,List<int> data)
{
  int n = data.length;
  return SizedBox(
    height: height*0.2, width: width*0.9,
    
    child: LineChart(
      LineChartData(
        minY: -0.5, maxY: 100.5,
        titlesData: FlTitlesData(

        leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: false,
          interval: 25,
        ),
      ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false
          )
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false
          )
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            interval: 1,
            showTitles: false
          )
        )
        ),

      gridData: FlGridData(
        drawVerticalLine: false,
        horizontalInterval: 25,
        
        
      ),  
      borderData: FlBorderData(
        show: false
      ),
      lineBarsData: [
        LineChartBarData(
         spots:[ FlSpot(1,n > 0 ? data[n-1].toDouble() : 0) , FlSpot(2, n > 1 ? data[n-2].toDouble() : 0), FlSpot(3,n > 2 ? data[n-3].toDouble() : 0),
                 FlSpot(4,n > 3 ? data[n-4].toDouble() : 0), FlSpot(5,n > 4 ? data[n-5].toDouble() : 0), FlSpot(6,n > 5 ? data[n-6].toDouble() : 0),
                 FlSpot(7,n > 6 ? data[n-7].toDouble() : 0) 
          ],
          isCurved: true,
          color: Colors.green,
          barWidth: 3,
          dotData: FlDotData(show: false),
          
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              begin: Alignment.topCenter, end: Alignment.bottomCenter,
              colors: [
                const Color.fromRGBO(76, 175, 80, 0.4),
                const Color.fromRGBO(76, 175, 80, 0.2),
                const Color.fromRGBO(255, 255, 255, 0)
              ],
              stops: [0, 0.5, 1]
              
              )
          )
        )
      ]
    )),
  );
}