// ignore_for_file: lines_longer_than_80_chars

import 'package:equatable/equatable.dart';

class Tone extends Equatable {
  const Tone({
    required this.initialPhase,
    required this.amplitude,
    required this.frequency,
  });

  final double initialPhase;
  final double amplitude;
  final double frequency;

  Tone copyWith({
    double? initialPhase,
    double? amplitude,
    double? frequency,
  }) {
    return Tone(
      initialPhase: initialPhase ?? this.initialPhase,
      amplitude: amplitude ?? this.amplitude,
      frequency: frequency ?? this.frequency,
    );
  }

  @override
  String toString() =>
      'Tone(initialPhase: $initialPhase, amplitude: $amplitude, frequency: $frequency)';

  @override
  List<Object> get props => [initialPhase, amplitude, frequency];
}
