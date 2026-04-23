import '../../domain/entities/counter.dart';

abstract class CounterLocalDataSource {
  Future<Counter> getCurrent();
  Future<Counter> increment();
}

class CounterLocalDataSourceImpl implements CounterLocalDataSource {
  int _value = 0;

  @override
  Future<Counter> getCurrent() async => Counter(_value);

  @override
  Future<Counter> increment() async {
    _value++;
    return Counter(_value);
  }
}
