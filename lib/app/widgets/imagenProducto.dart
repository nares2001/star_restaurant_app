import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:star_mesas_app/app/config/constantes.dart';
import 'package:star_mesas_app/app/config/preferences/datosConexionBd.dart';

class ImagenProducto extends StatelessWidget {
  final String nomImag;
  final bool isSelected;
  final double ancho;
  final double alto;
  final double sizeIcon;
  final bool isOval;

  const ImagenProducto({
    super.key,
    required this.nomImag,
    required this.isSelected,
    this.ancho = 50,
    this.alto = 50,
    this.sizeIcon = 30,
    this.isOval = true,
  });

  @override
  Widget build(BuildContext context) {
    final Icon iconFallback = Icon(
      Icons.inventory_2_outlined,
      color: isSelected ? colorGeneralStar : Colors.grey.shade500,
      size: sizeIcon,
    );

    if (nomImag.isEmpty || DatosConexionBd().direccionImg.isEmpty) {
      return iconFallback;
    }

    final String dirLimpia = DatosConexionBd().direccionImg.trim();
    final String nomLimpio = nomImag.trim();

    if (dirLimpia.startsWith('http://') || dirLimpia.startsWith('https://')) {
      final String url = dirLimpia.endsWith('/')
          ? '$dirLimpia$nomLimpio'
          : '$dirLimpia/$nomLimpio';

      final imageWidget = CachedNetworkImage(
        imageUrl: url,
        width: ancho,
        height: alto,
        fit: BoxFit.cover,
        placeholder: (context, url) =>
            const Center(child: CircularProgressIndicator(strokeWidth: 2)),
        errorWidget: (context, url, error) => iconFallback,
      );

      return isOval
          ? ClipOval(child: imageWidget)
          : ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: imageWidget,
            );
    } else {
      String sep = Platform.pathSeparator;
      String dirPath = dirLimpia;
      if (dirPath.endsWith('/') || dirPath.endsWith('\\')) {
        dirPath = dirPath.substring(0, dirPath.length - 1);
      }
      final String fullPath = '$dirPath$sep$nomLimpio';
      final file = File(fullPath);

      if (file.existsSync()) {
        final imageWidget = Image.file(
          file,
          width: ancho,
          height: alto,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => iconFallback,
        );

        return isOval
            ? ClipOval(child: imageWidget)
            : ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: imageWidget,
              );
      } else {
        return iconFallback;
      }
    }
  }
}
