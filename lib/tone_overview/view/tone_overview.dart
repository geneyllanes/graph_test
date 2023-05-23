import 'package:acoustics_repository/acoustics_repository.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graph_test/tone_overview/tone_overview.dart';
import 'package:time_series_generator_api/generated/time_series_generator.pb.dart';

class ToneOverview extends StatelessWidget {
  const ToneOverview({key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      lazy: false,
      create: (context) => ToneOverviewBloc(
        acousticsRepository: context.read<AcousticsRepository>(),
      ),
      child: const ToneView(),
    );
  }
}

class ToneView extends StatelessWidget {
  const ToneView({Key? key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          'ToneView',
          textAlign: TextAlign.center,
        ),
        ElevatedButton(
          onPressed: () {
            // toneOverviewBloc.add(ToneOverviewSubscriptionRequested());
          },
          child: const Text('button'),
        ),
        AspectRatio(
          aspectRatio: 1.5,
          child: BlocBuilder<ToneOverviewBloc, ToneOverviewState>(
              builder: (context, state) {
            final batch = state.combinedTone;
            return ChartWidget(data: batch!);
          }),
        )
      ],
    );
  }
}

class ChartWidget extends StatelessWidget {
  final BatchedData data;

  ChartWidget({required this.data});

  @override
  Widget build(BuildContext context) {
    List<FlSpot> spots = data.xValues.asMap().entries.map((entry) {
      int index = entry.key;
      double x = entry.value;
      double y = data.yValues[index];
      return FlSpot(x, y);
    }).toList();

    return LineChart(LineChartData(
      minX: 100,
      maxX: 1000000,
      minY: -10,
      maxY: 10,
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
      ),
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: false,
          barWidth: 2,
          dotData: FlDotData(show: false),
        ),
      ],
    ));
  }
}
