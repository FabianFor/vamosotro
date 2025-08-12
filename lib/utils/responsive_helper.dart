// lib/utils/responsive_helper.dart
import 'package:flutter/material.dart';

class ResponsiveHelper {
  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static late Orientation orientation;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    orientation = _mediaQueryData.orientation;
  }

  // 📱 CATEGORÍAS DE PANTALLA BASADAS EN ANCHO FÍSICO
  static String get screenCategory {
    if (screenWidth < 350) return 'small';      // Pantallas pequeñas
    if (screenWidth < 390) return 'medium';     // Pantallas medianas  
    if (screenWidth < 430) return 'large';      // Pantallas grandes
    return 'xlarge';                            // Pantallas extra grandes
  }

  // 🎯 SISTEMA DE TAMAÑOS FIJOS POR CATEGORÍA DE PANTALLA
  
  // ===== TAMAÑOS DE FUENTE FIJOS =====
  static double getFontSize(double baseSize) {
    switch (screenCategory) {
      case 'small':   // 320-349px
        return _getFontForSmall(baseSize);
      case 'medium':  // 350-389px  
        return _getFontForMedium(baseSize);
      case 'large':   // 390-429px
        return _getFontForLarge(baseSize);
      case 'xlarge':  // 430px+
        return _getFontForXLarge(baseSize);
      default:
        return baseSize;
    }
  }

  static double _getFontForSmall(double base) {
    // Pantallas pequeñas - tamaños más compactos
    if (base <= 9) return 8.0;
    if (base <= 10) return 9.0;
    if (base <= 11) return 10.0;
    if (base <= 12) return 11.0;
    if (base <= 14) return 12.0;
    if (base <= 15) return 13.0;
    if (base <= 16) return 14.0;
    if (base <= 18) return 15.0;
    if (base <= 20) return 17.0;
    return 18.0;
  }

  static double _getFontForMedium(double base) {
    // Pantallas medianas - tamaños estándar
    if (base <= 9) return 9.0;
    if (base <= 10) return 10.0;
    if (base <= 11) return 11.0;
    if (base <= 12) return 12.0;
    if (base <= 14) return 13.0;
    if (base <= 15) return 14.0;
    if (base <= 16) return 15.0;
    if (base <= 18) return 17.0;
    if (base <= 20) return 19.0;
    return 20.0;
  }

  static double _getFontForLarge(double base) {
    // Pantallas grandes - tamaños cómodos
    if (base <= 9) return 10.0;
    if (base <= 10) return 11.0;
    if (base <= 11) return 12.0;
    if (base <= 12) return 13.0;
    if (base <= 14) return 15.0;
    if (base <= 15) return 16.0;
    if (base <= 16) return 17.0;
    if (base <= 18) return 19.0;
    if (base <= 20) return 21.0;
    return 22.0;
  }

  static double _getFontForXLarge(double base) {
    // Pantallas extra grandes - tamaños amplios
    if (base <= 9) return 11.0;
    if (base <= 10) return 12.0;
    if (base <= 11) return 13.0;
    if (base <= 12) return 14.0;
    if (base <= 14) return 16.0;
    if (base <= 15) return 17.0;
    if (base <= 16) return 18.0;
    if (base <= 18) return 20.0;
    if (base <= 20) return 22.0;
    return 24.0;
  }

  // ===== DIMENSIONES FIJAS =====
  
  // Altura de cards fija por categoría
  static double getCardHeight() {
    switch (screenCategory) {
      case 'small':  return 120.0;
      case 'medium': return 135.0;
      case 'large':  return 145.0;
      case 'xlarge': return 155.0;
      default: return 135.0;
    }
  }

  // Ancho de imagen fija por categoría
  static double getImageWidth() {
    switch (screenCategory) {
      case 'small':  return 95.0;
      case 'medium': return 105.0;
      case 'large':  return 115.0;
      case 'xlarge': return 125.0;
      default: return 105.0;
    }
  }

  // Padding horizontal fijo por categoría
  static double getHorizontalPadding() {
    switch (screenCategory) {
      case 'small':  return 12.0;
      case 'medium': return 16.0;
      case 'large':  return 20.0;
      case 'xlarge': return 24.0;
      default: return 16.0;
    }
  }

  // Escala de imagen fija por categoría
  static double getImageScale() {
    switch (screenCategory) {
      case 'small':  return 1.0;
      case 'medium': return 1.1;
      case 'large':  return 1.2;
      case 'xlarge': return 1.3;
      default: return 1.1;
    }
  }

  // Offset de imagen fijo por categoría
  static Offset getImageOffset() {
    switch (screenCategory) {
      case 'small':  return const Offset(-10, 0);
      case 'medium': return const Offset(-15, 0);
      case 'large':  return const Offset(-18, 0);
      case 'xlarge': return const Offset(-22, 0);
      default: return const Offset(-15, 0);
    }
  }

  // ===== ESPACIADOS FIJOS =====
  
  // Espaciado vertical pequeño
  static double getSmallVerticalSpacing() {
    switch (screenCategory) {
      case 'small':  return 4.0;
      case 'medium': return 5.0;
      case 'large':  return 6.0;
      case 'xlarge': return 7.0;
      default: return 5.0;
    }
  }

  // Espaciado vertical mediano
  static double getMediumVerticalSpacing() {
    switch (screenCategory) {
      case 'small':  return 8.0;
      case 'medium': return 10.0;
      case 'large':  return 12.0;
      case 'xlarge': return 14.0;
      default: return 10.0;
    }
  }

  // Espaciado vertical grande
  static double getLargeVerticalSpacing() {
    switch (screenCategory) {
      case 'small':  return 12.0;
      case 'medium': return 15.0;
      case 'large':  return 18.0;
      case 'xlarge': return 22.0;
      default: return 15.0;
    }
  }

  // Espaciado horizontal pequeño
  static double getSmallHorizontalSpacing() {
    switch (screenCategory) {
      case 'small':  return 6.0;
      case 'medium': return 8.0;
      case 'large':  return 10.0;
      case 'xlarge': return 12.0;
      default: return 8.0;
    }
  }

  // Espaciado horizontal mediano
  static double getMediumHorizontalSpacing() {
    switch (screenCategory) {
      case 'small':  return 10.0;
      case 'medium': return 12.0;
      case 'large':  return 15.0;
      case 'xlarge': return 18.0;
      default: return 12.0;
    }
  }

  // ===== DIMENSIONES DE BOTONES FIJAS =====
  
  // Padding de botones
  static EdgeInsets getButtonPadding() {
    switch (screenCategory) {
      case 'small':  return const EdgeInsets.symmetric(horizontal: 12, vertical: 8);
      case 'medium': return const EdgeInsets.symmetric(horizontal: 16, vertical: 10);
      case 'large':  return const EdgeInsets.symmetric(horizontal: 20, vertical: 12);
      case 'xlarge': return const EdgeInsets.symmetric(horizontal: 24, vertical: 14);
      default: return const EdgeInsets.symmetric(horizontal: 16, vertical: 10);
    }
  }

  // Radio de border radius
  static double getBorderRadius() {
    switch (screenCategory) {
      case 'small':  return 10.0;
      case 'medium': return 12.0;
      case 'large':  return 14.0;
      case 'xlarge': return 16.0;
      default: return 12.0;
    }
  }

  // ===== DIMENSIONES ESPECÍFICAS PARA LA APP =====
  
  // Altura del header expandido
  static double getExpandedHeaderHeight() {
    switch (screenCategory) {
      case 'small':  return 100.0;
      case 'medium': return 120.0;
      case 'large':  return 130.0;
      case 'xlarge': return 140.0;
      default: return 120.0;
    }
  }

  // Altura de categorías
  static double getCategoryHeight() {
    switch (screenCategory) {
      case 'small':  return 70.0;
      case 'medium': return 80.0;
      case 'large':  return 85.0;
      case 'xlarge': return 90.0;
      default: return 80.0;
    }
  }

  // Ancho de categorías
  static double getCategoryWidth() {
    switch (screenCategory) {
      case 'small':  return 75.0;
      case 'medium': return 85.0;
      case 'large':  return 90.0;
      case 'xlarge': return 95.0;
      default: return 85.0;
    }
  }

  // Tamaño del logo
  static double getLogoSize() {
    switch (screenCategory) {
      case 'small':  return 40.0;
      case 'medium': return 45.0;
      case 'large':  return 50.0;
      case 'xlarge': return 55.0;
      default: return 45.0;
    }
  }

  // Tamaño de iconos
  static double getIconSize(String type) {
    double baseSize;
    switch (type) {
      case 'small': baseSize = 16.0; break;
      case 'medium': baseSize = 20.0; break;
      case 'large': baseSize = 24.0; break;
      case 'xlarge': baseSize = 28.0; break;
      default: baseSize = 20.0;
    }

    switch (screenCategory) {
      case 'small':  return baseSize * 0.9;
      case 'medium': return baseSize;
      case 'large':  return baseSize * 1.1;
      case 'xlarge': return baseSize * 1.2;
      default: return baseSize;
    }
  }

  // ===== MÉTODOS DE UTILIDAD =====
  
  // Verificar si es pantalla pequeña
  static bool isSmallScreen() => screenCategory == 'small';
  
  // Verificar si es pantalla grande
  static bool isLargeScreen() => screenCategory == 'large' || screenCategory == 'xlarge';

  // Método para debug
  static void printDebugInfo() {
    print('=== ResponsiveHelper Debug FIXED ===');
    print('Screen Size: ${screenWidth.toInt()}x${screenHeight.toInt()}');
    print('Category: $screenCategory');
    print('Card Height: ${getCardHeight()}px');
    print('Image Width: ${getImageWidth()}px');
    print('Font Sample (16): ${getFontSize(16)}px');
    print('H Padding: ${getHorizontalPadding()}px');
    print('===================================');
  }
}