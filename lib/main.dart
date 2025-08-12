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
      title: 'Pizzería App',
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
          ),
        ),
      ),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        final mediaQueryData = MediaQuery.of(context);
        return MediaQuery(
          data: mediaQueryData.copyWith(
            textScaler: TextScaler.linear(1.0),
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}