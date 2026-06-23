import 'dart:async';
import 'package:bloc_clean_architecture/src/comman/routes.dart';
import 'package:bloc_clean_architecture/src/presentation/bloc/authenticator_watcher/authenticator_watcher_bloc.dart';
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

void main() {
  late MockAuthenticatorWatcherBloc mockAuthenticatorWatcherBloc;

  setUpAll(() {
    registerFallbackValue(FakeAuthenticatorWatcherEvent());
    registerFallbackValue(FakeAuthenticatorWatcherState());
  });

  setUp(() {
    mockAuthenticatorWatcherBloc = MockAuthenticatorWatcherBloc();
  });

  tearDown(() {
    mockAuthenticatorWatcherBloc.close();
  });

  Widget createWidgetUnderTest({required GoRouter router}) {
    return BlocProvider<AuthenticatorWatcherBloc>.value(
      value: mockAuthenticatorWatcherBloc,
      child: MaterialApp.router(
        routerConfig: router,
      ),
    );
  }

  testWidgets('DashBoardScreen displays correctly', (WidgetTester tester) async {
    // Arrange
    when(() => mockAuthenticatorWatcherBloc.state)
        .thenReturn(const AuthenticatorWatcherState.initial());

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
    expect(find.text('DashBoard Page'), findsOneWidget);
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
}
