import 'package:shared_preferences/shared_preferences.dart';
import 'package:star_mesas_app/app/config/database/database.dart';
import 'package:star_mesas_app/app/config/preferences/secureStorage.dart';

class DatosConexionBd {
  static final _storage = SafeSecureStorage();

  // Variables de caché en memoria para accesos síncronos
  static String _usuarioBD = '';
  static String _nombreBaseD = '';
  static String _contrasenaBD = '';
  static String _conexionApiHttp = 'http://localhost/starConexionPuntoVenta';
  static String _puertoBaseD = '3306';
  static String _ipBaseD = 'localhost';
  static String _tokenDigital = '';
  static String _userDigital = const String.fromEnvironment(
    'USER_DIGITAL',
    defaultValue: '',
  );
  static String _passDigital = const String.fromEnvironment(
    'PASS_DIGITAL',
    defaultValue: '',
  );
  static String _passAdmin = const String.fromEnvironment(
    'passAdmin',
    defaultValue: '13112001',
  );
  static String _direccionImg = "";

  static String _themeConfig = "";
  static String _logoPrin = "";
  static String _imprimirFiscal = "http://localhost:8080/imprimir/";
  static String _dirApiImp = 'C:/xampp/htdocs/apiFiscal/StarSystem IMP.exe';
  static DateTime _fechaVenciPos = DateTime.now();
  static String _uuidPos = "";
  static String _codigoPos = "";
  static int _numFacHechas = 0;

  static bool _posSinActivacion = false;

