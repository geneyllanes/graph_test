part of 'tone_overview_bloc.dart';

abstract class ToneOverviewEvent extends Equatable {
  const ToneOverviewEvent();

  @override
  List<Object?> get props => [];
}

class ToneOverviewSubscriptionRequested extends ToneOverviewEvent {}

class StartHeartRate extends ToneOverviewEvent {}

class HeartRatePoint extends ToneOverviewEvent {
  final List<int> point;

  const HeartRatePoint(this.point);

  @override
  List<Object> get props => [point];
}
