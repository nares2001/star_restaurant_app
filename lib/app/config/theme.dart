import 'package:flutter/material.dart';

import 'package:star_mesas_app/app/models/modeloTheme.dart';

ThemeData theme([dynamic config]) {
  return StarTheme.buildTheme(config);
}

class StarTheme {
  static const List<String> availableFonts = [
    'Montserrat',
    'Poppins',
    'Roboto',
    'Open Sans',
    'Lato',
    'Inter',
  ];
  static ThemeData buildTheme([dynamic config]) {
    // Valores por defecto
    Color primary = primaryColor;
    Color secondary = secondaryColor;
    Color error = errorColor;
    Color background = tertiaryColor;
    Color surface = Colors.white;
    Color onPrimary = Colors.white;
    Color onSecondary = Colors.black;
    Color onBackground = Colors.black;
    Color onSurface = Colors.black;
    Color onError = Colors.white;
    Brightness brightness = Brightness.light;
    String fontFamily = 'Poppins';

    ModeloTheme? modeloTheme;

    if (config is ModeloTheme) {
      modeloTheme = config;
    } else if (config is String && config.isNotEmpty) {
      try {
        modeloTheme = ModeloTheme.fromRawJson(config);
      } catch (_) {}
    } else if (config is Map<String, dynamic>) {
      try {
        modeloTheme = ModeloTheme.fromJson(config);
      } catch (_) {}
    }

    if (modeloTheme != null) {
      if (modeloTheme.colors != null) {
        final c = modeloTheme.colors!;
        primary = c.primaryColor ?? primary;
        secondary = c.secondaryColor ?? secondary;
        error = c.errorColor ?? error;
        background = c.backgroundColor ?? background;
        surface = c.surfaceColor ?? surface;
        onPrimary = c.onPrimaryColor ?? onPrimary;
        onSecondary = c.onSecondaryColor ?? onSecondary;
        onBackground = c.onBackgroundColor ?? onBackground;
        onSurface = c.onSurfaceColor ?? onSurface;
        onError = c.onErrorColor ?? onError;
      }

      if (modeloTheme.brightness?.toLowerCase() == 'dark') {
        brightness = Brightness.dark;
      }

      if (modeloTheme.typography?.fontFamily != null &&
          modeloTheme.typography!.fontFamily!.isNotEmpty) {
        fontFamily = modeloTheme.typography!.fontFamily!;
      }
    }

    TextTheme baseTextTheme = _getTextTheme(fontFamily);

    final components = modeloTheme?.components;

    final normalizedFont = normalizeFontFamily(fontFamily);

    return ThemeData(
      fontFamily: normalizedFont,
      primaryColor: primary,
      scaffoldBackgroundColor: background,
      canvasColor: Colors.white,
      cardColor: Colors.white,
      dialogTheme: const DialogThemeData(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
      ),
      textTheme: baseTextTheme,
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: primary,
        onPrimary: onPrimary,
        secondary: secondary,
        onSecondary: onSecondary,
        error: error,
        onError: onError,
        surface: surface,
        onSurface: onSurface,
      ),
      elevatedButtonTheme: components?.buttonBorderRadius != null
          ? ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    components!.buttonBorderRadius!,
                  ),
                ),
              ),
            )
          : null,
      cardTheme: components != null
          ? CardThemeData(
              elevation: components.cardElevation ?? 2.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  components.cardBorderRadius ?? 12.0,
                ),
              ),
            )
          : null,
    );
  }

  static String normalizeFontFamily(String font) {
    switch (font.toLowerCase().replaceAll(' ', '').replaceAll('-', '')) {
      case 'montserrat':
        return 'Montserrat';
      case 'inter':
        return 'Inter';
      case 'poppins':
        return 'Poppins';
      case 'roboto':
        return 'Roboto';
      case 'opensans':
        return 'Open Sans';
      case 'lato':
        return 'Lato';
      default:
        return 'Poppins';
    }
  }

  static TextTheme _getTextTheme(String font) {
    final family = normalizeFontFamily(font);
    return Typography.material2021().black.apply(fontFamily: family);
  }

  static Color? parseHexColor(String? hexString) {
    if (hexString == null || hexString.isEmpty) return null;
    hexString = hexString.replaceAll('#', '');
    if (hexString.startsWith('0x') || hexString.startsWith('0X')) {
      hexString = hexString.substring(2);
    }
    if (hexString.length == 6) {
      hexString = 'FF$hexString';
    }
    try {
      return Color(int.parse(hexString, radix: 16));
    } catch (e) {
      return null;
    }
  }

  static const primaryColor = Color.fromARGB(255, 16, 61, 121); // #103D79
  static const secondaryColor = Color.fromARGB(255, 0, 0, 0);
  static const tertiaryColor = Color.fromARGB(255, 255, 255, 255);
  static const errorColor = Color.fromARGB(255, 255, 0, 0);

  static const headerColor = Color.fromARGB(255, 0, 0, 0);

  static Color colorFechaDesde1 = const Color(
    0xFF103D79,
  ); // Azul corporativo StarSystem
  static Color colorFechaDesde2 = const Color(0xFF1E529A); // Azul medio sobrio

  static Color colorFechaHasta1 = const Color.fromARGB(
    255,
    17,
    90,
    84,
  ); // Teal / Azul petróleo elegante
  static Color colorFechaHasta2 = const Color.fromARGB(
    255,
    7,
    107,
    99,
  ); // Teal sobrio

  static IconData getIconFromCodePoint(int cp) {
    const availableIcons = <IconData>[
      Icons.important_devices,
      Icons.web,
      Icons.phone_android,
      Icons.cloud,
      Icons.security,
      Icons.analytics,
      Icons.shopping_cart,
      Icons.design_services,
      Icons.code,
      Icons.api,
      Icons.storage,
      Icons.rocket_launch,
      Icons.shopping_bag,
      Icons.star,
      Icons.help,
      Icons.info,
      Icons.settings,
    ];
    for (final icon in availableIcons) {
      if (icon.codePoint == cp) return icon;
    }
    return Icons.important_devices;
  }
}
