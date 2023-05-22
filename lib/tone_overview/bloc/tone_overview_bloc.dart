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
    on<ToneOverviewSubscriptionRequested>(_onSubscriptionRequested);
  }
  final AcousticsRepository _acousticsRepository;

  /// maxDataPoints represents the maximum number of data points you want
  ///  to keep in the list. After adding the new data point to the updated list,
  /// it checks if the length of the list exceeds the maximum limit. If it does,
  /// the sublist method is used to keep only the most recent maxDataPoints
  /// elements in the list, discarding the older ones.
  Future<void> _onSubscriptionRequested(ToneOverviewSubscriptionRequested event,
      Emitter<ToneOverviewState> emit) async {

    await emit.forEach<BatchedData>(_acousticsRepository.getCombinedTone(),
        onData: (data) {
      // List<BatchedData> updated = [...state.combinedTone.!, data];

      // if (updated.length > maxDataPoints) {
      //   updated = updated.sublist(updated.length - maxDataPoints);
      // }

      return state.copyWith();
    });
  }
}
