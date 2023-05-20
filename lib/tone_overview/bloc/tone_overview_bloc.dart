import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'tone_overview_event.dart';
part 'tone_overview_state.dart';

class ToneOverviewBloc extends Bloc<ToneOverviewEvent, ToneOverviewState> {
  ToneOverviewBloc() : super(ToneOverviewInitial()) {
    on<ToneOverviewEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
