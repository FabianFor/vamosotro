import 'package:flutter/material.dart';
import '../services/services.dart';

class DialogUtils {
  static Future<void> mostrarDialogoGpsDesactivado(BuildContext context) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.location_off, color: Colors.red),
            SizedBox(width: 10),
            Text('GPS Desactivado'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Para el delivery necesitamos tu ubicación exacta.',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('Por favor activa el GPS en tu dispositivo para continuar.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton.icon(
            onPressed: () async {
              Navigator.pop(context);
              await UbicacionService.openLocationSettings();
            },
            icon: const Icon(Icons.settings),
            label: const Text('Ir a Configuración'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  static Future<void> mostrarDialogoPermisosDenegados(BuildContext context) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.location_disabled, color: Colors.orange),
            SizedBox(width: 10),
            Text('Permisos Requeridos'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Para el delivery necesitamos acceso a tu ubicación.',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('Los permisos han sido denegados permanentemente. Ve a configuración de la app para habilitarlos.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton.icon(
            onPressed: () async {
              Navigator.pop(context);
              await UbicacionService.openAppSettings();
            },
            icon: const Icon(Icons.settings_applications),
            label: const Text('Configuración App'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  static Future<void> mostrarDialogoReintentar(
    BuildContext context,
    String titulo,
    String mensaje,
    VoidCallback onReintentar,
  ) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.refresh, color: Colors.blue),
            const SizedBox(width: 10),
            Text(titulo),
          ],
        ),
        content: Text(mensaje),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              onReintentar();
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Reintentar'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  // 🔥 MÉTODO ACTUALIZADO CON NOMBRES INCLUIDOS
  static void mostrarInstruccionesPago(
    BuildContext context,
    String metodo,
    String numero,
    double monto,
    String numeroPedido,
  ) {
    // Obtener nombre según el método
    String nombreTitular = '';
    if (metodo == 'Yape') {
      nombreTitular = 'Carlos Alberto Huaytalla Quispe';
    } else if (metodo == 'Plin') {
      nombreTitular = 'Fabian Hector Huaytalla Guevara';
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Pago con $metodo'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Para completar el pago:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text('1. Abre tu app de $metodo'),
            Text('2. Busca el número: $numero'),
            if (nombreTitular.isNotEmpty) Text('3. Nombre: $nombreTitular'),
            Text('${nombreTitular.isNotEmpty ? '4' : '3'}. Envía: S/ ${monto.toStringAsFixed(2)}'),
            Text('${nombreTitular.isNotEmpty ? '5' : '4'}. Concepto: Pedido #$numeroPedido'),
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Datos para copiar:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue[800])),
                  const SizedBox(height: 5),
                  SelectableText('Número: $numero'),
                  if (nombreTitular.isNotEmpty) SelectableText('Nombre: $nombreTitular'),
                  SelectableText('Monto: S/ ${monto.toStringAsFixed(2)}'),
                  SelectableText('Concepto: Pedido #$numeroPedido'),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Entendido'),
          ),
        ],
      ),
    );
  }
}