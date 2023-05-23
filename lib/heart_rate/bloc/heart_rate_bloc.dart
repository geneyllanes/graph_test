import 'package:acoustics_repository/acoustics_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fl_chart/fl_chart.dart';

part 'heart_rate_event.dart';
part 'heart_rate_state.dart';

class HeartRateBloc extends Bloc<HeartRateEvent, HeartRateState> {
  HeartRateBloc({
    required AcousticsRepository acousticsRepository,
  })  : _acousticsRepository = acousticsRepository,
        super(const HeartRateState()) {
    on<StartHeartRate>(_onStartHeartRate);
    on<StartSTPSD>(_onStartSTPSD);
  }

  final AcousticsRepository _acousticsRepository;

  Future<void> _onStartHeartRate(
      StartHeartRate event, Emitter<HeartRateState> emit) async {
    await emit.forEach<List<int>>(_acousticsRepository.getHeartRateStream(),
        onData: (point) {
      final newData = FlSpot(point[0].toDouble(), point[1].toDouble());
      final updatedList = state.chartData.map((e) => e).toList();

      if (updatedList.length > 50) {
        updatedList.removeAt(0);
      }

      return state.copyWith(chartData: updatedList..add(newData));
    }).whenComplete(() => add(StartHeartRate()));
  }

  Future<void> _onStartSTPSD(
      StartSTPSD event, Emitter<HeartRateState> emit) async {
    await emit.forEach<List<int>>(_acousticsRepository.getHeartRateStream(),
        onData: (point) {
      final newData = FlSpot(point[0].toDouble(), point[1].toDouble());
      final updatedList = state.chartData.map((e) => e).toList();

      if (updatedList.length > 50) {
        updatedList.removeAt(0);
      }

      return state.copyWith(chartData: updatedList..add(newData));
    }).whenComplete(() => add(StartHeartRate()));
  }
}
