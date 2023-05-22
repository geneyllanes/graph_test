import 'package:acoustics_repository/acoustics_repository.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graph_test/tone_overview/tone_overview.dart';

class ToneOverview extends StatelessWidget {
  const ToneOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      lazy: false,
      create: (context) => ToneOverviewBloc(
        acousticsRepository: context.read<AcousticsRepository>(),
      )..add(ToneOverviewSubscriptionRequested()),
      child: const ToneView(),
    );
  }
}

class ToneView extends StatelessWidget {
  const ToneView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text('ToneView');
  }
}
