import 'package:flutter/material.dart';

class MostrarBotonGuardar extends StatefulWidget {
  final Color colorBton;
  final String texto;
  final Color colorTexto;
  final Function() accion;
  final IconData icon;
  final Color colorIcon;
  final Color colorBorder;
  final FocusNode? focusNode;
  final double? alto;
  final double? ancho;
  const MostrarBotonGuardar({
    super.key,
    required this.colorBton,
    required this.texto,
    required this.colorTexto,
    required this.accion,
    required this.icon,
    required this.colorIcon,
    required this.colorBorder,
    this.alto,
    this.ancho,
    this.focusNode,
  });

  @override
  State<MostrarBotonGuardar> createState() => _MostrarBotonGuardarState();
}

class _MostrarBotonGuardarState extends State<MostrarBotonGuardar> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.alto ?? 55,
      width: widget.ancho ?? double.infinity,
      child: ElevatedButton(
        onPressed: widget.accion,
        focusNode: widget.focusNode,
        style: ElevatedButton.styleFrom(
          backgroundColor: widget.colorBton,
          foregroundColor: widget.colorTexto,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: widget.colorBorder, width: 1.5),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(widget.icon, size: 22),
            const SizedBox(width: 8),
            Text(
              widget.texto,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.2,
                color: widget.colorTexto,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
