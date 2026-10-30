import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:star_mesas_app/app/config/preferences/datosVarios.dart';
import 'package:star_mesas_app/app/config/theme.dart';

bool isDesktop(BuildContext context) {
  return MediaQuery.of(context).size.width > 1200;
}

bool isTablet(BuildContext context) {
  return MediaQuery.of(context).size.width < 1100 &&
      MediaQuery.of(context).size.width >= 600;
}

bool isMobile(BuildContext context) {
  return MediaQuery.of(context).size.width < 600;
}

int parseInt(dynamic value) {
  if (value == null) return 0;
  if (value is num) return value.toInt();
  if (value is String) {
    return int.tryParse(value) ?? 0;
  }
  return 0;
}

double parseValue(dynamic value) {
  if (value == null) return 0.0;
  if (value is num) return value.toDouble();
  if (value is String) {
    return double.tryParse(value.replaceAll(',', '.')) ?? 0.0;
  }
  return 0.0;
}

String formatQuantity(int amount) {
  final format = NumberFormat.decimalPattern('es_VE');
  return format.format(amount);
}

String formatNum(double v) =>
    NumberFormat.decimalPattern('es_VE').format(v.toInt());

String formatCurrency(double amount, String symbol) {
  final format = NumberFormat.currency(
    locale: 'es_VE',
    symbol: symbol,
    decimalDigits: 2,
  );
  return format.format(amount);
}

String formatMonto(dynamic amount) {
  if (amount == null) return '0,00';
  final double v = amount is num
      ? amount.toDouble()
      : (double.tryParse(amount.toString().replaceAll(',', '.')) ?? 0.0);
  return NumberFormat.currency(
    locale: 'es_VE',
    symbol: '',
    decimalDigits: 2,
  ).format(v).trim();
}

String formatCop(double v) => NumberFormat.currency(
  locale: 'es_CO',
  symbol: 'COP ',
  decimalDigits: 2,
).format(v);

String formatDolar(double v) => NumberFormat.currency(
  locale: 'es_VE',
  symbol: '\$ ',
  decimalDigits: 2,
).format(v);

NumberFormat currency = NumberFormat.currency(
  locale: 'es_VE',
  symbol: '\$',
  decimalDigits: 2,
);

String formatFecha(DateTime? fecha) {
  if (fecha == null || fecha.year <= 2000) return 'Sin Fecha de Vencimiento';
  return '${fecha.day.toString().padLeft(2, '0')}/${fecha.month.toString().padLeft(2, '0')}/${fecha.year}';
}

// Formatea la fecha para enviar al backend (yyyy-MM-dd)
String? fechaParaBackend(DateTime? fecha) {
  if (fecha == null || fecha.year <= 2000) return null;
  return '${fecha.year}-${fecha.month.toString().padLeft(2, '0')}-${fecha.day.toString().padLeft(2, '0')}';
}

Color parseColor(String colorString, Color defaultColor) {
  if (colorString.isEmpty) return defaultColor;
  try {
    return Color(int.parse(colorString));
  } catch (e) {
    return defaultColor;
  }
}

Color get colorGeneralStarLight => Color(0xFF1A4FA8);
const kAccent = Color(0xFF3B82F6);
const kGold = Color(0xFFF59E0B);
const kSurface = Color(0xFFF8FAFF);
const kBorder = Color(0xFFD1DCF0);
const kTextPrimary = Color(0xFF0F172A);
const kTextSecondary = Color(0xFF64748B);

final colorFondo1 = const Color.fromARGB(255, 217, 228, 247).withOpacity(0.75);
final colorFondo2 = const Color.fromARGB(255, 103, 122, 158).withOpacity(0.10);

const temaDesktopImagen = "assets/imagenes/fondo.jpg";

const temaMovilImagen = "assets/imagenes/fondoMovil2.jpg";

const temaLoginDesktopImagen = "assets/imagenes/login.jpg";

