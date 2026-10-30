import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

class EditorTextoGeneral extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final Color accentColor;
  final Color labelColor;
  final bool oscured;
  final bool readOnly;
  final bool mayusculas;
  final ValueChanged<String>? onChanged;
  final String? hintText;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;
  final FocusNode? focusNodeNext;

  const EditorTextoGeneral({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    required this.accentColor,
    required this.labelColor,
    this.focusNode,
    this.focusNodeNext,
    // ignore: unused_element_parameter
    this.oscured = false,
    // ignore: unused_element_parameter
    this.readOnly = false,
    this.mayusculas = false,
    this.onChanged,
    this.hintText,
    // ignore: unused_element_parameter
    this.keyboardType = TextInputType.text,
    // ignore: unused_element_parameter
    this.inputFormatters,
    // ignore: unused_element_parameter
    this.validator,
  });

  @override
  State<EditorTextoGeneral> createState() => _EditorTextoGeneralState();
}

class _EditorTextoGeneralState extends State<EditorTextoGeneral> {
  late bool _isObscured;

  @override
  void initState() {
    super.initState();
    _isObscured = widget.oscured;
  }

  @override
  Widget build(BuildContext context) {
    final borderColor = Colors.black.withOpacity(0.12);
    final focusBorderColor = widget.accentColor;
    final fillColor = Colors.black.withOpacity(0.04);

    return TextFormField(
      controller: widget.controller,
      readOnly: widget.readOnly,
      validator: widget.validator,
      obscureText: widget.oscured ? _isObscured : false,
      keyboardType: widget.keyboardType,
      inputFormatters: [
        if (widget.mayusculas) UpperCaseTextFormatter(),
        ...?widget.inputFormatters,
      ],
      onChanged: widget.onChanged,
      focusNode: widget.focusNode,
      style: TextStyle(
        fontWeight: FontWeight.w600,
        color: (widget.readOnly ? Colors.black54 : Colors.black87),
      ),
      decoration: InputDecoration(
        hintText: widget.hintText,
        labelText: widget.label,
        labelStyle: TextStyle(
          color: widget.labelColor,
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
        prefixIcon: Icon(
          widget.icon,
          color: widget.readOnly ? Colors.grey : widget.accentColor,
          size: 20,
        ),
        suffixIcon: widget.oscured
            ? IconButton(
                icon: Icon(
                  _isObscured ? Icons.visibility : Icons.visibility_off,
                  color: widget.readOnly ? Colors.grey : widget.accentColor,
                  size: 20,
                ),
                onPressed: () {
                  setState(() {
                    _isObscured = !_isObscured;
                  });
                },
              )
            : null,
        filled: true,
        fillColor: widget.readOnly ? Colors.black.withOpacity(0.1) : fillColor,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: borderColor, width: 1.2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: focusBorderColor, width: 1.8),
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
      ),
      onFieldSubmitted: (value) {
        widget.focusNodeNext?.requestFocus();
      },
    );
  }
}
