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

  // 🔥 AQUÍ ESTÁ LA SOLUCIÓN AL totalFinal
  double get totalFinal => widget.tipoEntrega == 'delivery' ? widget.total + 2.00 : widget.total;

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
        return widget.tipoEntrega == 'delivery' ? '30-45 minutos' : '25-35 minutos';
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
              _buildTarjetaEstado(),
              const SizedBox(height: 16),

              // 🔥 ADVERTENCIA DE NO PAGAR AÚN (para pagos digitales)
              if (widget.metodoPago != 'efectivo')
                _buildAdvertenciaNoPagar(),

              // Información de pago
              if (widget.metodoPago != 'efectivo') ...[
                const SizedBox(height: 12),
                _buildTarjetaPagoDigital(),
              ],
              if (widget.metodoPago == 'efectivo') ...[
                const SizedBox(height: 12),
                _buildTarjetaEfectivo(),
              ],

              const SizedBox(height: 12),
              _buildTarjetaResumenCompacto(),
              const SizedBox(height: 12),
              _buildTarjetaEntrega(),
              const SizedBox(height: 24),
              _buildBotonesAccion(),
              const SizedBox(height: 16),
              _buildTarjetaConsulta(),
            ],
          ),
        ),
      ),
    );
  }

  // 🔥 NUEVA ADVERTENCIA
  Widget _buildAdvertenciaNoPagar() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.red[100]!, Colors.orange[100]!],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red[300]!, width: 2),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(Icons.warning, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '⚠️ NO PAGUES AÚN',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.red[800],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Espera a que confirmemos tu pedido antes de realizar el pago',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.red[700],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTarjetaEstado() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [_obtenerColorEstado(), _obtenerColorEstado().withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: _obtenerColorEstado().withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: estadoPedido == 'confirmado' ? _pulseAnimation.value : 1.0,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _obtenerIconoEstado(),
                      color: Colors.white,
                      size: 48,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            Text(
              _obtenerEstadoTexto(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                'Pedido #${widget.numeroPedido}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (_obtenerTiempoEstimado().isNotEmpty) ...[
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.access_time, color: Colors.white, size: 18),
                  const SizedBox(width: 6),
                  Text(
                    'Tiempo estimado: ${_obtenerTiempoEstimado()}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTarjetaPagoDigital() {
    final metodoPago = widget.metodoPago.toLowerCase();
    final colorPrincipal = metodoPago == 'yape' ? Colors.purple : Colors.teal;
    final nombreMetodo = metodoPago == 'yape' ? 'Yape' : 'Plin';
    final numeroTelefono = metodoPago == 'yape' ? PagoService.numeroYape : PagoService.numeroPlin;
    final nombreTitular = metodoPago == 'yape' 
        ? 'Carlos Alberto Huaytalla Quispe' 
        : 'Fabian Hector Huaytalla Guevara';

    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [Colors.white, colorPrincipal.withOpacity(0.05)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Header compacto
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [colorPrincipal, colorPrincipal.withOpacity(0.8)],
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.payment, color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Información de Pago',
                          style: TextStyle(
                            fontWeight: FontWeight.bold, 
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          'Datos para $nombreMetodo',
                          style: TextStyle(
                            color: Colors.grey[600], 
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Información compacta
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [colorPrincipal, colorPrincipal.withOpacity(0.8)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    // Logo y método
                    Row(
                      children: [
                        _buildLogoMetodoPago(metodoPago),
                        const SizedBox(width: 12),
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
                    const SizedBox(height: 12),
                    
                    // Datos compactos
                    _buildInfoPagoDigitalCompacto('📱', numeroTelefono),
                    const SizedBox(height: 8),
                    _buildInfoPagoDigitalCompacto('👤', nombreTitular),
                    const SizedBox(height: 8),
                    _buildInfoPagoDigitalCompacto(
                      '💰', 
                      widget.tipoEntrega == 'delivery' 
                          ? 'S/${totalFinal.toStringAsFixed(2)} (incluye delivery)'
                          : 'S/${totalFinal.toStringAsFixed(2)}'
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Botón copiar compacto
              ElevatedButton.icon(
                onPressed: _copiarNumero,
                icon: const Icon(Icons.copy, color: Colors.white, size: 16),
                label: const Text(
                  'Copiar Número',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorPrincipal,
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogoMetodoPago(String metodo) {
    final assetPath = metodo == 'yape' 
        ? 'assets/images/logos/yape_logo.png'
        : 'assets/images/logos/plin_logo.png';

    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Image.asset(
          assetPath,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return Icon(
              metodo == 'yape' ? Icons.account_balance_wallet : Icons.credit_card,
              size: 20,
              color: metodo == 'yape' ? Colors.purple : Colors.teal,
            );
          },
        ),
      ),
    );
  }

  Widget _buildInfoPagoDigitalCompacto(String icono, String value) {
    return Row(
      children: [
        Text(icono, style: const TextStyle(fontSize: 16)),
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

  Widget _buildTarjetaEfectivo() {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.payments, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pago en Efectivo',
                        style: TextStyle(
                          fontWeight: FontWeight.bold, 
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        'Pago al momento de la entrega',
                        style: TextStyle(
                          color: Colors.grey, 
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: widget.vuelto != null && widget.vuelto! > 0 
                      ? [Colors.blue[50]!, Colors.blue[100]!]
                      : [Colors.green[50]!, Colors.green[100]!],
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: widget.vuelto != null && widget.vuelto! > 0 
                      ? Colors.blue[200]! 
                      : Colors.green[200]!,
                ),
              ),
              child: Column(
                children: [
                  _buildInfoPago('Total:', 'S/${totalFinal.toStringAsFixed(2)}'),
                  if (widget.pagoConCuanto != null) ...[
                    const SizedBox(height: 8),
                    _buildInfoPago('Paga con:', 'S/${widget.pagoConCuanto!.toStringAsFixed(2)}'),
                  ],
                  if (widget.vuelto != null && widget.vuelto! > 0) ...[
                    const SizedBox(height: 8),
                    _buildInfoPago('Vuelto:', 'S/${widget.vuelto!.toStringAsFixed(2)}'),
                  ] else if (widget.pagoConCuanto != null) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.green[100]!, Colors.green[200]!],
                        ),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.green[300]!),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Icon(Icons.check_circle, color: Colors.white, size: 16),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Pago exacto ✅',
                              style: TextStyle(
                                fontSize: 14,
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
    );
  }

  Widget _buildInfoPago(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label, 
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            )
          ),
          SelectableText(
            value,
            style: const TextStyle(
              fontSize: 14, 
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTarjetaResumenCompacto() {
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
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(Icons.receipt_long, color: Colors.white, size: 16),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Resumen del Pedido', 
                  style: TextStyle(
                    fontWeight: FontWeight.bold, 
                    fontSize: 16,
                    color: Colors.black87,
                  )
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            // Lista compacta de productos
            ...widget.carrito.map((item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
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
                        fontSize: 10,
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
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (item.adicionales.isNotEmpty) ...[
                          const SizedBox(height: 1),
                          Text(
                            '+ ${item.adicionales.map((a) => '${a.icono} ${a.nombre}').join(', ')}',
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
                    'S/${(item.precioTotal * item.cantidad).toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            )),
            
            if (widget.tipoEntrega == 'delivery') ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.delivery_dining, color: Colors.orange, size: 14),
                  const SizedBox(width: 6),
                  const Expanded(
                    child: Text(
                      'Delivery',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Text(
                    'S/2.00',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
            
            const SizedBox(height: 8),
            Container(height: 1, color: Colors.grey[300]),
            const SizedBox(height: 8),
            
            // Total - USANDO totalFinal
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'TOTAL:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold, 
                    fontSize: 14,
                    color: Colors.black87,
                  )
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
                      fontSize: 14, 
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

  Widget _buildTarjetaEntrega() {
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
                  child: Icon(
                    widget.tipoEntrega == 'delivery' ? Icons.delivery_dining : Icons.store,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Información de Entrega', 
                  style: TextStyle(
                    fontWeight: FontWeight.bold, 
                    fontSize: 16,
                    color: Colors.black87,
                  )
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            _buildInfoEntrega(Icons.person, widget.nombre),
            const SizedBox(height: 6),
            _buildInfoEntrega(Icons.phone, widget.telefono),
            const SizedBox(height: 6),
            _buildInfoEntrega(
              widget.tipoEntrega == 'delivery' ? Icons.delivery_dining : Icons.store,
              widget.tipoEntrega == 'delivery' ? 'Delivery a domicilio' : 'Recojo en tienda',
            ),
            
            if (widget.tipoEntrega == 'delivery' && widget.ubicacion != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.red, size: 16),
                        SizedBox(width: 6),
                        Text(
                          'Ubicación de entrega:', 
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                            fontSize: 12,
                          )
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Lat: ${widget.ubicacion!.latitude.toStringAsFixed(6)}',
                      style: const TextStyle(fontSize: 10, color: Colors.blue),
                    ),
                    Text(
                      'Lng: ${widget.ubicacion!.longitude.toStringAsFixed(6)}',
                      style: const TextStyle(fontSize: 10, color: Colors.blue),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => PagoService.abrirEnMaps(
                          widget.ubicacion!.latitude,
                          widget.ubicacion!.longitude,
                        ),
                        icon: const Icon(Icons.map, color: Colors.white, size: 14),
                        label: const Text(
                          'Ver en Google Maps',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ] else if (widget.tipoEntrega == 'recojo') ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.store, color: Colors.green, size: 16),
                        SizedBox(width: 6),
                        Text(
                          'Nuestra ubicación:', 
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                            fontSize: 12,
                          )
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Lurigancho-Chosica, Anexo 8',
                      style: TextStyle(fontSize: 11, color: Colors.green),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => PagoService.abrirEnMaps(-11.979865, -76.941701),
                        icon: const Icon(Icons.map, color: Colors.white, size: 14),
                        label: const Text(
                          'Ver nuestra ubicación',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
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
    );
  }

  Widget _buildInfoEntrega(IconData icon, String text) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.orange,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Icon(icon, color: Colors.white, size: 12),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text, 
            style: const TextStyle(
              fontSize: 13,
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
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.green.withOpacity(0.3),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ElevatedButton.icon(
            onPressed: () => PagoService.realizarLlamada(PagoService.numeroWhatsApp),
            icon: const Icon(Icons.phone, color: Colors.white, size: 18),
            label: const Text(
              'Llamar a la pizzería',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () => Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const HomeScreen()),
              (route) => false,
            ),
            icon: const Icon(Icons.restaurant_menu, color: Colors.red, size: 18),
            label: const Text(
              'Volver al menú',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              side: const BorderSide(color: Colors.red, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTarjetaConsulta() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.green.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          const Icon(Icons.chat, color: Colors.green, size: 24),
          const SizedBox(height: 8),
          Text(
            '¿Tienes alguna consulta o necesitas hacer algún cambio?',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: Colors.green[800]),
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: _contactarPorWhatsApp, 
            icon: const FaIcon(FontAwesomeIcons.whatsapp, size: 16),
            label: const Text(
              'Contactar por WhatsApp',
              style: TextStyle(fontSize: 12),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _copiarNumero() async {
    final numero = widget.metodoPago.toLowerCase() == 'yape' 
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

  void _contactarPorWhatsApp() {
    final mensaje = '''Hola 👋

Tengo una consulta sobre mi pedido #${widget.numeroPedido}.

¿Podrían ayudarme por favor?

Gracias 😊''';

    PagoService.enviarWhatsApp(PagoService.numeroWhatsApp, mensaje);
  }
}