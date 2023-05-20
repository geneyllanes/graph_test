import 'package:graph_test/bootstrap.dart';
import 'package:time_series_generator_api/generated/time_series_generator.dart';
import 'package:grpc/grpc.dart' as grpc;
import 'package:time_series_generator_api/time_series_generator_api.dart';

void main() {
  final channel = grpc.ClientChannel('localhost',
      port: 8080,
      options: const grpc.ChannelOptions(
          credentials: grpc.ChannelCredentials.insecure()));

  final client = TimeSeriesGeneratorClient(channel);

  final timeSeriesGeneratorApi = TimeSeriesGeneratorApi(client: client);

  return bootstrap(timeSeriesGeneratorApi: timeSeriesGeneratorApi);
}
