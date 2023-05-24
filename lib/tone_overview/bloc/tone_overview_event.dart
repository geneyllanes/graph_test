part of 'tone_overview_bloc.dart';

abstract class ToneOverviewEvent {}

class ToneOverviewSubscriptionRequested extends ToneOverviewEvent {}

class ToneAdded extends ToneOverviewEvent {
  final double amplitude;
  final double frequency;
  final double phase;

  ToneAdded(this.amplitude, this.frequency, this.phase);
}

class ToneOverviewPublishRequest extends ToneOverviewEvent {}
