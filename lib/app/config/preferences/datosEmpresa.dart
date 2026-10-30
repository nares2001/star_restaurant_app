// ignore_for_file: file_names

import 'package:shared_preferences/shared_preferences.dart';

// ignore: camel_case_types
class DatosEmpresa {
  static late SharedPreferences direccionAdministrativo;
  static late SharedPreferences nombreEmpresa;
  static late SharedPreferences rifEmpresa;
  static late SharedPreferences logoEmpresa;

  static Future init() async {
    direccionAdministrativo = await SharedPreferences.getInstance();
    nombreEmpresa = await SharedPreferences.getInstance();
    rifEmpresa = await SharedPreferences.getInstance();
    logoEmpresa = await SharedPreferences.getInstance();
  }

  String get dirAdmin {
    return direccionAdministrativo.getString('dirAdmin') ??
        'C:/starAdmin/StarSys.exe';
  }

  set dirAdmin(String value) {
    direccionAdministrativo.setString('dirAdmin', value);
  }

  String get nombreEmp {
    return nombreEmpresa.getString('nombreEmp') ?? '';
  }

  set nombreEmp(String value) {
    nombreEmpresa.setString('nombreEmp', value);
  }

  String get rifEmp {
    return rifEmpresa.getString('rifEmp') ?? '';
  }

  set rifEmp(String value) {
    rifEmpresa.setString('rifEmp', value);
  }

  String get logoEmp {
    return logoEmpresa.getString('logoEmp') ?? '';
  }

  set logoEmp(String value) {
    logoEmpresa.setString('logoEmp', value);
  }
}
