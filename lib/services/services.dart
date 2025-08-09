import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
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
      timeLimit: Duration(seconds: 10),
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
}

class PagoService {
  // Números de teléfono para pagos
  static const String numeroYape = '944609326';
  static const String numeroPlin = '924802760';
  static const String numeroWhatsApp = '933214908';

  // Generar URL para Yape
  static String generateYapeUrl(double monto, String concepto) {
    return 'yape://payment?amount=$monto&message=$concepto';
  }

  // Generar URL para Plin
  static String generatePlinUrl(double monto, String concepto) {
    return 'plin://payment?amount=$monto&message=$concepto';
  }

  // Abrir Yape con datos prellenados
  static Future<bool> abrirYape(double monto, String numeroPedido) async {
    final concepto = Uri.encodeComponent('Pedido #$numeroPedido');
    final url = Uri.parse('yape://');
    
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
        return true;
      }
    } catch (e) {
      print('Error al abrir Yape: $e');
    }
    return false;
  }

  // Abrir Plin con datos prellenados
  static Future<bool> abrirPlin(double monto, String numeroPedido) async {
    final concepto = Uri.encodeComponent('Pedido #$numeroPedido');
    final url = Uri.parse('plin://');
    
    try {
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

  // Verificar si es pago exacto
  static bool esPagoExacto(double total, double pagoConCuanto) {
    return (pagoConCuanto - total).abs() < 0.01;
  }
}