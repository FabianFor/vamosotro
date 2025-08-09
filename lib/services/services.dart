import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import '../models/models.dart';

class ClienteService {
  static const String _keyDatosCliente = 'datos_cliente';

  // Guardar datos del cliente
  static Future<void> guardarDatosCliente(DatosCliente datos) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyDatosCliente, jsonEncode(datos.toJson()));
  }

  // Obtener datos del cliente guardados
  static Future<DatosCliente?> obtenerDatosCliente() async {
    final prefs = await SharedPreferences.getInstance();
    final datosString = prefs.getString(_keyDatosCliente);
    if (datosString != null) {
      final datosJson = jsonDecode(datosString);
      return DatosCliente.fromJson(datosJson);
    }
    return null;
  }

  // Limpiar datos del cliente
  static Future<void> limpiarDatosCliente() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyDatosCliente);
  }
}

class UbicacionService {
  // Verificar si el GPS está habilitado
  static Future<bool> isGpsEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  // Verificar permisos de ubicación
  static Future<LocationPermission> checkLocationPermission() async {
    return await Geolocator.checkPermission();
  }

  // Solicitar permisos de ubicación
  static Future<LocationPermission> requestLocationPermission() async {
    return await Geolocator.requestPermission();
  }

  // Obtener ubicación actual
  static Future<Position> getCurrentPosition() async {
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
      timeLimit: const Duration(seconds: 10),
    );
  }

  // Abrir configuración de ubicación
  static Future<void> openLocationSettings() async {
    await Geolocator.openLocationSettings();
  }

  // Abrir configuración de la app
  static Future<void> openAppSettings() async {
    await Geolocator.openAppSettings();
  }

  // Abrir en Google Maps
  static Future<void> abrirEnMaps(double lat, double lng) async {
    final Uri mapsUrl = Uri.parse('https://www.google.com/maps?q=$lat,$lng');
    try {
      if (await canLaunchUrl(mapsUrl)) {
        await launchUrl(mapsUrl, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      print('Error al abrir Google Maps: $e');
    }
  }
}

class PagoService {
  // Números de teléfono para pagos
  static const String numeroYape = '944609326';
  static const String numeroPlin = '924802760';
  static const String numeroWhatsApp = '933214908';

  // 🔥 MÉTODO SIMPLIFICADO - Solo abrir Yape (sin datos)
  static Future<bool> abrirYape(double monto, String numeroPedido) async {
    try {
      final url = Uri.parse('yape://');
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
        return true;
      }
    } catch (e) {
      print('Error al abrir Yape: $e');
    }
    return false;
  }

  // 🔥 MÉTODO SIMPLIFICADO - Solo abrir Plin (sin datos)
  static Future<bool> abrirPlin(double monto, String numeroPedido) async {
    try {
      final url = Uri.parse('plin://');
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
        return true;
      }
    } catch (e) {
      print('Error al abrir Plin: $e');
    }
    return false;
  }

  // Realizar llamada telefónica
  static Future<void> realizarLlamada(String numero) async {
    final Uri telUrl = Uri.parse('tel:$numero');
    try {
      if (await canLaunchUrl(telUrl)) {
        await launchUrl(telUrl);
      }
    } catch (e) {
      print('Error al realizar llamada: $e');
    }
  }

  // Enviar mensaje de WhatsApp
  static Future<void> enviarWhatsApp(String numero, String mensaje) async {
    final url = Uri.parse('https://wa.me/51$numero?text=${Uri.encodeComponent(mensaje)}');
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      print('Error al abrir WhatsApp: $e');
    }
  }

  // Abrir en Google Maps
  static Future<void> abrirEnMaps(double lat, double lng) async {
    final Uri mapsUrl = Uri.parse('https://www.google.com/maps?q=$lat,$lng');
    try {
      if (await canLaunchUrl(mapsUrl)) {
        await launchUrl(mapsUrl, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      print('Error al abrir Google Maps: $e');
    }
  }

  // Calcular vuelto
  static double calcularVuelto(double total, double pagoConCuanto) {
    return pagoConCuanto - total;
  }

  // 🔥 COPIAR DATOS SIMPLIFICADO - Con nombres incluidos
  static Future<void> copiarDatosPago(String metodo, String numero, double monto, String numeroPedido) async {
    String nombreTitular = '';
    if (metodo == 'Yape') {
      nombreTitular = 'Carlos Alberto Huaytalla Quispe';
    } else if (metodo == 'Plin') {
      nombreTitular = 'Fabian Hector Huaytalla Guevara';
    }

    final datos = '''Datos para $metodo:
Número: $numero
Nombre: $nombreTitular
Monto: S/ ${monto.toStringAsFixed(2)}
Concepto: Pedido #$numeroPedido''';
    
    await Clipboard.setData(ClipboardData(text: datos));
  }

  // Verificar si es pago exacto
  static bool esPagoExacto(double total, double pagoConCuanto) {
    return (pagoConCuanto - total).abs() < 0.01;
  }
}