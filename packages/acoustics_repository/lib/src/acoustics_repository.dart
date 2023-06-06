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
  Stream<BatchedData> getCombinedTone() {
    print('subscribe in repo');
    return _generatorApi.subscribe();
  }

  /// publish tones for the generator

  Future<void> setTones(TimeSeriesConfig publishRequest) async {
    print('publish request in repo');

    final response = await _generatorApi.publish(publishRequest);

    print('response${response.message}');
  }

  // just for testing
  Stream<Point> getHeartRateStream() {
    return _generatorApi.generateHeartRateStream(70, 20000);
  }
}
