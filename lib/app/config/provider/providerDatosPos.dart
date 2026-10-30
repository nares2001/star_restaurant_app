import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:star_mesas_app/app/config/constantes.dart';
import 'package:star_mesas_app/app/config/database/mysql.dart';
import 'package:star_mesas_app/app/config/preferences/datosConexionBd.dart';
import 'package:star_mesas_app/app/config/preferences/datosEmpresa.dart';

class ProviderDatosPos extends ChangeNotifier {
  String cedusu = '';
  String usuario = '';
  String contra = '';
  bool supervisor = false;
  bool master = false;

  bool mostrarDolar = false;
  bool mostrarCop = false;

  bool valNotaCredito = false;
  bool valNotaDebito = false;
  bool valNotaCerrada = false;
  bool valNuevaFactura = false;
  bool status_NDesp = false;
  bool mesas = false;
  bool validarImp = false;
  bool verPedidos = false;
  bool enviarCorreo = false;
  bool enviarMensajeWhatsApp = false;
  bool enviarMensajeSms = false;
  bool casillaCredito = false;
  bool nroTarjetaPos = false;

  bool verTasa = false;
  bool verFact = false;
  bool usarIgtf = false;

  double tasaDolar = 0.0;
  double tasaCop = 0.0;
  double tasaCopDolarCompra = 0.0;
  double igtf = 0.0;

  String nrodocumento = '0';
  String nrodocreg = '0';
  String fechaTasa = ' --/--/---- ';

  String tipoImpre = '';
  String serialImpre = '';
  String puertoImpre = '';
  String codigoSerialPos = '';

  String numeroFac = '1';
  String numeroNC = '1';
  String numeroND = '1';
  String numPedido = '';
  String ntarjeta = '';

  bool posFacturacion = false;
  bool posVendedor = false;

  String tipoPrecio = 'General';
  String tipoDeposito = 'DP';

  String anchoTicket = '80';

  bool valiarCant = false;

  String tipoControlFact = '';
  String numControlFact = '';
  String moneda_NDesp = '';
  String tipoPos = '';

  // Nuevos campos mapeados desde la BD que antes estaban en SharedPreferences
  int limiteArt = 100;
  String modeloImp = '';
  bool statusImp = false;
  double porc1 = 0.0;

  bool isLoading = false;
  String errorMessage = '';

