import '../entities/counter.dart';

abstract class CounterRepository {
  Future<Counter> getCurrent();
  Future<Counter> increment();
}
