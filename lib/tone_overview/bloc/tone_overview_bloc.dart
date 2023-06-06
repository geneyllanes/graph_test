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
        super(const ToneOverviewState()) {
    // on<ToneOverviewSubscriptionRequested>(_onSubscriptionRequested);
    on<ToneAdded>(_onToneAdded);
  }
  final AcousticsRepository _acousticsRepository;

  // Future<void> _onSubscriptionRequested(ToneOverviewSubscriptionRequested event,
  //     Emitter<ToneOverviewState> emit) async {
  //   await emit.forEach<BatchedData>(_acousticsRepository.getCombinedTone(),
  //       onData: (data) {
  //     final output = downSample(100, data);

  //     return state.copyWith(combinedTone: data);
  //   });
  // }

  Future<void> _onToneAdded(
      ToneAdded event, Emitter<ToneOverviewState> emit) async {
    emit(state.copyWith(status: ToneStatus.loading));
    final updated = state.tones.map((e) => e).toList()
      ..add(ToneConfig(
          amplitude: event.amplitude,
          frequency: event.frequency,
          initialPhase: event.phase));

    // await _acousticsRepository
    //     .setTones(TimeSeriesConfig(sampleRate: 100, tones: updated));

    emit(state.copyWith(
        tones: updated,
        publishRequest: TimeSeriesConfig(sampleRate: 44100, tones: updated),
        status: ToneStatus.success));
  }
}
