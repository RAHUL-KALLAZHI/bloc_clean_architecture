import 'package:bloc_clean_architecture/src/comman/routes.dart';
import 'package:bloc_clean_architecture/src/presentation/bloc/authenticator_watcher/authenticator_watcher_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({super.key});

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticatorWatcherBloc, AuthenticatorWatcherState>(
      listener: (context, state) {
        state.maybeMap(
          orElse: () {},
          unauthenticated: (_) {
            context.goNamed(AppRoutes.LOGIN_ROUTE_NAME);
          },
        );
      },
      child: Scaffold(
        appBar: AppBar(
          actions: [
            InkWell(
              child: const FaIcon(FontAwesomeIcons.arrowRightFromBracket),
              onTap: () {
                context.read<AuthenticatorWatcherBloc>().add(
                      const AuthenticatorWatcherEvent.signOut(),
                    );
              },
            ),
            const SizedBox(width: 15),
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text('DashBoard Page'),
            ],
          ),
        ),
      ),
    );
  }
}
