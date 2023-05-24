import 'dart:math';

import 'package:time_series_generator_api/generated/time_series_generator.dart';
import 'package:time_series_generator_api/time_series_generator_api.dart';

/// {@template acoustics_repo}
/// My new Dart package
/// {@endtemplate}
class AcousticsRepository {
  /// {@macro acoustics_repo}
  const AcousticsRepository({
    required TimeSeriesGeneratorApi generatorApi,
  }) : _generatorApi = generatorApi;

  final TimeSeriesGeneratorApi _generatorApi;

  /// Get a stream of time series data
  Stream<BatchedData> getCombinedTone(TimeSeriesConfig config) {
    print('subscribe in repo');
    return _generatorApi.subscribeInApp(config);
  }

  /// publish tones for the generator

  Future<void> setTones(TimeSeriesConfig config) async {
    final response = await _generatorApi.publish(config);

    print('response${response.message}');
  }

  // just for testing
  Stream<Point> getHeartRateStream() {
    return _generatorApi.generateHeartRateStream(70, 20000);
  }
}
