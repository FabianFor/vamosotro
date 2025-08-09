import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../models/models.dart';
import '../services/services.dart';
import '../widgets/dialogs.dart';
import 'home_screen.dart';

class ConfirmacionScreen extends StatefulWidget {
  final String numeroPedido;
  final List<ItemPedido> carrito;
  final double total;
  final String metodoPago;
  final String tipoEntrega;
  final String nombre;
  final String telefono;
  final Position? ubicacion;
  final double? vuelto;
  final double? pagoConCuanto;

  ConfirmacionScreen({
    required this.numeroPedido,
    required this.carrito,
    required this.total,
    required this.metodoPago,
    required this.tipoEntrega,
    required this.nombre,
    required this.telefono,
    this.ubicacion,
    this.vuelto,
    this.pagoConCuanto,
  });

  @override
  _ConfirmacionScreenState createState() => _ConfirmacionScreenState();
}

class _ConfirmacionScreenState extends State<ConfirmacionScreen> 
    with TickerProviderStateMixin {
  
  String estadoPedido = 'confirmado';
  String estadoPago = 'pendiente';
  late AnimationController _pulseController;
  late AnimationController _slideController;
  late Animation<double> _pulseAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimaciones();
    _simularProcesoPedido();
  }

  void _setupAnimaciones() {
    // Animación de pulso para el ícono
    _pulseController = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _pulseController.repeat(reverse: true);

    // Animación de deslizamiento para las tarjetas
    _slideController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));
    
    _slideController.forward();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  void _simularProcesoPedido() {
    // Simular confirmación de pago después de 3 segundos
    Future.delayed(Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          estadoPago = widget.metodoPago == 'efectivo' ? 'pendiente_entrega' : 'confirmado';
        });
      }
    });

    // Simular estados del pedido
    Future.delayed(Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          estadoPedido = 'preparando';
          _pulseController.stop();
        });
      }
    });

    Future.delayed(Duration(seconds: 15), () {
      if (mounted) {
        setState(() {
          estadoPedido = 'listo';
        });
      }
    });

    if (widget.tipoEntrega == 'delivery') {
      Future.delayed(Duration(seconds: 20), () {
        if (mounted) {
          setState(() {
            estadoPedido = 'en_camino';
          });
        }
      });
    }
  }

  String _obtenerEstadoTexto() {
    switch (estadoPedido) {
      case 'confirmado':
        return '¡Pedido Confirmado!';
      case 'preparando':
        return 'Preparando tu pedido...';
      case 'listo':
        return widget.tipoEntrega == 'delivery' ? 'Pedido listo para envío' : 'Pedido listo para recojo';
      case 'en_camino':
        return 'En camino a tu ubicación';
      case 'entregado':
        return 'Pedido entregado';
      default:
        return 'Estado desconocido';
    }
  }

  Color _obtenerColorEstado() {
    switch (estadoPedido) {
      case 'confirmado':
        return Colors.green;
      case 'preparando':
        return Colors.orange;
      case 'listo':
        return Colors.blue;
      case 'en_camino':
        return Colors.purple;
      case 'entregado':
        return Colors.green[800]!;
      default:
        return Colors.grey;
    }
  }

  IconData _obtenerIconoEstado() {
    switch (estadoPedido) {
      case 'confirmado':
        return Icons.check_circle;
      case 'preparando':
        return Icons.restaurant;
      case 'listo':
        return Icons.done_all;
      case 'en_camino':
        return Icons.delivery_dining;
      case 'entregado':
        return Icons.thumb_up;
      default:
        return Icons.help;
    }
  }

  String _obtenerTiempoEstimado() {
    switch (estadoPedido) {
      case 'confirmado':
      case 'preparando':
        return widget.tipoEntrega == 'delivery' ? '25-35 minutos' : '15-20 minutos';
      case 'listo':
        return widget.tipoEntrega == 'delivery' ? '5-10 minutos' : 'Ya está listo';
      case 'en_camino':
        return '5-10 minutos';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('Confirmación de Pedido', style: TextStyle(color: Colors.white)),
        backgroundColor: _obtenerColorEstado(),
        automaticallyImplyLeading: false,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: SlideTransition(
          position: _slideAnimation,
          child: Column(
            children: [
              // Estado del pedido con animación
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [_obtenerColorEstado(), _obtenerColorEstado().withOpacity(0.8)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: _obtenerColorEstado().withOpacity(0.3),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.all(30),
                  child: Column(
                    children: [
                      AnimatedBuilder(
                        animation: _pulseAnimation,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: estadoPedido == 'confirmado' ? _pulseAnimation.value : 1.0,
                            child: Container(
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                _obtenerIconoEstado(),
                                color: Colors.white,
                                size: 64,
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 20),
                      Text(
                        _obtenerEstadoTexto(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Pedido #${widget.numeroPedido}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      if (_obtenerTiempoEstimado().isNotEmpty) ...[
                        SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.access_time, color: Colors.white, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Tiempo estimado: ${_obtenerTiempoEstimado()}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              SizedBox(height: 20),

              // Información de pago mejorada
              if (widget.metodoPago != 'efectivo')
                _buildTarjetaPago(),

              if (widget.metodoPago == 'efectivo')
                _buildTarjetaEfectivo(),

              SizedBox(height: 15),

              // Detalles del pedido
              _buildTarjetaResumen(),

              SizedBox(height: 15),

              // Información de entrega
              _buildTarjetaEntrega(),

              SizedBox(height: 30),

              // Botones de acción
              _buildBotonesAccion(),

              SizedBox(height: 20),

              // Botón opcional de WhatsApp
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green.withOpacity(0.3)),
                ),
                child: Column(
                  children: [
                    Icon(Icons.chat, color: Colors.green, size: 30),
                    SizedBox(height: 10),
                    Text(
                      '¿Necesitas hacer algún cambio o tienes alguna pregunta?',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.green[800]),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton.icon(
                      onPressed: _enviarWhatsAppPedido,
                      icon: Icon(Icons.whatsapp),
                      label: Text('Contactar por WhatsApp (Opcional)'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                      ),
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

  Widget _buildTarjetaPago() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: widget.metodoPago == 'yape' ? Colors.purple : Colors.teal,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.payment, color: Colors.white),
                ),
                SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Información de Pago',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      Text(
                        'Toca el botón para abrir ${widget.metodoPago == 'yape' ? 'Yape' : 'Plin'}',
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: widget.metodoPago == 'yape' ? Colors.purple[50] : Colors.teal[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: widget.metodoPago == 'yape' ? Colors.purple : Colors.teal,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: widget.metodoPago == 'yape' ? Colors.purple : Colors.teal,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          widget.metodoPago == 'yape' ? 'Yape' : 'Plin',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(width: 15),
                      Text('Realizar pago a:', style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  SizedBox(height: 15),
                  _buildInfoPago('Número:', widget.metodoPago == 'yape' ? PagoService.numeroYape : PagoService.numeroPlin),
                  _buildInfoPago('Monto:', 'S/ ${widget.total.toStringAsFixed(2)}'),
                  _buildInfoPago('Concepto:', 'Pedido #${widget.numeroPedido}'),
                ],
              ),
            ),
            SizedBox(height: 15),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _abrirAppPago(),
                icon: Icon(Icons.open_in_new),
                label: Text('Abrir ${widget.metodoPago == 'yape' ? 'Yape' : 'Plin'}'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.metodoPago == 'yape' ? Colors.purple : Colors.teal,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTarjetaEfectivo() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.monetization_on, color: Colors.white),
                ),
                SizedBox(width: 15),
                Text(
                  'Pago en Efectivo',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ],
            ),
            SizedBox(height: 15),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: widget.vuelto != null && widget.vuelto! > 0 
                    ? Colors.blue[50] 
                    : Colors.green[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: widget.vuelto != null && widget.vuelto! > 0 
                      ? Colors.blue 
                      : Colors.green,
                ),
              ),
              child: Column(
                children: [
                  _buildInfoPago('Total a pagar:', 'S/ ${widget.total.toStringAsFixed(2)}'),
                  if (widget.pagoConCuanto != null) 
                    _buildInfoPago('Paga con:', 'S/ ${widget.pagoConCuanto!.toStringAsFixed(2)}'),
                  
                  SizedBox(height: 10),
                  
                  if (widget.vuelto != null && widget.vuelto! > 0) ...[
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.monetization_on, color: Colors.blue[800]),
                          SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Su vuelto será:',
                                  style: TextStyle(fontSize: 14),
                                ),
                                Text(
                                  'S/ ${widget.vuelto!.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue[800],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ] else if (widget.vuelto != null) ...[
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.green[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.check_circle, color: Colors.green[800]),
                          SizedBox(width: 10),
                          Text(
                            'Pago exacto ✅',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.green[800],
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
        ),
      ),
    );
  }

  Widget _buildInfoPago(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontWeight: FontWeight.w500)),
          SelectableText(
            value,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildTarjetaResumen() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.receipt_long, color: Colors.blue),
                SizedBox(width: 10),
                Text('Resumen del Pedido', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
            SizedBox(height: 15),
            ...widget.carrito.map((item) => Padding(
              padding: EdgeInsets.symmetric(vertical: 3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      '${item.cantidad}x ${item.nombre} (${item.tamano})',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                  Text(
                    'S/ ${(item.precio * item.cantidad).toStringAsFixed(2)}',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            )).toList(),
            Divider(thickness: 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text(
                  'S/ ${widget.total.toStringAsFixed(2)}',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.red),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTarjetaEntrega() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  widget.tipoEntrega == 'delivery' ? Icons.delivery_dining : Icons.store,
                  color: Colors.orange,
                ),
                SizedBox(width: 10),
                Text('Información de Entrega', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
            SizedBox(height: 15),
            _buildInfoEntrega(Icons.person, widget.nombre),
            _buildInfoEntrega(Icons.phone, widget.telefono),
            _buildInfoEntrega(
              widget.tipoEntrega == 'delivery' ? Icons.delivery_dining : Icons.store,
              widget.tipoEntrega == 'delivery' ? 'Delivery a domicilio' : 'Recojo en tienda',
            ),
            if (widget.tipoEntrega == 'delivery' && widget.ubicacion != null) ...[
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.red, size: 20),
                        SizedBox(width: 8),
                        Text('Ubicación de entrega:', style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Lat: ${widget.ubicacion!.latitude.toStringAsFixed(6)}',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    Text(
                      'Lng: ${widget.ubicacion!.longitude.toStringAsFixed(6)}',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: () => PagoService.abrirEnMaps(
                        widget.ubicacion!.latitude,
                        widget.ubicacion!.longitude,
                      ),
                      icon: Icon(Icons.map),
                      label: Text('Ver en Google Maps'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoEntrega(IconData icon, String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey[600], size: 20),
          SizedBox(width: 12),
          Expanded(child: Text(text, style: TextStyle(fontSize: 15))),
        ],
      ),
    );
  }

  Widget _buildBotonesAccion() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => PagoService.realizarLlamada(PagoService.numeroWhatsApp),
            icon: Icon(Icons.phone),
            label: Text('Llamar a la pizzería'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ),
        SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () => Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => HomeScreen()),
              (route) => false,
            ),
            icon: Icon(Icons.restaurant_menu),
            label: Text('Volver al menú'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.red,
              padding: EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ),
      ],
    );
  }

  void _abrirAppPago() async {
    bool exito = false;
    
    if (widget.metodoPago == 'yape') {
      exito = await PagoService.abrirYape(widget.total, widget.numeroPedido);
    } else if (widget.metodoPago == 'plin') {
      exito = await PagoService.abrirPlin(widget.total, widget.numeroPedido);
    }
    
    if (!exito) {
      DialogUtils.mostrarInstruccionesPago(
        context,
        widget.metodoPago == 'yape' ? 'Yape' : 'Plin',
        widget.metodoPago == 'yape' ? PagoService.numeroYape : PagoService.numeroPlin,
        widget.total,
        widget.numeroPedido,
      );
    }
  }

  void _enviarWhatsAppPedido() {
    String mensaje = '''
🍕 *PEDIDO REALIZADO* 🍕

*Pedido #:* ${widget.numeroPedido}
*Cliente:* ${widget.nombre}
*Teléfono:* ${widget.telefono}

*PRODUCTOS:*
${widget.carrito.map((item) => '• ${item.cantidad}x ${item.nombre} (${item.tamano}) - S/ ${(item.precio * item.cantidad).toStringAsFixed(2)}').join('\n')}

*Total:* S/ ${widget.total.toStringAsFixed(2)}

*Entrega:* ${widget.tipoEntrega == 'delivery' ? 'Delivery' : 'Recojo en tienda'}
${widget.tipoEntrega == 'delivery' && widget.ubicacion != null ? '*Coordenadas:* ${widget.ubicacion!.latitude}, ${widget.ubicacion!.longitude}' : ''}

*Método de pago:* ${_obtenerNombreMetodoPago()}
${widget.metodoPago == 'efectivo' && widget.vuelto != null ? (widget.vuelto! > 0 ? '*Vuelto:* S/ ${widget.vuelto!.toStringAsFixed(2)}' : '*Pago exacto*') : ''}

${widget.metodoPago == 'efectivo' && widget.pagoConCuanto != null ? '*Paga con:* S/ ${widget.pagoConCuanto!.toStringAsFixed(2)}' : ''}

¡Gracias por su pedido! 😊
    ''';

    PagoService.enviarWhatsApp(PagoService.numeroWhatsApp, mensaje);
  }

  String _obtenerNombreMetodoPago() {
    switch (widget.metodoPago) {
      case 'efectivo':
        return 'Efectivo';
      case 'yape':
        return 'Yape - ${PagoService.numeroYape}';
      case 'plin':
        return 'Plin - ${PagoService.numeroPlin}';
      default:
        return widget.metodoPago;
    }
  }
}