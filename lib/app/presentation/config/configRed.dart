import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:star_mesas_app/app/components/fondoAnimado.dart';
import 'package:star_mesas_app/app/config/constantes.dart';
import 'package:star_mesas_app/app/config/database/mysql.dart';
import 'package:star_mesas_app/app/config/preferences/datosConexionBd.dart';
import 'package:star_mesas_app/app/config/preferences/datosEmpresa.dart';
import 'package:star_mesas_app/app/config/provider/providerDatosPos.dart';
import 'package:star_mesas_app/app/config/provider/serviciosProvider.dart';
import 'package:star_mesas_app/app/config/responsivo.dart';
import 'package:star_mesas_app/app/widgets/botonGeneral.dart';
import 'package:star_mesas_app/app/widgets/dropdown.dart';
import 'package:star_mesas_app/app/widgets/textEditingGeneral.dart';

class Configurarred extends ConsumerStatefulWidget {
  const Configurarred({super.key});

  @override
  ConsumerState<Configurarred> createState() => _ConfigurarredState();
}

class _ConfigurarredState extends ConsumerState<Configurarred> {
  // Controllers
  late TextEditingController clave;
  late TextEditingController conexionHttp;
  late TextEditingController controllerIpBd;
  late TextEditingController nombrePos;
  late TextEditingController nombreEmpresa;
  late TextEditingController nombreUsuarioBd;
  late TextEditingController contrasenaBd;
  late TextEditingController nombreBdText;
  late TextEditingController puertoBd;
  late TextEditingController direccionAdmin;
  late TextEditingController direccionApiImp;
  late TextEditingController direccionImg;
  late TextEditingController imprimirFiscal;

  // FocusNodes
  late FocusNode focusNodeConexionHttp;
  late FocusNode focusNodeNombrePos;
  late FocusNode focusNodeNombreEmpresa;
  late FocusNode focusNodeIpBd;
  late FocusNode focusNodeNombreUsuarioBd;
  late FocusNode focusNodeContrasenaBd;
  late FocusNode focusNodeNombreBdText;
  late FocusNode focusNodeDireccionAdmin;
  late FocusNode focusNodeDireccionApiImp;
  late FocusNode focusNodeBoton;
  late FocusNode focusNodePuertoBd;
  late FocusNode focusNodeDireccionImg;
  late FocusNode focusNodeImprimirFiscal;

  String contra = "2203202010";

  // Conexión a la base de datos
  var conexionHttpBD = DatosConexionBd();
  var nombreBD = DatosConexionBd();
  var passBD = DatosConexionBd();
  var usuarioBD = DatosConexionBd();
  var puertoBD = DatosConexionBd();

  // Datos empresa
  var nombreEmp = DatosEmpresa();
  var direccionAdminGuardada = DatosEmpresa();

  String serialImpGuardado = "";
  String puertoImpGuardado = "";

  bool mostrarDialogClave = true;
  List<String> codeEmp = [];
  String? selectedCodeEmp;
  List<String> codigosPos = [];
  String? selectedCodigoPos;

