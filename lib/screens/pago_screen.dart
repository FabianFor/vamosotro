import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../models/models.dart';
import '../services/services.dart';
import '../widgets/dialogs.dart';
import 'confirmacion_screen.dart';

class PagoScreen extends StatefulWidget {
  final List<ItemPedido> carrito;
  final double total;

  const PagoScreen({super.key, required this.carrito, required this.total});

  @override
  State<PagoScreen> createState() => _PagoScreenState();
}

class _PagoScreenState extends State<PagoScreen> {
  String metodoPago = '';
  String tipoEntrega = '';
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController telefonoController = TextEditingController();
  final TextEditingController pagoConCuantoController = TextEditingController();
  Position? ubicacionActual;
  bool cargandoUbicacion = false;
  double? vuelto;

  @override
  void initState() {
    super.initState();
    _cargarDatosCliente();
  }

  @override
  void dispose() {
    nombreController.dispose();
    telefonoController.dispose();
    pagoConCuantoController.dispose();
    super.dispose();
  }

  Future<void> _cargarDatosCliente() async {
    final datos = await ClienteService.obtenerDatosCliente();
    if (datos != null) {
      setState(() {
        nombreController.text = datos.nombre;
        telefonoController.text = datos.telefono;
      });
    }
  }

  void _calcularVuelto() {
    if (pagoConCuantoController.text.isNotEmpty && metodoPago == 'efectivo') {
      double pagoConCuanto = double.tryParse(pagoConCuantoController.text) ?? 0;
      if (pagoConCuanto >= widget.total) {
        setState(() {
          vuelto = PagoService.calcularVuelto(widget.total, pagoConCuanto);
        });
      } else {
        setState(() {
          vuelto = null;
        });
      }
    } else {
      setState(() {
        vuelto = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Finalizar Pedido', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔥 RESUMEN DEL PEDIDO ACTUALIZADO CON ADICIONALES
            Card(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Resumen del Pedido', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    ...widget.carrito.map((item) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  '${item.cantidad}x ${item.nombre} (${item.tamano})',
                                  style: const TextStyle(fontWeight: FontWeight.w500),
                                ),
                              ),
                              Text('S/ ${(item.precioTotal * item.cantidad).toStringAsFixed(2)}'),
                            ],
                          ),
                          // 🔥 MOSTRAR ADICIONALES SI LOS TIENE
                          if (item.adicionales.isNotEmpty) ...[
                            const SizedBox(height: 2),
                            Padding(
                              padding: const EdgeInsets.only(left: 16),
                              child: Text(
                                '+ ${item.adicionales.map((a) => '${a.icono} ${a.nombre}').join(', ')}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.green[700],
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    )),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        Text('S/ ${widget.total.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.red)),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Datos del cliente
            const Text('Datos del Cliente', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            TextField(
              controller: nombreController,
              decoration: const InputDecoration(
                labelText: 'Nombre completo',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: telefonoController,
              decoration: const InputDecoration(
                labelText: 'Teléfono',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),

            const SizedBox(height: 20),

            // Tipo de entrega
            const Text('Tipo de Entrega', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            RadioListTile(
              title: const Text('Delivery'),
              value: 'delivery',
              groupValue: tipoEntrega,
              onChanged: (value) {
                setState(() {
                  tipoEntrega = value!;
                  ubicacionActual = null;
                });
              },
            ),
            RadioListTile(
              title: const Text('Recojo en tienda'),
              value: 'recojo',
              groupValue: tipoEntrega,
              onChanged: (value) {
                setState(() {
                  tipoEntrega = value!;
                  ubicacionActual = null;
                });
              },
            ),

            // Ubicación para delivery
            if (tipoEntrega == 'delivery') ...[
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.orange),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.orange[50],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.info, color: Colors.orange),
                        SizedBox(width: 10),
                        Text('Ubicación para Delivery', style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    if (ubicacionActual == null) ...[
                      const Text('Necesitamos tu ubicación exacta para el delivery'),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: cargandoUbicacion ? null : _obtenerUbicacion,
                          icon: cargandoUbicacion 
                              ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                              : const Icon(Icons.location_on),
                          label: Text(cargandoUbicacion ? 'Obteniendo ubicación...' : 'Obtener mi ubicación'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                    ] else ...[
                      const Row(
                        children: [
                          Icon(Icons.check_circle, color: Colors.green),
                          SizedBox(width: 10),
                          Text('Ubicación obtenida ✅', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Lat: ${ubicacionActual!.latitude.toStringAsFixed(6)}',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                      Text(
                        'Lng: ${ubicacionActual!.longitude.toStringAsFixed(6)}',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton.icon(
                        onPressed: () => UbicacionService.abrirEnMaps(ubicacionActual!.latitude, ubicacionActual!.longitude),
                        icon: const Icon(Icons.map),
                        label: const Text('Ver en Maps'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],

            const SizedBox(height: 20),

            // Método de pago
            const Text('Método de Pago', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            RadioListTile(
              title: const Text('Efectivo'),
              value: 'efectivo',
              groupValue: metodoPago,
              onChanged: (value) {
                setState(() {
                  metodoPago = value!;
                });
              },
            ),
            RadioListTile(
              title: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.purple,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text('Yape', style: TextStyle(color: Colors.white, fontSize: 12)),
                  ),
                  const SizedBox(width: 10),
                  const Text('Yape'),
                ],
              ),
              value: 'yape',
              groupValue: metodoPago,
              onChanged: (value) {
                setState(() {
                  metodoPago = value!;
                  vuelto = null;
                });
              },
            ),
            RadioListTile(
              title: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.teal,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text('Plin', style: TextStyle(color: Colors.white, fontSize: 12)),
                  ),
                  const SizedBox(width: 10),
                  const Text('Plin'),
                ],
              ),
              value: 'plin',
              groupValue: metodoPago,
              onChanged: (value) {
                setState(() {
                  metodoPago = value!;
                  vuelto = null;
                });
              },
            ),

            // Campo para pago en efectivo
            if (metodoPago == 'efectivo') ...[
              const SizedBox(height: 15),
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.green),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.green[50],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Pago en Efectivo', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 10),
                    TextField(
                      controller: pagoConCuantoController,
                      decoration: const InputDecoration(
                        labelText: '¿Con cuánto va a pagar?',
                        prefixText: 'S/ ',
                        border: OutlineInputBorder(),
                        hintText: 'Ingrese el monto',
                      ),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      onChanged: (value) => _calcularVuelto(),
                    ),
                    if (vuelto != null) ...[
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: PagoService.esPagoExacto(widget.total, double.parse(pagoConCuantoController.text)) 
                              ? Colors.green[100] 
                              : Colors.blue[100],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: PagoService.esPagoExacto(widget.total, double.parse(pagoConCuantoController.text)) 
                                ? Colors.green 
                                : Colors.blue
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              PagoService.esPagoExacto(widget.total, double.parse(pagoConCuantoController.text)) 
                                  ? Icons.check_circle 
                                  : Icons.monetization_on,
                              color: PagoService.esPagoExacto(widget.total, double.parse(pagoConCuantoController.text)) 
                                  ? Colors.green 
                                  : Colors.blue,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                PagoService.esPagoExacto(widget.total, double.parse(pagoConCuantoController.text))
                                    ? 'Pago exacto ✅'
                                    : 'Su vuelto será: S/ ${vuelto!.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: PagoService.esPagoExacto(widget.total, double.parse(pagoConCuantoController.text)) 
                                      ? Colors.green[800] 
                                      : Colors.blue[800],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    if (pagoConCuantoController.text.isNotEmpty && 
                        double.tryParse(pagoConCuantoController.text) != null &&
                        double.parse(pagoConCuantoController.text) < widget.total) ...[
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.red[100],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.red),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.error, color: Colors.red),
                            const SizedBox(width: 10),
                            Text(
                              'El monto debe ser mayor o igual al total',
                              style: TextStyle(color: Colors.red[800], fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],

            const SizedBox(height: 30),

            // Botón confirmar pedido
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _puedeConfirmarPedido() ? _confirmarPedido : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  disabledBackgroundColor: Colors.grey,
                ),
                child: const Text('CONFIRMAR PEDIDO', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _puedeConfirmarPedido() {
    bool datosCompletos = nombreController.text.isNotEmpty &&
                         telefonoController.text.isNotEmpty &&
                         tipoEntrega.isNotEmpty &&
                         metodoPago.isNotEmpty;
    
    bool ubicacionOk = tipoEntrega == 'recojo' || ubicacionActual != null;
    
    bool pagoOk = true;
    if (metodoPago == 'efectivo') {
      if (pagoConCuantoController.text.isEmpty) {
        pagoOk = false;
      } else {
        double? pagoConCuanto = double.tryParse(pagoConCuantoController.text);
        pagoOk = pagoConCuanto != null && pagoConCuanto >= widget.total;
      }
    }
    
    return datosCompletos && ubicacionOk && pagoOk;
  }

  Future<void> _obtenerUbicacion() async {
    setState(() {
      cargandoUbicacion = true;
    });

    try {
      // Verificar si el GPS está habilitado
      bool serviceEnabled = await UbicacionService.isGpsEnabled();
      if (!serviceEnabled) {
        await DialogUtils.mostrarDialogoGpsDesactivado(context);
        return;
      }

      // Verificar permisos
      LocationPermission permission = await UbicacionService.checkLocationPermission();
      
      if (permission == LocationPermission.denied) {
        permission = await UbicacionService.requestLocationPermission();
      }

      if (permission == LocationPermission.deniedForever) {
        await DialogUtils.mostrarDialogoPermisosDenegados(context);
        return;
      }

      if (permission == LocationPermission.denied) {
        _mostrarError('Permisos de ubicación denegados');
        return;
      }

      // Obtener ubicación
      Position position = await UbicacionService.getCurrentPosition();

      setState(() {
        ubicacionActual = position;
      });

    } catch (e) {
      _mostrarError('Error al obtener ubicación: $e');
    } finally {
      setState(() {
        cargandoUbicacion = false;
      });
    }
  }

  void _mostrarError(String mensaje) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(mensaje),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // 🔥 MÉTODO MEJORADO PARA CONFIRMAR PEDIDO CON ADICIONALES
  void _confirmarPedido() async {
    // Mostrar loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      // Guardar datos del cliente
      await ClienteService.guardarDatosCliente(
        DatosCliente(nombre: nombreController.text, telefono: telefonoController.text)
      );

      // Generar número de pedido único
      String numeroPedido = DateTime.now().millisecondsSinceEpoch.toString().substring(7);
      
      // 🔥 ENVIAR PEDIDO AUTOMÁTICAMENTE POR WHATSAPP CON ADICIONALES
      await _enviarPedidoPorWhatsApp(numeroPedido);
      
      // Cerrar loading
      Navigator.pop(context);
      
      // Mostrar confirmación de envío
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 10),
              Text('¡Pedido enviado por WhatsApp! 🎉'),
            ],
          ),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
        ),
      );
      
      // Ir a pantalla de confirmación
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ConfirmacionScreen(
            numeroPedido: numeroPedido,
            carrito: widget.carrito,
            total: widget.total,
            metodoPago: metodoPago,
            tipoEntrega: tipoEntrega,
            nombre: nombreController.text,
            telefono: telefonoController.text,
            ubicacion: ubicacionActual,
            vuelto: vuelto,
            pagoConCuanto: metodoPago == 'efectivo' ? double.tryParse(pagoConCuantoController.text) : null,
          ),
        ),
      );
    } catch (e) {
      // Cerrar loading
      Navigator.pop(context);
      
      // Mostrar error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al enviar pedido: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // 🔥 MÉTODO ACTUALIZADO PARA INCLUIR ADICIONALES EN WHATSAPP
  Future<void> _enviarPedidoPorWhatsApp(String numeroPedido) async {
    // Crear link de Google Maps si hay ubicación
    String linkUbicacion = '';
    if (tipoEntrega == 'delivery' && ubicacionActual != null) {
      linkUbicacion = 'https://www.google.com/maps?q=${ubicacionActual!.latitude},${ubicacionActual!.longitude}';
    }

    String mensaje = '''🍕 *NUEVO PEDIDO FABICHELO* 🍕

📋 *PEDIDO #${numeroPedido}*

👤 *DATOS DEL CLIENTE:*
• *Nombre:* ${nombreController.text}
• *Teléfono:* ${telefonoController.text}

🛒 *PRODUCTOS:*
${widget.carrito.map((item) {
  String linea = '• ${item.cantidad}x ${item.nombre} (${item.tamano})';
  if (item.adicionales.isNotEmpty) {
    linea += ' + ${item.adicionales.map((a) => '${a.icono}${a.nombre}').join(', ')}';
  }
  linea += ' - S/${(item.precioTotal * item.cantidad).toStringAsFixed(2)}';
  return linea;
}).join('\n')}

💰 *TOTAL: S/${widget.total.toStringAsFixed(2)}*

🚚 *TIPO DE ENTREGA:*
${tipoEntrega == 'delivery' ? '🏠 *DELIVERY*' : '🏪 *RECOJO EN TIENDA*'}

${tipoEntrega == 'delivery' && ubicacionActual != null ? '📍 *UBICACIÓN DEL DELIVERY:*\n$linkUbicacion' : ''}

💳 *MÉTODO DE PAGO:*
${_obtenerTextoPago()}

⏰ *Hora del pedido:* ${DateTime.now().toString().substring(0, 16)}

━━━━━━━━━━━━━━━━━━━━━━━━━━

⚠️ *IMPORTANTE:* Por favor confirmar si pueden llegar a esta dirección antes de que el cliente realice el pago.

¡Gracias! 🍕❤️''';

    // Enviar por WhatsApp
    await PagoService.enviarWhatsApp(PagoService.numeroWhatsApp, mensaje);
  }

  String _obtenerTextoPago() {
    switch (metodoPago) {
      case 'efectivo':
        if (pagoConCuantoController.text.isNotEmpty) {
          double pagoConCuanto = double.parse(pagoConCuantoController.text);
          if (vuelto != null && vuelto! > 0) {
            return '💵 *EFECTIVO*\n   • Paga con: S/${pagoConCuanto.toStringAsFixed(2)}\n   • Vuelto: S/${vuelto!.toStringAsFixed(2)}';
          } else {
            return '💵 *EFECTIVO* - Pago exacto: S/${widget.total.toStringAsFixed(2)}';
          }
        }
        return '💵 *EFECTIVO*';
      case 'yape':
        return '🟣 *YAPE*\n   • Número: ${PagoService.numeroYape}\n   • Nombre: Carlos Alberto Huaytalla Quispe';
      case 'plin':
        return '🔵 *PLIN*\n   • Número: ${PagoService.numeroPlin}\n   • Nombre: Fabian Hector Huaytalla Guevara';
      default:
        return metodoPago.toUpperCase();
    }
  }
}