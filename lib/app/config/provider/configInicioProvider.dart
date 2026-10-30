import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:http/http.dart' as http;
import 'package:star_mesas_app/app/config/conexiones.dart';
import 'package:star_mesas_app/app/config/consultasHttp/consultasHttp.dart';
import 'package:star_mesas_app/app/config/database/database.dart';
import 'package:star_mesas_app/app/config/preferences/datosVarios.dart';
import 'package:star_mesas_app/app/config/provider/conexionProvider.dart';
import 'package:star_mesas_app/app/config/provider/providerDatosPos.dart';

class ConfiguracionInicial {
  Future<bool> validarConexionNube() async {
    try {
      final hasNet = await ConnectivityChecker.hasConnection();
      if (!hasNet) return false;

      final respuesta = await http
          .get(Uri.parse(validarConexion))
          .timeout(const Duration(seconds: 5));

      if (respuesta.statusCode == 200 ||
          respuesta.statusCode == 201 ||
          respuesta.statusCode == 403) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<void> traerConfiguracion() async {
    final dynamic datos = {"accion": "traerConfiguracion"};
    ConsultasHttp resultado = await ConsultasHttpService.consultarHttp(
      datos: datos,
      conexion: serviciosConexion,
    );
    if (resultado.ok) {
      final data = resultado.datos;
      final configList =
          data['datos']?['configuracion'] ?? data['configuracion'];
      if (configList != null && configList is List && configList.isNotEmpty) {
        final config = configList[0];
        final pass = config['pass']?.toString() ?? DatosVarios().passAdmin;
        final defaultTheme =
            '{"colors": {"error": "0xFFBD1919", "onError": "0xFFFFFFFF", "primary": "0xFF0055FF", "surface": "0xFFFFFFFF", "onPrimary": "0xFFFFFFFF", "onSurface": "0xFF111827", "secondary": "0xFF00D4FF", "background": "0xFFF3F4F6", "onSecondary": "0xFF000000", "onBackground": "0xFF111827"}, "brightness": "light", "components": {"cardElevation": 2, "appBarElevation": 0, "cardBorderRadius": 12, "appBarCenterTitle": true, "buttonBorderRadius": 8}, "typography": {"fontFamily": "Montserrat"}}';
        final themeConfigRaw = config['themeConfig']?.toString();
        final themeConfig =
            (themeConfigRaw != null && themeConfigRaw.isNotEmpty)
            ? themeConfigRaw
            : (DatosVarios().themeConfig.isNotEmpty
                  ? DatosVarios().themeConfig
                  : defaultTheme);
        DatosVarios().themeConfig = themeConfig;

        final logoPrin = config['logoPrin']?.toString();
        if (logoPrin != null && logoPrin.isNotEmpty) {
          DatosVarios().logoPrin = logoPrin;
        }
        final logoAguardar = (logoPrin != null && logoPrin.isNotEmpty)
            ? logoPrin + tokenImg
            : DatosVarios().logoPrin + tokenImg;

        final db = LocalDbService.instance;
        await db.saveConfigSystem(pass, themeConfig, logoAguardar);
      }
      return;
    } else {
      return;
    }
  }

  Future<Map<String, dynamic>> buscarCodigosPos() async {
    if (_conexion == null) {
      final resultado = {
        'ok': false,
        'message': 'No hay conexión activa a la base de datos.',
      };
      return resultado;
    }

    try {
      final sql = "SELECT codigo FROM star_cajeros";
      final result = await _conexion.execute(sql);

      if (result.rows.isNotEmpty) {
        final row = result.rows;
        final resultado = {'ok': true, 'message': 'Todo Correcto', 'data': row};
        return resultado;
      } else {
        final resultado = {
          'ok': false,
          'message': 'No se encontraron cajeros POS',
        };
        return resultado;
      }
    } catch (e) {
      final resultado = {'ok': false, 'message': e.toString()};
      return resultado;
    }
  }

  Future<Map<String, dynamic>> buscarCodeEmp() async {
    if (_conexion == null) {
      final resultado = {
        'ok': false,
        'message': 'No hay conexión activa a la base de datos.',
      };
      return resultado;
    }

    try {
      final sql = "SELECT code_emp FROM parametros";
      final result = await _conexion.execute(sql);

      if (result.rows.isNotEmpty) {
        final row = result.rows;
        final resultado = {
          'ok': true,
          'message': 'Todo Correcto',
          'data': row,
          'codeEmp': row,
        };
        return resultado;
      } else {
        final resultado = {
          'ok': false,
          'message': 'No se encontró la configuración del POS',
        };
        return resultado;
      }
    } catch (e) {
      final resultado = {'ok': false, 'message': e.toString()};
      return resultado;
    }
  }
}

final configuracionInicialProvider = ChangeNotifierProvider<ProviderDatosPos>((
  ref,
) {
  return ConfiguracionInicial();
});

final confiRestProvider = FutureProvider<void>((ref) async {
  final config = ConfiguracionInicial();
  bool tieneConexion = await config.validarConexionNube();

  if (tieneConexion) {
    await config.traerConfiguracion();
  }
});
