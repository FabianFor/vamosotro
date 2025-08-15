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
  // 🚀 CACHE PARA WIDGETS DE IMÁGENES
  late Map<String, Widget> _imagenesCache;
  
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
    _imagenesCache = {}; // 🚀 NUEVO CACHE DE IMÁGENES
    
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
          _mostrarError('Máximo ${maxPrimerasGaseosas} primera(s) gaseosa(s)');
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
              _mostrarError('Pizza ya tiene queso');
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

      // 🔥 MOSTRAR CONFIRMACIÓN SIMPLE
      _mostrarExito('✅ Agregado');
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
    return adicional.nombre.toLowerCase().contains('queso adicional');
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

  // 🔥 MÉTODO PARA QUITAR UNA UNIDAD DE ADICIONAL (ELIMINAMOS EL BORRAR COMPLETO)
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

  // 🔥 MENSAJES SIMPLIFICADOS
  void _mostrarError(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje, style: const TextStyle(fontSize: 13)),
        backgroundColor: Colors.red[600],
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _mostrarExito(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje, style: const TextStyle(fontSize: 13)),
        backgroundColor: colorSecundario,
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  // 🚀 NUEVA FUNCIÓN: Crear widget de imagen optimizado con cache
  Widget _buildImagenOptimizada(String rutaImagen, String cacheKey, {
    required double width,
    required double height,
    required bool esCircular,
    required BoxFit boxFit,
  }) {
    // Verificar si ya está en cache
    if (_imagenesCache.containsKey(cacheKey)) {
      return _imagenesCache[cacheKey]!;
    }

    // Crear widget de imagen optimizado
    Widget imagenWidget = Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        shape: esCircular ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: esCircular ? null : BorderRadius.circular(10),
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
        borderRadius: esCircular ? BorderRadius.circular(width / 2) : BorderRadius.circular(10),
        child: Image.asset(
          rutaImagen,
          fit: boxFit,
          // 🚀 OPTIMIZACIONES DE IMAGEN CRÍTICAS
          cacheWidth: (width * MediaQuery.of(context).devicePixelRatio).round(),
          cacheHeight: (height * MediaQuery.of(context).devicePixelRatio).round(),
          filterQuality: FilterQuality.low, // Reduce calidad para mejor rendimiento
          errorBuilder: (context, error, stackTrace) {
            return Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: esCircular ? BorderRadius.circular(width / 2) : BorderRadius.circular(10),
                border: Border.all(color: colorPrimario, width: 2),
              ),
              child: Icon(
                _getIconoProducto(cacheKey.split('_').last),
                size: width * 0.5,
                color: colorPrimario,
              ),
            );
          },
        ),
      ),
    );

    // Guardar en cache
    _imagenesCache[cacheKey] = imagenWidget;
    return imagenWidget;
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
                    padding: const EdgeInsets.all(12),
                    itemCount: carritoLocal.length,
                    // 🚀 OPTIMIZACIONES CRÍTICAS DEL LISTVIEW
                    cacheExtent: 200, // Reducido para mejor memoria
                    addAutomaticKeepAlives: false, // Evita mantener widgets en memoria
                    addRepaintBoundaries: false, // Reduce complejidad de repaint
                    itemBuilder: (context, index) => _buildCarritoItemOptimizado(index),
                  ),
                ),
                _buildFooterCarrito(),
              ],
            ),
    );
  }

  // 🚀 VERSIÓN OPTIMIZADA DEL ITEM DEL CARRITO
  Widget _buildCarritoItemOptimizado(int index) {
    final item = carritoLocal[index];
    final isExpanded = itemsExpandidos.contains(index);
    final esPersonalizable = item.tamano != 'Combo Broaster';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.12),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 3),
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
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                _buildImagenItemOptimizada(item),
                const SizedBox(width: 14),
                Expanded(child: _buildInfoItem(item)),
                _buildControlesItem(item, index),
              ],
            ),
          ),

          // 🔥 ADICIONALES AGREGADOS (CON CONTROLES SIMPLIFICADOS)
          if (item.adicionales.isNotEmpty)
            _buildAdicionalesActuales(item, index),

          // 🔥 SECCIÓN EXPANDIBLE DE ADICIONALES DISPONIBLES
          if (isExpanded && esPersonalizable) 
            _buildSeccionAdicionales(item, index),
        ],
      ),
    );
  }

  // 🚀 VERSIÓN OPTIMIZADA DE LA IMAGEN DEL ITEM
  Widget _buildImagenItemOptimizada(ItemPedido item) {
    final esCircular = 
        item.tamano == 'Familiar' || 
        item.tamano == 'Personal' || 
        item.tamano == 'Extra Grande';
    
    String cacheKey = '${item.nombre}_${item.tamano}_${item.imagen}';
    
    return _buildImagenOptimizada(
      item.imagen, 
      cacheKey,
      width: 55,
      height: 55,
      esCircular: esCircular,
      boxFit: esCircular ? BoxFit.cover : BoxFit.contain,
    );
  }

  Widget _buildImagenItem(ItemPedido item) {
    final esCircular = 
        item.tamano == 'Familiar' || 
        item.tamano == 'Personal' || 
        item.tamano == 'Extra Grande';
    
    return Container(
      width: 55,
      height: 55,
      decoration: BoxDecoration(
        shape: esCircular ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: esCircular ? null : BorderRadius.circular(10),
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
        borderRadius: esCircular ? BorderRadius.circular(27.5) : BorderRadius.circular(10),
        child: Image.asset(
          item.imagen,
          fit: esCircular ? BoxFit.cover : BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: esCircular ? BorderRadius.circular(27.5) : BorderRadius.circular(10),
                border: Border.all(color: colorPrimario, width: 2),
              ),
              child: Icon(
                _getIconoProducto(item.tamano),
                size: 26,
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
            fontSize: 15,
            color: Colors.black87,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: _getTamanoColor(item.tamano).withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: _getTamanoColor(item.tamano).withOpacity(0.3),
            ),
          ),
          child: Text(
            item.tamano,
            style: TextStyle(
              color: _getTamanoColor(item.tamano),
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'S/${item.precioTotalCarrito.toStringAsFixed(2)}',
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
      ],
    );
  }

  // 🔥 SECCIÓN DE ADICIONALES SIMPLIFICADA - SIN BOTÓN BORRAR COMPLETO
  Widget _buildAdicionalesActuales(ItemPedido item, int index) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8, left: 14, right: 14),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: colorSecundario.withOpacity(0.05),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: colorSecundario.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.add_circle_outline, color: colorSecundario, size: 14),
              const SizedBox(width: 4),
              Text(
                'Adicionales (${item.adicionales.length})',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: colorSecundario,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          // 🚀 USAR LISTVIEW.BUILDER PARA ADICIONALES SI HAY MUCHOS
          ...item.adicionales.asMap().entries.map((entry) {
            int adicionalIndex = entry.key;
            Adicional adicional = entry.value;
            
            return _buildAdicionalActualOptimizado(adicional, adicionalIndex, index);
          }).toList(),
        ],
      ),
    );
  }

  // 🚀 WIDGET OPTIMIZADO PARA ADICIONAL ACTUAL
  Widget _buildAdicionalActualOptimizado(Adicional adicional, int adicionalIndex, int itemIndex) {
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
          // 🚀 IMAGEN OPTIMIZADA MÁS PEQUEÑA
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: adicional.imagen.isNotEmpty
                  ? Image.asset(
                      adicional.imagen,
                      fit: BoxFit.contain,
                      // 🚀 OPTIMIZACIÓN DE IMAGEN PEQUEÑA
                      cacheWidth: 56, // 28 * 2 (devicePixelRatio promedio)
                      cacheHeight: 56,
                      filterQuality: FilterQuality.low,
                      errorBuilder: (context, error, stackTrace) {
                        return Center(
                          child: Text(adicional.icono, style: const TextStyle(fontSize: 11)),
                        );
                      },
                    )
                  : Center(
                      child: Text(adicional.icono, style: const TextStyle(fontSize: 11)),
                    ),
            ),
          ),
          const SizedBox(width: 8),
          
          // 🔥 INFO DEL ADICIONAL COMPACTA
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                                  Text(
                  adicional.nombre,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (adicional.pizzaEspecifica != null) ...[
                  const SizedBox(height: 1),
                  Text(
                    adicional.pizzaEspecifica!.length > 20 
                        ? '${adicional.pizzaEspecifica!.substring(0, 17)}...'
                        : adicional.pizzaEspecifica!,
                    style: TextStyle(
                      fontSize: 8,
                      color: Colors.blue[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ],
            ),
          ),
          
          // 🔥 CONTROLES SIMPLIFICADOS - SOLO CANTIDAD Y QUITAR
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // CANTIDAD
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: colorAcento,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'x${adicional.cantidad}',
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              
              // PRECIO
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.green.withOpacity(0.3)),
                ),
                child: Text(
                  adicional.precio == 0.0 
                      ? 'GRATIS'
                      : '+S/${(adicional.precio * adicional.cantidad).toStringAsFixed(1)}',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.green[700],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              
              // 🔥 SOLO BOTÓN QUITAR (-1) - YA NO HAY BORRAR COMPLETO
              GestureDetector(
                onTap: () => _quitarAdicional(itemIndex, adicionalIndex),
                child: Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    color: adicional.cantidad > 1 ? const Color.fromARGB(255, 255, 0, 0) : Colors.red,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Icon(
                    adicional.cantidad > 1 ? Icons.remove : Icons.delete,
                    size: 12,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
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
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: item.cantidad > 1 ? colorPrimario : Colors.red,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: (item.cantidad > 1 ? colorPrimario : Colors.red).withOpacity(0.3),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: IconButton(
                icon: Icon(
                  item.cantidad > 1 ? Icons.remove : Icons.delete,
                  color: Colors.white,
                  size: 12,
                ),
                padding: EdgeInsets.zero,
                onPressed: () => _modificarCantidad(index, item.cantidad - 1),
              ),
            ),
            
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 6),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [colorAcento.withOpacity(0.2), Colors.white],
                ),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: colorAcento.withOpacity(0.3)),
              ),
              child: Text(
                '${item.cantidad}',
                style: TextStyle(
                  fontSize: 12, 
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.8),
                ),
              ),
            ),
            
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: colorSecundario,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: colorSecundario.withOpacity(0.3),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(Icons.add, color: Colors.white, size: 12),
                padding: EdgeInsets.zero,
                onPressed: () => _modificarCantidad(index, item.cantidad + 1),
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 4),
        
        if (esPersonalizable)
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  colorAcento.withOpacity(0.1),
                  Colors.transparent,
                ],
              ),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: colorAcento.withOpacity(0.3)),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(6),
              onTap: () => _toggleExpansion(index),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                      color: const Color.fromARGB(255, 0, 0, 0),
                      size: 14,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      isExpanded ? 'Ocultar' : 'Adicionales',
                      style: TextStyle(
                        color: const Color.fromARGB(255, 0, 0, 0),
                        fontSize: 10,
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
            colorAcento.withOpacity(0.08),
            Colors.white,
          ],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(14),
          bottomRight: Radius.circular(14),
        ),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: colorAcento,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(Icons.restaurant, color: Colors.white, size: 14),
              ),
              const SizedBox(width: 6),
              Text(
                'Agregar adicionales',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 0, 0, 0),
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          
          // 🚀 OPTIMIZACIÓN: Usar ListView.builder si hay muchos adicionales
          if (adicionalesDisponibles.length > 6) ...[
            SizedBox(
              height: 200,
              child: ListView.builder(
                itemCount: adicionalesDisponibles.length,
                itemBuilder: (context, adicionalIndex) => 
                    _buildAdicionalDisponible(adicionalesDisponibles[adicionalIndex], item, index),
              ),
            ),
          ] else ...[
            ...adicionalesDisponibles.map((adicional) => _buildAdicionalDisponible(adicional, item, index)),
          ],
        ],
      ),
    );
  }

  // 🔥 WIDGET PARA ADICIONAL DISPONIBLE - COMPACTO Y OPTIMIZADO
  Widget _buildAdicionalDisponible(Adicional adicional, ItemPedido item, int index) {
    int cantidadActual = _getCantidadActualAdicional(item, adicional);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[300]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            // 🚀 IMAGEN OPTIMIZADA DEL ADICIONAL
            Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: adicional.imagen.isNotEmpty
                    ? Image.asset(
                        adicional.imagen,
                        fit: BoxFit.contain,
                        // 🚀 OPTIMIZACIÓN ESPECÍFICA PARA ADICIONALES
                        cacheWidth: 70, // 35 * 2
                        cacheHeight: 70,
                        filterQuality: FilterQuality.low,
                        errorBuilder: (context, error, stackTrace) {
                          return Center(
                            child: Text(adicional.icono, style: const TextStyle(fontSize: 14)),
                          );
                        },
                      )
                    : Center(
                        child: Text(adicional.icono, style: const TextStyle(fontSize: 14)),
                      ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    adicional.nombre,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                  if (cantidadActual > 0)
                    Text(
                      'Ya tienes: $cantidadActual',
                      style: const TextStyle(
                        fontSize: 8,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
              decoration: BoxDecoration(
                color: colorAcento,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                adicional.precio == 0.0 ? 'GRATIS' : '+S/${adicional.precio.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontSize: 9,
                ),
              ),
            ),
            const SizedBox(width: 6),
            GestureDetector(
              onTap: () => _mostrarDialogAdicional(index, adicional),
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: colorSecundario,
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: [
                    BoxShadow(
                      color: colorSecundario.withOpacity(0.3),
                      blurRadius: 2,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 14,
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
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(18),
          topRight: Radius.circular(18),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.25),
            spreadRadius: 1,
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white,
            colorAcento.withOpacity(0.04),
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
                  fontSize: 18, 
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                )
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [colorPrimario, colorPrimario.withOpacity(0.8)],
                  ),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: colorPrimario.withOpacity(0.3),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  'S/ ${_totalCacheado.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 18, 
                    fontWeight: FontWeight.bold, 
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [const Color.fromARGB(255, 38, 139, 40), const Color.fromARGB(255, 29, 172, 32).withOpacity(0.8)],
              ),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: colorSecundario.withOpacity(0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: carritoLocal.isEmpty ? null : () => _procederAlPago(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.white,
                shadowColor: Colors.transparent,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.payment, size: 18),
                  SizedBox(width: 6),
                  Text(
                    'PROCEDER AL PAGO', 
                    style: TextStyle(
                      fontSize: 15, 
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.4,
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

// 🔥 DIALOG SIMPLIFICADO CON MENOS ADVERTENCIAS - VERSIÓN OPTIMIZADA
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
    if (_requiereSeleccionPorPizza()) {
      cantidad = 1;
    }
  }

  bool _requiereSeleccionPorPizza() {
    return _esPrimeraGaseosa() || 
           _esQuesoAdicional() || 
           _esAdicionalEspecialGratuito();
  }

  bool _esPrimeraGaseosa() {
    return widget.adicional.nombre.toLowerCase().contains('primera');
  }

  bool _esQuesoAdicional() {
    return widget.adicional.nombre.toLowerCase().contains('queso adicional');
  }

  bool _esAdicionalEspecialGratuito() {
    return widget.adicional.nombre.contains('Solo Americana') || 
           widget.adicional.nombre.contains('Cambiar Hawaiana');
  }

  List<String> _getPizzasExpandidas() {
    List<String> pizzasBase = [];
    
    if (_esAdicionalEspecialGratuito()) {
      if (widget.adicional.nombre.contains('Solo Americana')) {
        pizzasBase = ['Pizza 2 sabores (Cambiar a Americana)'];
      } else if (widget.adicional.nombre.contains('Cambiar Hawaiana')) {
        pizzasBase = ['Pizza Hawaiana (Cambiar a Americana)'];
      }
    } else if (_esPrimeraGaseosa()) {
      pizzasBase = ['Pizza Personal'];
    } else {
      if (PizzaData.esComboMultiplePizzas(widget.itemPedido.nombre)) {
        pizzasBase = PizzaData.getPizzasEnCombo(widget.itemPedido.nombre);
      } else {
        pizzasBase = ['${widget.itemPedido.nombre} (${widget.itemPedido.tamano})'];
      }
    }
    
    List<String> pizzasExpandidas = [];
    
    if (_esAdicionalEspecialGratuito()) {
      if (widget.adicional.nombre.contains('Solo Americana')) {
        for (int i = 1; i <= widget.itemPedido.cantidad; i++) {
          pizzasExpandidas.add('Pizza 2 sabores (Cambiar a Americana) #$i');
        }
      } else if (widget.adicional.nombre.contains('Cambiar Hawaiana')) {
        for (int i = 1; i <= widget.itemPedido.cantidad; i++) {
          pizzasExpandidas.add('Pizza Hawaiana (Cambiar a Americana) del Dúo #$i');
        }
      }
    }
    else if (widget.itemPedido.nombre.toLowerCase().contains('combo compartir')) {
      for (int i = 1; i <= widget.itemPedido.cantidad; i++) {
        pizzasExpandidas.add('Pizza Americana (Familiar) del Combo #$i');
        pizzasExpandidas.add('Pizza Americana (Personal) del Combo #$i');
      }
    }
    else if (widget.itemPedido.nombre.toLowerCase().contains('combo brother')) {
      for (int i = 1; i <= widget.itemPedido.cantidad; i++) {
        pizzasExpandidas.add('Pizza Pepperoni del Combo #$i');
        pizzasExpandidas.add('Pizza Hawaiana del Combo #$i');
        pizzasExpandidas.add('Pizza Americana del Combo #$i');
      }
    }
    else if (widget.itemPedido.nombre.toLowerCase().contains('oferta dúo')) {
      for (int i = 1; i <= widget.itemPedido.cantidad; i++) {
        pizzasExpandidas.add('Pizza Hawaiana del Dúo #$i');
        pizzasExpandidas.add('Pizza Americana del Dúo #$i');
      }
    }
    else {
      for (int i = 1; i <= widget.itemPedido.cantidad; i++) {
        for (String pizza in pizzasBase) {
          pizzasExpandidas.add('$pizza #$i');
        }
      }
    }
    
    return pizzasExpandidas;
  }

  Set<String> _getPizzasYaOcupadas() {
    Set<String> ocupadas = {};
    
    for (Adicional a in widget.itemPedido.adicionales) {
      if (a.nombre == widget.adicional.nombre && a.pizzaEspecifica != null) {
        ocupadas.add(a.pizzaEspecifica!);
      }
    }
    
    return ocupadas;
  }

  int _getMaximoPermitido() {
    if (_requiereSeleccionPorPizza()) {
      List<String> pizzasDisponibles = _getPizzasExpandidas();
      Set<String> pizzasOcupadas = _getPizzasYaOcupadas();
      return pizzasDisponibles.length - pizzasOcupadas.length;
    }
    
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(18),
        constraints: const BoxConstraints(maxHeight: 580),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              colorAcento.withOpacity(0.04),
            ],
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 🔥 TÍTULO COMPACTO CON IMAGEN OPTIMIZADA
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: colorAcento.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: colorAcento.withOpacity(0.3)),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: widget.adicional.imagen.isNotEmpty
                        ? Image.asset(
                            widget.adicional.imagen,
                            fit: BoxFit.contain,
                            // 🚀 OPTIMIZACIÓN DE IMAGEN DEL DIALOG
                            cacheWidth: 80, // 40 * 2
                            cacheHeight: 80,
                            filterQuality: FilterQuality.low,
                            errorBuilder: (context, error, stackTrace) {
                              return Center(
                                child: Text(
                                  widget.adicional.icono,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              );
                            },
                          )
                        : Center(
                            child: Text(
                              widget.adicional.icono,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Agregar adicional',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 11, 216, 14),
                        ),
                      ),
                      Text(
                        widget.adicional.nombre,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),

            if (maximoPermitido <= 0) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.withOpacity(0.3)),
                ),
                child: Text(
                  'Ya no se puede agregar más de este adicional',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.red[700],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cerrar'),
                ),
              ),
            ] else ...[
              
              // 🔥 SELECTOR DE PIZZAS SIMPLIFICADO Y OPTIMIZADO
              if (requiereSeleccionPizzas) ...[
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.04),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue.withOpacity(0.2)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Selecciona las pizzas específicas:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[600],
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 8),
                      
                      // 🚀 LISTA OPTIMIZADA CON VIEWPORT LIMITADO
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxHeight: 180),
                        child: ListView.builder(
                          // 🚀 OPTIMIZACIONES PARA LISTA DE PIZZAS
                          shrinkWrap: true,
                          itemCount: pizzasDisponibles.length,
                          cacheExtent: 100,
                          addAutomaticKeepAlives: false,
                          addRepaintBoundaries: false,
                          itemBuilder: (context, index) {
                            String pizza = pizzasDisponibles[index];
                            bool yaSeleccionada = pizzasSeleccionadas.contains(pizza);
                            bool yaOcupada = pizzasOcupadas.contains(pizza);
                            bool disponible = pizzasLibres.contains(pizza);
                            
                            return Container(
                              margin: const EdgeInsets.only(bottom: 3),
                              decoration: BoxDecoration(
                                color: yaSeleccionada 
                                    ? colorSecundario.withOpacity(0.1)
                                    : yaOcupada
                                        ? Colors.grey.withOpacity(0.1)
                                        : Colors.white,
                                borderRadius: BorderRadius.circular(6),
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
                                    fontSize: 11,
                                    color: yaOcupada ? Colors.grey[600] : Colors.black87,
                                    decoration: yaOcupada ? TextDecoration.lineThrough : null,
                                    fontWeight: yaSeleccionada ? FontWeight.w600 : FontWeight.normal,
                                  ),
                                ),
                                subtitle: yaOcupada 
                                    ? const Text(
                                        'Ya lo tiene',
                                        style: TextStyle(fontSize: 9, color: Colors.grey),
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
                                contentPadding: const EdgeInsets.symmetric(horizontal: 6),
                                visualDensity: VisualDensity.compact,
                                controlAffinity: ListTileControlAffinity.leading,
                              ),
                            );
                          },
                        ),
                      ),
                      
                      const SizedBox(height: 6),
                      
                      Text(
                        'Seleccionadas: ${pizzasSeleccionadas.length} pizza(s)',
                        style: TextStyle(
                          fontSize: 10,
                          color: colorSecundario,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
              ],

              // 🔢 SELECTOR DE CANTIDAD COMPACTO
              if (!_requiereSeleccionPorPizza()) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colorSecundario.withOpacity(0.04),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: colorSecundario.withOpacity(0.2)),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Cantidad (Máx: $maximoPermitido)',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: colorSecundario,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: cantidad > 1 ? colorPrimario : Colors.grey,
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.remove, color: Colors.white, size: 16),
                              onPressed: cantidad > 1
                                  ? () {
                                      setState(() {
                                        cantidad--;
                                      });
                                    }
                                  : null,
                            ),
                          ),
                          
                          const SizedBox(width: 15),
                          
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [colorAcento, colorAcento.withOpacity(0.8)],
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '$cantidad',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          
                          const SizedBox(width: 15),
                          
                          Container(
                            decoration: BoxDecoration(
                              color: cantidad < maximoPermitido ? colorSecundario : Colors.grey,
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.add, color: Colors.white, size: 16),
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
                const SizedBox(height: 14),
              ],

              // 💰 PRECIO TOTAL
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.green.withOpacity(0.08), Colors.green.withOpacity(0.04)],
                  ),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Precio total:',
                      style: TextStyle(
                        fontSize: 14,
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
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[700],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // 🚀 BOTONES OPTIMIZADOS
              Row(
                children: [
                  // Botón Cancelar (Rojo)
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Cancelar',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Botón Agregar (Verde)
                  Expanded(
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
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        requiereSeleccionPizzas
                            ? pizzasSeleccionadas.isEmpty
                                ? 'Selecciona'
                                : 'Agregar (${pizzasSeleccionadas.length})'
                            : 'Agregar x$cantidad',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
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
