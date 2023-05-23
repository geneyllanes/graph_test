import 'dart:math';
import 'dart:typed_data';

import 'package:acoustics_repository/acoustics_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:fftea/fftea.dart';

part 'heart_rate_event.dart';
part 'heart_rate_state.dart';

class HeartRateBloc extends Bloc<HeartRateEvent, HeartRateState> {
  HeartRateBloc({
    required AcousticsRepository acousticsRepository,
  })  : _acousticsRepository = acousticsRepository,
        super(const HeartRateState()) {
    on<StartHeartRate>(_onStartHeartRate);
    on<StartSTPSD>(_onStartSTPSD);
  }
  final windowSize = 256;
  final overlap = 128;
  final samplingRate = 1000.0;

  final AcousticsRepository _acousticsRepository;

  Future<void> _onStartHeartRate(
      StartHeartRate event, Emitter<HeartRateState> emit) async {
    await emit.forEach<List<double>>(_acousticsRepository.getHeartRateStream(),
        onData: (point) {
      final newData = FlSpot(point[0].toDouble(), point[1].toDouble());
      final updatedList = state.chartData.map((e) => e).toList();

      if (updatedList.length > 50) {
        updatedList.removeAt(0);
      }

      return state.copyWith(chartData: updatedList..add(newData));
    }).whenComplete(() => add(StartHeartRate()));
  }

  Future<void> _onStartSTPSD(
      StartSTPSD event, Emitter<HeartRateState> emit) async {
    await emit.forEach<List<double>>(_acousticsRepository.getHeartRateStream(),
        onData: (point) {
      final stpsdData = <FlSpot>[];

      for (int i = 0; i < point.length; i += overlap) {
        print(i);
        final end = min(i + windowSize, point.length);
        final windowedData = point.sublist(i, end);

        final window = generateHammingWindow(windowSize);

        // Apply windowing function to the data chunk
        applyWindow(windowedData, window);

        // Compute the DFT of the windowed data
        final dft = FFT(windowedData.length);

        // // Calculate the power spectrum
        final fft = dft.realFft(windowedData);

        // Calculate the power spectrum
        final powerSpectrum = calculatePowerSpectrum(fft);

        // // Normalize the power spectrum and add to STPSD data
        stpsdData.add(FlSpot(i.toDouble(), powerSpectrum / windowSize));
      }

      return state.copyWith(stpsdData: stpsdData);
    });
  }

  List<double> generateHammingWindow(int windowSize) {
    final window = List<double>.filled(windowSize, 0.0);

    for (int i = 0; i < windowSize; i++) {
      window[i] = 0.54 - 0.46 * cos(2 * pi * i / (windowSize - 1));
    }

    return window;
  }

  void applyWindow(List<double> data, List<double> window) {
    // Apply a windowing function (e.g., Hamming window) to the data
    // You can use different windowing functions based on your requirements
    for (int i = 0; i < data.length; i++) {
      data[i] *= window[i];
    }
  }

  double calculatePowerSpectrum(Float64x2List fft) {
    double sum = 0;

    for (int i = 0; i < fft.length; i++) {
      final fftValue = fft[i];
      final real = fftValue.x;
      final imag = fftValue.y;
      final power = real * real + imag * imag;
      sum += power;
    }

    final averagePower = sum / fft.length;
    return averagePower;
  }
}
