import 'dart:async';
import 'package:bloc_clean_architecture/src/comman/routes.dart';
import 'package:bloc_clean_architecture/src/presentation/bloc/authenticator_watcher/authenticator_watcher_bloc.dart';
import 'package:bloc_clean_architecture/src/presentation/page/splash/splash_screen.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:bloc_clean_architecture/src/comman/themes.dart';
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
      child: Builder(
        builder: (context) {
          return MaterialApp.router(
            theme: themeLight(context),
            darkTheme: themeDark(context),
            routerConfig: router,
          );
        },
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
    expect(find.text('NEON '), findsOneWidget);
    expect(find.text('FUTURE-PROOF YOUR CAREER'), findsOneWidget);

    // Let the initState macro task execute and request auth check
    await tester.pump();

    verify(() => mockAuthenticatorWatcherBloc.add(
          const AuthenticatorWatcherEvent.authCheckRequest(),
        )).called(1);
        
    // Clean up timer
    await tester.pump(const Duration(seconds: 3));
  });

  testWidgets('Redirects to onboarding page on isFirstTime state',
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
          path: AppRoutes.ONBOARDING_ROUTE_PATH,
          name: AppRoutes.ONBOARDING_ROUTE_NAME,
          builder: (context, state) => const Scaffold(body: Text('Onboarding Page')),
        ),
      ],
    );

    // Act
    await tester.pumpWidget(createWidgetUnderTest(router: router));

    // Emit isFirstTime state
    controller.add(const AuthenticatorWatcherState.isFirstTime());
    
    // Advance progress simulation timer (2000ms) + 300ms transition delay
    await tester.pump(const Duration(milliseconds: 2500));
    await tester.pumpAndSettle();

    // Assert
    expect(find.text('Onboarding Page'), findsOneWidget);
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

    // Emit unauthenticated state
    controller.add(const AuthenticatorWatcherState.unauthenticated());
    
    // Advance progress simulation timer (2000ms) + 300ms transition delay
    await tester.pump(const Duration(milliseconds: 2500));
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

    // Emit authenticated state
    controller.add(const AuthenticatorWatcherState.authenticated());
    
    // Advance progress simulation timer (2000ms) + 300ms transition delay
    await tester.pump(const Duration(milliseconds: 2500));
    await tester.pumpAndSettle();

    // Assert
    expect(find.text('Dashboard Page'), findsOneWidget);
    await controller.close();
  });
}
