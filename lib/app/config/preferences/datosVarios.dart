import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:star_mesas_app/app/config/constantes.dart';

// ignore: camel_case_types
class DatosVarios {
  static const _secureStorage = FlutterSecureStorage();

  static double _tasaBCV = 0;
  static String _fechaTasaBCV = "";
  static String _passAdmin = const String.fromEnvironment(
    'passAdmin',
    defaultValue: '',
  );
  static String _themeConfig = '';
  static String _logoPrin = '';
  static String _uuidPos = '';

  static bool _useFallback = false;
  static SharedPreferences? _prefs;

  static Future init() async {
    // 1. Inicializar SharedPreferences
    try {
      _prefs = await SharedPreferences.getInstance();
    } catch (e) {
      debugPrint("Error al inicializar SharedPreferences: $e");
    }

    // 2. Cargar valores iniciales desde FlutterSecureStorage
    try {
      _tasaBCV = double.parse(await _secureStorage.read(key: 'tasaBCV') ?? '0');
      _fechaTasaBCV = await _secureStorage.read(key: 'fechaTasaBCV') ?? '';
      _passAdmin = await _secureStorage.read(key: 'passAdmin') ?? '';
      _themeConfig = await _secureStorage.read(key: 'themeConfig') ?? '';
      _logoPrin = await _secureStorage.read(key: 'logoPrin') ?? '';
      _uuidPos = await _secureStorage.read(key: 'uuidPos') ?? '';
    } catch (e) {
      debugPrint(
        "Error al leer desde FlutterSecureStorage: $e. Usando SharedPreferences como fallback.",
      );
      _useFallback = true;
      if (_prefs != null) {
        _tasaBCV = double.parse(_prefs!.getString('tasaBCV') ?? '0');
        _fechaTasaBCV = _prefs!.getString('fechaTasaBCV') ?? '';
        _passAdmin = _prefs!.getString('passAdmin') ?? '';
        _themeConfig = _prefs!.getString('themeConfig') ?? '';
        _logoPrin = _prefs!.getString('logoPrin') ?? '';
        _uuidPos = _prefs!.getString('uuidPos') ?? '';
      }
    }
  }

  double get tasaBCV {
    return _tasaBCV;
  }

  set tasaBCV(double value) {
    _tasaBCV = value;
    if (_useFallback) {
      _prefs?.setDouble('tasaBCV', value);
    } else {
      _secureStorage.write(key: 'tasaBCV', value: value.toString()).catchError((
        e,
      ) {
        debugPrint("Error al escribir tasaBCV en SecureStorage: $e");
      });
    }
  }

  String get fechaTasaBCV {
    return _fechaTasaBCV;
  }

  set fechaTasaBCV(String value) {
    _fechaTasaBCV = value;
    if (_useFallback) {
      _prefs?.setString('fechaTasaBCV', value);
    } else {
      _secureStorage.write(key: 'fechaTasaBCV', value: value).catchError((e) {
        debugPrint("Error al escribir fechaTasaBCV en SecureStorage: $e");
      });
    }
  }

  String get passAdmin {
    return _passAdmin;
  }

  set passAdmin(String value) {
    _passAdmin = value;
    if (_useFallback) {
      _prefs?.setString('passAdmin', value);
    } else {
      _secureStorage.write(key: 'passAdmin', value: value).catchError((e) {
        debugPrint("Error al escribir passAdmin en SecureStorage: $e");
      });
    }
  }

  String get themeConfig {
    return _themeConfig;
  }

  set themeConfig(String value) {
    _themeConfig = value;
    if (_useFallback) {
      _prefs?.setString('themeConfig', value);
    } else {
      _secureStorage.write(key: 'themeConfig', value: value).catchError((e) {
        debugPrint("Error al escribir themeConfig en SecureStorage: $e");
      });
    }
  }

  String get logoPrin {
    return _logoPrin;
  }

  set logoPrin(String value) {
    _logoPrin = value;
    if (_useFallback) {
      _prefs?.setString('logoPrin', value);
    } else {
      _secureStorage.write(key: 'logoPrin', value: value).catchError((e) {
        debugPrint("Error al escribir logoPrin en SecureStorage: $e");
      });
    }
  }

  String get uuidPos {
    return _uuidPos;
  }

  set uuidPos(String value) {
    _uuidPos = value;
    if (_useFallback) {
      _prefs?.setString('uuidPos', value);
    } else {
      _secureStorage.write(key: 'uuidPos', value: value).catchError((e) {
        debugPrint("Error al escribir uuidPos en SecureStorage: $e");
      });
    }
  }

  Future<void> guardarDatosInicioSesion({
    required Map<String, dynamic> datos,
  }) async {
    tasaBCV = parseValue(datos['tasaBCV']?.toString() ?? '0');
    fechaTasaBCV = datos['fechaTasaBCV']?.toString() ?? '';
  }

  Future<void> eliminarDatosSesion() async {
    passAdmin = '';
    themeConfig = '';
    logoPrin = '';
  }
}
