import 'dart:convert';

import 'package:formvalidation/src/preferenias_usuario/preferencas_usuario.dart';
import 'package:http/http.dart' as http;
// import 'package:firebase_auth/firebase_auth.dart';

class UsuarioProvider {
  final String _firebaseToken = 'token';
  final _prefs = Preferenciasusuario();

  Future<Map<String, dynamic>> login(String email, String password) async {
    final authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true,
    };

    final resp = await http.post(
      Uri.parse(
          'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$_firebaseToken'),
      body: json.encode(authData),
    );
    // FirebaseAuth.instance.createUserWithEmailAndPassword(email: ,password: )
    // print(resp);
    Map<String, dynamic> decodeResp = jsonDecode(resp.body);

    print(decodeResp);

    if (decodeResp.containsKey('idToken')) {
      _prefs.token = decodeResp['idToken'];
      return {'ok': true, 'token': decodeResp['idToken']};
    } else {
      return {'ok': false, 'mensaje': decodeResp['error']['message']};
    }
  }

  Future<Map<String, dynamic>> nuevoUsuario(
      String email, String password) async {
    final authData = {
      'email': email,
      'password': password,
      'returnSecureToken': 'true',
    };

    // final uri = Uri.https('identitytoolkit.googleapis.com',
    //     'v1/accounts:signUp?key=$_firebaseToken', authData);

    final resp = await http.post(
      Uri.parse(
          'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$_firebaseToken'),
      body: json.encode(authData),
    );
    // FirebaseAuth.instance.createUserWithEmailAndPassword(email: ,password: )
    // print(resp);
    Map<String, dynamic> decodeResp = jsonDecode(resp.body);

    print(decodeResp);

    if (decodeResp.containsKey('idToken')) {
      _prefs.token = decodeResp['idToken'];
      return {'ok': true, 'token': decodeResp['idToken']};
    } else {
      return {'ok': false, 'mensaje': decodeResp['error']['message']};
    }
  }
}
