import 'package:counting/cubit/counter_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CounterCubit extends Cubit<CounterState> {
  CounterCubit(super.initialState);
  int teamAPoints = 0;
  int teamBPoints = 0;

  void teamIncrement({required String team, required int buttomNumber}) {
    if (team == 'A') {
      teamAPoints += buttomNumber;
      emit(CounterAIncrementState());
    } else {
      teamBPoints += buttomNumber;
      emit(CounterBIncrementState());
    }
  }

  void setPoints() {
    teamAPoints = 0;
    teamBPoints = 0;
    emit(CounterState());
  }
}
