part of 'heart_rate_bloc.dart';

enum HeartRateStatus { initial, loading, success, failure }

class HeartRateState extends Equatable {
  final List<FlSpot> chartData;
  final List<FlSpot> stpsdData;
  final HeartRateStatus status;

  const HeartRateState({
    this.chartData = const [],
    this.stpsdData = const [],
    this.status = HeartRateStatus.initial,
  });

  @override
  List<Object> get props => [chartData, chartData, stpsdData];

  HeartRateState copyWith({
    List<FlSpot>? chartData,
    List<FlSpot>? stpsdData,
    HeartRateStatus? status,
  }) {
    return HeartRateState(
      chartData: chartData ?? this.chartData,
      stpsdData: stpsdData ?? this.stpsdData,
      status: status ?? this.status,
    );
  }
}
