import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../models/models.dart';
import '../services/services.dart';
import '../widgets/dialogs.dart';
import 'confirmacion_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Finalizar Pedido', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.red,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔥 RESUMEN DEL PEDIDO MEJORADO
            _buildResumenPedido(),

            const SizedBox(height: 24),

            // 🔥 DATOS DEL CLIENTE MEJORADO
            _buildDatosCliente(),

            const SizedBox(height: 24),

            // 🔥 TIPO DE ENTREGA MEJORADO
            _buildTipoEntrega(),

            const SizedBox(height: 24),

            // 🔥 MÉTODO DE PAGO REORDENADO (YAPE, PLIN, EFECTIVO)
            _buildMetodoPago(),

            const SizedBox(height: 32),

            // 🔥 BOTÓN CONFIRMAR MEJORADO
            _buildBotonConfirmar(),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildResumenPedido() {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [Colors.white, Colors.grey[50]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.receipt_long, color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Resumen del Pedido', 
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.blue[100]!),
                ),
                child: Column(
                  children: [
                    ...widget.carrito.map((item) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  '${item.cantidad}x',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${item.nombre} (${item.tamano})',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                    ),
                                    if (item.adicionales.isNotEmpty) ...[
                                      const SizedBox(height: 2),
                                      Text(
                                        '+ ${item.adicionales.map((a) => '${a.icono} ${a.nombre}').join(', ')}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.green[700],
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                              Text(
                                'S/ ${(item.precioTotal * item.cantidad).toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      height: 2,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.red[300]!, Colors.red[600]!],
                        ),
                        borderRadius: BorderRadius.circular(1),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'TOTAL:', 
                          style: TextStyle(
                            fontWeight: FontWeight.bold, 
                            fontSize: 18,
                            color: Colors.black87,
                          )
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.red.withOpacity(0.3),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            'S/ ${widget.total.toStringAsFixed(2)}', 
                            style: const TextStyle(
                              fontWeight: FontWeight.bold, 
                              fontSize: 18, 
                              color: Colors.white,
                            )
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDatosCliente() {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.person, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Datos del Cliente', 
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: nombreController,
              decoration: InputDecoration(
                labelText: 'Nombre completo',
                prefixIcon: const Icon(Icons.person_outline, color: Colors.green),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.green, width: 2),
                ),
                filled: true,
                fillColor: Colors.green[50],
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: telefonoController,
              decoration: InputDecoration(
                labelText: 'Teléfono',
                prefixIcon: const Icon(Icons.phone_outlined, color: Colors.green),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.green, width: 2),
                ),
                filled: true,
                fillColor: Colors.green[50],
              ),
              keyboardType: TextInputType.phone,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTipoEntrega() {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.delivery_dining, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Tipo de Entrega', 
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() {
                      tipoEntrega = 'delivery';
                      ubicacionActual = null;
                    }),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: tipoEntrega == 'delivery' ? Colors.orange : Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: tipoEntrega == 'delivery' ? Colors.orange : Colors.grey[300]!,
                          width: 2,
                        ),
                        boxShadow: tipoEntrega == 'delivery' ? [
                          BoxShadow(
                            color: Colors.orange.withOpacity(0.3),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ] : null,
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.delivery_dining,
                            color: tipoEntrega == 'delivery' ? Colors.white : Colors.grey[600],
                            size: 32,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Delivery',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: tipoEntrega == 'delivery' ? Colors.white : Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() {
                      tipoEntrega = 'recojo';
                      ubicacionActual = null;
                    }),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: tipoEntrega == 'recojo' ? Colors.orange : Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: tipoEntrega == 'recojo' ? Colors.orange : Colors.grey[300]!,
                          width: 2,
                        ),
                        boxShadow: tipoEntrega == 'recojo' ? [
                          BoxShadow(
                            color: Colors.orange.withOpacity(0.3),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ] : null,
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.store,
                            color: tipoEntrega == 'recojo' ? Colors.white : Colors.grey[600],
                            size: 32,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Recojo',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: tipoEntrega == 'recojo' ? Colors.white : Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Ubicación para delivery
            if (tipoEntrega == 'delivery') ...[
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue[50]!, Colors.blue[100]!],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.blue, size: 24),
                        SizedBox(width: 10),
                        Text(
                          'Ubicación para Delivery', 
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.blue,
                          )
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (ubicacionActual == null) ...[
                      const Text(
                        'Necesitamos tu ubicación exacta para el delivery',
                        style: TextStyle(color: Colors.blue),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: cargandoUbicacion ? null : _obtenerUbicacion,
                          icon: cargandoUbicacion 
                              ? const SizedBox(
                                  width: 16, 
                                  height: 16, 
                                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)
                                )
                              : const Icon(Icons.location_on, color: Colors.white),
                          label: Text(
                            cargandoUbicacion ? 'Obteniendo ubicación...' : 'Obtener mi ubicación',
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ] else ...[
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.green[100],
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.green[300]!),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.check_circle, color: Colors.green, size: 20),
                                SizedBox(width: 8),
                                Text(
                                  'Ubicación obtenida ✅', 
                                  style: TextStyle(
                                    color: Colors.green, 
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  )
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Lat: ${ubicacionActual!.latitude.toStringAsFixed(6)}',
                              style: const TextStyle(fontSize: 12, color: Colors.green),
                            ),
                            Text(
                              'Lng: ${ubicacionActual!.longitude.toStringAsFixed(6)}',
                              style: const TextStyle(fontSize: 12, color: Colors.green),
                            ),
                            const SizedBox(height: 12),
                            ElevatedButton.icon(
                              onPressed: () => UbicacionService.abrirEnMaps(
                                ubicacionActual!.latitude, 
                                ubicacionActual!.longitude
                              ),
                              icon: const Icon(Icons.map, color: Colors.white),
                              label: const Text(
                                'Ver en Maps',
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMetodoPago() {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.purple,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.payment, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Método de Pago', 
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)
                ),
              ],
            ),
            const SizedBox(height: 16),

            // YAPE - PRIMERO
            GestureDetector(
              onTap: () => setState(() {
                metodoPago = 'yape';
                vuelto = null;
              }),
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: metodoPago == 'yape' ? Colors.purple : Colors.purple[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: metodoPago == 'yape' ? Colors.purple : Colors.purple[200]!,
                    width: 2,
                  ),
                  boxShadow: metodoPago == 'yape' ? [
                    BoxShadow(
                      color: Colors.purple.withOpacity(0.3),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ] : null,
                ),
                child: Row(
                  children: [
                    // Logo real de Yape
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.purple.withOpacity(0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          'assets/images/logos/yape_logo.png',
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            // Fallback si no encuentra la imagen
                            return Container(
                              decoration: const BoxDecoration(
                                color: Colors.purple,
                                shape: BoxShape.circle,
                              ),
                              child: const Center(
                                child: Text(
                                  'Y',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      'Yape',
                      style: TextStyle(
                        color: metodoPago == 'yape' ? Colors.white : Colors.purple,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const Spacer(),
                    if (metodoPago == 'yape')
                      const Icon(Icons.check_circle, color: Colors.white),
                  ],
                ),
              ),
            ),

            // PLIN - SEGUNDO
            GestureDetector(
              onTap: () => setState(() {
                metodoPago = 'plin';
                vuelto = null;
              }),
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: metodoPago == 'plin' ? Colors.teal : Colors.teal[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: metodoPago == 'plin' ? Colors.teal : Colors.teal[200]!,
                    width: 2,
                  ),
                  boxShadow: metodoPago == 'plin' ? [
                    BoxShadow(
                      color: Colors.teal.withOpacity(0.3),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ] : null,
                ),
                child: Row(
                  children: [
                    // Logo real de Plin
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.teal.withOpacity(0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          'assets/images/logos/plin_logo.png',
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            // Fallback si no encuentra la imagen
                            return Container(
                              decoration: const BoxDecoration(
                                color: Colors.teal,
                                shape: BoxShape.circle,
                              ),
                              child: const Center(
                                child: Text(
                                  'P',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      'Plin',
                      style: TextStyle(
                        color: metodoPago == 'plin' ? Colors.white : Colors.teal,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const Spacer(),
                    if (metodoPago == 'plin')
                      const Icon(Icons.check_circle, color: Colors.white),
                  ],
                ),
              ),
            ),

            // EFECTIVO - ÚLTIMO
            GestureDetector(
              onTap: () => setState(() {
                metodoPago = 'efectivo';
              }),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: metodoPago == 'efectivo' ? Colors.green : Colors.green[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: metodoPago == 'efectivo' ? Colors.green : Colors.green[200]!,
                    width: 2,
                  ),
                  boxShadow: metodoPago == 'efectivo' ? [
                    BoxShadow(
                      color: Colors.green.withOpacity(0.3),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ] : null,
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: metodoPago == 'efectivo' ? Colors.white.withOpacity(0.2) : Colors.green,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.monetization_on,
                        color: metodoPago == 'efectivo' ? Colors.white : Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      'Efectivo',
                      style: TextStyle(
                        color: metodoPago == 'efectivo' ? Colors.white : Colors.green,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const Spacer(),
                    if (metodoPago == 'efectivo')
                      const Icon(Icons.check_circle, color: Colors.white),
                  ],
                ),
              ),
            ),

            // Campo para pago en efectivo
            if (metodoPago == 'efectivo') ...[
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.green[50]!, Colors.green[100]!],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Detalles del Pago en Efectivo', 
                      style: TextStyle(
                        fontWeight: FontWeight.bold, 
                        fontSize: 16,
                        color: Colors.green,
                      )
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: pagoConCuantoController,
                      decoration: InputDecoration(
                        labelText: '¿Con cuánto va a pagar?',
                        prefixText: 'S/ ',
                        prefixIcon: const Icon(Icons.monetization_on, color: Colors.green),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.green, width: 2),
                        ),
                        hintText: 'Ingrese el monto',
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      onChanged: (value) => _calcularVuelto(),
                    ),
                    if (vuelto != null) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: PagoService.esPagoExacto(widget.total, double.parse(pagoConCuantoController.text)) 
                              ? Colors.green[100] 
                              : Colors.blue[100],
                          borderRadius: BorderRadius.circular(10),
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
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                PagoService.esPagoExacto(widget.total, double.parse(pagoConCuantoController.text))
                                    ? 'Pago exacto ✅'
                                    : 'Su vuelto será: S/ ${vuelto!.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
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
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.red[100],
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.red),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.error, color: Colors.red),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'El monto debe ser mayor o igual al total',
                                style: TextStyle(
                                  color: Colors.red[800], 
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildBotonConfirmar() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: _puedeConfirmarPedido() 
              ? [Colors.red[600]!, Colors.red[700]!]
              : [Colors.grey[400]!, Colors.grey[500]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: _puedeConfirmarPedido() ? [
          BoxShadow(
            color: Colors.red.withOpacity(0.4),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ] : null,
      ),
      child: ElevatedButton(
        onPressed: _puedeConfirmarPedido() ? _confirmarPedido : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, size: 24),
            const SizedBox(width: 12),
            Text(
              _puedeConfirmarPedido() ? 'CONFIRMAR PEDIDO' : 'COMPLETE TODOS LOS DATOS',
              style: const TextStyle(
                fontSize: 16, 
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
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
          content: Row(
            children: [
              const Icon(Icons.error, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(child: Text(mensaje)),
            ],
          ),
          backgroundColor: Colors.red,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  // 🔥 MÉTODO MEJORADO PARA CONFIRMAR PEDIDO CON ADICIONALES
  void _confirmarPedido() async {
    // Mostrar loading mejorado
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Container(
        color: Colors.black.withOpacity(0.7),
        child: const Center(
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Enviando pedido...',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
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
      
      // Mostrar confirmación de envío mejorada
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(FontAwesomeIcons.whatsapp, color: Colors.white),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  '¡Pedido enviado por WhatsApp! 🎉',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          behavior: SnackBarBehavior.floating,
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
          content: Row(
            children: [
              const Icon(Icons.error, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(child: Text('Error al enviar pedido: $e')),
            ],
          ),
          backgroundColor: Colors.red,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          behavior: SnackBarBehavior.floating,
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