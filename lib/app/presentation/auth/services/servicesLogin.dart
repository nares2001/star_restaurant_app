import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mysql_client_plus/mysql_client_plus.dart';
import 'package:star_mesas_app/app/config/conexiones.dart';
import 'package:star_mesas_app/app/config/consultasHttp/consultasHttp.dart';
import 'package:star_mesas_app/app/config/database/mysql.dart';
import 'package:star_mesas_app/app/config/preferences/datosConexionBd.dart';
import 'package:star_mesas_app/app/config/preferences/datosEmpresa.dart';
import 'package:star_mesas_app/app/config/provider/providerDatosPos.dart';

class ServicesLogin {
  final MySQLConnectionPool? _conexion;
  ServicesLogin(this._conexion);

  Future<Map<dynamic, dynamic>> validarLogin({
    required String usuario,
    required String contrasena,
    required String pos,
    required WidgetRef ref,
  }) async {
    if (_conexion == null) {
      return {
        'ok': false,
        'message': 'No hay conexión activa a la base de datos.',
        'data': [],
      };
    }
    try {
      final result = await _conexion.execute(
        "SELECT cedusu, nomusu, passusu, status, statuspos, supervisor FROM star_usuarios WHERE logusu = :usuario AND code_emp = :code_emp",
        {'usuario': usuario, 'code_emp': DatosEmpresa().rifEmp},
      );
      if (result.rows.isEmpty) {
        return {
          'ok': false,
          'message': 'No se encontro el usuario',
          'data': [],
        };
      }

      bool loginExitoso = false;
      String? errorMensaje;
      final datosUsuario = <String, dynamic>{};
      final passEncriptada = encripta(usuario, contrasena);

      for (final row in result.rows) {
        final extraerDatos = row.assoc();
        final passusu = extraerDatos['passusu'];
        final status = extraerDatos['status'].toString();

        if (passusu == contrasena || passusu == passEncriptada) {
          if (status == '1') {
            if (extraerDatos['statuspos'] == '0') {
              errorMensaje = 'Usuario inactivo en punto de venta';
              break;
            }
            loginExitoso = true;

            datosUsuario['cedusu'] = extraerDatos['cedusu'];
            datosUsuario['nombre'] = extraerDatos['nomusu'];
            datosUsuario['status'] = extraerDatos['status'];
            datosUsuario['clave'] = passusu;
            datosUsuario['statuspos'] = extraerDatos['statuspos'];
            datosUsuario['supervisor'] = extraerDatos['supervisor'];
            break;
          } else {
            errorMensaje = 'Usuario inactivo';
          }
        } else {
          errorMensaje = 'Contraseña incorrecta';
        }
      }

      if (loginExitoso) {
        // Consultar configuración del cajero/POS para la impresora
        String serialimp = '';
        String puertoimp = '';
        String estatusImp = '';
        String tipoimp = '';

        try {
          final cajeroResult = await _conexion.execute(
            "SELECT serial_imp, puerto_imp, status_imp, tipo_imp FROM star_cajeros WHERE codigo = :pos AND code_emp = :code_emp",
            {'pos': pos, 'code_emp': DatosEmpresa().rifEmp},
          );
          if (cajeroResult.rows.isNotEmpty) {
            final rowCajero = cajeroResult.rows.first.assoc();
            serialimp = rowCajero['serial_imp']?.toString() ?? '';
            puertoimp = rowCajero['puerto_imp']?.toString() ?? '';
            estatusImp = rowCajero['status_imp']?.toString() ?? '';
            tipoimp = rowCajero['tipo_imp']?.toString() ?? '';
          }
        } catch (_) {}

        datosUsuario['serial_imp'] = serialimp;
        datosUsuario['puerto_imp'] = puertoimp;
        datosUsuario['status_imp'] = estatusImp;
        datosUsuario['tipo_imp'] = tipoimp;

        tomarIntentoLoginNube(
          cedusu: datosUsuario['cedusu']?.toString() ?? usuario,
          nomusu: datosUsuario['nombre']?.toString() ?? '',
          status: 1,
          motivo: 'Login exitoso',
        );
        await tomarIntentoLogin(
          usuario: usuario,
          tipo: 'POS',
          pos: pos,
          status: 1,
        );

        // Guardar los datos del usuario en el provider
        final providerPos = ref.read(providerDatosPos);

        // Cargar los datos de configuración desde la BD después del login exitoso
        await providerPos.cargarDatosDesdeBD(ref);

        return {'ok': true, 'message': 'Login exitoso', 'data': datosUsuario};
      } else {
        await tomarIntentoLoginNube(
          cedusu: usuario,
          nomusu: '',
          status: 0,
          motivo: errorMensaje ?? 'Error desconocido',
        );
        await tomarIntentoLogin(
          usuario: usuario,
          tipo: 'POS',
          pos: pos,
          status: 0,
        );
        return {'ok': false, 'message': errorMensaje, 'data': []};
      }
    } catch (e) {
      return {'ok': false, 'message': e.toString(), 'data': []};
    }
  }