  static Future init() async {
    // 1. Intentar migrar desde SharedPreferences tradicionales si existen
    final prefs = await SharedPreferences.getInstance();

    final legacyUser = prefs.getString('usuarioBD');
    final legacyNombre = prefs.getString('nombreBaseD');
    final legacyPass = prefs.getString('contrasenaBD');
    final legacyHttp = prefs.getString('conexionApiHttp');
    final legacyPuerto = prefs.getString('puertoBD');
    final legacyIp = prefs.getString('ipBD');
    final legacyToken = prefs.getString('tokenDigitalFAC');
    final legacyUserDig = prefs.getString('userDigitalFAC');
    final legacyPassDig = prefs.getString('passDigitalFAC');
    final legacyPassAdmin = prefs.getString('passAdmin');
    final legacyDireccionImg = prefs.getString('direccionImg');
    final legacyThemeConfig = prefs.getString('themeConfig');
    final legacyLogoPrin = prefs.getString('logoPrin');
    final legacyImprimirFiscal = prefs.getString('imprimirFiscal');
    final legacyDirApiImp = prefs.getString('dirApiImp');
    final legacyVenc = prefs.getString('fechaVenciPos');
    final legacyUuidPos = prefs.getString('uuidPos');
    final legacyCodigoPos = prefs.getString('codigoPos');
    final legacyNumFacHechas = prefs.getInt('numFacHechas');
    final legacyPosSinActivacion = prefs.getBool('posSinActivacion');

    // Si encontramos al menos una de las configuraciones clave en SharedPreferences antiguas
    if (legacyUser != null || legacyNombre != null || legacyIp != null) {
      if (legacyUser != null) {
        await _storage.write(key: 'usuarioBD', value: legacyUser);
        await prefs.remove('usuarioBD');
      }
      if (legacyNombre != null) {
        await _storage.write(key: 'nombreBaseD', value: legacyNombre);
        await prefs.remove('nombreBaseD');
      }
      if (legacyPass != null) {
        await _storage.write(key: 'contrasenaBD', value: legacyPass);
        await prefs.remove('contrasenaBD');
      }
      if (legacyHttp != null) {
        await _storage.write(key: 'conexionApiHttp', value: legacyHttp);
        await prefs.remove('conexionApiHttp');
      }
      if (legacyPuerto != null) {
        await _storage.write(key: 'puertoBD', value: legacyPuerto);
        await prefs.remove('puertoBD');
      }
      if (legacyIp != null) {
        await _storage.write(key: 'ipBD', value: legacyIp);
        await prefs.remove('ipBD');
      }
      if (legacyToken != null) {
        await _storage.write(key: 'tokenDigitalFAC', value: legacyToken);
        await prefs.remove('tokenDigitalFAC');
      }
      if (legacyUserDig != null) {
        await _storage.write(key: 'userDigitalFAC', value: legacyUserDig);
        await prefs.remove('userDigitalFAC');
      }
      if (legacyPassDig != null) {
        await _storage.write(key: 'passDigitalFAC', value: legacyPassDig);
        await prefs.remove('passDigitalFAC');
      }
      if (legacyPassAdmin != null) {
        await _storage.write(key: 'passAdmin', value: legacyPassAdmin);
        await prefs.remove('passAdmin');
      }
      if (legacyDireccionImg != null) {
        await _storage.write(key: 'direccionImg', value: legacyDireccionImg);
        await prefs.remove('direccionImg');
      }
      if (legacyThemeConfig != null) {
        await _storage.write(key: 'themeConfig', value: legacyThemeConfig);
        await prefs.remove('themeConfig');
      }
      if (legacyLogoPrin != null) {
        await _storage.write(key: 'logoPrin', value: legacyLogoPrin);
        await prefs.remove('logoPrin');
      }
      if (legacyImprimirFiscal != null) {
        await _storage.write(
          key: 'imprimirFiscal',
          value: legacyImprimirFiscal,
        );
        await prefs.remove('imprimirFiscal');
      }
      if (legacyDirApiImp != null) {
        await _storage.write(key: 'dirApiImp', value: legacyDirApiImp);
        await prefs.remove('dirApiImp');
      }
      if (legacyVenc != null) {
        await _storage.write(key: 'fechaVenciPos', value: legacyVenc);
        await prefs.remove('fechaVenciPos');
      }
      if (legacyUuidPos != null) {
        await _storage.write(key: 'uuidPos', value: legacyUuidPos);
        await prefs.remove('uuidPos');
      }
      if (legacyCodigoPos != null) {
        await _storage.write(key: 'codigoPos', value: legacyCodigoPos);
        await prefs.remove('codigoPos');
      }
      if (legacyNumFacHechas != null) {
        await _storage.write(
          key: 'numFacHechas',
          value: legacyNumFacHechas.toString(),
        );
        await prefs.remove('numFacHechas');
      }
      if (legacyPosSinActivacion != null) {
        await _storage.write(
          key: 'posSinActivacion',
          value: legacyPosSinActivacion.toString(),
        );
        await prefs.remove('posSinActivacion');
      }
    }

    // 2. Cargar datos desde el almacenamiento seguro a la caché en memoria usando readAll para optimizar accesos
    final allData = await _storage.readAll();
    _usuarioBD = allData['usuarioBD'] ?? '';
    _nombreBaseD = allData['nombreBaseD'] ?? '';
    _contrasenaBD = allData['contrasenaBD'] ?? '';
    _conexionApiHttp =
        allData['conexionApiHttp'] ?? 'http://localhost/starConexionPuntoVenta';
    _puertoBaseD = allData['puertoBD'] ?? '3306';
    _ipBaseD = allData['ipBD'] ?? 'localhost';
    _tokenDigital = allData['tokenDigitalFAC'] ?? '';
    _themeConfig = allData['themeConfig'] ?? '';
    _logoPrin = allData['logoPrin'] ?? '';
    _imprimirFiscal =
        allData['imprimirFiscal'] ?? 'http://localhost:8080/imprimir/';

    final String defaultUserDig = const String.fromEnvironment(
      'USER_DIGITAL',
      defaultValue: 'gwygmzeuijgl_tfhka',
    );
    final String defaultPassDig = const String.fromEnvironment(
      'PASS_DIGITAL',
      defaultValue: r'me$l.Tl;+oN!',
    );
    final String envPassAdmin = const String.fromEnvironment(
      'passAdmin',
      defaultValue: '13112001',
    );
    final String defaultPassAdmin = envPassAdmin.isNotEmpty
        ? envPassAdmin
        : '13112001';

    _userDigital =
        (allData['userDigitalFAC'] != null &&
            allData['userDigitalFAC']!.isNotEmpty)
        ? allData['userDigitalFAC']!
        : defaultUserDig;
    _passDigital =
        (allData['passDigitalFAC'] != null &&
            allData['passDigitalFAC']!.isNotEmpty)
        ? allData['passDigitalFAC']!
        : defaultPassDig;

    // Se deja vacío por ahora para permitir cargar desde SQLite si es necesario
    _passAdmin =
        (allData['passAdmin'] != null && allData['passAdmin']!.isNotEmpty)
        ? allData['passAdmin']!
        : '';

    _direccionImg = allData['direccionImg'] ?? "";
    _themeConfig = allData['themeConfig'] ?? "";
    _logoPrin = allData['logoPrin'] ?? "";
    _imprimirFiscal =
        allData['imprimirFiscal'] ?? 'http://localhost:8080/imprimir/';
    _dirApiImp =
        allData['dirApiImp'] ?? 'C:/xampp/htdocs/apiFiscal/StarSystem IMP.exe';
    _fechaVenciPos = DateTime.parse(
      allData['fechaVenciPos'] ?? DateTime.now().toIso8601String(),
    );
    _uuidPos = allData['uuidPos'] ?? '';
    _codigoPos = allData['codigoPos'] ?? '';
    _numFacHechas = int.parse(allData['numFacHechas'] ?? '0');
    _posSinActivacion = bool.parse(allData['posSinActivacion'] ?? 'false');

    // 3. Si themeConfig, logoPrin o passAdmin están vacíos en almacenamiento seguro, intentar cargar desde SQLite local (servicios)
    try {
      final db = LocalDbService.instance;
      final servicios = await db.obtenerTodosServicios();
      if (servicios.isNotEmpty) {
        final primer = servicios.first;
        final dbTheme = primer['themeConfig']?.toString() ?? '';
        final dbLogo = primer['logoPrin']?.toString() ?? '';
        final dbPass = primer['pass']?.toString() ?? '';

        if (_themeConfig.isEmpty && dbTheme.isNotEmpty) {
          _themeConfig = dbTheme;
          await _storage.write(key: 'themeConfig', value: dbTheme);
        }
        if (_logoPrin.isEmpty && dbLogo.isNotEmpty) {
          _logoPrin = dbLogo;
          await _storage.write(key: 'logoPrin', value: dbLogo);
        }
        if (_passAdmin.isEmpty && dbPass.isNotEmpty) {
          _passAdmin = dbPass;
          await _storage.write(key: 'passAdmin', value: dbPass);
        }
      }
    } catch (_) {}

    // 4. Si después de todo sigue vacío, usar el de --dart-define por defecto
    if (_passAdmin.isEmpty) {
      _passAdmin = defaultPassAdmin;
    }
  }

