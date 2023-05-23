import 'package:acoustics_repository/acoustics_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:time_series_generator_api/generated/time_series_generator.dart';

part 'tone_overview_event.dart';
part 'tone_overview_state.dart';

class ToneOverviewBloc extends Bloc<ToneOverviewEvent, ToneOverviewState> {
  ToneOverviewBloc({
    required AcousticsRepository acousticsRepository,
  })  : _acousticsRepository = acousticsRepository,
        super(ToneOverviewState(
            combinedTone: BatchedData(xValues: [], yValues: []))) {
    on<ToneOverviewSubscriptionRequested>(_onSubscriptionRequested);
  }
  final AcousticsRepository _acousticsRepository;

  BatchedData downSample(int targetPoints, BatchedData data) {
    if (data.xValues.length <= targetPoints) {
      return data; // No downsampling needed
    }

    final List<double> downsampledXValues = [];
    final List<double> downsampledYValues = [];

    final double stepSize = data.xValues.length / targetPoints.toDouble();
    double currentIndex = 0.0;

    for (int i = 0; i < targetPoints; i++) {
      final int index = currentIndex.floor();
      downsampledXValues.add(data.xValues[index]);
      downsampledYValues.add(data.yValues[index]);
      currentIndex += stepSize;
    }

    return BatchedData(
        xValues: downsampledXValues, yValues: downsampledYValues);
  }

  Future<void> _onSubscriptionRequested(ToneOverviewSubscriptionRequested event,
      Emitter<ToneOverviewState> emit) async {
    await emit.forEach<BatchedData>(_acousticsRepository.getCombinedTone(),
        onData: (data) {
      final output = downSample(100, data);

      return state.copyWith(combinedTone: data);
    });
  }
}
