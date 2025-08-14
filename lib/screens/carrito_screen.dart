import 'package:flutter/material.dart';
import '../models/models.dart';
import '../data/pizza_data.dart';
import 'pago_screen.dart';

class CarritoScreen extends StatefulWidget {
  final List<ItemPedido> carrito;
  final Function(List<ItemPedido>) onActualizar;

  const CarritoScreen({super.key, required this.carrito, required this.onActualizar});

  @override
  State<CarritoScreen> createState() => _CarritoScreenState();
}

class _CarritoScreenState extends State<CarritoScreen> {
  List<ItemPedido> carritoLocal = [];
  List<int> itemsExpandidos = [];
  
  // 🔥 CACHE PARA ADICIONALES Y COLORES - CORREGIDO
  late Map<String, List<Adicional>> _adicionalesCache;
  late Map<String, Color> _coloresCache;
  
  // 🔥 CACHE PARA TOTAL
  double _totalCacheado = 0.0;

  // 🎨 COLORES ACTUALIZADOS
  static const Color colorPrimario = Color(0xFFD4332A);
  static const Color colorSecundario = Color(0xFF2C5F2D);
  static const Color colorAcento = Color(0xFFF4B942);

  @override
  void initState() {
    super.initState();
    carritoLocal = List.from(widget.carrito);
    _inicializarCaches();
    _calcularTotal();
  }

  // 🔥 MÉTODO CORREGIDO PARA INICIALIZAR CACHES EN CARRITO
  void _inicializarCaches() {
    _adicionalesCache = {};
    
    // Inicializar cache para cada item del carrito
    for (var item in carritoLocal) {
      String key = '${item.nombre}_${item.tamano}';
      _adicionalesCache[key] = PizzaData.getAdicionalesParaItem(item.nombre, item.tamano);
    }
    
    // Cache de colores
    _coloresCache = {
      'Personal': colorSecundario,
      'Familiar': colorPrimario,
      'Extra Grande': const Color.fromARGB(255, 225, 0, 255), // Color café
      'Mostrito': Colors.orange,
      'Broaster': Colors.brown,
      '2 Sabores': Colors.purple,
      '4 Sabores': Colors.purple,
      'Combo Broaster': Colors.brown,
      'Fusión': Colors.deepPurple,
      'Combo': Colors.indigo,
      'Estrella': Colors.deepPurple,
      'Oferta Dúo': Colors.indigo,
    };
  }

  // 🔥 CALCULAR TOTAL SOLO CUANDO SEA NECESARIO
  void _calcularTotal() {
    _totalCacheado = carritoLocal.fold(0.0, (sum, item) => sum + (item.precioTotal * item.cantidad));
  }

