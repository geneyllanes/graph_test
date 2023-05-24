import 'dart:math';

import 'package:time_series_generator_api/generated/time_series_generator.dart';
import 'bloc/time_series_generator_bloc.dart';

/// {@template time_series_generator_api}
/// My new Dart package
/// {@endtemplate}
class TimeSeriesGeneratorApi {
  /// {@macro time_series_generator_api}
  TimeSeriesGeneratorApi({
    required TimeSeriesGeneratorClient client,
    required TimeSeriesGeneratorBloc generatorBloc,
  })  : _client = client,
        _generatorBloc = generatorBloc;

  final TimeSeriesGeneratorClient _client;
  final TimeSeriesGeneratorBloc _generatorBloc;

  /// Function for publishing to the server
  Future<PublishResponse> publish(TimeSeriesConfig publishRequest) async {
    // final publishResponse = await _client.publishTimeSeries(publishRequest);
    // return publishResponse;

    print('PublishTimeSeries request received');
    _generatorBloc.add(OnPublish(
      publishRequest.sampleRate,
      publishRequest.tones,
    ));

    return PublishResponse()
      ..id = 1
      ..message = 'Publishing';
  }

  /// function for subscribing to the server
  Stream<BatchedData> subscribe() {
    // final subscribeRequest = Empty();
    // final subscription = _client.subscribeToTimeSeries(subscribeRequest);
    // return subscription.map((event) => event);

    print('New subscriber');

    _generatorBloc.add(OnSubscribe(1));

    // Return the stream from the bloc
    final stream = _generatorBloc.stream.map((state) => state.batchedData!);

    return stream;
  }

  /// function for subscribing to the server
  Stream<BatchedData> subscribeInApp(TimeSeriesConfig config) {
    _generatorBloc.add(OnPublish(
      config.sampleRate,
      config.tones,
    ));

    // Return the stream from the bloc
    final stream = _generatorBloc.stream.map((state) => state.batchedData!);

    return stream;
  }

  /// documentation
  Stream<Point> generateHeartRateStream(
    int heartRate,
    int duration,
  ) async* {
    final x = List<int>.generate(duration, (index) => index);

    // Define the frequencies of the two tones
    const baseFrequency = 1.0; // Base frequency of the heart rate signal
    const modulationFrequency =
        0.1; // Modulation frequency for creating the beat effect

    for (var i = 0; i < duration; i++) {
      final time = i.toDouble();

      // Calculate the instantaneous frequency using the two tones
      final instantaneousFrequency = baseFrequency +
          modulationFrequency * sin(2 * pi * modulationFrequency * time);

      // Generate the heart rate signal using the instantaneous frequency
      final heartRateWithVariation = instantaneousFrequency * 60;

      yield Point(x[i].toDouble(), heartRateWithVariation);
      await Future.delayed(const Duration(milliseconds: 4), () {});
    }
  }
}
