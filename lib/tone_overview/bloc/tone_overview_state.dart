// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'tone_overview_bloc.dart';

enum ToneStatus {
  initial,
  loading,
  success,
  failure,
}

extension LogStatusX on ToneStatus {
  bool get isLoadingOrSuccess => [
        ToneStatus.loading,
        ToneStatus.success,
      ].contains(this);
}

class ToneOverviewState extends Equatable {
  const ToneOverviewState({
    this.status = ToneStatus.initial,
    this.publishRequest,
    this.tones = const [],
  });

  final ToneStatus status;
  final List<ToneConfig> tones;
  final TimeSeriesConfig? publishRequest;

  @override
  List<Object?> get props => [status, tones, publishRequest];

  ToneOverviewState copyWith({
    ToneStatus? status,
    List<ToneConfig>? tones,
    TimeSeriesConfig? publishRequest,
  }) {
    return ToneOverviewState(
      status: status ?? this.status,
      tones: tones ?? this.tones,
      publishRequest: publishRequest ?? this.publishRequest,
    );
  }
}
