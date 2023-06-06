import 'dart:math';

import 'package:acoustics_repository/acoustics_repository.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graph_test/heart_rate/bloc/heart_rate_bloc.dart';

class HeartRate extends StatelessWidget {
  const HeartRate({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DefaultTextStyle.merge(
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              child: const Text('Combined Tone'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey, // Border color
                    width: 2.0, // Border width
                  ),
                ),
                child: const HeartRateView()),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DefaultTextStyle.merge(
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                child: const Text('Short-time PSD')),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey, // Border color
                    width: 2.0, // Border width
                  ),
                ),
                child: const STPSDView()),
          ),
        ],
      ),
    );
  }
}

class HeartRateView extends StatelessWidget {
  const HeartRateView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AspectRatio(
          aspectRatio: 3,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: BlocBuilder<HeartRateBloc, HeartRateState>(
              builder: (context, state) {
                final data = state.chartData;
                // Calculate dynamic min and max y-values
                double minY = double.infinity;
                double maxY = double.negativeInfinity;
                for (final spot in data) {
                  if (!spot.y.isNaN) {
                    minY = min(minY, spot.y);
                    maxY = max(maxY, spot.y);
                  } else {
                    minY = 0;
                    maxY = 100;
                  }
                }

                // Adjust min and max y-values for better visualization
                minY = max(0, minY - 10);
                maxY = maxY + 10;
                return LineChart(
                  LineChartData(
                    minY: -10,
                    maxY: 10,
                    minX: data.isNotEmpty ? data.first.x : 0,
                    maxX: data.isNotEmpty ? data.last.x : 0,
                    lineTouchData: LineTouchData(enabled: false),
                    clipData: FlClipData.all(),
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                    ),
                    borderData: FlBorderData(show: false),
                    titlesData: FlTitlesData(
                      show: false,
                    ),
                    lineBarsData: [
                      LineChartBarData(
                        spots: state.chartData,
                        dotData: FlDotData(
                          show: false,
                        ),
                        gradient: LinearGradient(
                          colors: [Colors.red.withOpacity(0), Colors.red],
                          stops: const [0.1, 1.0],
                        ),
                        barWidth: 4,
                        isCurved: false,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class STPSDView extends StatelessWidget {
  const STPSDView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 200,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: BlocBuilder<HeartRateBloc, HeartRateState>(
              builder: (context, state) {
                final data = state.stpsdData;

                // Calculate dynamic min and max y-values
                double minY = double.infinity;
                double maxY = double.negativeInfinity;
                for (final spot in data) {
                  if (!spot.y.isNaN) {
                    minY = min(minY, spot.y);
                    maxY = max(maxY, spot.y);
                  } else {
                    minY = 0;
                    maxY = 100;
                  }
                }

                // Adjust min and max y-values for better visualization
                minY = max(0, minY - 10);
                maxY = maxY + 10;

                return LineChart(
                  LineChartData(
                    minY: -50,
                    maxY: 100,
                    minX: data.isNotEmpty ? data.first.x : 0,
                    maxX: data.isNotEmpty ? data.last.x : 0,
                    lineTouchData: LineTouchData(enabled: false),
                    clipData: FlClipData.all(),
                    gridData: FlGridData(show: true, drawVerticalLine: false),
                    borderData: FlBorderData(show: false),
                    titlesData: FlTitlesData(
                      show: true,
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            return Text(value.round().toString());
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          reservedSize: 70,
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            return Text('${value.round()} dB');
                          },
                        ),
                      ),
                      topTitles: AxisTitles(),
                      rightTitles: AxisTitles(),
                    ),
                    lineBarsData: [
                      LineChartBarData(
                        spots: state.stpsdData,
                        dotData: FlDotData(show: false),
                        gradient: const LinearGradient(
                          colors: [
                            Color.fromARGB(0, 255, 255, 255),
                            Colors.red
                          ],
                          stops: [0, 0.2],
                        ),
                        barWidth: 4,
                        isCurved: false,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
