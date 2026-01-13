import 'package:flutter/material.dart';
// Asegúrate de importar tu archivo main_chat.dart
// Si el nombre de tu proyecto es "mi_app", sería: import 'package:mi_app/screens/main_chat.dart';
import 'screens/home_bienvenida.dart';
import 'screens/main_chat.dart';

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
        // Usamos colores azules como base
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF5B9EE1)),
        useMaterial3: true,
      ),
      home: const HomeBienvenida(), // Aquí llamamos a tu pantalla
    );
  }
}
