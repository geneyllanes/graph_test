part of 'tone_overview_bloc.dart';

class ToneOverviewState extends Equatable {
  const ToneOverviewState({
    required this.combinedTone,
    this.tones,
  });

  final BatchedData? combinedTone;
  final List<ToneConfig>? tones;

  @override
  List<Object?> get props => [combinedTone, tones];

  ToneOverviewState copyWith({
    BatchedData? combinedTone,
    List<ToneConfig>? tones,
  }) {
    return ToneOverviewState(
      combinedTone: combinedTone ?? this.combinedTone,
      tones: tones ?? this.tones,
    );
  }
}
