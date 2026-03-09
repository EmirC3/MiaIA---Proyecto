import 'package:flutter/material.dart';
// 1. Asegúrate de que la ruta apunte a tu archivo NavegationBar.dart
// Si está en la carpeta screens sería: import 'package:mia_ia_app/screens/NavegationBar.dart';
import 'screens/NavegationBar.dart'; 

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MIA AI Chat',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF5B9EE1)),
        useMaterial3: true,
      ),
      // 2. Aquí llamamos a la clase que está dentro de NavegationBar.dart
      home: const MainNavigation(), 
    );
  }
}