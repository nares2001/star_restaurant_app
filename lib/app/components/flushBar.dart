import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class InfoFlush {
  /// Muestra un diálogo informativo reutilizable
  static void mostrarMensajeImportante(
    BuildContext context, {
    String titulo = "",
    String mensaje = "",
    bool color = false,
  }) {
    Flushbar(
      title: titulo,
      message: mensaje,
      duration: Duration(seconds: 5),
      backgroundColor: color
          ? Colors.red
          : const Color.fromARGB(255, 15, 91, 153),
      margin: EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(8),
      flushbarPosition: FlushbarPosition.TOP,
      icon: Icon(Icons.info_outline, color: Colors.white),
    ).show(context);
  }
}
