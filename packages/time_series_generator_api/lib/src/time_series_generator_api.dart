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
}
 