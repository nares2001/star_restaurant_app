import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:star_mesas_app/app/config/preferences/datosVarios.dart';
import 'package:star_mesas_app/app/config/theme.dart';
import 'package:star_mesas_app/app/rutas.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: theme(DatosVarios().themeConfig),
      supportedLocales: const [Locale('en'), Locale('es')],
      title: "StarSystem Restarurant",
      routerConfig: rutaSystem,
      builder: (context, child) {
        return Column(
          children: [Expanded(child: child ?? const SizedBox.shrink())],
        );
      },
    );
  }
}