const imagenUsuarioPredeterminada = "assets/imagenes/user.jpg";

const cardColorClaro = Colors.white;

const bordeClaroInicio = Color.fromARGB(236, 42, 49, 42);

String? _cachedThemeConfigStr;
Color? _cachedColorGeneralStar;

Color get colorGeneralStar {
  final currentThemeStr = DatosVarios().themeConfig;
  if (_cachedThemeConfigStr == currentThemeStr &&
      _cachedColorGeneralStar != null) {
    return _cachedColorGeneralStar!;
  }

  _cachedThemeConfigStr = currentThemeStr;
  try {
    _cachedColorGeneralStar = StarTheme.buildTheme(currentThemeStr)
        .primaryColor;
  } catch (_) {
    _cachedColorGeneralStar = const Color.fromARGB(255, 16, 61, 121);
  }
  return _cachedColorGeneralStar!;
}

const defaultPadding = 16.0;

// ========================================
// SISTEMA DE DISEÑO MODERNO - StarSystem
// ========================================

/* 
   Paleta de Colores Unificada
   Diseñada para ser minimalista, moderna y atractiva
*/

// --- Gradientes Modernos (Indigo/Purple) ---
const gradientStart = Color(0xFF6366F1); // Indigo vibrante
const gradientEnd = Color(0xFF8B5CF6); // Purple suave

// --- Colores de Acento (Estados y Acciones) ---
const accentSuccess = Color(0xFF10B981); // Verde moderno
const accentWarning = Color(0xFFF59E0B); // Naranja cálido
const accentError = Color(0xFFEF4444); // Rojo suave
const accentInfo = Color(0xFF3B82F6); // Azul brillante

// --- Neutrales (Backgrounds y Texto) ---
const neutralBackground = Color(0xFFFAFBFC); // Gris muy claro, cálido
const neutralSurface = Color(0xFFFFFFFF); // Blanco puro
const neutralBorder = Color(0xFFE5E7EB); // Gris suave para bordes
const neutralTextPrimary = Color(0xFF1F2937); // Casi negro, mejor legibilidad
const neutralTextSecondary = Color(0xFF6B7280); // Gris medio
const neutralTextTertiary = Color(0xFF9CA3AF); // Gris claro

// --- Colores de Superficie (Cards, Containers) ---
const surfaceLight = Color(0xFFF9FAFB); // Gris muy claro
const surfaceMedium = Color(0xFFF3F4F6); // Gris claro
const surfaceDark = Color(0xFFE5E7EB); // Gris medio

/* 
   Sistema de Espaciado Consistente
   Base: 8px (múltiplos de 8 para consistencia)
*/

const radiusSmall = 8.0; // Pequeño
const radiusMedium = 12.0; // Medio (estándar)
const radiusLarge = 16.0; // Grande
const radiusXLarge = 20.0; // Extra grande
const radiusFull = 999.0; // Completamente redondeado

/* 
   Elevaciones (Sombras)
   Para crear jerarquía visual
*/

// Sombra pequeña (cards, botones)
final shadowSmall = [
  BoxShadow(
    color: Colors.black.withOpacity(0.05),
    blurRadius: 10,
    offset: const Offset(0, 2),
  ),
];

// Sombra media (modals, dropdowns)
final shadowMedium = [
  BoxShadow(
    color: Colors.black.withOpacity(0.08),
    blurRadius: 20,
    offset: const Offset(0, 4),
  ),
];

// Sombra grande (dialogs, importantes)
final shadowLarge = [
  BoxShadow(
    color: Colors.black.withOpacity(0.12),
    blurRadius: 30,
    offset: const Offset(0, 8),
  ),
];

const durationFast = Duration(milliseconds: 150); // Hover, press
const durationNormal = Duration(milliseconds: 250); // Transiciones
const durationSlow = Duration(milliseconds: 350); // Animaciones complejas
