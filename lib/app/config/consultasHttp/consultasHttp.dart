import 'dart:convert';

import 'package:http/http.dart' as http;

/// Modelo para almacenar el resultado de la consulta de RIF
class ConsultasHttp {
  final bool ok;
  final Map<String, dynamic> datos;
  final String? mensajeError;

  ConsultasHttp({required this.ok, this.datos = const {}, this.mensajeError});
}

class ConsultasHttpService {
  static Future<ConsultasHttp> consultarHttp({
    required Map<String, dynamic> datos,
    required String conexion,
    String tipoConexion = "",

    bool json = false,
    int timeout = 60,

    Map<String, String>? headers,
  }) async {
    Map<String, String> requestHeaders = {};

    try {
      var url = Uri.parse(conexion);
      final response = await http
          .post(
            url,
            body: jsonEncode({...datos, "conexion": tipoConexion}),
            headers: {
              ...requestHeaders,
              'Content-Type': 'application/json',
              'accept': 'application/json',
              "User-Agent": "Dart",
              "x-flutter-request": "true",
              "X-Nube-Token": "SysNube-Ap1-2026xAlpha",
            },
          )
          .timeout(
            Duration(seconds: timeout),
            onTimeout: () {
              throw Exception(
                "Tiempo de espera agotado (Error 110). Verifique su conexión.",
              );
            },
          );
      try {
        final obtener = jsonDecode(response.body) as Map<String, dynamic>;
        if (obtener['ok'] == true || obtener['status'] == "ok") {
          return ConsultasHttp(ok: true, datos: obtener);
        } else {
          return ConsultasHttp(
            ok: false,
            mensajeError: obtener['message'] ?? 'Error desconocido',
          );
        }
      } catch (jsonErr) {
        return ConsultasHttp(
          ok: false,
          mensajeError: "Error de respuesta de servidor: $jsonErr",
        );
      }
    } catch (e) {
      return ConsultasHttp(ok: false, mensajeError: e.toString());
    }
  }

  static Future<ConsultasHttp> consultarApiExterna({
    required String conexion,
  }) async {
    try {
      var url = Uri.parse(conexion);
      final response = await http
          .get(url)
          .timeout(
            Duration(seconds: 30),
            onTimeout: () {
              throw Exception(
                "Tiempo de espera agotado (Error 110). Verifique su conexión.",
              );
            },
          );

      final obtener = jsonDecode(response.body) as Map<String, dynamic>;

      return ConsultasHttp(ok: true, datos: obtener);
    } catch (e) {
      return ConsultasHttp(ok: false, mensajeError: e.toString());
    }
  }
}
