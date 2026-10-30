import 'package:flutter/material.dart';

class DropdowMultiUsos extends StatelessWidget {
  final Color accentColor;
  final String label;
  final IconData? icon;
  final List<dynamic> items;
  final dynamic value;
  final String Function(dynamic item) itemLabelMapper;
  final ValueChanged<dynamic> onChanged;
  final String? Function(dynamic value)? validator;
  final bool bloquearFuncion;
  final FocusNode? focusNode;
  final FocusNode? focusNodeNext;
  final Color colortexto;
  final String textoSeleccion;
  final Color colorTextoSeleccion;
  final Color colorTextoMenu;
  final EdgeInsetsGeometry? contentPadding;

  const DropdowMultiUsos({
    super.key,
    required this.accentColor,
    required this.label,
    this.icon,
    required this.items,
    required this.value,
    required this.itemLabelMapper,
    required this.onChanged,
    this.bloquearFuncion = false,
    this.validator,
    this.focusNode,
    this.focusNodeNext,
    this.colortexto = Colors.black87,
    this.textoSeleccion = 'Seleccionar',
    this.colorTextoSeleccion = Colors.black87,
    this.colorTextoMenu = Colors.black87,
    this.contentPadding,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = Colors.black.withOpacity(0.12);
    final fillColor = Colors.black.withOpacity(0.04);

    return DropdownButtonFormField<dynamic>(
      validator: validator,
      value: items.contains(value) ? value : null,
      hint: Text(
        textoSeleccion,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 14,
          color: colorTextoSeleccion,
        ),
      ),
      focusNode: focusNode,
      isExpanded: true,
      icon: Icon(
        Icons.keyboard_arrow_down_rounded,
        color: bloquearFuncion ? Colors.grey : colortexto,
      ),
      dropdownColor: Colors.white,
      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
      selectedItemBuilder: (BuildContext context) {
        return items.map<Widget>((item) {
          return Text(
            itemLabelMapper(item),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: bloquearFuncion ? Colors.black54 : colorTextoSeleccion,
            ),
            overflow: TextOverflow.ellipsis,
          );
        }).toList();
      },
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: bloquearFuncion ? Colors.grey : colortexto,
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
        prefixIcon: icon != null
            ? Icon(
                icon,
                color: bloquearFuncion ? Colors.grey : accentColor,
                size: 20,
              )
            : null,
        filled: true,
        fillColor: bloquearFuncion ? Colors.black.withOpacity(0.1) : fillColor,
        contentPadding:
            contentPadding ??
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: borderColor, width: 1.2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: accentColor, width: 1.8),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.8),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: borderColor, width: 1.2),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: borderColor, width: 1.2),
        ),
      ),
      items: items.map((item) {
        return DropdownMenuItem<dynamic>(
          value: item,
          child: Text(
            itemLabelMapper(item),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: colorTextoMenu,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        );
      }).toList(),
      onChanged: bloquearFuncion
          ? null
          : (value) {
              if (focusNodeNext != null) {
                focusNodeNext!.requestFocus();
              }
              onChanged(value);
            },
    );
  }
}
