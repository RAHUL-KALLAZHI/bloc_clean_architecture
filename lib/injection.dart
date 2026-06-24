import 'package:bloc_clean_architecture/src/data/datasource/authentication_remote_data_source.dart';
import 'package:bloc_clean_architecture/src/data/datasource/job_remote_data_source.dart';
import 'package:bloc_clean_architecture/src/data/repository/authentication_repository_impl.dart';
import 'package:bloc_clean_architecture/src/data/repository/job_repository_impl.dart';
import 'package:bloc_clean_architecture/src/domain/repositories/autentication_repository.dart';
import 'package:bloc_clean_architecture/src/domain/repositories/job_repository.dart';
import 'package:bloc_clean_architecture/src/domain/usecase/get_companies.dart';
import 'package:bloc_clean_architecture/src/domain/usecase/get_jobs.dart';
import 'package:bloc_clean_architecture/src/domain/usecase/login.dart';
import 'package:bloc_clean_architecture/src/domain/usecase/sign_in_with_google.dart';
import 'package:bloc_clean_architecture/src/presentation/bloc/authenticator_watcher/authenticator_watcher_bloc.dart';
import 'package:bloc_clean_architecture/src/presentation/bloc/dashboard/dashboard_bloc.dart';
import 'package:bloc_clean_architecture/src/presentation/bloc/sign_in_form/sign_in_form_bloc.dart';
import 'package:bloc_clean_architecture/src/presentation/cubit/theme/theme_cubit.dart';
import 'package:get_it/get_it.dart';

final locator = GetIt.instance;

void init() {
  // Data sources
  final authRemoteDataSource = AuthenticationRemoteDataSourceImpl();
  locator.registerLazySingleton<AuthenticationRemoteDataSource>(
    () => authRemoteDataSource,
  );

  final jobRemoteDataSource = JobRemoteDataSourceImpl();
  locator.registerLazySingleton<JobRemoteDataSource>(
    () => jobRemoteDataSource,
  );

  // Repositories
  final authRepository = AuthenticationRepositoryImpl(locator());
  locator.registerLazySingleton<AuthenticationRepository>(
    () => authRepository,
  );

  final jobRepository = JobRepositoryImpl(locator());
  locator.registerLazySingleton<JobRepository>(
    () => jobRepository,
  );

  // Use cases
  final signIn = SignIn(locator());
  locator.registerLazySingleton(
    () => signIn,
  );

  final signInWithGoogle = SignInWithGoogle(locator());
  locator.registerLazySingleton(
    () => signInWithGoogle,
  );

  final getCompanies = GetCompanies(locator());
  locator.registerLazySingleton(
    () => getCompanies,
  );

  final getJobs = GetJobs(locator());
  locator.registerLazySingleton(
    () => getJobs,
  );

  // BLoCs
  final authenticatorWatcherBloc = AuthenticatorWatcherBloc();
  locator.registerLazySingleton(
    () => authenticatorWatcherBloc,
  );

  final signInFormBloc = SignInFormBloc(locator(), locator());
  locator.registerLazySingleton(
    () => signInFormBloc,
  );

  final dashboardBloc = DashboardBloc(locator(), locator());
  locator.registerLazySingleton(
    () => dashboardBloc,
  );

  final themeCubit = ThemeCubit();
  locator.registerLazySingleton(
    () => themeCubit,
  );
}