  /// Método para cargar toda la configuración del POS y tasas de cambio en tiempo real
  /// Reemplaza la funcionalidad antigua que dependía de SharedPreferences (DatosPos / DatosControlFactura)
  Future<Map<String, dynamic>> cargarDatosDesdeBD(dynamic ref) async {
    final pool = ref.read(mysqlProvider);
    if (pool == null) {
      errorMessage = 'No hay conexión a la base de datos local';
      isLoading = false;
      notifyListeners();
      return {'ok': false, 'message': errorMessage};
    }

    try {
      isLoading = true;
      notifyListeners();

      final String pos = DatosConexionBd().codigoPos.isNotEmpty
          ? DatosConexionBd().codigoPos
          : '1';
      final String codeEmp = DatosEmpresa().rifEmp;

      final sql = """
        SELECT 
         c.nrodocumento, c.nrodocreg, c.casillaCredito, c.verPedidos, c.serial_imp, c.puerto_imp, c.nroNC, c.nroND, c.nroFac, c.IGTF, 
          c.verTasa, c.valcant, c.moneda_NDesp, c.limite_art, c.cerrada, c.verfact, c.nroControl, c.tipocontrol, 
          c.deposito, c.modelo_imp, c.tipo_imp, c.status_imp, c.status_NDesp, c.mesas, c.ancho_ticket, c.tipoPos, c.dolar, c.cop, c.nroTarjetaPos,
          c.env_correo, c.env_wp, c.env_sms, t.fecha as fechaTasa, t.tasa_dolar, t.tasa_cop, p.Porc1, p.TasaCopDolarCompra,
          p.IGTF as param_igtf
        FROM star_cajeros c
        LEFT JOIN (
          SELECT fecha, tasa_dolar, tasa_cop, code_emp 
          FROM tasacambio 
          WHERE (code_emp = :code_emp OR :code_emp = '' OR :code_emp IS NULL OR code_emp IS NULL OR code_emp = '')
          ORDER BY fecha DESC LIMIT 1
        ) t ON 1=1
        LEFT JOIN (
          SELECT Porc1, IGTF, TasaCopDolarCompra, code_emp 
          FROM parametros 
          WHERE (code_emp = :code_emp OR :code_emp = '' OR :code_emp IS NULL OR code_emp IS NULL OR code_emp = '')
          LIMIT 1
        ) p ON 1=1
        WHERE (c.codigo = :pos OR :pos = '' OR :pos IS NULL)
          AND (c.code_emp = :code_emp OR :code_emp = '' OR :code_emp IS NULL)
        LIMIT 1
      """;
      final result = await pool.execute(sql, {'pos': pos, 'code_emp': codeEmp});

      if (result.rows.isNotEmpty) {
        final row = result.rows.first.assoc();
        // Evitar sobrescribir nrodocreg si ya hay una factura en progreso
        // para no perder el número de documento temporal actual
        /*  final cliente = ref.read(servicioCliente).cliente;
        if (cliente.rif.isEmpty) {
          _arreglarNroControlFactura(
            nrodocreg: row['nrodocreg']?.toString() ?? '',
            numgeneral: row['nrodocumento']?.toString() ?? '',
          );
        }*/

        serialImpre = row['serial_imp']?.toString() ?? '';
        puertoImpre = row['puerto_imp']?.toString() ?? '';
        numeroNC = row['nroNC']?.toString() ?? '1';
        numeroND = row['nroND']?.toString() ?? '1';
        numeroFac = row['nroFac']?.toString() ?? '1';

        usarIgtf = _parseBool(row['IGTF']);
        verTasa = _parseBool(row['verTasa']);
        valiarCant = _parseBool(row['valcant']);
        valNotaCerrada = _parseBool(row['cerrada']);
        verFact = _parseBool(row['verfact']);
        status_NDesp = _parseBool(row['status_NDesp']);
        mesas = _parseBool(row['mesas']);
        mostrarDolar = _parseBool(row['dolar']);
        mostrarCop = _parseBool(row['cop']);
        verPedidos = _parseBool(row['verPedidos']);
        enviarCorreo = _parseBool(row['env_correo']);
        enviarMensajeWhatsApp = _parseBool(row['env_wp']);
        enviarMensajeSms = _parseBool(row['env_sms']);
        casillaCredito = _parseBool(row['casillaCredito']);
        nroTarjetaPos = _parseBool(row['nroTarjetaPos']);

        moneda_NDesp = row['moneda_NDesp']?.toString() ?? '';
        limiteArt = int.tryParse(row['limite_art']?.toString() ?? '100') ?? 100;
        numControlFact = row['nroControl']?.toString() ?? '';
        tipoControlFact = row['tipocontrol']?.toString() ?? '';
        tipoDeposito = 'DP';
        modeloImp = row['modelo_imp']?.toString() ?? '';
        tipoImpre = row['tipo_imp']?.toString() ?? '';
        statusImp = _parseBool(row['status_imp']);
        validarImp = statusImp;
        anchoTicket = row['ancho_ticket']?.toString() ?? '80';
        tipoPos = row['tipoPos']?.toString() ?? '';

        // 2. Tasas y parámetros numéricos
        fechaTasa = row['fechaTasa']?.toString() ?? ' --/--/---- ';
        tasaDolar = parseValue(row['tasa_dolar']?.toString() ?? '0');
        tasaCop = parseValue(row['tasa_cop']?.toString() ?? '0');

        porc1 = parseValue(row['Porc1']?.toString() ?? '0');
        tasaCopDolarCompra = parseValue(
          row['TasaCopDolarCompra']?.toString() ?? '0',
        );
        if (row['param_igtf']?.toString() == 'Y' &&
            row['IGTF']?.toString() == '1') {
          igtf = parseValue(row['Porc1']?.toString() ?? '0');
        }

        isLoading = false;
        errorMessage = '';
        notifyListeners();
        return {'ok': true, 'message': 'Datos cargados correctamente'};
      } else {
        errorMessage =
            'No se encontró la configuración del POS en la base de datos.';
        isLoading = false;
        notifyListeners();
        return {'ok': false, 'message': errorMessage};
      }
    } catch (e) {
      errorMessage = 'Error al cargar datos del POS: $e';
      isLoading = false;
      notifyListeners();

      return {'ok': false, 'message': e.toString()};
    }
  }

  /// Método para guardar manualmente el nroControlFact calculado u otro valor.
  void setNumControlFactura(String nroControl) {
    numControlFact = nroControl;
    notifyListeners();
  }

  void _arreglarNroControlFactura({
    required String nrodocreg,
    required String numgeneral,
  }) {
    String posId = DatosConexionBd().codigoPos.padLeft(2, '0');

    // numgeneral corresponde a nrodocumento
    String docNum = numgeneral.toString().padLeft(8, '0');
    this.nrodocumento = '$posId$docNum';

    // nrodocreg corresponde a nrodocreg
    String docNum2 = nrodocreg.toString().padLeft(8, '0');
    this.nrodocreg = '$posId$docNum2';
  }

  void limpiarDatosFAC() async {
    nrodocreg = "";
    nrodocumento = "";
    numeroNC = "";
    numeroND = "";
    numeroFac = "";
    valNotaCredito = false;
    valNotaDebito = false;
    valNuevaFactura = true;
    numControlFact = "";
    ntarjeta = "";
    verFact = false;
  }

  bool _parseBool(dynamic val) {
    if (val == null) return false;
    if (val is bool) return val;
    final str = val.toString().trim().toUpperCase();
    return str == '1' ||
        str == 'Y' ||
        str == 'TRUE' ||
        str == 'SI' ||
        str == 'YES';
  }
}

final providerDatosPos = ChangeNotifierProvider<ProviderDatosPos>((ref) {
  return ProviderDatosPos();
});
