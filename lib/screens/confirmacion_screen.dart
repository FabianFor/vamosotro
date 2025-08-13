import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import '../models/models.dart';
import '../services/services.dart';
import 'home_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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

  const ConfirmacionScreen({
    super.key,
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
  State<ConfirmacionScreen> createState() => _ConfirmacionScreenState();
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
    _pulseController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _pulseController.repeat(reverse: true);
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
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
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          estadoPago = widget.metodoPago == 'efectivo' ? 'pendiente_entrega' : 'confirmado';
        });
      }
    });

    // Simular estados del pedido
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          estadoPedido = 'preparando';
          _pulseController.stop();
        });
      }
    });

    Future.delayed(const Duration(seconds: 15), () {
      if (mounted) {
        setState(() {
          estadoPedido = 'listo';
        });
      }
    });

    if (widget.tipoEntrega == 'delivery') {
      Future.delayed(const Duration(seconds: 20), () {
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
      case 'listo':
      case 'en_camino':
        return '25-35 minutos';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Confirmación de Pedido', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: _obtenerColorEstado(),
        automaticallyImplyLeading: false,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
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
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    children: [
                      AnimatedBuilder(
                        animation: _pulseAnimation,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: estadoPedido == 'confirmado' ? _pulseAnimation.value : 1.0,
                            child: Container(
                              padding: const EdgeInsets.all(20),
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
                      const SizedBox(height: 20),
                      Text(
                        _obtenerEstadoTexto(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Pedido #${widget.numeroPedido}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      if (_obtenerTiempoEstimado().isNotEmpty) ...[
                        const SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.access_time, color: Colors.white, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              'Tiempo estimado: ${_obtenerTiempoEstimado()}',
                              style: const TextStyle(
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

              const SizedBox(height: 20),

              if (widget.tipoEntrega == 'delivery') ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.orange[600]!, Colors.red[600]!],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.orange.withOpacity(0.4),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.warning,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                          const SizedBox(width: 15),
                          const Expanded(
                            child: Text(
                              '¡IMPORTANTE!',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.block, color: Colors.white, size: 24),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    'NO REALICES EL PAGO TODAVÍA',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'Espera a que nuestro personal confirme si podemos llegar a tu dirección. Te contactaremos para confirmar antes del pago.',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                height: 1.4,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.access_time, color: Colors.white, size: 20),
                                const SizedBox(width: 8),
                                Text(
                                  'Tiempo de respuesta: 2-5 minutos',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.9),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
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
                const SizedBox(height: 20),
              ],

              // 🔥 INFORMACIÓN DE PAGO MEJORADA
              if (widget.metodoPago != 'efectivo')
                _buildTarjetaPagoMejorada(),
              if (widget.metodoPago == 'efectivo')
                _buildTarjetaEfectivo(),
              const SizedBox(height: 15),
              
              _buildTarjetaResumen(),

              const SizedBox(height: 15),

              _buildTarjetaEntrega(),

              const SizedBox(height: 30),

              _buildBotonesAccion(),

              const SizedBox(height: 20),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green.withOpacity(0.3)),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.chat, color: Colors.green, size: 30),
                    const SizedBox(height: 10),
                    Text(
                      '¿Tienes alguna consulta adicional o quieres hacer algún cambio?',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.green[800]),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton.icon(
                      onPressed: _contactarPorWhatsApp, 
                      icon: const FaIcon(FontAwesomeIcons.whatsapp),
                      label: const Text('Contactar por WhatsApp (Opcional)'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
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

  // 🔥 TARJETA DE PAGO COMPLETAMENTE REDISEÑADA - MÁS BONITA Y ORGANIZADA
  Widget _buildTarjetaPagoMejorada() {
    Color colorPrincipal = widget.metodoPago == 'yape' ? Colors.purple : Colors.teal;
    String nombreMetodo = widget.metodoPago == 'yape' ? 'Yape' : 'Plin';
    String numeroTelefono = widget.metodoPago == 'yape' ? PagoService.numeroYape : PagoService.numeroPlin;
    String nombreTitular = widget.metodoPago == 'yape' 
        ? 'Carlos Alberto Huaytalla Quispe' 
        : 'Fabian Hector Huaytalla Guevara';

    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [Colors.white, colorPrincipal.withOpacity(0.05)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // Header de la tarjeta
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [colorPrincipal, colorPrincipal.withOpacity(0.8)],
                      ),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: colorPrincipal.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.payment, color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Información de Pago',
                          style: TextStyle(
                            fontWeight: FontWeight.bold, 
                            fontSize: 20,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          'Realiza el pago con $nombreMetodo',
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

              const SizedBox(height: 24),

              // Tarjeta del método de pago
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [colorPrincipal, colorPrincipal.withOpacity(0.8)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: colorPrincipal.withOpacity(0.4),
                      blurRadius: 10,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Logo y nombre del método
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Logo real de Yape/Plin
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Image.asset(
                                    widget.metodoPago == 'yape' 
                                        ? 'assets/images/logos/yape_logo.png'
                                        : 'assets/images/logos/plin_logo.png',
                                    fit: BoxFit.contain,
                                    errorBuilder: (context, error, stackTrace) {
                                      // Fallback si no encuentra la imagen
                                      return Container(
                                        decoration: BoxDecoration(
                                          color: widget.metodoPago == 'yape' ? Colors.purple[700] : Colors.teal[700],
                                          shape: BoxShape.circle,
                                        ),
                                        child: Center(
                                          child: Text(
                                            widget.metodoPago == 'yape' ? 'Y' : 'P',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                nombreMetodo,
                                style: TextStyle(
                                  color: colorPrincipal,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            widget.metodoPago == 'yape' ? Icons.account_balance_wallet : Icons.credit_card,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Información del pago
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white.withOpacity(0.2)),
                      ),
                      child: Column(
                        children: [
                          _buildInfoPagoMejorada('Número:', numeroTelefono, Icons.smartphone),
                          const SizedBox(height: 12),
                          _buildInfoPagoMejorada('Titular:', nombreTitular, Icons.account_circle),
                          const SizedBox(height: 12),
                          _buildInfoPagoMejorada('Monto:', 'S/ ${widget.total.toStringAsFixed(2)}', widget.metodoPago == 'yape' ? Icons.account_balance_wallet : Icons.payment),
                          const SizedBox(height: 12),
                          _buildInfoPagoMejorada('Concepto:', 'Pedido #${widget.numeroPedido}', Icons.shopping_cart),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Botón de copiar número
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: colorPrincipal.withOpacity(0.3),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ElevatedButton.icon(
                  onPressed: () => _copiarNumero(),
                  icon: const Icon(Icons.copy, color: Colors.white),
                  label: const Text(
                    'Copiar Número de Teléfono',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorPrincipal,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoPagoMejorada(String label, String value, IconData icono) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icono, color: Colors.white, size: 16),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              SelectableText(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTarjetaEfectivo() {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [Colors.white, Colors.green.withOpacity(0.05)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.green, Colors.green.withOpacity(0.8)],
                      ),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.monetization_on, color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pago en Efectivo',
                          style: TextStyle(
                            fontWeight: FontWeight.bold, 
                            fontSize: 20,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          'Pago al momento de la entrega',
                          style: TextStyle(
                            color: Colors.grey, 
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 20),
              
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: widget.vuelto != null && widget.vuelto! > 0 
                        ? [Colors.blue[50]!, Colors.blue[100]!]
                        : [Colors.green[50]!, Colors.green[100]!],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: widget.vuelto != null && widget.vuelto! > 0 
                        ? Colors.blue[200]! 
                        : Colors.green[200]!,
                  ),
                ),
                child: Column(
                  children: [
                    _buildInfoPago('Total a pagar:', 'S/ ${widget.total.toStringAsFixed(2)}'),
                    if (widget.pagoConCuanto != null) ...[
                      const SizedBox(height: 8),
                      _buildInfoPago('Paga con:', 'S/ ${widget.pagoConCuanto!.toStringAsFixed(2)}'),
                    ],
                    
                    const SizedBox(height: 16),
                    
                    if (widget.vuelto != null && widget.vuelto! > 0) ...[
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.blue[100]!, Colors.blue[200]!],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.blue[300]!),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(Icons.monetization_on, color: Colors.white, size: 20),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Su vuelto será:',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    'S/ ${widget.vuelto!.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      fontSize: 22,
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
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.green[100]!, Colors.green[200]!],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.green[300]!),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(Icons.check_circle, color: Colors.white, size: 20),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Pago exacto ✅',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green[800],
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
          ),
        ),
      ),
    );
  }

  Widget _buildInfoPago(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label, 
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
            )
          ),
          SelectableText(
            value,
            style: const TextStyle(
              fontSize: 16, 
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTarjetaResumen() {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [Colors.white, Colors.blue.withOpacity(0.05)],
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
                    style: TextStyle(
                      fontWeight: FontWeight.bold, 
                      fontSize: 18,
                      color: Colors.black87,
                    )
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue[100]!),
                ),
                child: Column(
                  children: [
                    ...widget.carrito.map((item) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(8),
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
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${item.nombre} (${item.tamano})',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
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
                                'S/ ${(item.precio * item.cantidad).toStringAsFixed(2)}',
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
                    const SizedBox(height: 12),
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
                            fontSize: 16,
                            color: Colors.black87,
                          )
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'S/ ${widget.total.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold, 
                              fontSize: 16, 
                              color: Colors.white,
                            ),
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

  Widget _buildTarjetaEntrega() {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [Colors.white, Colors.orange.withOpacity(0.05)],
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
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      widget.tipoEntrega == 'delivery' ? Icons.delivery_dining : Icons.store,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Información de Entrega', 
                    style: TextStyle(
                      fontWeight: FontWeight.bold, 
                      fontSize: 18,
                      color: Colors.black87,
                    )
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.orange[100]!),
                ),
                child: Column(
                  children: [
                    _buildInfoEntrega(Icons.person, widget.nombre),
                    const SizedBox(height: 8),
                    _buildInfoEntrega(Icons.phone, widget.telefono),
                    const SizedBox(height: 8),
                    _buildInfoEntrega(
                      widget.tipoEntrega == 'delivery' ? Icons.delivery_dining : Icons.store,
                      widget.tipoEntrega == 'delivery' ? 'Delivery a domicilio' : 'Recojo en tienda',
                    ),
                    if (widget.tipoEntrega == 'delivery' && widget.ubicacion != null) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.blue[50]!, Colors.blue[100]!],
                          ),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.blue[200]!),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.location_on, color: Colors.red, size: 20),
                                SizedBox(width: 8),
                                Text(
                                  'Ubicación de entrega:', 
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  )
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Lat: ${widget.ubicacion!.latitude.toStringAsFixed(6)}',
                              style: const TextStyle(fontSize: 12, color: Colors.blue),
                            ),
                            Text(
                              'Lng: ${widget.ubicacion!.longitude.toStringAsFixed(6)}',
                              style: const TextStyle(fontSize: 12, color: Colors.blue),
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: () => PagoService.abrirEnMaps(
                                  widget.ubicacion!.latitude,
                                  widget.ubicacion!.longitude,
                                ),
                                icon: const Icon(Icons.map, color: Colors.white),
                                label: const Text(
                                  'Ver en Google Maps',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
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
      ),
    );
  }

Widget _buildInfoEntrega(IconData icon, String text) {
  return Row(
    children: [
      Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.orange,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Colors.white, size: 16),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: Text(
          text, 
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          )
        )
      ),
    ],
  );
}

Widget _buildBotonesAccion() {
  return Column(
    children: [
      Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.green.withOpacity(0.3),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ElevatedButton.icon(
          onPressed: () => PagoService.realizarLlamada(PagoService.numeroWhatsApp),
          icon: const Icon(Icons.phone, color: Colors.white),
          label: const Text(
            'Llamar a la pizzería',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      const SizedBox(height: 12),
      SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed: () => Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const HomeScreen()),
            (route) => false,
          ),
          icon: const Icon(Icons.restaurant_menu, color: Colors.red),
          label: const Text(
            'Volver al menú',
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            side: const BorderSide(color: Colors.red, width: 2),
          ),
        ),
      ),
    ],
  );
}

// 🔥 MÉTODO MEJORADO PARA COPIAR NÚMERO
Future<void> _copiarNumero() async {
  String numero = widget.metodoPago == 'yape' ? PagoService.numeroYape : PagoService.numeroPlin;
  
  await Clipboard.setData(ClipboardData(text: numero));

  if (mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
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
          borderRadius: BorderRadius.circular(10),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

// 🔥 MÉTODO MEJORADO PARA CONTACTO POR WHATSAPP
void _contactarPorWhatsApp() {
  String mensaje = '''Hola 👋

Tengo una consulta sobre mi pedido #${widget.numeroPedido}.

¿Podrían ayudarme por favor?

Gracias 😊''';

  PagoService.enviarWhatsApp(PagoService.numeroWhatsApp, mensaje);
}
}