import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:star_mesas_app/app/presentation/auth/screen/authScreen.dart';
import 'package:star_mesas_app/app/presentation/windows/ventanaPrincipal.dart';
import 'package:star_mesas_app/app/redirigir.dart';

final GoRouter rutaSystem = GoRouter(
  initialLocation: '/',
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const Redirigir();
      },
    ),
    GoRoute(
      path: '/login',
      builder: (BuildContext context, GoRouterState state) {
        return const Login();
      },
    ),
    GoRoute(
      path: '/ventanaPrincipal',
      builder: (BuildContext context, GoRouterState state) {
        return const VentanaPrincipal();
      },
    ),
  ],
);
