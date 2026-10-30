import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mysql_client_plus/mysql_client_plus.dart';
import 'package:star_mesas_app/app/config/database/mysql.dart';
import 'package:star_mesas_app/app/config/provider/providerDatosPos.dart';

class ServiciosNotifier {
  final MySQLConnectionPool? _conexion;
  final ProviderDatosPos posData;
  ServiciosNotifier(this._conexion, this.posData) {}

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
}

final serviciosProvider = Provider<ServiciosNotifier>((ref) {
  final conn = ref.watch(mysqlProvider);
  final posData = ref.read(providerDatosPos);
  return ServiciosNotifier(conn, posData);
});
