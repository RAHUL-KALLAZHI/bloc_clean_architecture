import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:bloc_clean_architecture/src/utilities/logger.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart' as bloc_concurrency;
import 'package:bloc_clean_architecture/src/comman/themes.dart';
import 'package:bloc_clean_architecture/src/presentation/bloc/authenticator_watcher/authenticator_watcher_bloc.dart';
import 'package:bloc_clean_architecture/src/presentation/bloc/dashboard/dashboard_bloc.dart';
import 'package:bloc_clean_architecture/src/presentation/bloc/sign_in_form/sign_in_form_bloc.dart';
import 'package:bloc_clean_architecture/src/presentation/cubit/theme/theme_cubit.dart';
import 'package:bloc_clean_architecture/src/utilities/app_bloc_observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'src/utilities/go_router_init.dart';
import './injection.dart' as di;

void main() {
  logger.runLogging(
    () => runZonedGuarded(
      () async {
        WidgetsFlutterBinding.ensureInitialized();
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
        Bloc.transformer = bloc_concurrency.sequential();
        Bloc.observer = const AppBlocObserver();
        di.init();

        runApp(const MyApp());
      },
      logger.logZoneError,
    ),
    const LogOptions(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.locator<AuthenticatorWatcherBloc>()),
        BlocProvider(create: (_) => di.locator<SignInFormBloc>()),
        BlocProvider(create: (_) => di.locator<ThemeCubit>()),
        BlocProvider(
          create: (_) => di.locator<DashboardBloc>()
            ..add(const DashboardEvent.fetchData()),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, themeState) {
          final ThemeMode themeMode;
          if (themeState is ThemeDark) {
            themeMode = ThemeMode.dark;
          } else if (themeState is ThemeLight) {
            themeMode = ThemeMode.light;
          } else {
            themeMode = ThemeMode.system;
          }
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'flutter bloc clean architecture',
            theme: themeLight(context),
            darkTheme: themeDark(context),
            themeMode: themeMode,
            routerConfig: routerinit,
          );
        },
      ),
    );
  }
}
