part of 'heart_rate_bloc.dart';

abstract class HeartRateEvent extends Equatable {
  const HeartRateEvent();

  @override
  List<Object> get props => [];
}

class StartFromGenerator extends HeartRateEvent {
  final TimeSeriesConfig config;

  const StartFromGenerator(this.config);
  @override
  List<Object> get props => [config];
}

class StartSTPSD extends HeartRateEvent {}

class HeartRatePoint extends HeartRateEvent {
  final List<int> point;

  const HeartRatePoint(this.point);

  @override
  List<Object> get props => [point];
}
