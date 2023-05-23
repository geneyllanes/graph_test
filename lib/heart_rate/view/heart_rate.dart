import 'package:acoustics_repository/acoustics_repository.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graph_test/heart_rate/bloc/heart_rate_bloc.dart';

class HeartRate extends StatelessWidget {
  const HeartRate({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      lazy: false,
      create: (context) => HeartRateBloc(
        acousticsRepository: context.read<AcousticsRepository>(),
      )..add(StartHeartRate()),
      child: const HeartRateView(),
    );
  }
}

class HeartRateView extends StatelessWidget {
  const HeartRateView({super.key});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<HeartRateBloc, HeartRateState>(
          builder: (context, state) {
            final data = state.chartData;
            return LineChart(
              LineChartData(
                minY: 20,
                maxY: 100,
                minX: data.length > 1 ? state.chartData.first.x : 0,
                maxX: data.length > 1 ? state.chartData.last.x : 0,
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
    );
  }
}
