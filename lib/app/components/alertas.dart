import 'dart:convert';
import 'dart:ui';

import 'package:crypto/crypto.dart';
import 'package:bcrypt/bcrypt.dart';
import 'package:flutter/material.dart';
import 'package:star_mesas_app/app/config/constantes.dart';
import 'package:star_mesas_app/app/config/database/database.dart';
import 'package:star_mesas_app/app/config/preferences/datosConexionBd.dart';
import 'package:star_mesas_app/app/config/provider/providerDatosPos.dart';

class MostrarMensajeAceptacion {
  /// Muestra un mensaje minimalista y retorna [true] si se presiona el botón principal,
  /// [false] si se presiona el botón secundario y [null] si se descarta el diálogo.
  static Future<bool?> mostrarMensajeAceptacion(
    BuildContext context, {
    required IconData icono,
    required String titulo,
    required String subtitulo,
    Color? colorFondoIcon,
    Color? colorIcon,
    bool dosBotones = false,
    String textoBotonAceptar = "Aceptar",
    String textoBotonCancelar = "Cancelar",
    required Function(bool) accion,
    bool bloquearDialogo = true,
  }) {
    final effectiveColorFondoIcon = colorFondoIcon ?? colorGeneralStar;
    final effectiveColorIcon = colorIcon ?? colorGeneralStar;

    return showDialog<bool>(
      context: context,
      barrierDismissible: bloquearDialogo,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            backgroundColor: Colors.white,
            child: Container(
              constraints: const BoxConstraints(maxWidth: 400),
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: effectiveColorFondoIcon.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icono, size: 48, color: effectiveColorIcon),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    titulo,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.bold,
                      color: colorGeneralStar,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    subtitulo,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                      fontFamily: "Poppins",
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          autofocus: true,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            backgroundColor: Colors.red,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () async {
                            if (context.mounted) {
                              Navigator.pop(context, true);
                            }
                            await accion(true);
                          },
                          child: Text(
                            textoBotonAceptar,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      if (dosBotones) ...[
                        const SizedBox(width: 16),
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              side: BorderSide(color: Colors.grey.shade400),
                            ),
                            onPressed: () => Navigator.pop(context, false),
                            child: Text(
                              textoBotonCancelar,
                              style: const TextStyle(
                                color: Colors.black87,
                                fontSize: 16,
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class AlertaImpresion {
  /// Muestra un diálogo informativo reutilizable
  static void mostrarVentanaImpresion(
    BuildContext context, {
    String titulo = "",
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return PopScope(
          canPop: false,
          child: Dialog(
            backgroundColor: Colors.red,
            insetPadding: EdgeInsets.zero,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
            child: Container(
              width: double.infinity,
              height: 100,
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(color: Colors.white),
                  const SizedBox(width: 10),
                  Text(
                    titulo,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class AlertaClave {
  static String encripta(String clave, String pass) {
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

  /// Muestra un diálogo informativo reutilizable
  static Future<bool> mostrarMensajeContra(
    BuildContext context, {
    Function(bool)? accion,
    bool requiereMaster = true,
    bool requiereSupervisor = true,
    required ProviderDatosPos posData,
  }) async {
    if (!requiereMaster && !requiereSupervisor) {
      accion?.call(true);
      return true;
    }

    TextEditingController contra = TextEditingController();
    FocusNode focusNodeText = FocusNode();
    FocusNode focusNodeBtn = FocusNode();

    // 2. Obtener la contraseña de la BD local (asíncrono)
    String? localDbPass;
    try {
      final db = LocalDbService.instance;
      final servicios = await db.obtenerTodosServicios();
      localDbPass =
          (servicios.isNotEmpty ? servicios.first['pass'] : null) ??
          DatosConexionBd().passAdmin;
    } catch (e) {
      // //debugdebugPrint("Error al obtener contraseña local de la BD: $e");
      localDbPass = DatosConexionBd().passAdmin;
    }

    debugPrint("==================================================");
    debugPrint("=== [AlertaClave] MOSTRANDO DIALOGO CONTRASEÑA ===");
    debugPrint(
      "requiereMaster: $requiereMaster, requiereSupervisor: $requiereSupervisor",
    );
    debugPrint(
      "posData.supervisor: ${posData.supervisor}, posData.master: ${posData.master}",
    );
    debugPrint("posData.contra: '${posData.contra}'");
    debugPrint("localDbPass obtenido: '$localDbPass'");
    debugPrint("==================================================");

    if (!context.mounted) return false;

    final resultado = await showDialog<bool>(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext dialogContext) {
        void validar() {
          final input = contra.text;
          debugPrint("\n--- [AlertaClave] INTENTO DE VALIDACIÓN ---");
          debugPrint("Input ingresado por usuario: '$input'");

          // Hacheamos el input con SHA-256 para validarlo contra el hash almacenado en la BD local
          final bytes = utf8.encode(input);
          final hashInput = sha256.convert(bytes).toString();
          debugPrint("SHA256 del input: '$hashInput'");

          bool esValido = false;

          // Clave estática por defecto
          if (input == '13112001') {
            debugPrint(
              "✔ Coincidencia con clave maestra estática ('13112001')",
            );
            esValido = true;
          }

          // 1. Validar contra BD local (cifrada/hasheada)
          if (!esValido && localDbPass != null && localDbPass.isNotEmpty) {
            debugPrint("Evaluando contra localDbPass: '$localDbPass'...");
            if (localDbPass.startsWith(RegExp(r'\$2[aby]\$'))) {
              try {
                esValido = BCrypt.checkpw(input, localDbPass);
                debugPrint("Resultado BCrypt checkpw: $esValido");
              } catch (e) {
                debugPrint("Error al verificar hash bcrypt: $e");
              }
            }

            if (!esValido && input == localDbPass) {
              debugPrint(
                "✔ Coincidencia directa en texto plano con localDbPass",
              );
              esValido = true;
            }

            if (!esValido) {
              final hashComparar = hashInput.length >= localDbPass.length
                  ? hashInput.substring(0, localDbPass.length)
                  : hashInput;
              if (hashComparar == localDbPass || hashInput == localDbPass) {
                debugPrint("✔ Coincidencia de hash SHA-256 con localDbPass");
                esValido = true;
              }
            }
          }

          // 3. Validar contra la contraseña del usuario actual únicamente si es supervisor/master
          if (!esValido &&
              (requiereSupervisor || requiereMaster) &&
              posData.supervisor == true &&
              posData.contra.isNotEmpty) {
            debugPrint(
              "Evaluando contraseña de usuario Supervisor (posData.contra: '${posData.contra}')...",
            );
            if (input == posData.contra) {
              debugPrint(
                "✔ Coincidencia con la contraseña del Supervisor actual",
              );
              esValido = true;
            }
          }

          if (!esValido &&
              (requiereSupervisor || requiereMaster) &&
              posData.master == true &&
              posData.contra.isNotEmpty) {
            debugPrint(
              "Evaluando contraseña de usuario Master (posData.contra: '${posData.contra}')...",
            );
            if (input == posData.contra) {
              debugPrint("✔ Coincidencia con la contraseña del Master actual");
              esValido = true;
            }
          }

          //  debugPrint("=== RESULTADO FINAL -> esValido = $esValido ===\n");

          if (esValido) {
            if (dialogContext.mounted) {
              Navigator.pop(dialogContext, true);
              Future.microtask(() {
                accion?.call(true);
              });
            }
          } else {
            contra.text = "";
            focusNodeText.requestFocus();
          }
        }

        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6.0, sigmaY: 6.0),
          child: AlertDialog(
            backgroundColor: Colors.white,
            elevation: 6,
            scrollable: true,
            title: const Text(
              "Contraseña de Seguridad",
              style: TextStyle(
                fontSize: 22,
                fontFamily: "Poppins",
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 16, 61, 121),
              ),
            ),
            content: TextField(
              autofocus: true,
              controller: contra,
              focusNode: focusNodeText,
              obscureText: true,
              onSubmitted: (_) => validar(),
            ),
            actions: [
              ElevatedButton(
                focusNode: focusNodeBtn,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 16, 61, 121),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                onPressed: validar,
                child: const Text(
                  "Aceptar",
                  style: TextStyle(color: Colors.white, fontFamily: "Poppins"),
                ),
              ),
            ],
          ),
        );
      },
    );

    return resultado == true;
  }
}

class DialogoVencimientoPos extends StatefulWidget {
  final bool isVencido;
  final int dias;
  final int segundosIniciales;

  const DialogoVencimientoPos({
    super.key,
    required this.isVencido,
    required this.dias,
    required this.segundosIniciales,
  });

  @override
  State<DialogoVencimientoPos> createState() => _DialogoVencimientoPosState();
}

class _DialogoVencimientoPosState extends State<DialogoVencimientoPos> {
  late int segundosRestantes;
  bool _cerrando = false;

  @override
  void initState() {
    super.initState();
    segundosRestantes = widget.segundosIniciales;
    _iniciarConteo();
  }

  Future<void> _iniciarConteo() async {
    while (segundosRestantes > 0) {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return;
      setState(() {
        segundosRestantes--;
      });
    }
    if (mounted && !_cerrando) {
      _cerrando = true;
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorBase = widget.isVencido ? Colors.red : Colors.orange;
    final colorFondoIcono = widget.isVencido
        ? Colors.red.shade50
        : Colors.orange.shade50;
    final colorTextoOscuro = widget.isVencido
        ? Colors.red.shade900
        : Colors.orange.shade900;
    final titulo = widget.isVencido
        ? "ACTIVACIÓN VENCIDA"
        : "AVISO DE VENCIMIENTO";

    final mensajePrincipal = widget.isVencido
        ? "La activación de este POS ya está vencida (Días vencido: ${widget.dias}).\nContacte al administrador para renovar el acceso."
        : "¡ATENCIÓN! La activación de este POS vencerá en ${widget.dias} días.\nPor favor contacte al administrador pronto para renovar el acceso.";

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
      child: PopScope(
        canPop: false,
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 16,
          backgroundColor: Colors.white,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 480),
            padding: const EdgeInsets.all(30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: colorFondoIcono,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    widget.isVencido
                        ? Icons.error_outline_rounded
                        : Icons.warning_amber_rounded,
                    size: 60,
                    color: colorBase,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  titulo,
                  style: TextStyle(
                    fontSize: 22,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.bold,
                    color: colorBase.shade800,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  mensajePrincipal,
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: "Poppins",
                    color: Colors.grey.shade700,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 20,
                  ),
                  decoration: BoxDecoration(
                    color: colorFondoIcono,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: colorBase.shade200),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.timer_outlined,
                        color: colorTextoOscuro,
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "Espera requerida: $segundosRestantes s",
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.bold,
                          color: colorTextoOscuro,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
