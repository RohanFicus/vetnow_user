import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/counter.dart';
import '../../domain/usecases/increment_counter.dart';

class CounterState {
  final int value;
  final bool isLoading;

  const CounterState({required this.value, this.isLoading = false});

  CounterState copyWith({int? value, bool? isLoading}) {
    return CounterState(
      value: value ?? this.value,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class CounterCubit extends Cubit<CounterState> {
  final IncrementCounter incrementCounter;

  CounterCubit(this.incrementCounter) : super(const CounterState(value: 0));

  Future<void> increment() async {
    emit(state.copyWith(isLoading: true));
    Counter newValue = await incrementCounter(const NoParams());
    emit(state.copyWith(value: newValue.value, isLoading: false));
  }
}
