// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'time_series_generator_bloc.dart';

class TimeSeriesGeneratorState extends Equatable {
  final List<int> subscribers;
  final int? batchSize;
  final double? sampleRate;
  final List<ToneConfig>? toneConfigs;
  final BatchedData? batchedData;
  final Point? pnt;
  final bool? isGenerating;
  final StreamSubscription? dataGenerationSubscription;

  TimeSeriesGeneratorState({
    this.subscribers = const [],
    this.batchSize = 256,
    this.sampleRate = 0,
    this.toneConfigs = const [],
    required this.batchedData,
    required this.pnt,
    this.isGenerating = false,
    this.dataGenerationSubscription,
  });

  TimeSeriesGeneratorState copyWith({
    List<int>? subscribers,
    int? batchSize,
    double? sampleRate,
    List<ToneConfig>? toneConfigs,
    BatchedData? batchedData,
    Point? pnt,
    bool? isGenerating,
    StreamSubscription? dataGenerationSubscription,
  }) {
    return TimeSeriesGeneratorState(
      subscribers: subscribers ?? this.subscribers,
      batchSize: batchSize ?? this.batchSize,
      sampleRate: sampleRate ?? this.sampleRate,
      toneConfigs: toneConfigs ?? this.toneConfigs,
      batchedData: batchedData ?? this.batchedData,
      pnt: pnt ?? this.pnt,
      isGenerating: isGenerating ?? this.isGenerating,
      dataGenerationSubscription:
          dataGenerationSubscription ?? this.dataGenerationSubscription,
    );
  }

  @override
  List<Object?> get props {
    return [
      subscribers,
      batchSize,
      sampleRate,
      toneConfigs,
      batchedData,
      isGenerating,
    ];
  }
}
