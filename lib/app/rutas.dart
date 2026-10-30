import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
  ],
);
