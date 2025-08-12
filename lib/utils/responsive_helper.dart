// lib/utils/responsive_helper.dart
import 'package:flutter/material.dart';

class ResponsiveHelper {
  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static late double textScaleFactor;
  static late Orientation orientation;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    orientation = _mediaQueryData.orientation;
    textScaleFactor = _mediaQueryData.textScaler.scale(1.0);
  }

  // 🎯 SISTEMA BASADO EN PORCENTAJES REAL
  
  // Obtener altura basada en porcentaje de pantalla
  static double getProportionateScreenHeight(double percentage) {
    return screenHeight * (percentage / 100);
  }

  // Obtener ancho basado en porcentaje de pantalla
  static double getProportionateScreenWidth(double percentage) {
    return screenWidth * (percentage / 100);
  }

  // Obtener tamaño de fuente que se adapta a la configuración del sistema
  static double getFontSize(double baseSize) {
    // Base más conservadora para evitar textos gigantes
    double scaledSize = baseSize * textScaleFactor;
    
    // Límites para evitar extremos
    if (textScaleFactor > 1.3) {
      scaledSize = baseSize * 1.2; // Máximo 20% más grande
    } else if (textScaleFactor < 0.8) {
      scaledSize = baseSize * 0.9; // Mínimo 10% más pequeño
    }
    
    return scaledSize;
  }

  // Detectar configuración de visualización del sistema
  static String getDisplayMode() {
    if (textScaleFactor < 0.9) return 'small';
    if (textScaleFactor > 1.15) return 'large';
    return 'default';
  }

  // Verificar si es una pantalla físicamente pequeña
  static bool isSmallScreen() {
    return screenWidth < 360;
  }

  // Verificar si es una pantalla físicamente grande
  static bool isLargeScreen() {
    return screenWidth > 410;
  }

  // 🔧 SISTEMA ADAPTATIVO MEJORADO

  // Padding horizontal adaptativo (2-5% de ancho de pantalla)
  static double getHorizontalPadding() {
    double percentage;
    String displayMode = getDisplayMode();
    
    switch (displayMode) {
      case 'small':
        percentage = 3.0; // 3% en modo pequeño
        break;
      case 'large':
        percentage = 2.0; // 2% en modo grande para aprovechar espacio
        break;
      default:
        percentage = 4.0; // 4% en modo predeterminado
    }
    
    return getProportionateScreenWidth(percentage);
  }

  // Altura de card adaptativa (15-20% de altura de pantalla)
  static double getCardHeight() {
    double percentage;
    String displayMode = getDisplayMode();
    
    switch (displayMode) {
      case 'small':
        percentage = 16.0; // 16% en modo pequeño
        break;
      case 'large':
        percentage = 14.0; // 14% en modo grande
        break;
      default:
        percentage = 18.0; // 18% en modo predeterminado
    }
    
    return getProportionateScreenHeight(percentage);
  }

  // Ancho de imagen adaptativo (25-30% de ancho de pantalla)
  static double getImageWidth() {
    double percentage;
    String displayMode = getDisplayMode();
    
    switch (displayMode) {
      case 'small':
        percentage = 30.0; // 30% en modo pequeño
        break;
      case 'large':
        percentage = 25.0; // 25% en modo grande
        break;
      default:
        percentage = 29.0; // 29% en modo predeterminado
    }
    
    return getProportionateScreenWidth(percentage);
  }

  // Escala de imagen adaptativa
  static double getImageScale() {
    String displayMode = getDisplayMode();
    
    switch (displayMode) {
      case 'small':
        return 1.1; // Menos escala en modo pequeño
      case 'large':
        return 1.2; // Menos escala en modo grande
      default:
        return 1.3; // Escala normal en predeterminado
    }
  }

  // Offset de imagen adaptativo (basado en porcentaje)
  static Offset getImageOffset() {
    double offsetPercentage;
    String displayMode = getDisplayMode();
    
    switch (displayMode) {
      case 'small':
        offsetPercentage = 4.0; // 4% del ancho en modo pequeño
        break;
      case 'large':
        offsetPercentage = 3.0; // 3% del ancho en modo grande
        break;
      default:
        offsetPercentage = 5.0; // 5% del ancho en predeterminado
    }
    
    double offsetValue = getProportionateScreenWidth(offsetPercentage);
    return Offset(-offsetValue, 0);
  }

  // Método para debug - ver configuración actual
  static void printDebugInfo() {
    print('=== ResponsiveHelper Debug ===');
    print('Screen: ${screenWidth.toInt()}x${screenHeight.toInt()}');
    print('Text Scale: ${textScaleFactor.toStringAsFixed(2)}');
    print('Display Mode: ${getDisplayMode()}');
    print('Card Height: ${getCardHeight().toInt()}px');
    print('Image Width: ${getImageWidth().toInt()}px');
    print('H Padding: ${getHorizontalPadding().toInt()}px');
    print('=============================');
  }
}