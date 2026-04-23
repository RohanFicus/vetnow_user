import '../../../../core/usecases/usecase.dart';
import '../entities/counter.dart';
import '../repository/counter_repository.dart';

class IncrementCounter implements UseCase<Counter, NoParams> {
  final CounterRepository repository;
  IncrementCounter(this.repository);

  @override
  Future<Counter> call(NoParams params) async {
    return repository.increment();
  }
}
