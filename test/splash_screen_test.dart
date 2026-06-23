import 'dart:async';
import 'package:bloc_clean_architecture/src/comman/routes.dart';
import 'package:bloc_clean_architecture/src/presentation/bloc/authenticator_watcher/authenticator_watcher_bloc.dart';
import 'package:bloc_clean_architecture/src/presentation/page/splash/splash_screen.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
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

  testWidgets('SplashScreen displays correctly and requests auth check',
      (WidgetTester tester) async {
    // Arrange
    when(() => mockAuthenticatorWatcherBloc.state)
        .thenReturn(const AuthenticatorWatcherState.initial());

    final router = GoRouter(
      initialLocation: AppRoutes.SPLASH_ROUTE_PATH,
      routes: [
        GoRoute(
          path: AppRoutes.SPLASH_ROUTE_PATH,
          name: AppRoutes.SPLASH_ROUTE_NAME,
          builder: (context, state) => const SplashScreen(),
        ),
      ],
    );

    // Act
    await tester.pumpWidget(createWidgetUnderTest(router: router));

    // Assert
    expect(find.text('Splash Screen.'), findsOneWidget);

    // Wait for the Future.delayed of 1 second in initState to trigger the event
    await tester.pump(const Duration(seconds: 1));

    verify(() => mockAuthenticatorWatcherBloc.add(
          const AuthenticatorWatcherEvent.authCheckRequest(),
        )).called(1);
  });

  testWidgets('Redirects to login page on isFirstTime state',
      (WidgetTester tester) async {
    // Arrange
    final controller = StreamController<AuthenticatorWatcherState>();
    whenListen(
      mockAuthenticatorWatcherBloc,
      controller.stream,
      initialState: const AuthenticatorWatcherState.initial(),
    );

    final router = GoRouter(
      initialLocation: AppRoutes.SPLASH_ROUTE_PATH,
      routes: [
        GoRoute(
          path: AppRoutes.SPLASH_ROUTE_PATH,
          name: AppRoutes.SPLASH_ROUTE_NAME,
          builder: (context, state) => const SplashScreen(),
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
    await tester.pump(const Duration(seconds: 1));

    // Emit isFirstTime state
    controller.add(const AuthenticatorWatcherState.isFirstTime());
    await tester.pumpAndSettle();

    // Assert
    expect(find.text('Login Page'), findsOneWidget);
    await controller.close();
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
      initialLocation: AppRoutes.SPLASH_ROUTE_PATH,
      routes: [
        GoRoute(
          path: AppRoutes.SPLASH_ROUTE_PATH,
          name: AppRoutes.SPLASH_ROUTE_NAME,
          builder: (context, state) => const SplashScreen(),
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
    await tester.pump(const Duration(seconds: 1));

    // Emit unauthenticated state
    controller.add(const AuthenticatorWatcherState.unauthenticated());
    await tester.pumpAndSettle();

    // Assert
    expect(find.text('Login Page'), findsOneWidget);
    await controller.close();
  });

  testWidgets('Redirects to dashboard page on authenticated state',
      (WidgetTester tester) async {
    // Arrange
    final controller = StreamController<AuthenticatorWatcherState>();
    whenListen(
      mockAuthenticatorWatcherBloc,
      controller.stream,
      initialState: const AuthenticatorWatcherState.initial(),
    );

    final router = GoRouter(
      initialLocation: AppRoutes.SPLASH_ROUTE_PATH,
      routes: [
        GoRoute(
          path: AppRoutes.SPLASH_ROUTE_PATH,
          name: AppRoutes.SPLASH_ROUTE_NAME,
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          path: AppRoutes.DASHBOARD_ROUTE_PATH,
          name: AppRoutes.DASHBOARD_ROUTE_NAME,
          builder: (context, state) => const Scaffold(body: Text('Dashboard Page')),
        ),
      ],
    );

    // Act
    await tester.pumpWidget(createWidgetUnderTest(router: router));
    await tester.pump(const Duration(seconds: 1));

    // Emit authenticated state
    controller.add(const AuthenticatorWatcherState.authenticated());
    await tester.pumpAndSettle();

    // Assert
    expect(find.text('Dashboard Page'), findsOneWidget);
    await controller.close();
  });
}
