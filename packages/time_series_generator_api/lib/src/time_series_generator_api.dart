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
  Future<PublishResponse> publish(TimeSeriesConfig publishRequest) async {
    final publishResponse = await _client.publishTimeSeries(publishRequest);
    return publishResponse;
  }

  /// function for subscribing to the server
  Stream<TimeSeriesData> subscribe() {
    return _client.subscribeToTimeSeries(Empty());
  }
}