  @override
  void initState() {
    super.initState();
    clave = TextEditingController();

    // Conexión a la base de datos
    conexionHttp = TextEditingController();
    controllerIpBd = TextEditingController();
    nombreUsuarioBd = TextEditingController();
    contrasenaBd = TextEditingController();
    nombreBdText = TextEditingController();
    puertoBd = TextEditingController();

    // Datos empresa
    nombreEmpresa = TextEditingController();
    direccionAdmin = TextEditingController();

    // Datos pos
    nombrePos = TextEditingController();
    direccionApiImp = TextEditingController();
    direccionImg = TextEditingController();
    imprimirFiscal = TextEditingController();

    focusNodeConexionHttp = FocusNode();
    focusNodeNombrePos = FocusNode();
    focusNodeNombreEmpresa = FocusNode();
    focusNodeNombreUsuarioBd = FocusNode();
    focusNodeContrasenaBd = FocusNode();
    focusNodeNombreBdText = FocusNode();
    focusNodeDireccionAdmin = FocusNode();
    focusNodeDireccionApiImp = FocusNode();
    focusNodeBoton = FocusNode();
    focusNodePuertoBd = FocusNode();
    focusNodeIpBd = FocusNode();
    focusNodeDireccionImg = FocusNode();
    focusNodeImprimirFiscal = FocusNode();

    traer();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      traerCodeEmp();
      traerCodigosPos();
    });
  }

  Future<void> traerCodeEmp({bool mostrarMensajeError = false}) async {
    try {
      final result = await ref.read(serviciosProvider).buscarCodeEmp();
      if (!mounted) return;
      if (result['ok']) {
        final data = result['data'];
        if (data != null && data.toString().isNotEmpty) {
          final rows = data as Iterable;
          final options = rows
              .map((row) => row.assoc()['code_emp']?.toString() ?? '')
              .where((val) => val.isNotEmpty)
              .toList();
          setState(() {
            codeEmp = options;
            final currentCode = DatosEmpresa().rifEmp;
            if (options.contains(currentCode)) {
              selectedCodeEmp = currentCode;
            } else if (options.isNotEmpty) {
              if (selectedCodeEmp != null &&
                  options.contains(selectedCodeEmp)) {
                // Mantener el actual si ya es válido
              } else {
                selectedCodeEmp = options.first;
              }
            }
          });
        } else {
          if (mostrarMensajeError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  result['message'] ?? 'No se encontraron empresas',
                ),
                backgroundColor: Colors.redAccent,
              ),
            );
          }
        }
      } else {
        if (mostrarMensajeError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['message']),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      }
    } catch (e) {
      if (mostrarMensajeError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al cargar empresas: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  Future<void> traerCodigosPos({bool mostrarMensajeError = false}) async {
    try {
      final result = await ref.read(serviciosProvider).buscarCodigosPos();
      if (!mounted) return;
      if (result['ok']) {
        final data = result['data'];
        if (data != null && data.toString().isNotEmpty) {
          final rows = data as Iterable;
          final options = rows
              .map((row) => row.assoc()['codigo']?.toString() ?? '')
              .where((val) => val.isNotEmpty)
              .toList();
          setState(() {
            codigosPos = options;
            final currentCode = nombrePos.text;
            if (options.contains(currentCode)) {
              selectedCodigoPos = currentCode;
            } else if (options.isNotEmpty) {
              if (selectedCodigoPos != null &&
                  options.contains(selectedCodigoPos)) {
                // Mantener el actual si ya es válido
              } else {
                selectedCodigoPos = options.first;
                nombrePos.text = options.first;
              }
            }
          });
        } else {
          if (mostrarMensajeError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  result['message'] ?? 'No se encontraron códigos POS',
                ),
                backgroundColor: Colors.redAccent,
              ),
            );
          }
        }
      } else {
        if (mostrarMensajeError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['message']),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      }
    } catch (e) {
      if (mostrarMensajeError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al cargar códigos POS: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    conexionHttp.dispose();
    clave.dispose();
    nombrePos.dispose();
    nombreEmpresa.dispose();
    nombreUsuarioBd.dispose();
    contrasenaBd.dispose();
    nombreBdText.dispose();
    direccionAdmin.dispose();
    puertoBd.dispose();
    controllerIpBd.dispose();
    direccionApiImp.dispose();
    direccionImg.dispose();
    imprimirFiscal.dispose();

    focusNodeConexionHttp.dispose();
    focusNodeNombrePos.dispose();
    focusNodeNombreEmpresa.dispose();
    focusNodeNombreUsuarioBd.dispose();
    focusNodeContrasenaBd.dispose();
    focusNodeNombreBdText.dispose();
    focusNodeDireccionAdmin.dispose();
    focusNodeDireccionApiImp.dispose();
    focusNodeBoton.dispose();
    focusNodePuertoBd.dispose();
    focusNodeIpBd.dispose();
    focusNodeDireccionImg.dispose();
    focusNodeImprimirFiscal.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Responsive(mobile: mobile(), desktop: desktop(), tablet: tablet());
  }

  Widget desktop() {
    return Dialog(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.transparent,
      child: Container(
        width: 950,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            titulo(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(30),
                child: Column(
                  children: [
                    IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(flex: 5, child: columnaIzquierda()),
                          const SizedBox(width: 30),
                          Expanded(flex: 4, child: columnaDerecha()),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    botonGuardar(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget tablet() {
    return Scaffold(
      body: SafeArea(
        child: AnimatedBubblesBackground(
          child: Column(
            children: [
              titulo(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(child: columnaIzquierda()),
                            const SizedBox(width: 16),
                            Expanded(child: columnaDerecha()),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      botonGuardar(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget mobile() {
    return Scaffold(
      body: SafeArea(
        child: AnimatedBubblesBackground(
          child: Column(
            children: [
              titulo(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      columnaIzquierda(),
                      const SizedBox(height: 16),
                      columnaDerecha(),
                      const SizedBox(height: 20),
                      botonGuardar(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget titulo() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: colorGeneralStar.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.settings_suggest_rounded,
              color: colorGeneralStar,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Configuraciones de Sistema",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "Parámetros de conexión de red, base de datos y servicios",
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close_rounded, color: Colors.grey),
            onPressed: () => Navigator.pop(context),
            tooltip: "Cerrar",
          ),
        ],
      ),
    );
  }

  Widget columnaIzquierda() {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.wifi_rounded, color: colorGeneralStar, size: 26),
              const SizedBox(width: 12),
              const Text(
                "Conexión de Red",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Divider(color: Colors.grey.shade200, thickness: 1),
          const SizedBox(height: 16),

          // Código POS (Selector o texto)
          codigosPos.isEmpty
              ? EditorTextoGeneral(
                  controller: nombrePos,
                  focusNode: focusNodeNombrePos,
                  focusNodeNext: focusNodeNombreEmpresa,
                  label: "Código POS",
                  icon: Icons.point_of_sale_rounded,
                  accentColor: colorGeneralStar,
                  labelColor: colorGeneralStar,
                )
              : DropdowMultiUsos(
                  value: selectedCodigoPos,
                  items: codigosPos,
                  accentColor: colorGeneralStar,
                  label: "Código POS",
                  icon: Icons.point_of_sale_rounded,
                  textoSeleccion: 'Seleccionar POS',
                  itemLabelMapper: (item) => item.toString(),
                  onChanged: (dynamic newValue) {
                    setState(() {
                      selectedCodigoPos = newValue as String?;
                      if (newValue != null) {
                        nombrePos.text = newValue;
                      }
                    });
                  },
                ),
          const SizedBox(height: 16),

          EditorTextoGeneral(
            controller: nombreEmpresa,
            focusNode: focusNodeNombreEmpresa,
            focusNodeNext: focusNodeIpBd,
            label: "Nombre Empresa",
            icon: Icons.business_rounded,
            accentColor: colorGeneralStar,
            labelColor: colorGeneralStar,
          ),
          const SizedBox(height: 16),

          EditorTextoGeneral(
            controller: controllerIpBd,
            focusNode: focusNodeIpBd,
            focusNodeNext: focusNodeNombreBdText,
            label: "IP BD / Servidor",
            icon: Icons.dns_rounded,
            accentColor: colorGeneralStar,
            labelColor: colorGeneralStar,
            keyboardType: TextInputType.url,
          ),
          const SizedBox(height: 16),

          EditorTextoGeneral(
            controller: nombreBdText,
            focusNode: focusNodeNombreBdText,
            focusNodeNext: focusNodeNombreUsuarioBd,
            label: "Nombre BD",
            icon: Icons.storage_rounded,
            accentColor: colorGeneralStar,
            labelColor: colorGeneralStar,
          ),
          const SizedBox(height: 16),

          EditorTextoGeneral(
            controller: nombreUsuarioBd,
            focusNode: focusNodeNombreUsuarioBd,
            focusNodeNext: focusNodeContrasenaBd,
            label: "Usuario BD",
            icon: Icons.person_rounded,
            accentColor: colorGeneralStar,
            labelColor: colorGeneralStar,
          ),
          const SizedBox(height: 16),

          EditorTextoGeneral(
            controller: contrasenaBd,
            focusNode: focusNodeContrasenaBd,
            focusNodeNext: focusNodePuertoBd,
            label: "Contraseña BD",
            icon: Icons.lock_rounded,
            accentColor: colorGeneralStar,
            labelColor: colorGeneralStar,
            oscured: true,
          ),
          const SizedBox(height: 16),

          EditorTextoGeneral(
            controller: puertoBd,
            focusNode: focusNodePuertoBd,
            focusNodeNext: focusNodeDireccionAdmin,
            label: "Puerto BD",
            icon: Icons.numbers_rounded,
            accentColor: colorGeneralStar,
            labelColor: colorGeneralStar,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),

          EditorTextoGeneral(
            controller: direccionAdmin,
            focusNode: focusNodeDireccionAdmin,
            focusNodeNext: focusNodeDireccionApiImp,
            label: "Dirección Admin",
            icon: Icons.admin_panel_settings_rounded,
            accentColor: colorGeneralStar,
            labelColor: colorGeneralStar,
          ),
        ],
      ),
    );
  }

  Widget columnaDerecha() {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.print_rounded, color: colorGeneralStar, size: 26),
              const SizedBox(width: 12),
              const Text(
                "Servicios e Impresoras",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Divider(color: Colors.grey.shade200, thickness: 1),
          const SizedBox(height: 16),

          EditorTextoGeneral(
            controller: direccionApiImp,
            focusNode: focusNodeDireccionApiImp,
            focusNodeNext: focusNodeDireccionImg,
            label: "Dirección API Impresora",
            icon: Icons.print_rounded,
            accentColor: colorGeneralStar,
            labelColor: colorGeneralStar,
          ),
          const SizedBox(height: 16),

          EditorTextoGeneral(
            controller: direccionImg,
            focusNode: focusNodeDireccionImg,
            focusNodeNext: (Platform.isAndroid || Platform.isWindows)
                ? focusNodeImprimirFiscal
                : focusNodeBoton,
            label: "Dirección Imágenes",
            icon: Icons.image_rounded,
            accentColor: colorGeneralStar,
            labelColor: colorGeneralStar,
          ),

          if (Platform.isAndroid || Platform.isWindows) ...[
            const SizedBox(height: 16),
            EditorTextoGeneral(
              controller: imprimirFiscal,
              focusNode: focusNodeImprimirFiscal,
              focusNodeNext: focusNodeBoton,
              label: "Imprimir Fiscal",
              icon: Icons.receipt_long_rounded,
              accentColor: colorGeneralStar,
              labelColor: colorGeneralStar,
            ),
          ],

          const SizedBox(height: 16),

          // Selector de Código Empresa
          codeEmp.isEmpty
              ? Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.warning_amber_rounded,
                        color: Colors.orange,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "No se encontraron empresas o no hay conexión.",
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          final db = DatosConexionBd();
                          db.ipBaseD = controllerIpBd.text;
                          db.nombreBaseD = nombreBdText.text;
                          db.usuarioBD = nombreUsuarioBd.text;
                          db.contrasenaBD = contrasenaBd.text;
                          db.puertoBaseD = (int.tryParse(puertoBd.text) ?? 3306)
                              .toString();

                          await ref
                              .read(conexionProvider.notifier)
                              .reconectar();
                          await traerCodeEmp(mostrarMensajeError: true);
                          await traerCodigosPos();
                        },
                        child: const Text("Cargar"),
                      ),
                    ],
                  ),
                )
              : DropdowMultiUsos(
                  value: selectedCodeEmp,
                  items: codeEmp,
                  accentColor: colorGeneralStar,
                  label: "Código Empresa (RIF)",
                  icon: Icons.badge_rounded,
                  textoSeleccion: 'Seleccionar código de empresa',
                  itemLabelMapper: (item) => item.toString(),
                  onChanged: (dynamic newValue) {
                    setState(() {
                      selectedCodeEmp = newValue as String?;
                      if (newValue != null) {
                        nombreEmpresa.text = newValue;
                      }
                    });
                  },
                ),
        ],
      ),
    );
  }

  Widget botonGuardar() {
    return MostrarBotonGuardar(
      colorBton: colorGeneralStar,
      texto: 'GUARDAR CONFIGURACIÓN',
      colorTexto: Colors.white,
      accion: _guardar,
      icon: Icons.save_rounded,
      colorIcon: Colors.white,
      colorBorder: Colors.transparent,
      focusNode: focusNodeBoton,
      alto: 52,
    );
  }

  void traer() {
    final posData = ref.read(providerDatosPos);
    setState(() {
      clave.clear();
      mostrarDialogClave = false;
      conexionHttp.text = DatosConexionBd().conexionApiHttp;
      nombreEmpresa.text = DatosEmpresa().nombreEmp;
      nombrePos.text = DatosConexionBd().codigoPos;
      selectedCodigoPos = DatosConexionBd().codigoPos.isNotEmpty
          ? DatosConexionBd().codigoPos
          : null;
      nombreUsuarioBd.text = DatosConexionBd().usuarioBD;
      contrasenaBd.text = DatosConexionBd().contrasenaBD;
      nombreBdText.text = DatosConexionBd().nombreBaseD;
      controllerIpBd.text = DatosConexionBd().ipBaseD;
      direccionAdmin.text = DatosEmpresa().dirAdmin;
      puertoBd.text = DatosConexionBd().puertoBaseD;
      direccionApiImp.text = DatosConexionBd().dirApiImp;
      direccionImg.text = DatosConexionBd().direccionImg;
      imprimirFiscal.text = DatosConexionBd().imprimirFiscal;

      serialImpGuardado = posData.serialImpre;
      puertoImpGuardado = posData.puertoImpre;
    });
  }

  void _guardar() {
    setState(() {
      // Conexión a la base de datos
      DatosConexionBd().conexionApiHttp = conexionHttp.text;
      DatosConexionBd().usuarioBD = nombreUsuarioBd.text;
      DatosConexionBd().contrasenaBD = contrasenaBd.text;
      DatosConexionBd().nombreBaseD = nombreBdText.text;
      DatosConexionBd().puertoBaseD = puertoBd.text;
      DatosConexionBd().ipBaseD = controllerIpBd.text;

      // Datos empresa
      DatosEmpresa().nombreEmp = nombreEmpresa.text;
      if (selectedCodeEmp != null) {
        DatosEmpresa().rifEmp = selectedCodeEmp!;
      }
      DatosEmpresa().dirAdmin = direccionAdmin.text;

      // Datos pos
      DatosConexionBd().codigoPos = nombrePos.text;
      DatosConexionBd().dirApiImp = direccionApiImp.text;
      DatosConexionBd().direccionImg = direccionImg.text;
      DatosConexionBd().imprimirFiscal = imprimirFiscal.text;
    });

    Navigator.pop(context);
  }
}