  //usuarioBD
  String get usuarioBD => _usuarioBD;

  set usuarioBD(String value) {
    _usuarioBD = value;
    _storage.write(key: 'usuarioBD', value: value);
  }

  //nombreBD
  String get nombreBaseD => _nombreBaseD;

  set nombreBaseD(String value) {
    _nombreBaseD = value;
    _storage.write(key: 'nombreBaseD', value: value);
  }

  //passConexionBD
  String get contrasenaBD => _contrasenaBD;

  set contrasenaBD(String value) {
    _contrasenaBD = value;
    _storage.write(key: 'contrasenaBD', value: value);
  }

  //httpBD
  String get conexionApiHttp => _conexionApiHttp;

  set conexionApiHttp(String value) {
    _conexionApiHttp = value;
    _storage.write(key: 'conexionApiHttp', value: value);
  }

  //puertoBD
  String get puertoBaseD => _puertoBaseD;

  set puertoBaseD(String value) {
    _puertoBaseD = value;
    _storage.write(key: 'puertoBD', value: value);
  }

  //ipBD
  String get ipBaseD => _ipBaseD;

  set ipBaseD(String value) {
    _ipBaseD = value;
    _storage.write(key: 'ipBD', value: value);
  }

  //tokenDigital
  String get tokenDigital => _tokenDigital;

  set tokenDigital(String value) {
    _tokenDigital = value;
    _storage.write(key: 'tokenDigitalFAC', value: value);
  }

  //userDigital
  String get userDigital => _userDigital.isNotEmpty
      ? _userDigital
      : const String.fromEnvironment(
          'USER_DIGITAL',
          defaultValue: 'gwygmzeuijgl_tfhka',
        );

  set userDigital(String value) {
    _userDigital = value;
    _storage.write(key: 'userDigitalFAC', value: value);
  }

  //passDigital
  String get passDigital => _passDigital.isNotEmpty
      ? _passDigital
      : const String.fromEnvironment(
          'PASS_DIGITAL',
          defaultValue: r'me$l.Tl;+oN!',
        );

  set passDigital(String value) {
    _passDigital = value;
    _storage.write(key: 'passDigitalFAC', value: value);
  }

  String get passAdmin {
    if (_passAdmin.isNotEmpty) return _passAdmin;
    final envPass = const String.fromEnvironment(
      'passAdmin',
      defaultValue: '13112001',
    );
    return envPass.isNotEmpty ? envPass : '13112001';
  }

  set passAdmin(String value) {
    _passAdmin = value;
    _storage.write(key: 'passAdmin', value: value);
  }

  String get direccionImg => _direccionImg;

  set direccionImg(String value) {
    _direccionImg = value;
    _storage.write(key: 'direccionImg', value: value);
  }

  String get themeConfig => _themeConfig;

  set themeConfig(String value) {
    _themeConfig = value;
    _storage.write(key: 'themeConfig', value: value);
  }

  String get logoPrin => _logoPrin;

  set logoPrin(String value) {
    _logoPrin = value;
    _storage.write(key: 'logoPrin', value: value);
  }

  String get imprimirFiscal => _imprimirFiscal.isNotEmpty
      ? _imprimirFiscal
      : 'http://localhost:8085/imprimir/';

  set imprimirFiscal(String value) {
    _imprimirFiscal = value;
    _storage.write(key: 'imprimirFiscal', value: value);
  }

  String get dirApiImp => _dirApiImp;

  set dirApiImp(String value) {
    _dirApiImp = value;
    _storage.write(key: 'dirApiImp', value: value);
  }

  DateTime get fechaVenciPos => _fechaVenciPos;
  set fechaVenciPos(DateTime value) {
    _fechaVenciPos = value;
    _storage.write(key: 'fechaVenciPos', value: value.toString());
  }

  String get uuidPos => _uuidPos;
  set uuidPos(String value) {
    _uuidPos = value;
    _storage.write(key: 'uuidPos', value: value);
  }

  String get codigoPos => _codigoPos;
  set codigoPos(String value) {
    _codigoPos = value;
    _storage.write(key: 'codigoPos', value: value);
  }

  int get numFacHechas => _numFacHechas;
  set numFacHechas(int value) {
    _numFacHechas = value;
    _storage.write(key: 'numFacHechas', value: value.toString());
  }

  bool get posSinActivacion => _posSinActivacion;
  set posSinActivacion(bool value) {
    _posSinActivacion = value;
    _storage.write(key: 'posSinActivacion', value: value.toString());
  }
}
