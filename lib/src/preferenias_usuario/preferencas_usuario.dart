import 'package:shared_preferences/shared_preferences.dart';

class Preferenciasusuario {
  static final Preferenciasusuario _instancia = Preferenciasusuario._internal();

  factory Preferenciasusuario() {
    return _instancia;
  }

  Preferenciasusuario._internal();

  late SharedPreferences _prefs;

  initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  String get token {
    return _prefs.getString('token') ?? '';
  }

  set token(String value) {
    _prefs.setString('token', value);
  }

  String get ultimaPagina {
    return _prefs.getString('token') ?? 'login';
  }

  set ultimaPagina(String value) {
    _prefs.setString('token', value);
  }
}
