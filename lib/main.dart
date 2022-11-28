import 'package:flutter/material.dart';
import 'package:formvalidation/src/bloc/provider.dart';
import 'package:formvalidation/src/pages/home_page.dart';
import 'package:formvalidation/src/pages/login_page.dart';
import 'package:formvalidation/src/pages/producto_page.dart';
import 'package:formvalidation/src/pages/registro_page.dart';
import 'package:formvalidation/src/preferenias_usuario/preferencas_usuario.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = Preferenciasusuario();
  await prefs.initPrefs();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final prefs = Preferenciasusuario();
    print(prefs.token);
    return Provider(
        child: MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      initialRoute: 'login',
      routes: {
        'login': (context) => LoginPage(),
        'registro': (context) => RegistroPage(),
        'home': (context) => const HomePage(),
        'producto': (context) => const ProductPage(),
      },
      theme: ThemeData(primarySwatch: Colors.deepPurple),
    ));
  }
}