  void _procederAlPago(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PagoScreen(
          carrito: carritoLocal,
          total: _totalCacheado,
        ),
      ),
    );
  }

  // 🔥 NUEVO MÉTODO PARA MANEJAR ADICIONALES CON CANTIDAD
  void _mostrarDialogAdicional(int itemIndex, Adicional adicional) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return _DialogAdicional(
          adicional: adicional,
          itemPedido: carritoLocal[itemIndex],
          onAgregar: (int cantidad, String? pizzaEspecifica) {
            _agregarAdicionalConCantidad(itemIndex, adicional, cantidad, pizzaEspecifica);
          },
        );
      },
    );
  }

  // 🔥 MÉTODO PARA AGREGAR ADICIONAL CON CANTIDAD Y PIZZA ESPECÍFICA
  void _agregarAdicionalConCantidad(int itemIndex, Adicional adicional, int cantidad, String? pizzaEspecifica) {
    setState(() {
      ItemPedido item = carritoLocal[itemIndex];
      List<Adicional> nuevosAdicionales = List.from(item.adicionales);

      // 🔥 CREAR NUEVO ADICIONAL CON CANTIDAD Y PIZZA ESPECÍFICA
      Adicional nuevoAdicional = Adicional(
        nombre: pizzaEspecifica != null 
            ? '${adicional.nombre} (${pizzaEspecifica})' 
            : adicional.nombre,
        precio: adicional.precio,
        icono: adicional.icono,
        imagen: adicional.imagen,
        cantidad: cantidad,
        pizzaEspecifica: pizzaEspecifica,
      );

      // 🔥 VERIFICAR SI YA EXISTE EL MISMO ADICIONAL
      int indiceExistente = nuevosAdicionales.indexWhere((a) => 
          a.nombre == nuevoAdicional.nombre && 
          a.pizzaEspecifica == pizzaEspecifica);

      if (indiceExistente != -1) {
        // Si existe, actualizar cantidad
        Adicional existente = nuevosAdicionales[indiceExistente];
        nuevosAdicionales[indiceExistente] = existente.copyWith(
          cantidad: existente.cantidad + cantidad
        );
      } else {
        // Si no existe, agregarlo
        nuevosAdicionales.add(nuevoAdicional);
      }

      carritoLocal[itemIndex] = item.copyWith(adicionales: nuevosAdicionales);
      _calcularTotal();
      widget.onActualizar(carritoLocal);
    });
  }

  // 🔥 MÉTODO PARA QUITAR ADICIONAL
  void _quitarAdicional(int itemIndex, int adicionalIndex) {
    setState(() {
      ItemPedido item = carritoLocal[itemIndex];
      List<Adicional> nuevosAdicionales = List.from(item.adicionales);
      
      Adicional adicional = nuevosAdicionales[adicionalIndex];
      if (adicional.cantidad > 1) {
        // Si tiene más de 1, reducir cantidad
        nuevosAdicionales[adicionalIndex] = adicional.copyWith(
          cantidad: adicional.cantidad - 1
        );
      } else {
        // Si tiene 1, eliminar completamente
        nuevosAdicionales.removeAt(adicionalIndex);
      }

      carritoLocal[itemIndex] = item.copyWith(adicionales: nuevosAdicionales);
      _calcularTotal();
      widget.onActualizar(carritoLocal);
    });
  }

  // 🔥 MÉTODO CORREGIDO PARA OBTENER ADICIONALES CON FILTROS ESPECIALES
  List<Adicional> _getAdicionalesDisponibles(String tamano, String nombre) {
    String key = '${nombre}_${tamano}';
    
    // Si no está en cache, crearlo
    if (!_adicionalesCache.containsKey(key)) {
      _adicionalesCache[key] = PizzaData.getAdicionalesParaItem(nombre, tamano);
    }
    
    return _adicionalesCache[key] ?? [];
  }

  // 🎨 USAR CACHE PARA COLORES
  Color _getTamanoColor(String tamano) {
    return _coloresCache[tamano] ?? colorAcento;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Mi Carrito', style: TextStyle(color: Colors.white)),
        backgroundColor: colorPrimario,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                colorPrimario,
                colorPrimario.withOpacity(0.8),
              ],
            ),
          ),
        ),
      ),
      body: carritoLocal.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart_outlined, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('Tu carrito está vacío', style: TextStyle(fontSize: 18, color: Colors.grey)),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: carritoLocal.length,
                    cacheExtent: 300,
                    itemBuilder: (context, index) => _buildCarritoItem(index),
                  ),
                ),
                _buildFooterCarrito(),
              ],
            ),
    );
  }

  // 🔥 ITEM DEL CARRITO COMO WIDGET SEPARADO PARA MEJOR PERFORMANCE
  Widget _buildCarritoItem(int index) {
    final item = carritoLocal[index];
    final isExpanded = itemsExpandidos.contains(index);
    final esPersonalizable = item.tamano != 'Combo Broaster';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: colorSecundario.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // 🔥 INFORMACIÓN PRINCIPAL DEL ITEM
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _buildImagenItem(item),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildInfoItem(item),
                ),
                _buildControlesItem(item, index),
              ],
            ),
          ),

          // 🔥 ADICIONALES ACTUALES (SIEMPRE VISIBLE SI HAY ADICIONALES)
          if (item.adicionales.isNotEmpty)
            _buildAdicionalesActuales(item, index),

          // 🔥 SECCIÓN EXPANDIBLE DE ADICIONALES DISPONIBLES
          if (isExpanded && esPersonalizable) 
            _buildSeccionAdicionales(item, index),
        ],
      ),
    );
  }

  // 🖼️ IMAGEN DEL ITEM OPTIMIZADA
  Widget _buildImagenItem(ItemPedido item) {
    final esCircular = 
    item.tamano == 'Familiar' || 
    item.tamano == 'Personal' || 
    item.tamano == 'Extra Grande';
    
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        shape: esCircular ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: esCircular ? null : BorderRadius.circular(12),
        gradient: LinearGradient(
          colors: [
            colorSecundario.withOpacity(0.1),
            colorPrimario.withOpacity(0.1),
          ],
        ),
        border: Border.all(
          color: colorSecundario.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: ClipRRect(
        borderRadius: esCircular ? BorderRadius.circular(30) : BorderRadius.circular(12),
        child: Image.asset(
          item.imagen,
          fit: esCircular ? BoxFit.cover : BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: esCircular ? BorderRadius.circular(30) : BorderRadius.circular(12),
                border: Border.all(color: colorPrimario, width: 2),
              ),
              child: Icon(
                _getIconoProducto(item.tamano),
                size: 30,
                color: colorPrimario,
              ),
            );
          },
        ),
      ),
    );
  }

  // 🔥 OBTENER ICONO SEGÚN PRODUCTO
  IconData _getIconoProducto(String tamano) {
    if (tamano.contains('Combo')) return Icons.restaurant_menu;
    if (tamano == 'Mostrito') return Icons.restaurant_menu;
    if (tamano == 'Fusión') return Icons.auto_awesome;
    return Icons.local_pizza;
  }

  Widget _buildInfoItem(ItemPedido item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          item.nombre,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.black87,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 6),
        // 🏷️ ETIQUETA DE CATEGORÍA
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: _getTamanoColor(item.tamano).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: _getTamanoColor(item.tamano).withOpacity(0.3),
            ),
          ),
          child: Text(
            item.tamano,
            style: TextStyle(
              color: _getTamanoColor(item.tamano),
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 6),
        // 💰 PRECIO
        Text(
          'S/${item.precioTotal.toStringAsFixed(2)}',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
      ],
    );
  }

  // 🔥 NUEVA SECCIÓN PARA MOSTRAR ADICIONALES ACTUALES
  Widget _buildAdicionalesActuales(ItemPedido item, int index) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8, left: 16, right: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorSecundario.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorSecundario.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.add_circle_outline, color: colorSecundario, size: 16),
              const SizedBox(width: 4),
              Text(
                'Adicionales agregados:',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: colorSecundario,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...item.adicionales.asMap().entries.map((entry) {
            int adicionalIndex = entry.key;
            Adicional adicional = entry.value;
            
            return Container(
              margin: const EdgeInsets.only(bottom: 4),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Row(
                children: [
                  Text(
                    adicional.icono,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          adicional.nombre,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (adicional.pizzaEspecifica != null)
                          Text(
                            'Para: ${adicional.pizzaEspecifica}',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.blue[600],
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                      ],
                    ),
                  ),
                  // 🔢 CANTIDAD DEL ADICIONAL
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: colorAcento,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'x${adicional.cantidad}',
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  // 💰 PRECIO TOTAL DEL ADICIONAL
                  Text(
                    '+S/${(adicional.precio * adicional.cantidad).toStringAsFixed(1)}',
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 4),
                  // ❌ BOTÓN QUITAR
                  GestureDetector(
                    onTap: () => _quitarAdicional(index, adicionalIndex),
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Icon(
                        Icons.remove,
                        size: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  // 🎛️ CONTROLES DEL ITEM
  Widget _buildControlesItem(ItemPedido item, int index) {
    final isExpanded = itemsExpandidos.contains(index);
    final esPersonalizable = item.tamano != 'Combo Broaster';

    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 🔥 BOTÓN QUITAR/ELIMINAR
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: item.cantidad > 1 ? colorPrimario : Colors.red,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: (item.cantidad > 1 ? colorPrimario : Colors.red).withOpacity(0.3),
                    blurRadius: 3,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: IconButton(
                icon: Icon(
                  item.cantidad > 1 ? Icons.remove : Icons.delete,
                  color: Colors.white,
                  size: 14,
                ),
                padding: EdgeInsets.zero,
                onPressed: () => _modificarCantidad(index, item.cantidad - 1),
              ),
            ),
            
            // 🔢 CANTIDAD
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [colorAcento.withOpacity(0.2), Colors.white],
                ),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: colorAcento.withOpacity(0.3)),
              ),
              child: Text(
                '${item.cantidad}',
                style: TextStyle(
                  fontSize: 14, 
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.8),
                ),
              ),
            ),
            
            // ➕ BOTÓN AGREGAR
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: colorSecundario,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: colorSecundario.withOpacity(0.3),
                    blurRadius: 3,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(Icons.add, color: Colors.white, size: 14),
                padding: EdgeInsets.zero,
                onPressed: () => _modificarCantidad(index, item.cantidad + 1),
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 6),
        
        // 🔥 BOTÓN PERSONALIZAR
        if (esPersonalizable)
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  colorAcento.withOpacity(0.1),
                  Colors.transparent,
                ],
              ),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: colorAcento.withOpacity(0.3)),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () => _toggleExpansion(index),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                      color: const Color.fromARGB(255, 0, 0, 0),
                      size: 16,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      isExpanded ? 'Ocultar' : 'Adicionales',
                      style: TextStyle(
                        color: const Color.fromARGB(255, 0, 0, 0),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  // 🔥 OPTIMIZAR CAMBIO DE CANTIDAD
  void _modificarCantidad(int index, int nuevaCantidad) {
    setState(() {
      if (nuevaCantidad <= 0) {
        carritoLocal.removeAt(index);
        itemsExpandidos.remove(index);
        // Reajustar índices expandidos
        itemsExpandidos = itemsExpandidos.map((i) => i > index ? i - 1 : i).toList();
      } else {
        carritoLocal[index] = carritoLocal[index].copyWith(cantidad: nuevaCantidad);
      }
      _calcularTotal();
      widget.onActualizar(carritoLocal);
    });
  }

  // 🔥 OPTIMIZAR TOGGLE DE EXPANSIÓN
  void _toggleExpansion(int index) {
    setState(() {
      if (itemsExpandidos.contains(index)) {
        itemsExpandidos.remove(index);
      } else {
        itemsExpandidos.add(index);
      }
    });
  }

  // 🍕 SECCIÓN DE ADICIONALES DISPONIBLES MEJORADA
  Widget _buildSeccionAdicionales(ItemPedido item, int index) {
    final adicionalesDisponibles = _getAdicionalesDisponibles(item.tamano, item.nombre);
    
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorAcento.withOpacity(0.1),
            Colors.white,
          ],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: colorAcento,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.restaurant, color: Colors.white, size: 16),
              ),
              const SizedBox(width: 8),
              Text(
                'Agregar adicionales',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 0, 0, 0),
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // 🔥 LISTA DE ADICIONALES DISPONIBLES
          ...adicionalesDisponibles.map((adicional) => _buildAdicionalDisponible(adicional, item, index)),
        ],
      ),
    );
  }

  // 🔥 WIDGET PARA ADICIONAL DISPONIBLE (CLICKEABLE)
  Widget _buildAdicionalDisponible(Adicional adicional, ItemPedido item, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _mostrarDialogAdicional(index, adicional),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // 🖼️ IMAGEN DEL ADICIONAL
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: adicional.imagen.isNotEmpty
                      ? Image.asset(
                          adicional.imagen,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return Center(
                              child: Text(adicional.icono, style: const TextStyle(fontSize: 16)),
                            );
                          },
                        )
                      : Center(
                          child: Text(adicional.icono, style: const TextStyle(fontSize: 16)),
                        ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      adicional.nombre,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      'Toca para agregar',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: colorAcento,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  adicional.precio == 0.0 ? 'GRATIS' : '+S/${adicional.precio.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 11,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.add_circle_outline, color: colorSecundario, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  // 🔥 FOOTER DEL CARRITO OPTIMIZADO
  Widget _buildFooterCarrito() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 15,
            offset: const Offset(0, -5),
          ),
        ],
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white,
            colorAcento.withOpacity(0.05),
          ],
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total:', 
                style: TextStyle(
                  fontSize: 20, 
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                )
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [colorPrimario, colorPrimario.withOpacity(0.8)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: colorPrimario.withOpacity(0.3),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  'S/ ${_totalCacheado.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 20, 
                    fontWeight: FontWeight.bold, 
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [const Color.fromARGB(255, 38, 139, 40), const Color.fromARGB(255, 29, 172, 32).withOpacity(0.8)],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: colorSecundario.withOpacity(0.4),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: carritoLocal.isEmpty ? null : () => _procederAlPago(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.white,
                shadowColor: Colors.transparent,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.payment, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'PROCEDER AL PAGO', 
                    style: TextStyle(
                      fontSize: 16, 
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    )
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 🔥 DIALOG PERSONALIZADO PARA AGREGAR ADICIONALES CON CANTIDAD
class _DialogAdicional extends StatefulWidget {
  final Adicional adicional;
  final ItemPedido itemPedido;
  final Function(int cantidad, String? pizzaEspecifica) onAgregar;

  const _DialogAdicional({
    required this.adicional,
    required this.itemPedido,
    required this.onAgregar,
  });

  @override
  State<_DialogAdicional> createState() => _DialogAdicionalState();
}

class _DialogAdicionalState extends State<_DialogAdicional> {
  int cantidad = 1;
  String? pizzaSeleccionada;
  
  static const Color colorPrimario = Color(0xFFD4332A);
  static const Color colorSecundario = Color(0xFF2C5F2D);
  static const Color colorAcento = Color(0xFFF4B942);

  @override
  void initState() {
    super.initState();
    // Si es queso adicional y hay múltiples pizzas, no preseleccionar
    if (!_esQuesoAdicional() || !_tieneMultiplesPizzas()) {
      pizzaSeleccionada = null;
    }
  }

  bool _esQuesoAdicional() {
    return widget.adicional.nombre.toLowerCase().contains('queso');
  }

  bool _tieneMultiplesPizzas() {
    return PizzaData.esComboMultiplePizzas(widget.itemPedido.nombre);
  }

  List<String> _getPizzasDisponibles() {
    if (!_tieneMultiplesPizzas()) return [];
    return PizzaData.getPizzasEnCombo(widget.itemPedido.nombre);
  }

  @override
  Widget build(BuildContext context) {
    final pizzasDisponibles = _getPizzasDisponibles();
    final requierePizzaEspecifica = _esQuesoAdicional() && pizzasDisponibles.isNotEmpty;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              colorAcento.withOpacity(0.05),
            ],
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 🔥 TÍTULO CON IMAGEN
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: colorAcento.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: colorAcento.withOpacity(0.3)),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: widget.adicional.imagen.isNotEmpty
                        ? Image.asset(
                            widget.adicional.imagen,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return Center(
                                child: Text(
                                  widget.adicional.icono,
                                  style: const TextStyle(fontSize: 20),
                                ),
                              );
                            },
                          )
                        : Center(
                            child: Text(
                              widget.adicional.icono,
                              style: const TextStyle(fontSize: 20),
                            ),
                          ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Agregar adicional',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: colorSecundario,
                        ),
                      ),
                      Text(
                        widget.adicional.nombre,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 20),

            // 🔥 SELECTOR DE PIZZA (SOLO PARA QUESO EN COMBOS MÚLTIPLES)
            if (requierePizzaEspecifica) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.withOpacity(0.2)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.blue[600], size: 18),
                        const SizedBox(width: 6),
                        Text(
                          '¿Para qué pizza?',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Selecciona la pizza específica donde quieres agregar el queso:',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue[600],
                      ),
                    ),
                    const SizedBox(height: 10),
                    ...pizzasDisponibles.map((pizza) {
                      return RadioListTile<String>(
                        title: Text(
                          pizza,
                          style: const TextStyle(fontSize: 12),
                        ),
                        value: pizza,
                        groupValue: pizzaSeleccionada,
                        onChanged: (value) {
                          setState(() {
                            pizzaSeleccionada = value;
                          });
                        },
                        activeColor: colorSecundario,
                        contentPadding: EdgeInsets.zero,
                        visualDensity: VisualDensity.compact,
                      );
                    }).toList(),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // 🔢 SELECTOR DE CANTIDAD
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorSecundario.withOpacity(0.05),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: colorSecundario.withOpacity(0.2)),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(Icons.shopping_cart, color: colorSecundario, size: 18),
                      const SizedBox(width: 6),
                      Text(
                        'Cantidad',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: colorSecundario,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // 🔥 BOTÓN QUITAR
                      Container(
                        decoration: BoxDecoration(
                          color: cantidad > 1 ? colorPrimario : Colors.grey,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: (cantidad > 1 ? colorPrimario : Colors.grey).withOpacity(0.3),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.remove, color: Colors.white, size: 20),
                          onPressed: cantidad > 1
                              ? () {
                                  setState(() {
                                    cantidad--;
                                  });
                                }
                              : null,
                        ),
                      ),
                      
                      const SizedBox(width: 20),
                      
                      // 🔢 CANTIDAD ACTUAL
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [colorAcento, colorAcento.withOpacity(0.8)],
                          ),
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: colorAcento.withOpacity(0.3),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Text(
                          '$cantidad',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      
                      const SizedBox(width: 20),
                      
                      // ➕ BOTÓN AGREGAR
                      Container(
                        decoration: BoxDecoration(
                          color: colorSecundario,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: colorSecundario.withOpacity(0.3),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.add, color: Colors.white, size: 20),
                          onPressed: cantidad < 10
                              ? () {
                                  setState(() {
                                    cantidad++;
                                  });
                                }
                              : null,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 💰 PRECIO TOTAL
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.green.withOpacity(0.1), Colors.green.withOpacity(0.05)],
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green.withOpacity(0.3)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Precio total:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[700],
                    ),
                  ),
                  Text(
                    widget.adicional.precio == 0.0
                        ? 'GRATIS'
                        : 'S/${(widget.adicional.precio * cantidad).toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[700],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 🔥 BOTONES DE ACCIÓN
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(
                      'Cancelar',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [colorSecundario, colorSecundario.withOpacity(0.8)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: colorSecundario.withOpacity(0.3),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: (requierePizzaEspecifica && pizzaSeleccionada == null)
                          ? null
                          : () {
                              widget.onAgregar(cantidad, pizzaSeleccionada);
                              Navigator.of(context).pop();
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        foregroundColor: Colors.white,
                        shadowColor: Colors.transparent,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text(
                        'Agregar al carrito',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
  }