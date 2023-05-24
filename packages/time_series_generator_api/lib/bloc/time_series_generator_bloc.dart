// ignore_for_file: public_member_api_docs

import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
// import 'package:rxdart/rxdart.dart';
import 'package:time_series_generator_api/generated/time_series_generator.dart';

part 'time_series_generator_event.dart';
part 'time_series_generator_state.dart';

class TimeSeriesGeneratorBloc
    extends Bloc<TimeSeriesGeneratorEvent, TimeSeriesGeneratorState> {
  TimeSeriesGeneratorBloc()
      : super(TimeSeriesGeneratorState(
          batchedData: BatchedData(xValues: [0], yValues: [0]),
          pnt: const Point(0, 0),
        )) {
    on<OnSubscribe>(_onSubscribe);
    on<OnPublish>(_onPublish);
    on<UpdateConfiguration>(_onUpdateConfiguration);
    on<StartDataGeneration>(_onStartDataGeneration);
    on<StopDataGeneration>(_onStopDataGeneration);
  }
  StreamSubscription<BatchedData>? periodicSubscription;

  void _onSubscribe(OnSubscribe event, Emitter<TimeSeriesGeneratorState> emit) {
    final updated = state.subscribers.map((e) => e).toList()..add(event.hash);

    emit(state.copyWith(subscribers: updated));
    print('Subscribed Event: ' + event.hashCode.toString());

    StartDataGeneration();
  }

  void _onPublish(
      OnPublish event, Emitter<TimeSeriesGeneratorState> emit) async {
    await periodicSubscription
        ?.cancel()
        .then((value) => print('stop cancelled periodic Generation'));
    emit(
      state.copyWith(
        sampleRate: event.sampleRate,
        toneConfigs: event.toneConfigs,
      ),
    );
    add(StartDataGeneration());
  }

  void _onUpdateConfiguration(
      UpdateConfiguration event, Emitter<TimeSeriesGeneratorState> emit) async {
    await periodicSubscription
        ?.cancel()
        .then((value) => print('stop cancelled periodic Generation'));
    emit(
      state.copyWith(
        sampleRate: event.sampleRate,
        toneConfigs: event.toneConfigs,
      ),
    );
  }

  Future<void> _onStartDataGeneration(
    StartDataGeneration event,
    Emitter<TimeSeriesGeneratorState> emit,
  ) async {
    final toneConfigs = <ToneConfigData>[];
    final intervalMicroseconds = (1000000 / state.sampleRate!).round();
    var elapsedTime = 0;

    for (final toneConfig in state.toneConfigs!) {
      final constant = 2 * pi * toneConfig.frequency / state.sampleRate!;
      toneConfigs.add(ToneConfigData(
          constant, toneConfig.amplitude, toneConfig.initialPhase));
    }

    var xValues = List<double>.generate(state.batchSize!, (_) => 0.0);
    var yValues = List<double>.generate(state.batchSize!, (_) => 0.0);

    final batchDataTransformer =
        StreamTransformer<int, BatchedData>.fromHandlers(
            handleData: (value, sink) {
      final xValue = elapsedTime / 1000;
      final yValue = generateYValue(elapsedTime, toneConfigs);

      xValues.add(xValue);
      yValues.add(yValue);

      elapsedTime += intervalMicroseconds;

      if (xValues.length >= state.batchSize!) {
        final output = BatchedData(
          xValues: xValues,
          yValues: yValues,
        );

        print(output.xValues.firstOrNull.toString());

        xValues = [];
        yValues = [];

        sink.add(output);
      }
    });

    final stopwatch = Stopwatch()..start();

    final intervalStream =
        Stream.periodic(Duration(microseconds: intervalMicroseconds), (value) {
      return stopwatch.elapsedMicroseconds;
    });

    periodicSubscription =
        intervalStream.transform(batchDataTransformer).listen((batchedData) {
      emit(state.copyWith(batchedData: batchedData));
    });
  }

  double generateYValue(int currentTime, List<ToneConfigData> toneConfigs) {
    double yValue = 0;

    for (var toneConfig in toneConfigs) {
      final value = toneConfig.amplitude *
          sin(toneConfig.constant * currentTime + toneConfig.initialPhase);
      yValue += value;
    }

    return yValue;
  }

  void _onStopDataGeneration(
      StopDataGeneration event, Emitter<TimeSeriesGeneratorState> emit) async {
    await periodicSubscription
        ?.cancel()
        .then((value) => print('stop cancelled periodic Generation'));

    emit(
      state.copyWith(
        batchedData: BatchedData(xValues: [0], yValues: [0]),
        isGenerating: false,
      ),
    );
  }

  @override
  Future<void> close() async {
    print('onClose');
    await periodicSubscription
        ?.cancel()
        .then((value) => print('onClose cancelled periodic Generation'));
    return super.close();
  }
}

class ToneConfigData {
  final double constant;
  final double amplitude;
  final double initialPhase;

  ToneConfigData(this.constant, this.amplitude, this.initialPhase);
}
