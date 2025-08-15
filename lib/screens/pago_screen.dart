import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // 🔥 AGREGADO PARA CLIPBOARD
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
      double totalFinal = tipoEntrega == 'delivery' ? widget.total + 2.00 : widget.total;
      
      if (pagoConCuanto >= totalFinal) {
        setState(() {
          vuelto = PagoService.calcularVuelto(totalFinal, pagoConCuanto);
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
            // 🔥 DATOS DEL CLIENTE
            _buildDatosCliente(),

            const SizedBox(height: 20),

            // 🔥 TIPO DE ENTREGA CON UBICACIÓN DE TIENDA
            _buildTipoEntrega(),

            const SizedBox(height: 20),

            // 🔥 MÉTODO DE PAGO
            _buildMetodoPago(),

            const SizedBox(height: 20),

            // 🔥 RESUMEN DEL PEDIDO COMPACTO
            _buildResumenPedidoCompacto(),

            const SizedBox(height: 24),

            // 🔥 BOTÓN CONFIRMAR
            _buildBotonConfirmar(),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

Widget _buildResumenPedidoCompacto() {
  final double totalFinal = tipoEntrega == 'delivery' ? widget.total + 2.00 : widget.total;
  
  return Card(
    elevation: 4,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(Icons.receipt_long, color: Colors.white, size: 16), // 🔧 TAMAÑO ICONO HEADER (+2)
              ),
              const SizedBox(width: 8),
              const Text(
                'Resumen', 
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold) // 🔧 TÍTULO HEADER (+2)
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // Lista compacta de productos
          ...widget.carrito.map((item) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Text(
                    '${item.cantidad}x',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12, // 🔧 CANTIDAD PRODUCTOS (+2)
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${item.nombre} (${item.tamano})',
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500), // 🔧 NOMBRE PRODUCTOS (+2)
                      ),
                      if (item.adicionales.isNotEmpty) ...[
                        const SizedBox(height: 1),
                        Text(
                          '+ ${item.adicionales.map((a) => '${a.cantidad}x ${a.nombre}').join(', ')}',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.green[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Text(
                  'S/${item.precioTotalCarrito.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                    fontSize: 14, // 🔧 PRECIO PRODUCTOS (+2)
                  ),
                ),
              ],
            ),
          )),
          
          if (tipoEntrega == 'delivery') ...[
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.delivery_dining, color: Colors.orange, size: 16), // 🔧 ICONO DELIVERY (+2)
                const SizedBox(width: 6),
                const Expanded(
                  child: Text(
                    'Delivery',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500), // 🔧 TEXTO DELIVERY (+2)
                  ),
                ),
                Text(
                  'S/2.00',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                    fontSize: 14, // 🔧 PRECIO DELIVERY (+2)
                  ),
                ),
              ],
            ),
          ],
          
          const SizedBox(height: 8),
          Container(height: 1, color: Colors.grey[300]),
          const SizedBox(height: 8),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'TOTAL:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16) // 🔧 LABEL TOTAL (+2)
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'S/${totalFinal.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold, 
                    fontSize: 16, // 🔧 PRECIO TOTAL (+2)
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

  Widget _buildDatosCliente() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(Icons.person, color: Colors.white, size: 16),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Datos del Cliente', 
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: nombreController,
              decoration: InputDecoration(
                labelText: 'Nombre completo',
                prefixIcon: const Icon(Icons.person_outline, color: Colors.green),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.green, width: 2),
                ),
                filled: true,
                fillColor: Colors.green[50],
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: telefonoController,
              decoration: InputDecoration(
                labelText: 'Teléfono',
                prefixIcon: const Icon(Icons.phone_outlined, color: Colors.green),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
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
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(Icons.delivery_dining, color: Colors.white, size: 16),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Tipo de Entrega', 
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() {
                      tipoEntrega = 'delivery';
                      ubicacionActual = null;
                    }),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: tipoEntrega == 'delivery' ? Colors.orange : Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: tipoEntrega == 'delivery' ? Colors.orange : Colors.grey[300]!,
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.delivery_dining,
                            color: tipoEntrega == 'delivery' ? Colors.white : Colors.grey[600],
                            size: 24,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Delivery',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: tipoEntrega == 'delivery' ? Colors.white : Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() {
                      tipoEntrega = 'recojo';
                      ubicacionActual = null;
                    }),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: tipoEntrega == 'recojo' ? Colors.orange : Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: tipoEntrega == 'recojo' ? Colors.orange : Colors.grey[300]!,
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.store,
                            color: tipoEntrega == 'recojo' ? Colors.white : Colors.grey[600],
                            size: 24,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Recojo',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: tipoEntrega == 'recojo' ? Colors.white : Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Sección específica según tipo de entrega
            if (tipoEntrega == 'delivery') ...[
              const SizedBox(height: 16),
              _buildSeccionDelivery(),
            ] else if (tipoEntrega == 'recojo') ...[
              const SizedBox(height: 16),
              _buildSeccionRecojo(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSeccionDelivery() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ⚠️ ADVERTENCIA COMPACTA
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.orange[100],
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.orange[300]!),
            ),
            child: Row(
              children: [
                Icon(Icons.warning, color: Colors.orange[800], size: 16),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Delivery S/2.00',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.orange[800],
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 8),
          
          if (ubicacionActual == null) ...[
            const Text(
              'Necesitamos tu ubicación',
              style: TextStyle(color: Colors.blue, fontSize: 14),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: cargandoUbicacion ? null : _obtenerUbicacion,
                icon: cargandoUbicacion 
                    ? const SizedBox(
                        width: 12, 
                        height: 12, 
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)
                      )
                    : const Icon(Icons.location_on, color: Colors.white, size: 16),
                label: Text(
                  cargandoUbicacion ? 'Obteniendo...' : 'Obtener ubicación',
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                ),
              ),
            ),
          ] else ...[
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green[100],
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.green[300]!),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.green, size: 16),
                  const SizedBox(width: 6),
                  const Expanded(
                    child: Text(
                      'Ubicación obtenida', 
                      style: TextStyle(
                        color: Colors.green, 
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      )
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () => UbicacionService.abrirEnMaps(
                      ubicacionActual!.latitude, 
                      ubicacionActual!.longitude
                    ),
                    icon: const Icon(Icons.map, size: 15, color: Colors.green),
                    label: const Text('', style: TextStyle(fontSize: 14, color: Colors.green)),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                      minimumSize: Size.zero,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSeccionRecojo() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.store, color: Colors.green, size: 16),
              const SizedBox(width: 6),
              const Text(
                'Lurigancho-Chosica, Anexo 8', 
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.green,
                )
              ),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => UbicacionService.abrirEnMaps(-11.979865, -76.941701),
              icon: const Icon(Icons.map, color: Colors.white, size: 14),
              label: const Text(
                'Ver ubicación',
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🔥 MÉTODO DE PAGO ACTUALIZADO CON TARJETAS YAPE/PLIN
  Widget _buildMetodoPago() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.purple,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(Icons.payment, color: Colors.white, size: 16),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Método de Pago', 
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
                ),
              ],
            ),
            const SizedBox(height: 12),

            // 🔥 ADVERTENCIA ARRIBA (para pagos digitales)
            if (metodoPago == 'yape' || metodoPago == 'plin') ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.red[100]!, Colors.orange[100]!],
                  ),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red[300]!, width: 2),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Icon(Icons.warning, color: Colors.white, size: 16),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '⚠️ NO REALIZE EL PAGO',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.red[800],
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Espera a que nuestro personal confirme la ubicacion para llevar su pedido',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.red[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],

            // YAPE
            _buildOpcionPago('yape', 'Yape', Colors.purple, 'assets/images/logos/yape_logo.png'),
            const SizedBox(height: 8),

            // PLIN
            _buildOpcionPago('plin', 'Plin', Colors.teal, 'assets/images/logos/plin_logo.png'),
            const SizedBox(height: 8),

            // EFECTIVO
            _buildOpcionPago('efectivo', 'Efectivo', Colors.green, null),

            // 🔥 TARJETA DE PAGO DIGITAL (cuando se seleccione Yape o Plin)
            if (metodoPago == 'yape' || metodoPago == 'plin') ...[
              const SizedBox(height: 12),
              _buildTarjetaPagoDigital(),
            ],

            // 🔥 RECORDATORIO WHATSAPP (solo para pagos digitales - más pequeño)
            if (metodoPago == 'yape' || metodoPago == 'plin') ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(
                            color: Colors.blue[800],
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          children: [
                            const TextSpan(text: 'Cuando se acepte el pedido y su ubicación realice el pago del '),
                            TextSpan(
                              text: metodoPago.toUpperCase(),
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const TextSpan(text: ' y mande captura al WhatsApp '),
                            const WidgetSpan(
                              child: FaIcon(
                                FontAwesomeIcons.whatsapp,
                                color: Colors.green,
                                size: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // Campo para pago en efectivo
            if (metodoPago == 'efectivo') ...[
              const SizedBox(height: 12),
              _buildCampoEfectivo(),
            ],
          ],
        ),
      ),
    );
  }

  // 🔥 TARJETA DE PAGO DIGITAL (copiada y adaptada de confirmacion_screen)
  Widget _buildTarjetaPagoDigital() {
    final metodoPagoLower = metodoPago.toLowerCase();
    final colorPrincipal = metodoPagoLower == 'yape' ? Colors.purple : Colors.teal;
    final nombreMetodo = metodoPagoLower == 'yape' ? 'Yape' : 'Plin';
    final numeroTelefono = metodoPagoLower == 'yape' ? PagoService.numeroYape : PagoService.numeroPlin;
    final nombreTitular = metodoPagoLower == 'yape' 
        ? 'Carlos Alberto Huaytalla Quispe' 
        : 'Fabian Hector Huaytalla Guevara';

    // Calcular total final
    final double totalFinal = tipoEntrega == 'delivery' ? widget.total + 2.00 : widget.total;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          colors: [Colors.white, colorPrincipal.withOpacity(0.05)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: colorPrincipal.withOpacity(0.3)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [colorPrincipal, colorPrincipal.withOpacity(0.8)],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.payment, color: Colors.white, size: 16),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Datos para $nombreMetodo',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold, 
                          fontSize: 15,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        'Información de pago',
                        style: TextStyle(
                          color: Colors.grey[600], 
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Información de pago
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [colorPrincipal, colorPrincipal.withOpacity(0.8)],
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  // Logo y método
                  Row(
                    children: [
                      _buildLogoMetodoPago(metodoPagoLower),
                      const SizedBox(width: 10),
                      Text(
                        nombreMetodo,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  
                  // Datos
                  _buildInfoPagoDigitalCompacto('📱', numeroTelefono),
                  const SizedBox(height: 6),
                  _buildInfoPagoDigitalCompacto('👤', nombreTitular),
                  const SizedBox(height: 6),
                  _buildInfoPagoDigitalCompacto(
                    '💵', 
                    tipoEntrega == 'delivery' 
                        ? 'S/${totalFinal.toStringAsFixed(2)} (incluye delivery)'
                        : 'S/${totalFinal.toStringAsFixed(2)}'
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Botón copiar
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _copiarNumero,
                icon: const Icon(Icons.copy, color: Colors.white, size: 16),
                label: const Text(
                  'Copiar Número',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorPrincipal,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔥 COPIAR NÚMERO - MÉTODO INDEPENDIENTE
  Future<void> _copiarNumero() async {
    final numero = metodoPago.toLowerCase() == 'yape' 
        ? PagoService.numeroYape 
        : PagoService.numeroPlin;
    
    await Clipboard.setData(ClipboardData(text: numero));

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Número copiado: $numero ✅',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.blue,
          duration: const Duration(seconds: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  // 🔥 LOGO MÉTODO DE PAGO
  Widget _buildLogoMetodoPago(String metodo) {
    final assetPath = metodo == 'yape' 
        ? 'assets/images/logos/yape_logo.png'
        : 'assets/images/logos/plin_logo.png';

    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Image.asset(
          assetPath,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return Icon(
              metodo == 'yape' ? Icons.account_balance_wallet : Icons.credit_card,
              size: 16,
              color: metodo == 'yape' ? Colors.purple : Colors.teal,
            );
          },
        ),
      ),
    );
  }

  // 🔥 INFO PAGO DIGITAL COMPACTO
  Widget _buildInfoPagoDigitalCompacto(String icono, String value) {
    return Row(
      children: [
        Text(icono, style: const TextStyle(fontSize: 14)),
        const SizedBox(width: 8),
        Expanded(
          child: SelectableText(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOpcionPago(String metodo, String nombre, Color color, String? logoPath) {
    bool seleccionado = metodoPago == metodo;
    
    return GestureDetector(
      onTap: () => setState(() {
        metodoPago = metodo;
        if (metodo != 'efectivo') vuelto = null;
      }),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: seleccionado ? color : color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: seleccionado ? color : color.withOpacity(0.3),
          ),
        ),
        child: Row(
          children: [
            if (logoPath != null) ...[
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Image.asset(
                    logoPath,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.payment, color: color, size: 16);
                    },
                  ),
                ),
              ),
            ] else ...[
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: seleccionado ? Colors.white.withOpacity(0.2) : color,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Icon(Icons.payments, color: Colors.white, size: 16),
              ),
            ],
            const SizedBox(width: 10),
            Text(
              nombre,
              style: TextStyle(
                color: seleccionado ? Colors.white : color,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            const Spacer(),
            if (seleccionado)
              const Icon(Icons.check_circle, color: Colors.white, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildCampoEfectivo() {
    final double totalFinal = tipoEntrega == 'delivery' ? widget.total + 2.00 : widget.total;
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Pago en Efectivo', 
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.green)
          ),
          const SizedBox(height: 8),
          TextField(
            controller: pagoConCuantoController,
            decoration: InputDecoration(
              labelText: '¿Con cuánto va a pagar?',
              prefixText: 'S/ ',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: const BorderSide(color: Colors.green, width: 2),
              ),
              hintText: 'Ingrese el monto',
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onChanged: (value) => _calcularVuelto(),
          ),
          if (vuelto != null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: PagoService.esPagoExacto(totalFinal, double.parse(pagoConCuantoController.text)) 
                    ? Colors.green[100] 
                    : Colors.blue[100],
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: PagoService.esPagoExacto(totalFinal, double.parse(pagoConCuantoController.text)) 
                      ? Colors.green 
                      : Colors.blue
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    PagoService.esPagoExacto(totalFinal, double.parse(pagoConCuantoController.text)) 
                        ? Icons.check_circle 
                        : Icons.monetization_on,
                    color: PagoService.esPagoExacto(totalFinal, double.parse(pagoConCuantoController.text)) 
                        ? Colors.green 
                        : Colors.blue,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      PagoService.esPagoExacto(totalFinal, double.parse(pagoConCuantoController.text))
                          ? 'Pago exacto ✅'
                          : 'Vuelto: S/${vuelto!.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: PagoService.esPagoExacto(totalFinal, double.parse(pagoConCuantoController.text)) 
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
              double.parse(pagoConCuantoController.text) < totalFinal) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red[100],
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.red),
              ),
              child: Row(
                children: [
                  const Icon(Icons.error, color: Colors.red, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Monto insuficiente',
                      style: TextStyle(
                        color: Colors.red[800], 
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBotonConfirmar() {
    bool puedeConfirmar = _puedeConfirmarPedido();
    
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: puedeConfirmar 
              ? [Colors.red[600]!, Colors.red[700]!]
              : [Colors.grey[400]!, Colors.grey[500]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: puedeConfirmar ? [
          BoxShadow(
            color: Colors.red.withOpacity(0.4),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ] : null,
      ),
      child: ElevatedButton(
        onPressed: puedeConfirmar ? _confirmarPedido : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, size: 20),
            const SizedBox(width: 8),
            Text(
              puedeConfirmar ? 'CONFIRMAR PEDIDO' : 'COMPLETE TODOS LOS DATOS',
              style: const TextStyle(
                fontSize: 14, 
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
  double totalFinal = tipoEntrega == 'delivery' ? widget.total + 2.00 : widget.total;
  
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
      pagoOk = pagoConCuanto != null && pagoConCuanto >= totalFinal;
    }
  }
  
  return datosCompletos && ubicacionOk && pagoOk;
}

  Future<void> _obtenerUbicacion() async {
    setState(() {
      cargandoUbicacion = true;
    });

    try {
      bool serviceEnabled = await UbicacionService.isGpsEnabled();
      if (!serviceEnabled) {
        await DialogUtils.mostrarDialogoGpsDesactivado(context);
        return;
      }

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

  void _confirmarPedido() async {
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
      await ClienteService.guardarDatosCliente(
        DatosCliente(nombre: nombreController.text, telefono: telefonoController.text)
      );

      String numeroPedido = DateTime.now().millisecondsSinceEpoch.toString().substring(7);
      
      await _enviarPedidoPorWhatsApp(numeroPedido);
      
      if (!mounted) return;
      
      Navigator.pop(context);
      
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
      if (!mounted) return;
      
      Navigator.pop(context);
      
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

Future<void> _enviarPedidoPorWhatsApp(String numeroPedido) async {
  // 🔥 PREPARAR INFORMACIÓN DE UBICACIÓN
  String infoUbicacion = '';
  if (tipoEntrega == 'delivery' && ubicacionActual != null) {
    String linkUbicacion = 'https://www.google.com/maps?q=${ubicacionActual!.latitude},${ubicacionActual!.longitude}';
    infoUbicacion = '\n📍 Ubicación: $linkUbicacion';
  }

  String mensaje = '''🍕 *NUEVO PEDIDO FABICHELO* 
📋 Pedido #$numeroPedido

👤 *DATOS DEL CLIENTE*
• Nombre: ${nombreController.text}
• Teléfono: ${telefonoController.text}

🚚 *TIPO DE ENTREGA*
${tipoEntrega == 'delivery' ? '🏠 Delivery' : '🏪 Recojo en tienda'}$infoUbicacion

💳 *MÉTODO DE PAGO*
${_obtenerTextoPagoLimpio()}

🛒 *PRODUCTOS PEDIDOS*
${widget.carrito.map((item) {
    String linea = '• ${item.cantidad}x ${item.nombre} (${item.tamano})';
    if (item.adicionales.isNotEmpty) {
      linea += '\n   ${item.adicionales.map((a) => '${a.cantidad}x - ${a.nombre}').join('\n   ')}';

    }
    linea += '\n   S/${item.precioTotalCarrito.toStringAsFixed(2)}';
    return linea;
  }).join('\n\n')}${tipoEntrega == 'delivery' ? '\n\n• Delivery\n   S/2.00' : ''}

━━━━━━━━━━━━━━━━━━━━━━━━━━
🔥 *TOTAL A COBRAR: S/${(widget.total + (tipoEntrega == 'delivery' ? 2.00 : 0.00)).toStringAsFixed(2)}*

¡Gracias por tu pedido! 🍕❤️''';

  await PagoService.enviarWhatsApp(PagoService.numeroWhatsApp, mensaje);
}

String _obtenerTextoPagoLimpio() {
  // Calculamos el total final (incluyendo delivery si aplica)
  double totalFinal = tipoEntrega == 'delivery' ? widget.total + 2.00 : widget.total;

  switch (metodoPago) {
    case 'efectivo':
      if (pagoConCuantoController.text.isNotEmpty) {
        double pagoConCuanto = double.parse(pagoConCuantoController.text);
        double vueltoCalculado = pagoConCuanto - totalFinal;

        if (vueltoCalculado > 0) {
          return '💵 Efectivo\n• Paga con: S/${pagoConCuanto.toStringAsFixed(2)}\n• Vuelto: S/${vueltoCalculado.toStringAsFixed(2)}';
        } else {
          return '💵 Efectivo (pago exacto)';
        }
      }
      return '💵 Efectivo';

    case 'yape':
      return '🟣 Yape\n• ${PagoService.numeroYape}\n• Carlos Alberto Huaytalla Quispe';

    case 'plin':
      return '🔵 Plin\n• ${PagoService.numeroPlin}\n• Fabian Hector Huaytalla Guevara';

    default:
      return metodoPago.toUpperCase();
  }
}
}