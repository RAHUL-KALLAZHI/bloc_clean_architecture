import 'dart:async';
import 'package:bloc_clean_architecture/src/comman/enum.dart';
import 'package:bloc_clean_architecture/src/comman/routes.dart';
import 'package:bloc_clean_architecture/src/domain/entities/company.dart';
import 'package:bloc_clean_architecture/src/domain/entities/job.dart';
import 'package:bloc_clean_architecture/src/presentation/bloc/authenticator_watcher/authenticator_watcher_bloc.dart';
import 'package:bloc_clean_architecture/src/presentation/bloc/dashboard/dashboard_bloc.dart';
import 'package:bloc_clean_architecture/src/presentation/page/dashboard/dashboard_screen.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthenticatorWatcherBloc
    extends MockBloc<AuthenticatorWatcherEvent, AuthenticatorWatcherState>
    implements AuthenticatorWatcherBloc {}

class FakeAuthenticatorWatcherEvent extends Fake
    implements AuthenticatorWatcherEvent {}

class FakeAuthenticatorWatcherState extends Fake
    implements AuthenticatorWatcherState {}

class MockDashboardBloc extends MockBloc<DashboardEvent, DashboardState>
    implements DashboardBloc {}

class FakeDashboardEvent extends Fake implements DashboardEvent {}

class FakeDashboardState extends Fake implements DashboardState {}

