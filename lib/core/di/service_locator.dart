import 'package:get_it/get_it.dart';
import 'package:vetnow_user/core/storage/secure_storage_service.dart';
import 'package:vetnow_user/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:vetnow_user/features/auth/data/datasources/dashboard_local_data_source.dart';
import 'package:vetnow_user/features/auth/data/datasources/dashboard_remote_data_source.dart';
import 'package:vetnow_user/features/auth/data/repositories/dashboard_repository_impl.dart';
import 'package:vetnow_user/features/auth/domain/repository/dashboard_repository.dart';
import 'package:vetnow_user/features/auth/data/datasources/profile_remote_data_source.dart';
import 'package:vetnow_user/features/auth/domain/usecases/dashboard_usecase.dart';
import 'package:vetnow_user/features/auth/domain/usecases/owner_profile_usecase.dart';
import 'package:vetnow_user/features/auth/domain/usecases/profile_usecase.dart';
import 'package:vetnow_user/features/auth/domain/usecases/send_otp_usecase.dart';
import 'package:vetnow_user/features/auth/domain/usecases/verify_otp_usecase.dart';
import 'package:vetnow_user/features/auth/presentation/bloc/dashboardProfile/dashboard_bloc.dart';
import 'package:vetnow_user/features/auth/presentation/bloc/otp/otp_bloc.dart';
import 'package:vetnow_user/features/auth/presentation/bloc/ownerProfile/owner_profile_bloc.dart';
import 'package:vetnow_user/features/auth/presentation/bloc/pet_profile/profile_bloc.dart';
import 'package:vetnow_user/features/auth/presentation/bloc/sign_in_bloc.dart';

import '../../core/network/api_client.dart';
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/datasources/counter_local_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/data/repositories/counter_repository_impl.dart';
import '../../features/auth/domain/repository/auth_repository.dart';
import '../../features/auth/domain/repository/counter_repository.dart';
import '../../features/auth/domain/usecases/increment_counter.dart';
import '../../features/auth/presentation/bloc/counter_cubit.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // ========== CORE ==========
  sl.registerLazySingleton<ApiClient>(() => ApiClient());
  sl.registerLazySingleton<SecureStorageService>(() => SecureStorageService());

  // ========== COUNTER ==========
  sl.registerLazySingleton<CounterLocalDataSource>(
    () => CounterLocalDataSourceImpl(),
  );
  sl.registerLazySingleton<CounterRepository>(
    () => CounterRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<IncrementCounter>(() => IncrementCounter(sl()));
  sl.registerFactory(() => CounterCubit(sl()));

  // ========== AUTH ==========
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl<ApiClient>()),
  );
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl(), sl()),
  );

  // ========== LOCAL ==========
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(),
  );

  // ========== PROFILE ==========
  sl.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(sl<ApiClient>()),
  );

  // ========== DASHBOARD ==========
  sl.registerLazySingleton<DashboardLocalDataSource>(
    () => DashboardLocalDataSourceImpl(),
  );
  sl.registerLazySingleton<DashboardRemoteDataSource>(
    () => DashboardRemoteDataSourceImpl(sl<ApiClient>()),
  );
  sl.registerLazySingleton<DashboardRepository>(
    () => DashboardRepositoryImpl(sl(), sl()),
  );
  // ========== USE CASES ==========
  sl.registerLazySingleton<SendOtpUseCase>(() => SendOtpUseCase(sl()));
  sl.registerLazySingleton<VerifyOtpUseCase>(() => VerifyOtpUseCase(sl()));
  sl.registerLazySingleton<OwnerProfileUseCase>(() => OwnerProfileUseCase(sl()));
  sl.registerLazySingleton<ProfileUseCase>(() => ProfileUseCase(sl()));
  sl.registerLazySingleton<DashboardUseCase>(() => DashboardUseCase(sl()));

  // ========== BLOC ==========
  sl.registerFactory<OtpBloc>(
    () => OtpBloc(sl<VerifyOtpUseCase>(), sl<SecureStorageService>()),
  );

  sl.registerFactory<SignInBloc>(
    () => SignInBloc(sl<SendOtpUseCase>(), sl<SecureStorageService>()),
  );

  sl.registerFactory<ProfileBloc>(
    () => ProfileBloc(sl<ProfileUseCase>(), sl<SecureStorageService>()),
  );

  sl.registerFactory<DashboardBloc>(
    () => DashboardBloc(sl<DashboardUseCase>(), sl<SecureStorageService>()),
  );
}
