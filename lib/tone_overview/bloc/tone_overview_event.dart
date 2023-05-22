part of 'tone_overview_bloc.dart';

abstract class ToneOverviewEvent extends Equatable {
  const ToneOverviewEvent();

  @override
  List<Object?> get props => [];
}

class ToneOverviewSubscriptionRequested extends ToneOverviewEvent {}
