import 'package:bloc_clean_architecture/src/comman/enum.dart';
import 'package:bloc_clean_architecture/src/comman/failure.dart';
import 'package:bloc_clean_architecture/src/domain/entities/company.dart';
import 'package:bloc_clean_architecture/src/domain/entities/job.dart';
import 'package:bloc_clean_architecture/src/domain/usecase/get_companies.dart';
import 'package:bloc_clean_architecture/src/domain/usecase/get_jobs.dart';
import 'package:bloc_clean_architecture/src/presentation/bloc/dashboard/dashboard_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetCompanies extends Mock implements GetCompanies {}
class MockGetJobs extends Mock implements GetJobs {}

void main() {
  late MockGetCompanies mockGetCompanies;
  late MockGetJobs mockGetJobs;
  late DashboardBloc dashboardBloc;

  final tCompanies = [
    Company(
      id: '2',
      name: 'CoolMinds Technologies',
      email: 'carer@coolmindsinc.com',
      jobCount: 1,
      jobIds: const {'19076_6': true},
      lastUpdated: 1782126596,
    ),
    Company(
      id: '1',
      name: 'Armia Systems Pvt. Ltd',
      email: 'jobs@armia.com',
      jobCount: 5,
      jobIds: const {'24236_3': true},
      lastUpdated: 1782126611,
    ),
  ];

  late List<Company> tCompaniesSorted;

  final tJobs = [
    Job(
      id: '12771_95',
      companyId: '95',
      title: 'INTERNSHIP - SOFTWARE TESTING',
      description: 'We are looking for IT novice...',
      email: 'career@aabasoft.com',
      jobUrl: 'https://infopark.in/company-jobs/details/12771/95',
      lastUpdated: 1782126607,
    ),
  ];

  setUp(() {
    mockGetCompanies = MockGetCompanies();
    mockGetJobs = MockGetJobs();
    dashboardBloc = DashboardBloc(mockGetCompanies, mockGetJobs);
    tCompaniesSorted = [tCompanies[1], tCompanies[0]];
  });

  tearDown(() {
    dashboardBloc.close();
  });

  test('initial state should be DashboardState.initial()', () {
    expect(dashboardBloc.state, equals(DashboardState.initial()));
  });

  blocTest<DashboardBloc, DashboardState>(
    'emits [Loading, Loaded] when fetchData event is added successfully',
    build: () {
      when(() => mockGetCompanies.execute())
          .thenAnswer((_) async => Right(tCompanies));
      when(() => mockGetJobs.execute())
          .thenAnswer((_) async => Right(tJobs));
      return dashboardBloc;
    },
    act: (bloc) => bloc.add(const DashboardEvent.fetchData()),
    expect: () => [
      DashboardState.initial().copyWith(state: RequestState.loading),
      DashboardState.initial().copyWith(
        state: RequestState.loaded,
        companies: tCompaniesSorted,
        jobs: tJobs,
      ),
    ],
    verify: (_) {
      verify(() => mockGetCompanies.execute()).called(1);
      verify(() => mockGetJobs.execute()).called(1);
    },
  );

  blocTest<DashboardBloc, DashboardState>(
    'emits [Loading, Error] when fetchData event fails to load companies',
    build: () {
      when(() => mockGetCompanies.execute())
          .thenAnswer((_) async => const Left(ServerFailure('Firebase Error')));
      when(() => mockGetJobs.execute())
          .thenAnswer((_) async => Right(tJobs));
      return dashboardBloc;
    },
    act: (bloc) => bloc.add(const DashboardEvent.fetchData()),
    expect: () => [
      DashboardState.initial().copyWith(state: RequestState.loading),
      DashboardState.initial().copyWith(
        state: RequestState.error,
        errorMessage: 'Companies error: Firebase Error\n',
        jobs: tJobs,
      ),
    ],
  );

  blocTest<DashboardBloc, DashboardState>(
    'emits [Loading, Error] when fetchData event fails to load jobs',
    build: () {
      when(() => mockGetCompanies.execute())
          .thenAnswer((_) async => Right(tCompanies));
      when(() => mockGetJobs.execute())
          .thenAnswer((_) async => const Left(ServerFailure('Connection Error')));
      return dashboardBloc;
    },
    act: (bloc) => bloc.add(const DashboardEvent.fetchData()),
    expect: () => [
      DashboardState.initial().copyWith(state: RequestState.loading),
      DashboardState.initial().copyWith(
        state: RequestState.error,
        errorMessage: 'Jobs error: Connection Error',
        companies: tCompaniesSorted,
      ),
    ],
  );

  blocTest<DashboardBloc, DashboardState>(
    'emits state with new query when searchQueryChanged is added',
    build: () => dashboardBloc,
    act: (bloc) => bloc.add(const DashboardEvent.searchQueryChanged('Flutter')),
    expect: () => [
      DashboardState.initial().copyWith(searchQuery: 'Flutter'),
    ],
  );

  blocTest<DashboardBloc, DashboardState>(
    'emits state with new active tab when tabChanged is added',
    build: () => dashboardBloc,
    act: (bloc) => bloc.add(const DashboardEvent.tabChanged(1)),
    expect: () => [
      DashboardState.initial().copyWith(activeTab: 1),
    ],
  );
}
