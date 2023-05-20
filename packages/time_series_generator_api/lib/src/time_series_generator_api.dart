import 'package:time_series_generator_api/generated/time_series_generator.dart';

/// {@template time_series_generator_api}
/// My new Dart package
/// {@endtemplate}
class TimeSeriesGeneratorApi {
  /// {@macro time_series_generator_api}
  TimeSeriesGeneratorApi({
    required TimeSeriesGeneratorClient client,
  }) : _client = client;

  final TimeSeriesGeneratorClient _client;

  /// Function for publishing to the server
  Future<PublishResponse> publishTones(TimeSeriesConfig publishRequest) async {
    final publishResponse = await _client.publishTimeSeries(publishRequest);
    return publishResponse;
  }

  Stream<TimeSeriesData> subscribe(TimeSeriesConfig publishConfig) {
    return _client.subscribeToTimeSeries(Empty());
  }
}
