import '../../domain/entities/counter.dart';
import '../../domain/repository/counter_repository.dart';
import '../datasources/counter_local_data_source.dart';

class CounterRepositoryImpl implements CounterRepository {
  final CounterLocalDataSource localDataSource;

  CounterRepositoryImpl(this.localDataSource);

  @override
  Future<Counter> getCurrent() => localDataSource.getCurrent();

  @override
  Future<Counter> increment() => localDataSource.increment();
}