void main() {
  late MockAuthenticatorWatcherBloc mockAuthenticatorWatcherBloc;
  late MockDashboardBloc mockDashboardBloc;

  setUpAll(() {
    registerFallbackValue(FakeAuthenticatorWatcherEvent());
    registerFallbackValue(FakeAuthenticatorWatcherState());
    registerFallbackValue(FakeDashboardEvent());
    registerFallbackValue(FakeDashboardState());
  });

  setUp(() {
    mockAuthenticatorWatcherBloc = MockAuthenticatorWatcherBloc();
    mockDashboardBloc = MockDashboardBloc();
  });

  tearDown(() {
    mockAuthenticatorWatcherBloc.close();
    mockDashboardBloc.close();
  });

  Widget createWidgetUnderTest({required GoRouter router}) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthenticatorWatcherBloc>.value(
          value: mockAuthenticatorWatcherBloc,
        ),
        BlocProvider<DashboardBloc>.value(
          value: mockDashboardBloc,
        ),
      ],
      child: MaterialApp.router(
        routerConfig: router,
      ),
    );
  }

  testWidgets('DashBoardScreen displays correctly', (WidgetTester tester) async {
    // Arrange
    when(() => mockAuthenticatorWatcherBloc.state)
        .thenReturn(const AuthenticatorWatcherState.initial());
    when(() => mockDashboardBloc.state)
        .thenReturn(DashboardState.initial().copyWith(state: RequestState.loaded));

    final router = GoRouter(
      initialLocation: AppRoutes.DASHBOARD_ROUTE_PATH,
      routes: [
        GoRoute(
          path: AppRoutes.DASHBOARD_ROUTE_PATH,
          name: AppRoutes.DASHBOARD_ROUTE_NAME,
          builder: (context, state) => const DashBoardScreen(),
        ),
      ],
    );

    // Act
    await tester.pumpWidget(createWidgetUnderTest(router: router));

    // Assert
    expect(find.text('Job Portal'), findsOneWidget);
    expect(
      find.descendant(
        of: find.byType(InkWell),
        matching: find.byType(FaIcon),
      ),
      findsOneWidget,
    );
  });

  testWidgets('Tapping the sign out icon dispatches signOut event',
      (WidgetTester tester) async {
    // Arrange
    when(() => mockAuthenticatorWatcherBloc.state)
        .thenReturn(const AuthenticatorWatcherState.initial());
    when(() => mockDashboardBloc.state)
        .thenReturn(DashboardState.initial().copyWith(state: RequestState.loaded));

    final router = GoRouter(
      initialLocation: AppRoutes.DASHBOARD_ROUTE_PATH,
      routes: [
        GoRoute(
          path: AppRoutes.DASHBOARD_ROUTE_PATH,
          name: AppRoutes.DASHBOARD_ROUTE_NAME,
          builder: (context, state) => const DashBoardScreen(),
        ),
      ],
    );

    // Act
    await tester.pumpWidget(createWidgetUnderTest(router: router));

    final signOutButtonFinder = find.descendant(
      of: find.byType(InkWell),
      matching: find.byType(FaIcon),
    );

    await tester.tap(signOutButtonFinder);
    await tester.pump();

    // Assert
    verify(() => mockAuthenticatorWatcherBloc.add(
          const AuthenticatorWatcherEvent.signOut(),
        )).called(1);
  });

  testWidgets('Redirects to login page on unauthenticated state',
      (WidgetTester tester) async {
    // Arrange
    final controller = StreamController<AuthenticatorWatcherState>();
    whenListen(
      mockAuthenticatorWatcherBloc,
      controller.stream,
      initialState: const AuthenticatorWatcherState.initial(),
    );
    when(() => mockDashboardBloc.state)
        .thenReturn(DashboardState.initial().copyWith(state: RequestState.loaded));

    final router = GoRouter(
      initialLocation: AppRoutes.DASHBOARD_ROUTE_PATH,
      routes: [
        GoRoute(
          path: AppRoutes.DASHBOARD_ROUTE_PATH,
          name: AppRoutes.DASHBOARD_ROUTE_NAME,
          builder: (context, state) => const DashBoardScreen(),
        ),
        GoRoute(
          path: AppRoutes.LOGIN_ROUTE_PATH,
          name: AppRoutes.LOGIN_ROUTE_NAME,
          builder: (context, state) => const Scaffold(body: Text('Login Page')),
        ),
      ],
    );

    // Act
    await tester.pumpWidget(createWidgetUnderTest(router: router));
    
    // Emit unauthenticated state
    controller.add(const AuthenticatorWatcherState.unauthenticated());
    await tester.pumpAndSettle();

    // Assert
    expect(find.text('Login Page'), findsOneWidget);
    await controller.close();
  });

  testWidgets(
      'Tapping on a company card shows its jobs and back button resets it',
      (WidgetTester tester) async {
    // Arrange
    final companies = [
      Company(
        id: '95',
        name: 'Aabasoft',
        email: 'career@aabasoft.com',
        jobCount: 1,
        jobIds: const {'12771_95': true},
        lastUpdated: 1782126511,
      ),
    ];
    final jobs = [
      Job(
        id: '12771_95',
        companyId: '95',
        title: 'Software Testing',
        description: 'Manual testing...',
        email: 'career@aabasoft.com',
        jobUrl: 'https://aabasoft.com',
        lastUpdated: 1782126607,
      ),
    ];

    when(() => mockAuthenticatorWatcherBloc.state)
        .thenReturn(const AuthenticatorWatcherState.initial());
    when(() => mockDashboardBloc.state)
        .thenReturn(DashboardState.initial().copyWith(
      state: RequestState.loaded,
      companies: companies,
      jobs: jobs,
    ));

    final router = GoRouter(
      initialLocation: AppRoutes.DASHBOARD_ROUTE_PATH,
      routes: [
        GoRoute(
          path: AppRoutes.DASHBOARD_ROUTE_PATH,
          name: AppRoutes.DASHBOARD_ROUTE_NAME,
          builder: (context, state) => const DashBoardScreen(),
        ),
      ],
    );

    // Act - Render the screen
    await tester.pumpWidget(createWidgetUnderTest(router: router));

    // Assert - Shows the company
    expect(find.text('Aabasoft'), findsOneWidget);
    expect(find.text('career@aabasoft.com'), findsOneWidget);
    expect(find.text('Software Testing'), findsNothing); // Job is not shown yet

    // Act - Tap on the company card
    await tester.tap(find.text('Aabasoft'));
    await tester.pumpAndSettle();

    // Assert - Shows the job list and the back button
    expect(find.text('Software Testing'), findsOneWidget);
    expect(find.byIcon(Icons.arrow_back), findsOneWidget);

    // Act - Tap the back button
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();

    // Assert - Shows the company list again
    expect(find.text('Aabasoft'), findsOneWidget);
    expect(find.text('Software Testing'), findsNothing);
  });

  testWidgets(
      'Companies list is sorted alphabetically by name case-insensitively',
      (WidgetTester tester) async {
    // Arrange
    final companies = [
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
      Company(
        id: '3',
        name: 'art Technology and Software.',
        email: 'lavanya.a@arttechgroup.com',
        jobCount: 5,
        jobIds: const {'22011_4': true},
        lastUpdated: 1782126488,
      ),
    ];

    when(() => mockAuthenticatorWatcherBloc.state)
        .thenReturn(const AuthenticatorWatcherState.initial());
    when(() => mockDashboardBloc.state)
        .thenReturn(DashboardState.initial().copyWith(
      state: RequestState.loaded,
      companies: companies,
      jobs: [],
    ));

    final router = GoRouter(
      initialLocation: AppRoutes.DASHBOARD_ROUTE_PATH,
      routes: [
        GoRoute(
          path: AppRoutes.DASHBOARD_ROUTE_PATH,
          name: AppRoutes.DASHBOARD_ROUTE_NAME,
          builder: (context, state) => const DashBoardScreen(),
        ),
      ],
    );

    // Act
    await tester.pumpWidget(createWidgetUnderTest(router: router));

    // Assert
    final textFinders = find.byType(Text);
    final texts = textFinders.evaluate().map((element) {
      final widget = element.widget as Text;
      return widget.data ?? '';
    }).toList();

    final companyNamesInUI = texts.where((text) => 
        text == 'Armia Systems Pvt. Ltd' ||
        text == 'art Technology and Software.' ||
        text == 'CoolMinds Technologies'
    ).toList();

    expect(companyNamesInUI.length, 3);
    expect(companyNamesInUI[0], 'Armia Systems Pvt. Ltd');
    expect(companyNamesInUI[1], 'art Technology and Software.');
    expect(companyNamesInUI[2], 'CoolMinds Technologies');
  });
}
