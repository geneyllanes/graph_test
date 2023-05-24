import 'package:acoustics_repository/acoustics_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graph_test/heart_rate/bloc/heart_rate_bloc.dart';
import 'package:graph_test/tone_overview/tone_overview.dart';
import 'package:time_series_generator_api/generated/time_series_generator.dart';
import 'package:time_series_generator_api/time_series_generator_api.dart';

class ToneOverview extends StatelessWidget {
  const ToneOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      lazy: false,
      create: (context) => ToneOverviewBloc(
        acousticsRepository: context.read<AcousticsRepository>(),
      ),
      child: ToneView(),
    );
  }
}

class ToneView extends StatelessWidget {
  ToneView({Key? key});

  final TextEditingController amplitudeFieldController =
      TextEditingController();
  final TextEditingController frequencyFieldController =
      TextEditingController();
  final TextEditingController phaseFieldController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final state = context.watch<ToneOverviewBloc>().state;
    return BlocListener<ToneOverviewBloc, ToneOverviewState>(
      listener: (context, state) {
        if (state.status == ToneStatus.success) {
          context.read<HeartRateBloc>().add(StartFromGenerator(
              TimeSeriesConfig(sampleRate: 100, tones: state.tones)));
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DefaultTextStyle.merge(
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              child: const Text('Tone Overview'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: BlocBuilder<ToneOverviewBloc, ToneOverviewState>(
              // buildWhen: (previous, current) {
              //   return previous.comments!.length != current.comments!.length;
              // },
              builder: (context, state) {
                print(state.tones.isNotEmpty);

                if (state.tones.isNotEmpty) {
                  return Container(
                    width: double.maxFinite,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: state.tones.length,
                      itemBuilder: ((context, index) {
                        return ToneTile(
                          tone: state.tones[index],
                        );
                      }),
                    ),
                  );
                } else {
                  return Text('no tones yet');
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: phaseFieldController,
                    decoration: InputDecoration(
                      enabled: !state.status.isLoadingOrSuccess,
                      hintText: 'phase',
                    ),
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    controller: frequencyFieldController,
                    decoration: InputDecoration(
                      enabled: !state.status.isLoadingOrSuccess,
                      hintText: 'frequency',
                    ),
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    controller: amplitudeFieldController,
                    decoration: InputDecoration(
                      enabled: !state.status.isLoadingOrSuccess,
                      hintText: 'amplitude',
                      suffixIcon: IconButton(
                        icon: Icon(Icons.send),
                        onPressed: () {
                          print('pressed');
                          context.read<ToneOverviewBloc>().add(
                                ToneAdded(
                                  double.parse(amplitudeFieldController.text),
                                  double.parse(frequencyFieldController.text),
                                  double.parse(phaseFieldController.text),
                                ),
                              );
                          amplitudeFieldController.clear();
                          frequencyFieldController.clear();
                          phaseFieldController.clear();
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class ToneTile extends StatelessWidget {
  const ToneTile({super.key, required this.tone});

  final ToneConfig tone;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(tone.initialPhase.toString()),
        ),
        Expanded(
          child: Text(tone.amplitude.toString()),
        ),
        Expanded(
          child: Text(tone.frequency.toString()),
        ),
      ],
    );
  }
}
