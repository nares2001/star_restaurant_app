import 'dart:convert';

import 'package:flutter/material.dart';

/// Modelo principal para la configuración del tema visual
class ModeloTheme {
  final ThemeColors? colors;
  final String? brightness;
  final ThemeComponents? components;
  final ThemeTypography? typography;

  ModeloTheme({this.colors, this.brightness, this.components, this.typography});

  factory ModeloTheme.fromRawJson(String str) =>
      ModeloTheme.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ModeloTheme.fromJson(Map<String, dynamic> json) => ModeloTheme(
    colors: json["colors"] == null
        ? null
        : ThemeColors.fromJson(json["colors"]),
    brightness: json["brightness"] as String?,
    components: json["components"] == null
        ? null
        : ThemeComponents.fromJson(json["components"]),
    typography: json["typography"] == null
        ? null
        : ThemeTypography.fromJson(json["typography"]),
  );

  Map<String, dynamic> toJson() => {
    "colors": colors?.toJson(),
    "brightness": brightness,
    "components": components?.toJson(),
    "typography": typography?.toJson(),
  };

  ModeloTheme copyWith({
    ThemeColors? colors,
    String? brightness,
    ThemeComponents? components,
    ThemeTypography? typography,
  }) {
    return ModeloTheme(
      colors: colors ?? this.colors,
      brightness: brightness ?? this.brightness,
      components: components ?? this.components,
      typography: typography ?? this.typography,
    );
  }
}

/// Colores definidos en el tema
class ThemeColors {
  final String? error;
  final String? onError;
  final String? primary;
  final String? surface;
  final String? onPrimary;
  final String? onSurface;
  final String? secondary;
  final String? background;
  final String? onSecondary;
  final String? onBackground;

  ThemeColors({
    this.error,
    this.onError,
    this.primary,
    this.surface,
    this.onPrimary,
    this.onSurface,
    this.secondary,
    this.background,
    this.onSecondary,
    this.onBackground,
  });

  factory ThemeColors.fromJson(Map<String, dynamic> json) => ThemeColors(
    error: json["error"] as String?,
    onError: json["onError"] as String?,
    primary: json["primary"] as String?,
    surface: json["surface"] as String?,
    onPrimary: json["onPrimary"] as String?,
    onSurface: json["onSurface"] as String?,
    secondary: json["secondary"] as String?,
    background: json["background"] as String?,
    onSecondary: json["onSecondary"] as String?,
    onBackground: json["onBackground"] as String?,
  );

  Map<String, dynamic> toJson() => {
    "error": error,
    "onError": onError,
    "primary": primary,
    "surface": surface,
    "onPrimary": onPrimary,
    "onSurface": onSurface,
    "secondary": secondary,
    "background": background,
    "onSecondary": onSecondary,
    "onBackground": onBackground,
  };

  /// Convierte un string en formato Hex / 0x a objeto [Color] de Flutter
  static Color? _parseColor(String? hexString) {
    if (hexString == null || hexString.trim().isEmpty) return null;
    String cleanHex = hexString.trim().replaceAll('#', '');
    if (cleanHex.startsWith('0x') || cleanHex.startsWith('0X')) {
      cleanHex = cleanHex.substring(2);
    }
    if (cleanHex.length == 6) {
      cleanHex = 'FF$cleanHex';
    }
    try {
      return Color(int.parse(cleanHex, radix: 16));
    } catch (_) {
      return null;
    }
  }

  Color? get primaryColor => _parseColor(primary);
  Color? get secondaryColor => _parseColor(secondary);
  Color? get errorColor => _parseColor(error);
  Color? get backgroundColor => _parseColor(background);
  Color? get surfaceColor => _parseColor(surface);
  Color? get onPrimaryColor => _parseColor(onPrimary);
  Color? get onSecondaryColor => _parseColor(onSecondary);
  Color? get onBackgroundColor => _parseColor(onBackground);
  Color? get onSurfaceColor => _parseColor(onSurface);
  Color? get onErrorColor => _parseColor(onError);
}

/// Parámetros visuales de componentes (tarjetas, botones, appbar, etc.)
class ThemeComponents {
  final double? cardElevation;
  final double? appBarElevation;
  final double? cardBorderRadius;
  final bool? appBarCenterTitle;
  final double? buttonBorderRadius;

  ThemeComponents({
    this.cardElevation,
    this.appBarElevation,
    this.cardBorderRadius,
    this.appBarCenterTitle,
    this.buttonBorderRadius,
  });

  factory ThemeComponents.fromJson(Map<String, dynamic> json) =>
      ThemeComponents(
        cardElevation: (json["cardElevation"] as num?)?.toDouble(),
        appBarElevation: (json["appBarElevation"] as num?)?.toDouble(),
        cardBorderRadius: (json["cardBorderRadius"] as num?)?.toDouble(),
        appBarCenterTitle: json["appBarCenterTitle"] as bool?,
        buttonBorderRadius: (json["buttonBorderRadius"] as num?)?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
    "cardElevation": cardElevation,
    "appBarElevation": appBarElevation,
    "cardBorderRadius": cardBorderRadius,
    "appBarCenterTitle": appBarCenterTitle,
    "buttonBorderRadius": buttonBorderRadius,
  };
}

/// Configuración tipográfica
class ThemeTypography {
  final String? fontFamily;

  ThemeTypography({this.fontFamily});

  factory ThemeTypography.fromJson(Map<String, dynamic> json) =>
      ThemeTypography(fontFamily: json["fontFamily"] as String?);

  Map<String, dynamic> toJson() => {"fontFamily": fontFamily};
}
