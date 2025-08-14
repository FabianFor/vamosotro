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
  
  // 🔥 CACHE PARA ADICIONALES Y COLORES
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
      'Extra Grande': const Color.fromARGB(255, 225, 0, 255),
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

  void _calcularTotal() {
    _totalCacheado = carritoLocal.fold(0.0, (sum, item) {
      return sum + item.precioTotalCarrito;
    });
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

  // 🔥 MOSTRAR DIALOG PARA AGREGAR ADICIONAL CON SELECCIÓN DE PIZZAS
  void _mostrarDialogAdicional(int itemIndex, Adicional adicional) {
    final item = carritoLocal[itemIndex];
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return _DialogAdicional(
          adicional: adicional,
          itemPedido: item,
          onAgregar: (int cantidad, List<String> pizzasSeleccionadas) {
            _agregarAdicionalConSeleccion(itemIndex, adicional, cantidad, pizzasSeleccionadas);
          },
        );
      },
    );
  }

  // 🔥 AGREGAR ADICIONAL CON SELECCIÓN ESPECÍFICA DE PIZZAS
  void _agregarAdicionalConSeleccion(int itemIndex, Adicional adicional, int cantidad, List<String> pizzasSeleccionadas) {
    setState(() {
      ItemPedido item = carritoLocal[itemIndex];
      List<Adicional> nuevosAdicionales = List.from(item.adicionales);

      // 🔥 VALIDACIONES ESPECIALES
      
      // 1️⃣ VALIDACIÓN PARA PRIMERA GASEOSA - Solo pizzas personales
      if (_esPrimeraGaseosa(adicional)) {
        int primerasGaseosasActuales = _contarPrimerasGaseosas(item);
        int maxPrimerasGaseosas = item.cantidad;
        
        if (primerasGaseosasActuales >= maxPrimerasGaseosas) {
          _mostrarError('Ya tienes $maxPrimerasGaseosas primera(s) gaseosa(s). Solo 1 primera gaseosa por pizza personal.');
          return;
        }
        
        if (primerasGaseosasActuales + cantidad > maxPrimerasGaseosas) {
          cantidad = maxPrimerasGaseosas - primerasGaseosasActuales;
          if (cantidad <= 0) return;
        }
        
        // Para primera gaseosa, agregar por pizzas seleccionadas
        for (String pizzaEspecifica in pizzasSeleccionadas) {
          Adicional nuevoAdicional = Adicional(
            nombre: adicional.nombre,
            precio: adicional.precio,
            icono: adicional.icono,
            imagen: adicional.imagen,
            cantidad: 1, // Siempre 1 por pizza
            pizzaEspecifica: pizzaEspecifica,
          );
          
          int indiceExistente = nuevosAdicionales.indexWhere((a) => 
              a.nombre == nuevoAdicional.nombre && a.pizzaEspecifica == pizzaEspecifica);
          
          if (indiceExistente == -1) { // Solo agregar si no existe
            nuevosAdicionales.add(nuevoAdicional);
          }
        }
      } 
      // 2️⃣ PARA CAMBIOS GRATUITOS (Solo Americana)
      else if (_esAdicionalEspecialGratuito(adicional)) {
        for (String pizzaEspecifica in pizzasSeleccionadas) {
          Adicional nuevoAdicional = Adicional(
            nombre: adicional.nombre,
            precio: adicional.precio,
            icono: adicional.icono,
            imagen: adicional.imagen,
            cantidad: 1,
            pizzaEspecifica: _convertirNombrePizzaCambiada(pizzaEspecifica),
          );

          int indiceExistente = nuevosAdicionales.indexWhere((a) => 
              a.nombre == nuevoAdicional.nombre && a.pizzaEspecifica == nuevoAdicional.pizzaEspecifica);
          
          if (indiceExistente == -1) {
            nuevosAdicionales.add(nuevoAdicional);
          }
        }
      }
      // 3️⃣ PARA OTROS ADICIONALES CON PIZZAS ESPECÍFICAS
      else if (pizzasSeleccionadas.isNotEmpty) {
        for (String pizzaEspecifica in pizzasSeleccionadas) {
          // 🔥 VALIDACIÓN ESPECIAL PARA QUESO
          if (_esQuesoAdicional(adicional)) {
            int quesosActuales = _contarQuesosPorPizza(item, pizzaEspecifica);
            if (quesosActuales >= 1) {
              _mostrarError('Ya tienes queso para $pizzaEspecifica. Solo 1 queso por pizza.');
              continue;
            }
          }

          Adicional nuevoAdicional = Adicional(
            nombre: adicional.nombre,
            precio: adicional.precio,
            icono: adicional.icono,
            imagen: adicional.imagen,
            cantidad: _esQuesoAdicional(adicional) ? 1 : cantidad,
            pizzaEspecifica: pizzaEspecifica,
          );

          int indiceExistente = nuevosAdicionales.indexWhere((a) => 
              a.nombre == nuevoAdicional.nombre && 
              a.pizzaEspecifica == pizzaEspecifica);

          if (indiceExistente != -1) {
            if (!_esQuesoAdicional(adicional)) {
              Adicional existente = nuevosAdicionales[indiceExistente];
              nuevosAdicionales[indiceExistente] = existente.copyWith(
                cantidad: existente.cantidad + cantidad
              );
            }
          } else {
            nuevosAdicionales.add(nuevoAdicional);
          }
        }
      }
      // 4️⃣ PARA ADICIONALES SIN SELECCIÓN DE PIZZAS (CANTIDAD LIBRE)
      else {
        Adicional nuevoAdicional = Adicional(
          nombre: adicional.nombre,
          precio: adicional.precio,
          icono: adicional.icono,
          imagen: adicional.imagen,
          cantidad: cantidad,
          pizzaEspecifica: null,
        );
        
        int indiceExistente = nuevosAdicionales.indexWhere((a) => 
            a.nombre == nuevoAdicional.nombre && a.pizzaEspecifica == null);
        
        if (indiceExistente != -1) {
          Adicional existente = nuevosAdicionales[indiceExistente];
          nuevosAdicionales[indiceExistente] = existente.copyWith(
            cantidad: existente.cantidad + cantidad
          );
        } else {
          nuevosAdicionales.add(nuevoAdicional);
        }
      }

      carritoLocal[itemIndex] = item.copyWith(adicionales: nuevosAdicionales);
      _calcularTotal();
      widget.onActualizar(carritoLocal);

      // 🔥 MOSTRAR CONFIRMACIÓN
      String mensaje = pizzasSeleccionadas.isNotEmpty
          ? '✅ Agregado: ${adicional.nombre} para ${pizzasSeleccionadas.length} pizza(s)'
          : '✅ Agregado: ${adicional.nombre} x$cantidad';
      
      _mostrarExito(mensaje);
    });
  }

  // 🔥 NUEVA FUNCIÓN: Convertir nombre de pizza cuando se cambia a americana
  String _convertirNombrePizzaCambiada(String nombreOriginal) {
    if (nombreOriginal.contains('Pizza Hawaiana (Cambiar a Americana)')) {
      return nombreOriginal.replaceAll('Pizza Hawaiana (Cambiar a Americana)', 'Pizza Hawaiana (Americana)');
    } else if (nombreOriginal.contains('Pizza 2 sabores (Cambiar a Americana)')) {
      return nombreOriginal.replaceAll('Pizza 2 sabores (Cambiar a Americana)', 'Pizza 2 sabores (Americana)');
    }
    return nombreOriginal;
  }

  // 🔥 VERIFICACIONES DE TIPOS DE ADICIONALES
  bool _esPrimeraGaseosa(Adicional adicional) {
    return adicional.nombre.toLowerCase().contains('primera');
  }

  bool _esQuesoAdicional(Adicional adicional) {
    return adicional.nombre.toLowerCase().contains('queso');
  }

  bool _esAdicionalEspecialGratuito(Adicional adicional) {
    return adicional.nombre.contains('Solo Americana') || 
           adicional.nombre.contains('Cambiar Hawaiana');
  }

  // 🔥 CONTAR PRIMERAS GASEOSAS ACTUALES
  int _contarPrimerasGaseosas(ItemPedido item) {
    return item.adicionales.where((a) => 
        a.nombre.toLowerCase().contains('primera')
    ).fold(0, (sum, a) => sum + a.cantidad);
  }

  // 🔥 CONTAR QUESOS POR PIZZA ESPECÍFICA
  int _contarQuesosPorPizza(ItemPedido item, String? pizzaEspecifica) {
    return item.adicionales.where((a) => 
        a.nombre.toLowerCase().contains('queso') && 
        a.pizzaEspecifica == pizzaEspecifica
    ).fold(0, (sum, a) => sum + a.cantidad);
  }

  // 🔥 MÉTODO PARA QUITAR ADICIONAL COMPLETO
  void _eliminarAdicionalCompleto(int itemIndex, int adicionalIndex) {
    setState(() {
      ItemPedido item = carritoLocal[itemIndex];
      List<Adicional> nuevosAdicionales = List.from(item.adicionales);
      
      String nombreAdicional = nuevosAdicionales[adicionalIndex].nombre;
      nuevosAdicionales.removeAt(adicionalIndex);

      carritoLocal[itemIndex] = item.copyWith(adicionales: nuevosAdicionales);
      _calcularTotal();
      widget.onActualizar(carritoLocal);

      _mostrarInfo('🗑️ Eliminado: $nombreAdicional');
    });
  }

  // 🔥 MÉTODO PARA QUITAR UNA UNIDAD DE ADICIONAL
  void _quitarAdicional(int itemIndex, int adicionalIndex) {
    setState(() {
      ItemPedido item = carritoLocal[itemIndex];
      List<Adicional> nuevosAdicionales = List.from(item.adicionales);
      
      Adicional adicional = nuevosAdicionales[adicionalIndex];
      if (adicional.cantidad > 1) {
        nuevosAdicionales[adicionalIndex] = adicional.copyWith(
          cantidad: adicional.cantidad - 1
        );
      } else {
        nuevosAdicionales.removeAt(adicionalIndex);
      }

      carritoLocal[itemIndex] = item.copyWith(adicionales: nuevosAdicionales);
      _calcularTotal();
      widget.onActualizar(carritoLocal);
    });
  }

  // 🔥 OBTENER ADICIONALES DISPONIBLES
  List<Adicional> _getAdicionalesDisponibles(String tamano, String nombre) {
    String key = '${nombre}_${tamano}';
    
    if (!_adicionalesCache.containsKey(key)) {
      List<Adicional> adicionales = List.from(PizzaData.getAdicionalesParaItem(nombre, tamano));
      
      if (_esComboEstrella(nombre)) {
        adicionales.insert(0, Adicional(
          nombre: 'Solo Americana',
          precio: 0.0,
          icono: '🔄',
          imagen: 'assets/images/adicionales/cambio_americana.png',
        ));
      } else if (_esOfertaDuo(nombre)) {
        adicionales.insert(0, Adicional(
          nombre: 'Cambiar Hawaiana → Americana',
          precio: 0.0,
          icono: '🔄',
          imagen: 'assets/images/adicionales/cambio_americana.png',
        ));
      }
      
      adicionales.sort((a, b) => a.precio.compareTo(b.precio));
      _adicionalesCache[key] = adicionales;
    }
    
    return _adicionalesCache[key] ?? [];
  }

  bool _esComboEstrella(String nombre) {
    return nombre.toLowerCase().contains('estrella');
  }

  bool _esOfertaDuo(String nombre) {
    return nombre.toLowerCase().contains('oferta dúo');
  }

  // 🎨 USAR CACHE PARA COLORES
  Color _getTamanoColor(String tamano) {
    return _coloresCache[tamano] ?? colorAcento;
  }

  // 🔥 OPTIMIZAR CAMBIO DE CANTIDAD
  void _modificarCantidad(int index, int nuevaCantidad) {
    setState(() {
      if (nuevaCantidad <= 0) {
        carritoLocal.removeAt(index);
        itemsExpandidos.remove(index);
        itemsExpandidos = itemsExpandidos.map((i) => i > index ? i - 1 : i).toList();
      } else {
        carritoLocal[index] = carritoLocal[index].copyWith(cantidad: nuevaCantidad);
      }
      _calcularTotal();
      widget.onActualizar(carritoLocal);
    });
  }

  // 🔥 TOGGLE DE EXPANSIÓN
  void _toggleExpansion(int index) {
    setState(() {
      if (itemsExpandidos.contains(index)) {
        itemsExpandidos.remove(index);
      } else {
        itemsExpandidos.add(index);
      }
    });
  }

  // 🔥 MENSAJES MEJORADOS
  void _mostrarError(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Expanded(child: Text(mensaje, style: const TextStyle(fontSize: 13))),
          ],
        ),
        backgroundColor: Colors.red[600],
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _mostrarExito(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Expanded(child: Text(mensaje, style: const TextStyle(fontSize: 13))),
          ],
        ),
        backgroundColor: colorSecundario,
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _mostrarInfo(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.info, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Expanded(child: Text(mensaje, style: const TextStyle(fontSize: 13))),
          ],
        ),
        backgroundColor: Colors.orange[600],
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
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
          // INFORMACIÓN PRINCIPAL
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _buildImagenItem(item),
                const SizedBox(width: 16),
                Expanded(child: _buildInfoItem(item)),
                _buildControlesItem(item, index),
              ],
            ),
          ),

          // 🔥 ADICIONALES AGREGADOS (SIEMPRE VISIBLE CON CONTROLES MEJORADOS)
          if (item.adicionales.isNotEmpty)
            _buildAdicionalesActualesConControles(item, index),

          // 🔥 SECCIÓN EXPANDIBLE DE ADICIONALES DISPONIBLES
          if (isExpanded && esPersonalizable) 
            _buildSeccionAdicionales(item, index),
        ],
      ),
    );
  }

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
        Text(
          'S/${item.precioTotalCarrito.toStringAsFixed(2)}',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
      ],
    );
  }

  // 🔥 SECCIÓN DE ADICIONALES CON CONTROLES MEJORADOS (INCLUYE BOTÓN BORRAR)
  Widget _buildAdicionalesActualesConControles(ItemPedido item, int index) {
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
                'Adicionales (${item.adicionales.length}):',
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
              margin: const EdgeInsets.only(bottom: 6),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey[300]!),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // 🔥 ICONO/IMAGEN
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: adicional.imagen.isNotEmpty
                          ? Image.asset(
                              adicional.imagen,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return Center(
                                  child: Text(adicional.icono, style: const TextStyle(fontSize: 12)),
                                );
                              },
                            )
                          : Center(
                              child: Text(adicional.icono, style: const TextStyle(fontSize: 12)),
                            ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  
                  // 🔥 INFO DEL ADICIONAL
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          adicional.nombre,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (adicional.pizzaEspecifica != null) ...[
                          const SizedBox(height: 2),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: Colors.blue.withOpacity(0.3)),
                            ),
                            child: Text(
                              'Para: ${adicional.pizzaEspecifica}',
                              style: TextStyle(
                                fontSize: 9,
                                color: Colors.blue[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  
                  // 🔥 CONTROLES DE CANTIDAD Y BORRAR
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // CANTIDAD
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
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
                      const SizedBox(width: 6),
                      
                      // PRECIO
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: Colors.green.withOpacity(0.3)),
                        ),
                        child: Text(
                          adicional.precio == 0.0 
                              ? 'GRATIS'
                              : '+S/${(adicional.precio * adicional.cantidad).toStringAsFixed(1)}',
                          style: TextStyle(
                            fontSize: 9,
                            color: Colors.green[700],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      
                      // 🔥 BOTÓN QUITAR (-1)
                      GestureDetector(
                        onTap: () => _quitarAdicional(index, adicionalIndex),
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: adicional.cantidad > 1 ? Colors.orange : Colors.grey,
                            borderRadius: BorderRadius.circular(4),
                            boxShadow: [
                              BoxShadow(
                                color: (adicional.cantidad > 1 ? Colors.orange : Colors.grey).withOpacity(0.3),
                                blurRadius: 2,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.remove,
                            size: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      
                      // 🔥 BOTÓN BORRAR COMPLETO (NUEVO)
                      GestureDetector(
                        onTap: () => _mostrarConfirmacionBorrar(index, adicionalIndex, adicional.nombre),
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(4),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.red.withOpacity(0.3),
                                blurRadius: 2,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.delete,
                            size: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  // 🔥 CONFIRMACIÓN ANTES DE BORRAR ADICIONAL COMPLETO
  void _mostrarConfirmacionBorrar(int itemIndex, int adicionalIndex, String nombreAdicional) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Row(
            children: [
              Icon(Icons.delete_forever, color: Colors.red[600], size: 24),
              const SizedBox(width: 8),
              const Text('Confirmar eliminación', style: TextStyle(fontSize: 16)),
            ],
          ),
          content: Text(
            '¿Estás seguro de que quieres eliminar completamente "$nombreAdicional"?',
            style: const TextStyle(fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancelar', style: TextStyle(color: Colors.grey[600])),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _eliminarAdicionalCompleto(itemIndex, adicionalIndex);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Eliminar', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildControlesItem(ItemPedido item, int index) {
    final isExpanded = itemsExpandidos.contains(index);
    final esPersonalizable = item.tamano != 'Combo Broaster';

    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
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
          
          ...adicionalesDisponibles.map((adicional) => _buildAdicionalDisponible(adicional, item, index)),
        ],
      ),
    );
  }

  // 🔥 WIDGET PARA ADICIONAL DISPONIBLE - Solo botón + funciona
  Widget _buildAdicionalDisponible(Adicional adicional, ItemPedido item, int index) {
    // 🔥 CALCULAR CANTIDAD ACTUAL DEL ADICIONAL
    int cantidadActual = _getCantidadActualAdicional(item, adicional);
    
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
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
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
                  const SizedBox(height: 2),
                  // 🔥 MOSTRAR CANTIDAD ACTUAL
                  if (cantidadActual > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'Ya tienes: $cantidadActual',
                        style: const TextStyle(
                          fontSize: 9,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  else
                    Text(
                      'Disponible para agregar',
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
            // 🔥 SOLO EL BOTÓN + ES CLICKEABLE
            GestureDetector(
              onTap: () => _mostrarDialogAdicional(index, adicional),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: colorSecundario,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: colorSecundario.withOpacity(0.3),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔥 OBTENER CANTIDAD ACTUAL DE UN ADICIONAL
  int _getCantidadActualAdicional(ItemPedido item, Adicional adicional) {
    return item.adicionales.where((a) => a.nombre == adicional.nombre)
        .fold(0, (sum, a) => sum + a.cantidad);
  }

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

// 🔥 DIALOG MEJORADO CON LÓGICA CORREGIDA PARA COMBOS MÚLTIPLES
class _DialogAdicional extends StatefulWidget {
  final Adicional adicional;
  final ItemPedido itemPedido;
  final Function(int cantidad, List<String> pizzasSeleccionadas) onAgregar;

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
  Set<String> pizzasSeleccionadas = {};
  
  static const Color colorPrimario = Color(0xFFD4332A);
  static const Color colorSecundario = Color(0xFF2C5F2D);
  static const Color colorAcento = Color(0xFFF4B942);

  @override
  void initState() {
    super.initState();
    // 🔥 LÓGICA ESPECIAL PARA ADICIONALES QUE VAN POR PIZZA
    if (_requiereSeleccionPorPizza()) {
      cantidad = 1; // Fijo para estos tipos
    }
  }

  // 🔥 DETERMINAR SI REQUIERE SELECCIÓN POR PIZZA
  bool _requiereSeleccionPorPizza() {
    return _esPrimeraGaseosa() || 
           _esQuesoAdicional() || 
           _esAdicionalEspecialGratuito();
  }

  bool _esPrimeraGaseosa() {
    return widget.adicional.nombre.toLowerCase().contains('primera');
  }

  bool _esQuesoAdicional() {
    return widget.adicional.nombre.toLowerCase().contains('queso');
  }

  bool _esAdicionalEspecialGratuito() {
    return widget.adicional.nombre.contains('Solo Americana') || 
           widget.adicional.nombre.contains('Cambiar Hawaiana');
  }

  // 🔥 OBTENER PIZZAS EXPANDIDAS POR CANTIDAD CON LÓGICA ESPECÍFICA CORREGIDA
  List<String> _getPizzasExpandidas() {
    List<String> pizzasBase = [];
    
    // 🔥 LÓGICA ESPECÍFICA SEGÚN EL TIPO DE ADICIONAL
    if (_esAdicionalEspecialGratuito()) {
      if (widget.adicional.nombre.contains('Solo Americana')) {
        // Para Combo Estrella - solo mostrar las pizzas que NO son americana
        pizzasBase = ['Pizza 2 sabores (Cambiar a Americana)'];
      } else if (widget.adicional.nombre.contains('Cambiar Hawaiana')) {
        // Para Oferta Dúo - solo las hawaianas pueden cambiarse
        pizzasBase = ['Pizza Hawaiana (Cambiar a Americana)'];
      }
    } else if (_esPrimeraGaseosa()) {
      // Para primera gaseosa: una por cada pizza personal
      pizzasBase = ['Pizza Personal'];
    } else {
      // Para queso y otros: usar lógica existente MEJORADA
      if (PizzaData.esComboMultiplePizzas(widget.itemPedido.nombre)) {
        pizzasBase = PizzaData.getPizzasEnCombo(widget.itemPedido.nombre);
      } else {
        pizzasBase = ['${widget.itemPedido.nombre} (${widget.itemPedido.tamano})'];
      }
    }
    
    // 🔥 EXPANDIR SEGÚN CANTIDAD DEL ITEM - LÓGICA CORREGIDA
    List<String> pizzasExpandidas = [];
    
    // 🔥 CASO ESPECIAL: Para cambios gratuitos, solo expandir las pizzas que se pueden cambiar
    if (_esAdicionalEspecialGratuito()) {
      if (widget.adicional.nombre.contains('Solo Americana')) {
        // Combo Estrella: Solo 1 por combo (la pizza de 2 sabores)
        for (int i = 1; i <= widget.itemPedido.cantidad; i++) {
          pizzasExpandidas.add('Pizza 2 sabores (Cambiar a Americana) #$i');
        }
      } else if (widget.adicional.nombre.contains('Cambiar Hawaiana')) {
        // Oferta Dúo: Solo las hawaianas (1 por dúo)
        for (int i = 1; i <= widget.itemPedido.cantidad; i++) {
          pizzasExpandidas.add('Pizza Hawaiana (Cambiar a Americana) del Dúo #$i');
        }
      }
    }
    // 🔥 CASO ESPECIAL: Combo Compartir (2 americanas familiar y personal)
    else if (widget.itemPedido.nombre.toLowerCase().contains('combo compartir')) {
      for (int i = 1; i <= widget.itemPedido.cantidad; i++) {
        pizzasExpandidas.add('Pizza Americana (Familiar) del Combo #$i');
        pizzasExpandidas.add('Pizza Americana (Personal) del Combo #$i');
      }
    }
    // 🔥 CASO ESPECIAL: Combo Brother (3 pizzas personales)  
    else if (widget.itemPedido.nombre.toLowerCase().contains('combo brother')) {
      for (int i = 1; i <= widget.itemPedido.cantidad; i++) {
        pizzasExpandidas.add('Pizza Pepperoni del Combo #$i');
        pizzasExpandidas.add('Pizza Hawaiana del Combo #$i');
        pizzasExpandidas.add('Pizza Americana del Combo #$i');
      }
    }
    // 🔥 CASO ESPECIAL: Oferta Dúo (2 pizzas familiares)
    else if (widget.itemPedido.nombre.toLowerCase().contains('oferta dúo')) {
      for (int i = 1; i <= widget.itemPedido.cantidad; i++) {
        pizzasExpandidas.add('Pizza Hawaiana del Dúo #$i');
        pizzasExpandidas.add('Pizza Americana del Dúo #$i');
      }
    }
    // 🔥 EXPANSIÓN NORMAL PARA OTROS CASOS
    else {
      for (int i = 1; i <= widget.itemPedido.cantidad; i++) {
        for (String pizza in pizzasBase) {
          pizzasExpandidas.add('$pizza #$i');
        }
      }
    }
    
    return pizzasExpandidas;
  }

  // 🔥 OBTENER PIZZAS YA OCUPADAS
  Set<String> _getPizzasYaOcupadas() {
    Set<String> ocupadas = {};
    
    for (Adicional a in widget.itemPedido.adicionales) {
      if (a.nombre == widget.adicional.nombre && a.pizzaEspecifica != null) {
        ocupadas.add(a.pizzaEspecifica!);
      }
    }
    
    return ocupadas;
  }

  // 🔥 VALIDAR MÁXIMOS DISPONIBLES
  int _getMaximoPermitido() {
    if (_requiereSeleccionPorPizza()) {
      List<String> pizzasDisponibles = _getPizzasExpandidas();
      Set<String> pizzasOcupadas = _getPizzasYaOcupadas();
      return pizzasDisponibles.length - pizzasOcupadas.length;
    }
    
    // Para otros adicionales: máximo 10
    return 10;
  }

  @override
  Widget build(BuildContext context) {
    final pizzasDisponibles = _getPizzasExpandidas();
    final pizzasOcupadas = _getPizzasYaOcupadas();
    final pizzasLibres = pizzasDisponibles.where((p) => !pizzasOcupadas.contains(p)).toList();
    final requiereSeleccionPizzas = _requiereSeleccionPorPizza() && pizzasLibres.isNotEmpty;
    final maximoPermitido = _getMaximoPermitido();

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(20),
        constraints: const BoxConstraints(maxHeight: 650),
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

            // 🔥 VALIDAR SI HAY DISPONIBILIDAD
            if (maximoPermitido <= 0) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.block, color: Colors.red[700], size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Ya no puedes agregar más de este adicional. Todas las pizzas ya lo tienen.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.red[700],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Solo botón cerrar
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(
                    'Cerrar',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ] else ...[
              // 🔥 ADVERTENCIAS ESPECIALES
              if (_requiereSeleccionPorPizza()) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _esAdicionalEspecialGratuito() 
                        ? Colors.blue.withOpacity(0.1) 
                        : _esPrimeraGaseosa() 
                            ? Colors.green.withOpacity(0.1) 
                            : Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _esAdicionalEspecialGratuito() 
                          ? Colors.blue.withOpacity(0.3)
                          : _esPrimeraGaseosa() 
                              ? Colors.green.withOpacity(0.3) 
                              : Colors.orange.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _esAdicionalEspecialGratuito() 
                            ? Icons.swap_horiz
                            : _esPrimeraGaseosa() 
                                ? Icons.local_offer 
                                : Icons.info_outline,
                        color: _esAdicionalEspecialGratuito() 
                            ? Colors.blue[700]
                            : _esPrimeraGaseosa() 
                                ? Colors.green[700] 
                                : Colors.orange[700],
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _esAdicionalEspecialGratuito()
                              ? 'Cambio gratuito: Selecciona específicamente qué pizzas cambiar.'
                              : _esPrimeraGaseosa() 
                                  ? 'Primera gaseosa: Solo S/1.00 c/u. Selecciona a cuáles pizzas aplicar.'
                                  : 'Selecciona específicamente a qué pizzas aplicar el queso. Solo 1 queso por pizza.',
                          style: TextStyle(
                            fontSize: 12,
                            color: _esAdicionalEspecialGratuito() 
                                ? Colors.blue[700]
                                : _esPrimeraGaseosa() 
                                    ? Colors.green[700] 
                                    : Colors.orange[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // 🔥 SELECTOR DE PIZZAS ESPECÍFICAS CON LÓGICA MEJORADA
              if (requiereSeleccionPizzas) ...[
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
                          Icon(Icons.local_pizza, color: Colors.blue[600], size: 18),
                          const SizedBox(width: 6),
                          Text(
                            '¿Para qué pizzas específicamente?',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[600],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Marca solo las pizzas que quieres que tengan este adicional. No se cobrará por las no marcadas.',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.blue[600],
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const SizedBox(height: 10),
                      
                      // 🔥 LISTA SCROLLEABLE DE PIZZAS CON CHECKBOXES MEJORADA
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxHeight: 200),
                        child: SingleChildScrollView(
                          child: Column(
                            children: pizzasDisponibles.map((pizza) {
                              bool yaSeleccionada = pizzasSeleccionadas.contains(pizza);
                              bool yaOcupada = pizzasOcupadas.contains(pizza);
                              bool disponible = pizzasLibres.contains(pizza);
                              
                              return Container(
                                margin: const EdgeInsets.only(bottom: 4),
                                decoration: BoxDecoration(
                                  color: yaSeleccionada 
                                      ? colorSecundario.withOpacity(0.1)
                                      : yaOcupada
                                          ? Colors.grey.withOpacity(0.2)
                                          : Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: yaSeleccionada 
                                        ? colorSecundario
                                        : yaOcupada 
                                            ? Colors.grey
                                            : Colors.grey[300]!,
                                  ),
                                ),
                                child: CheckboxListTile(
                                  title: Text(
                                    pizza,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: yaOcupada ? Colors.grey[600] : Colors.black87,
                                      decoration: yaOcupada ? TextDecoration.lineThrough : null,
                                      fontWeight: yaSeleccionada ? FontWeight.w600 : FontWeight.normal,
                                    ),
                                  ),
                                  subtitle: yaOcupada 
                                      ? Text(
                                          'Ya tiene este adicional',
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.grey[600],
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ) 
                                      : yaSeleccionada 
                                          ? Text(
                                              '✅ Se aplicará este adicional',
                                              style: TextStyle(
                                                fontSize: 10,
                                                color: colorSecundario,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            )
                                          : null,
                                  value: yaSeleccionada,
                                  onChanged: !disponible ? null : (bool? value) {
                                    setState(() {
                                      if (value == true) {
                                        pizzasSeleccionadas.add(pizza);
                                      } else {
                                        pizzasSeleccionadas.remove(pizza);
                                      }
                                    });
                                  },
                                  activeColor: colorSecundario,
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                                  visualDensity: VisualDensity.compact,
                                  controlAffinity: ListTileControlAffinity.leading,
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 8),
                      
                      // 🔥 RESUMEN DE SELECCIÓN MEJORADO
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: pizzasSeleccionadas.isNotEmpty ? colorSecundario.withOpacity(0.1) : Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: pizzasSeleccionadas.isNotEmpty ? colorSecundario.withOpacity(0.3) : Colors.grey[300]!,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              pizzasSeleccionadas.isNotEmpty ? Icons.check_circle : Icons.info,
                              color: pizzasSeleccionadas.isNotEmpty ? colorSecundario : Colors.grey[600],
                              size: 16,
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                'Seleccionadas: ${pizzasSeleccionadas.length} pizza(s)',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: pizzasSeleccionadas.isNotEmpty ? colorSecundario : Colors.grey[600],
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'Disponibles: ${pizzasLibres.length}',
                                style: TextStyle(
                                  fontSize: 9,
                                  color: Colors.blue[600],
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // 🔢 SELECTOR DE CANTIDAD (SOLO PARA ADICIONALES QUE NO VAN POR PIZZA)
              if (!_requiereSeleccionPorPizza()) ...[
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
                            'Cantidad (Máx: $maximoPermitido)',
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
                              color: cantidad < maximoPermitido ? colorSecundario : Colors.grey,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: (cantidad < maximoPermitido ? colorSecundario : Colors.grey).withOpacity(0.3),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.add, color: Colors.white, size: 20),
                              onPressed: cantidad < maximoPermitido
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
              ],

              // 💰 PRECIO TOTAL CON LÓGICA CORREGIDA
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
                      widget.adicional.precio == 0.0 ? 'Cambio gratuito:' : _esPrimeraGaseosa() ? 'Precio especial:' : 'Precio total:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[700],
                      ),
                    ),
                    Text(
                      widget.adicional.precio == 0.0
                          ? 'GRATIS'
                          : _esPrimeraGaseosa()
                              ? 'S/${(1.0 * pizzasSeleccionadas.length).toStringAsFixed(2)}'
                              : requiereSeleccionPizzas
                                  ? 'S/${(widget.adicional.precio * pizzasSeleccionadas.length).toStringAsFixed(2)}'
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
                        onPressed: (requiereSeleccionPizzas && pizzasSeleccionadas.isEmpty)
                            ? null
                            : () {
                                List<String> pizzasParaAgregar = requiereSeleccionPizzas 
                                    ? pizzasSeleccionadas.toList()
                                    : [];
                                widget.onAgregar(cantidad, pizzasParaAgregar);
                                Navigator.of(context).pop();
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          foregroundColor: Colors.white,
                          shadowColor: Colors.transparent,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Text(
                          requiereSeleccionPizzas 
                              ? pizzasSeleccionadas.isEmpty
                                  ? 'Selecciona pizzas primero'
                                  : pizzasSeleccionadas.length == 1
                                      ? 'Agregar a 1 pizza'
                                      : 'Agregar a ${pizzasSeleccionadas.length} pizzas'
                              : 'Agregar x$cantidad',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
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
}