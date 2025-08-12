// lib/main.dart
import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const PizzeriaApp());
}

class PizzeriaApp extends StatelessWidget {
  const PizzeriaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pizza Fabichelo',
      theme: ThemeData(
        // 🎨 Colores consistentes con tu app
        primarySwatch: Colors.red,
        primaryColor: const Color(0xFFD4332A), // Tu rojo principal
        visualDensity: VisualDensity.adaptivePlatformDensity,
        
        // 🎨 Configuración de texto para mejor responsividad
        textTheme: const TextTheme().apply(
          fontFamily: 'Default', // Puedes cambiarlo si tienes una fuente específica
        ),
        
        // 🎨 Botones con tu estilo
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFD4332A), // Tu color primario
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12), // Más redondeado como tus cards
            ),
            elevation: 2,
          ),
        ),
        
        // 🎨 App Bar consistente
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFD4332A),
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
        ),
      ),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}