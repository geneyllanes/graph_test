import 'package:time_series_generator_api/time_series_generator_api.dart';

/// {@template acoustics_repo}
/// My new Dart package
/// {@endtemplate}
class AcousticsRepository {
  /// {@macro acoustics_repo}
  const AcousticsRepository({
    required TimeSeriesGeneratorApi timeSeriesGeneratorApi,
  }) : _timeSeriesGeneratorApi = timeSeriesGeneratorApi;

  final TimeSeriesGeneratorApi _timeSeriesGeneratorApi;

  //publish
  //subscribe
}