  Future<bool> tomarIntentoLogin({
    required String usuario,
    required String tipo,
    required String pos,
    required int status,
  }) async {
    if (_conexion == null) {
      return false;
    }
    try {
      final result = await _conexion.execute(
        "INSERT INTO starintentoslogin (usuario, tipo, pos, code_emp, fecha, status) VALUES (:usuario, :tipo, :pos, :code_emp, :fecha, :status)",
        {
          'usuario': usuario,
          'tipo': tipo,
          'pos': pos,
          'code_emp': DatosEmpresa().rifEmp,
          'fecha': DateTime.now().toString(),
          'status': status,
        },
      );
      if (result.rows.isEmpty) {
        return false;
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  String encripta(String clave, String pass) {
    if (clave.isEmpty) return "";
    final codeUnitsPass = pass.codeUnits;
    final codeUnitsClave = clave.codeUnits;
    final result = StringBuffer();
    for (int i = 0; i < codeUnitsPass.length; i++) {
      final xorResult =
          codeUnitsPass[i] ^ codeUnitsClave[i % codeUnitsClave.length];
      final hex = xorResult.toRadixString(16).padLeft(2, '0').toUpperCase();
      result.write(hex);
    }
    return result.toString();
  }

  Future<void> tomarIntentoLoginNube({
    required String cedusu,
    required String nomusu,
    required int status,
    required String motivo,
  }) async {
    try {
      final deviceInfo = DeviceInfoPlugin();
      String idPc = '';
      String namePc = '';
      if (Platform.isWindows) {
        final winInfo = await deviceInfo.windowsInfo;
        idPc = winInfo.deviceId;
        namePc = winInfo.computerName;
      }

      // Obtener IP local
      String ipPc = '';
      try {
        final interfaces = await NetworkInterface.list(
          type: InternetAddressType.IPv4,
          includeLinkLocal: false,
        );
        for (var iface in interfaces) {
          for (var addr in iface.addresses) {
            if (addr.address != '127.0.0.1' && !addr.isLoopback) {
              ipPc = addr.address;
              break;
            }
          }
          if (ipPc.isNotEmpty) break;
        }
      } catch (_) {}

      // Obtener coordenadas con Geolocator
      String? latitud;
      String? longitud;
      try {
        bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
        if (serviceEnabled) {
          LocationPermission permission = await Geolocator.checkPermission();
          if (permission == LocationPermission.denied) {
            permission = await Geolocator.requestPermission();
          }
          if (permission == LocationPermission.whileInUse ||
              permission == LocationPermission.always) {
            Position position = await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.low,
              timeLimit: const Duration(seconds: 4),
            );
            latitud = position.latitude.toString();
            longitud = position.longitude.toString();
          }
        }
      } catch (_) {}

      final data = {
        'accion': 'registrarIntentoPos',
        'cedusu': cedusu,
        'nomusu': nomusu,
        'code_emp': DatosEmpresa().rifEmp,
        'id_pc': idPc,
        'namepc': namePc,
        'ip_pc': ipPc,
        'token': DatosConexionBd().uuidPos,
        'longitud': longitud,
        'latitud': latitud,
        'status': status,
        'motivo': motivo,
      };
      await ConsultasHttpService.consultarHttp(
        datos: data,
        conexion: datosRestaurantConexion,
        timeout: 15,
      );
    } catch (_) {}
  }
}

final servicesloginProvider = Provider<ServicesLogin>((ref) {
  final conn = ref.watch(mysqlProvider);
  ref.watch(providerDatosPos);
  return ServicesLogin(conn);
});
