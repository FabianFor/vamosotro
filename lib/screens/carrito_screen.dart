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
      'Extra Grande': const Color(0xFF8B4513), // Color café
      'Mostrito': Colors.orange,
      'Broaster': Colors.brown,
      '2 Sabores': Colors.purple,
      '4 Sabores': Colors.purple,
      'Combo Broaster': Colors.brown,
      'Fusión': Colors.deepPurple,
      'Combo Pizza': Colors.indigo,
      'Combo Estrella': Colors.deepPurple,
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

  // 🔥 MÉTODO ESPECIAL PARA TOGGLE DE ADICIONAL CON LÓGICA DE PRIMERA GASEOSA
  void _toggleAdicional(int itemIndex, Adicional adicional) {
    setState(() {
      ItemPedido item = carritoLocal[itemIndex];
      List<Adicional> nuevosAdicionales = List.from(item.adicionales);

      // 🔥 LÓGICA ESPECIAL PARA PRIMERA GASEOSA EN PIZZAS PERSONALES
      if (item.tamano == 'Personal' && adicional.nombre == 'Pepsi 350ml (primera)') {
        // Verificar si ya tiene primera gaseosa
        bool yaHayPrimera = nuevosAdicionales.any((a) => a.nombre == 'Pepsi 350ml (primera)');
        
        if (yaHayPrimera) {
          // Quitar la primera gaseosa
          nuevosAdicionales.removeWhere((a) => a.nombre == 'Pepsi 350ml (primera)');
        } else {
          // Añadir la primera gaseosa (solo si no hay otra primera)
          nuevosAdicionales.add(adicional);
        }
      } 
      // 🔥 LÓGICA ESPECIAL PARA CAMBIOS GRATUITOS EN COMBOS ESPECIALES
      else if (adicional.nombre == 'Cambiar a solo Americana') {
        bool yaTieneCambio = nuevosAdicionales.any((a) => a.nombre == 'Cambiar a solo Americana');
        
        if (yaTieneCambio) {
          nuevosAdicionales.removeWhere((a) => a.nombre == 'Cambiar a solo Americana');
        } else {
          nuevosAdicionales.add(adicional);
        }
      }
      // 🔥 LÓGICA NORMAL PARA OTROS ADICIONALES
      else {
        if (nuevosAdicionales.any((a) => a.nombre == adicional.nombre)) {
          nuevosAdicionales.removeWhere((a) => a.nombre == adicional.nombre);
        } else {
          nuevosAdicionales.add(adicional);
        }
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

  // 🔥 MÉTODO MEJORADO PARA MOSTRAR SELECTOR DE PIZZA EN COMBOS MÚLTIPLES
  void _mostrarSelectorPizza(BuildContext context, ItemPedido item, int index, Adicional adicional) {
    // Solo para combos con múltiples pizzas
    if (!PizzaData.esComboMultiplePizzas(item.nombre)) {
      _toggleAdicional(index, adicional);
      return;
    }

    // 🔥 OBTENER PIZZAS ESPECÍFICAS DEL COMBO
    List<String> pizzasEnCombo = PizzaData.getPizzasEnCombo(item.nombre);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('¿En qué pizza aplicar ${adicional.nombre}?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ...pizzasEnCombo.map((pizzaNombre) => ListTile(
              title: Text(pizzaNombre),
              onTap: () {
                Navigator.pop(context);
                _aplicarAdicionalEspecifico(index, adicional, pizzaNombre);
              },
            )).toList(),
            ListTile(
              title: const Text('Todas las pizzas'),
              leading: const Icon(Icons.select_all),
              onTap: () {
                Navigator.pop(context);
                _aplicarAdicionalEspecifico(index, adicional, 'Todas las pizzas');
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
        ],
      ),
    );
  }

  // 🔥 MÉTODO PARA APLICAR ADICIONAL A PIZZA ESPECÍFICA
  void _aplicarAdicionalEspecifico(int index, Adicional adicional, String pizzaEspecifica) {
    setState(() {
      ItemPedido item = carritoLocal[index];
      List<Adicional> nuevosAdicionales = List.from(item.adicionales);

      // Crear adicional con especificación de pizza
      Adicional adicionalEspecifico = Adicional(
        nombre: '${adicional.nombre} (${pizzaEspecifica})',
        precio: adicional.precio,
        icono: adicional.icono,
      );

      // Verificar si ya existe
      bool yaExiste = nuevosAdicionales.any((a) => a.nombre == adicionalEspecifico.nombre);
      
      if (yaExiste) {
        nuevosAdicionales.removeWhere((a) => a.nombre == adicionalEspecifico.nombre);
      } else {
        nuevosAdicionales.add(adicionalEspecifico);
      }

      carritoLocal[index] = item.copyWith(adicionales: nuevosAdicionales);
      _calcularTotal();
      widget.onActualizar(carritoLocal);
    });
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
                  // 🚀 OPTIMIZAR LISTA CON LISTVIEW.BUILDER SIN SHRINKWRAP
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: carritoLocal.length,
                    // 🔥 MEJORAS DE PERFORMANCE PARA LISTAS LARGAS
                    cacheExtent: 300, // Cache más items fuera de pantalla
                    itemExtent: null, // Permitir alturas dinámicas pero optimizadas
                    itemBuilder: (context, index) => _buildCarritoItem(index),
                  ),
                ),
                _buildFooterCarrito(), // 🔥 WIDGET SEPARADO
              ],
            ),
    );
  }

  // 🔥 ITEM DEL CARRITO COMO WIDGET SEPARADO PARA MEJOR PERFORMANCE
  Widget _buildCarritoItem(int index) {
    final item = carritoLocal[index];
    final isExpanded = itemsExpandidos.contains(index);
    final esPersonalizable = item.tamano != 'Combo Broaster' && 
                           item.tamano != 'Mostrito';

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
                _buildImagenItem(item), // 🔥 WIDGET SEPARADO
                const SizedBox(width: 16),
                Expanded(
                  child: _buildInfoItem(item), // 🔥 WIDGET SEPARADO
                ),
                _buildControlesItem(item, index), // 🔥 CONTROLES SEPARADOS
              ],
            ),
          ),

          // 🔥 SECCIÓN EXPANDIBLE DE ADICIONALES
          if (isExpanded && esPersonalizable) 
            _buildSeccionAdicionales(item, index), // 🔥 WIDGET SEPARADO
        ],
      ),
    );
  }

  // 🖼️ IMAGEN DEL ITEM OPTIMIZADA
  Widget _buildImagenItem(ItemPedido item) {
    final esCircular = item.tamano == 'Familiar' || item.tamano == 'Personal';
    
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
    if (tamano == 'Mostrito') return Icons.restaurant_menu; // 🔥 ICONO DE MENÚ/COMIDA
    if (tamano == 'Fusión') return Icons.auto_awesome;
    return Icons.local_pizza;
  }

  // ℹ️ INFORMACIÓN DEL ITEM
  Widget _buildInfoItem(ItemPedido item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          item.descripcionCompleta,
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
        Row(
          children: [
            Text(
              'S/${item.precioTotal.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            if (item.adicionales.isNotEmpty) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '+${item.adicionales.length} extra${item.adicionales.length > 1 ? 's' : ''}',
                  style: TextStyle(
                    fontSize: 9,
                    color: Colors.orange[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ],
        ),
        if (item.adicionales.isNotEmpty) ...[
          const SizedBox(height: 6),
          Wrap(
            spacing: 4,
            runSpacing: 2,
            children: item.adicionales.map((adicional) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                decoration: BoxDecoration(
                  color: colorSecundario.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: colorSecundario.withOpacity(0.3)),
                ),
                child: Text(
                  '${adicional.icono} ${adicional.nombre}',
                  style: TextStyle(
                    fontSize: 9,
                    color: colorSecundario,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }

  // 🎛️ CONTROLES DEL ITEM
  Widget _buildControlesItem(ItemPedido item, int index) {
    final isExpanded = itemsExpandidos.contains(index);
    final esPersonalizable = item.tamano != 'Combo Broaster' && item.tamano != 'Mostrito';

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
                  color: colorAcento.withOpacity(0.8),
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
        
        // 🔥 BOTÓN PERSONALIZAR - FLECHA HACIA ABAJO 🎯
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
                      color: colorAcento,
                      size: 16,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      isExpanded ? 'Ocultar' : 'Adicionales',
                      style: TextStyle(
                        color: colorAcento,
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
      _calcularTotal(); // 🔥 RECALCULAR SOLO CUANDO CAMBIE
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

  // 🍕 SECCIÓN DE ADICIONALES CORREGIDA
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
                'Personaliza tu ${item.nombre}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: colorAcento,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // 🔥 LISTA DE ADICIONALES CON MEJOR PERFORMANCE
          ...adicionalesDisponibles.map((adicional) => _buildAdicionalTile(adicional, item, index)),
        ],
      ),
    );
  }

  // 🔥 MÉTODO MEJORADO PARA CONSTRUIR TILES DE ADICIONALES
  Widget _buildAdicionalTile(Adicional adicional, ItemPedido item, int index) {
    final isSelected = item.adicionales.any((a) => a.nombre == adicional.nombre);
    
    // 🔥 LÓGICA ESPECIAL PARA MOSTRAR INFORMACIÓN ADICIONAL
    String descripcionExtra = '';
    Color colorEspecial = colorSecundario;
    
    if (adicional.nombre == 'Pepsi 350ml (primera)' && item.tamano == 'Personal') {
      descripcionExtra = ' (Solo +S/1 en personal)';
      colorEspecial = Colors.green;
    } else if (adicional.nombre == 'Cambiar a solo Americana') {
      descripcionExtra = ' (Cambio gratuito)';
      colorEspecial = Colors.blue;
    } else if (adicional.precio == 0.0) {
      descripcionExtra = ' (Gratis)';
      colorEspecial = Colors.green;
    }
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isSelected ? colorEspecial.withOpacity(0.1) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? colorEspecial : Colors.grey[300]!,
          width: isSelected ? 2 : 1,
        ),
        boxShadow: isSelected ? [
          BoxShadow(
            color: colorEspecial.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ] : null,
      ),
      child: CheckboxListTile(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: isSelected ? colorEspecial.withOpacity(0.2) : Colors.grey[100],
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(adicional.icono, style: const TextStyle(fontSize: 16)),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    adicional.nombre,
                    style: TextStyle(
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      color: isSelected ? colorEspecial : Colors.black87,
                      fontSize: 13,
                    ),
                  ),
                  if (descripcionExtra.isNotEmpty)
                    Text(
                      descripcionExtra,
                      style: TextStyle(
                        fontSize: 10,
                        color: colorEspecial.withOpacity(0.7),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: isSelected ? colorEspecial : colorAcento,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                adicional.precio == 0.0 
                  ? 'GRATIS' 
                  : (adicional.nombre == 'Pepsi 350ml (primera)' && item.tamano == 'Personal')
                    ? '+S/1'
                    : '+S/${adicional.precio.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 11,
                ),
              ),
            ),
          ],
        ),
        value: isSelected,
        onChanged: (bool? value) {
          // 🔥 DETECTAR SI REQUIERE SELECTOR ESPECIAL PARA QUESO EN COMBOS MÚLTIPLES
          if (PizzaData.esComboMultiplePizzas(item.nombre) && adicional.nombre.contains('Queso adicional')) {
            _mostrarSelectorPizza(context, item, index, adicional);
          } else {
            _toggleAdicional(index, adicional);
          }
        },
        activeColor: colorEspecial,
        contentPadding: const EdgeInsets.symmetric(horizontal: 8),
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
                  'S/ ${_totalCacheado.toStringAsFixed(2)}', // 🔥 USAR CACHE
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
                colors: [colorSecundario, colorSecundario.withOpacity(0.8)],
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