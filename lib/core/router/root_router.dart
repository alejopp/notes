import 'package:bext_notes/core/theme/app_theme.dart';
import 'package:bext_notes/core/theme/theme_cubit.dart';
import 'package:bext_notes/features/auth/bloc/bloc.dart';
import 'package:bext_notes/features/auth/presentation/pages/login_screen.dart';
import 'package:bext_notes/features/notes/presentation/pages/notes_page.dart';
import 'package:bext_notes/features/profile/presentation/pages/profile_page.dart';
import 'package:bext_notes/features/setting/presentation/pages/setting_page.dart';
import 'package:bext_notes/features/splash/presentation/screen/splash_screen.dart';
import 'package:bext_notes/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'router_refresh_stream.dart';

class RootRouter extends StatelessWidget {
  const RootRouter({super.key});

  @override
  Widget build(BuildContext context) {
    final authBloc = context.read<AuthBloc>();
    final router = GoRouter(
      initialLocation: '/splash',
      refreshListenable: GoRouterRefreshStream(authBloc.stream),
      redirect: (context, state) {
        final authState = authBloc.state;
        final isSplash = state.matchedLocation == '/splash';
        final isLogin = state.matchedLocation == '/login';
        final isAuthenticated = authState is Authenticated;

        if (authState is AuthInitial || authState is AuthLoading) {
          return isSplash ? null : '/splash';
        }

        if (!isAuthenticated) {
          return isLogin ? null : '/login';
        }

        if (isLogin || isSplash) {
          return '/home';
        }

        return null;
      },
      routes: [
        GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
        GoRoute(path: '/notes', builder: (_, __) => const NotesPage()),
        GoRoute(path: '/profile', builder: (_, __) => const ProfilePage()),
        GoRoute(path: '/settings', builder: (_, __) => const SettingPage()),
        GoRoute(
          path: '/splash',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const SplashScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) =>
                    FadeTransition(opacity: animation, child: child),
          ),
        ),
        GoRoute(
          path: '/home',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const HomeScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) =>
                    SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1, 0), // de la derecha
                end: Offset.zero,
              ).animate(animation),
              child: child,
            ),
          ),
        ),
      ],
    );

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Notas',
      routerConfig: router,
      themeMode: context.watch<ThemeCubit>().state,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
    );
  }
}
