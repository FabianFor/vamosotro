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
  List<int> itemsExpandidos = []; // 🔥 PARA CONTROLAR CUÁLES ESTÁN EXPANDIDOS

  // 🎨 COLORES ACTUALIZADOS
  static const Color colorPrimario = Color(0xFFD4332A); // Rojo del logo
  static const Color colorSecundario = Color(0xFF2C5F2D); // Verde del logo
  static const Color colorAcento = Color(0xFFF4B942); // Amarillo/dorado

  @override
  void initState() {
    super.initState();
    carritoLocal = List.from(widget.carrito);
  }

  double get total {
    return carritoLocal.fold(0.0, (sum, item) => sum + (item.precioTotal * item.cantidad));
  }

  void _procederAlPago(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PagoScreen(
          carrito: carritoLocal,
          total: total,
        ),
      ),
    );
  }

  // 🔥 AGREGAR O QUITAR ADICIONAL
  void _toggleAdicional(int itemIndex, Adicional adicional) {
    setState(() {
      ItemPedido item = carritoLocal[itemIndex];
      List<Adicional> nuevosAdicionales = List.from(item.adicionales);

      if (nuevosAdicionales.any((a) => a.nombre == adicional.nombre)) {
        // Quitar adicional
        nuevosAdicionales.removeWhere((a) => a.nombre == adicional.nombre);
      } else {
        // Agregar adicional
        nuevosAdicionales.add(adicional);
      }

      carritoLocal[itemIndex] = item.copyWith(adicionales: nuevosAdicionales);
      widget.onActualizar(carritoLocal);
    });
  }

  // 🎯 OBTENER ADICIONALES DISPONIBLES SEGÚN EL TAMAÑO
  List<Adicional> _getAdicionalesDisponibles(String tamano) {
    return PizzaData.getAdicionalesDisponibles(tamano);
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
                    itemBuilder: (context, index) {
                      final item = carritoLocal[index];
                      final isExpanded = itemsExpandidos.contains(index);
                      final esPersonalizable = item.tamano != 'Combo Broaster' && 
                                             item.tamano != 'Mostrito'; // 🔥 SOLO PIZZAS Y FUSIONES SON PERSONALIZABLES

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
                                  // 🔥 IMAGEN ADAPTATIVA SEGÚN EL TIPO DE PRODUCTO
                                  Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      // Solo circular para pizzas, rectangular para el resto
                                      shape: (item.tamano == 'Familiar' || item.tamano == 'Personal') 
                                          ? BoxShape.circle 
                                          : BoxShape.rectangle,
                                      borderRadius: (item.tamano == 'Familiar' || item.tamano == 'Personal') 
                                          ? null 
                                          : BorderRadius.circular(12), // Bordes redondeados para combos
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
                                    child: (item.tamano == 'Familiar' || item.tamano == 'Personal') 
                                        ? ClipOval( // Solo clip circular para pizzas
                                            child: Image.asset(
                                              item.imagen,
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error, stackTrace) {
                                                return Container(
                                                  decoration: BoxDecoration(
                                                    color: const Color(0xFFF5F5F5),
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                      color: colorPrimario,
                                                      width: 2,
                                                    ),
                                                  ),
                                                  child: Icon(
                                                    Icons.local_pizza,
                                                    size: 30,
                                                    color: colorPrimario,
                                                  ),
                                                );
                                              },
                                            ),
                                          )
                                        : ClipRRect( // Clip rectangular para todo lo demás
                                            borderRadius: BorderRadius.circular(12),
                                            child: Image.asset(
                                              item.imagen,
                                              fit: BoxFit.contain, // contain para mostrar imagen completa
                                              errorBuilder: (context, error, stackTrace) {
                                                return Container(
                                                  decoration: BoxDecoration(
                                                    color: const Color(0xFFF5F5F5),
                                                    borderRadius: BorderRadius.circular(12),
                                                    border: Border.all(
                                                      color: colorPrimario,
                                                      width: 2,
                                                    ),
                                                  ),
                                                  child: Icon(
                                                    item.tamano.contains('Combo') ? Icons.restaurant_menu : 
                                                    item.tamano == 'Mostrito' ? Icons.fastfood : 
                                                    item.tamano == 'Fusión' ? Icons.auto_awesome :
                                                    Icons.local_pizza,
                                                    size: 30,
                                                    color: colorPrimario,
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                  ),

                                  const SizedBox(width: 16),

                                  // 🔥 INFORMACIÓN Y CONTROLES
                                  Expanded(
                                    child: Column(
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
                                        // 💰 PRECIO SEPARADO
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
                                    ),
                                  ),

                                  // 🔥 CONTROLES DE CANTIDAD - BOTONES MÁS PEQUEÑOS
                                  Column(
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
                                              onPressed: () {
                                                setState(() {
                                                  if (item.cantidad > 1) {
                                                    carritoLocal[index] = item.copyWith(cantidad: item.cantidad - 1);
                                                  } else {
                                                    carritoLocal.removeAt(index);
                                                    itemsExpandidos.remove(index);
                                                    // Reajustar índices expandidos
                                                    itemsExpandidos = itemsExpandidos.map((i) => i > index ? i - 1 : i).toList();
                                                  }
                                                  widget.onActualizar(carritoLocal);
                                                });
                                              },
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
                                                color: colorAcento.withOpacity(0.8),
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
                                              onPressed: () {
                                                setState(() {
                                                  carritoLocal[index] = item.copyWith(cantidad: item.cantidad + 1);
                                                  widget.onActualizar(carritoLocal);
                                                });
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                      
                                      const SizedBox(height: 6),
                                      
                                      // 🔥 BOTÓN PERSONALIZAR MÁS PEQUEÑO
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
                                            onTap: () {
                                              setState(() {
                                                if (isExpanded) {
                                                  itemsExpandidos.remove(index);
                                                } else {
                                                  itemsExpandidos.add(index);
                                                }
                                              });
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(
                                                    isExpanded ? Icons.expand_less : Icons.expand_more,
                                                    color: colorAcento,
                                                    size: 14,
                                                  ),
                                                  const SizedBox(width: 2),
                                                  Text(
                                                    isExpanded ? 'Ocultar' : 'Extras',
                                                    style: TextStyle(
                                                      color: colorAcento,
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
                                  ),
                                ],
                              ),
                            ),

                            // 🔥 SECCIÓN EXPANDIBLE DE ADICIONALES
                            if (isExpanded && esPersonalizable) ...[
                              Container(
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
                                    
                                    // 🔥 LISTA DE ADICIONALES DISPONIBLES POR TAMAÑO
                                    ..._getAdicionalesDisponibles(item.tamano).map((adicional) {
                                      final isSelected = item.adicionales.any((a) => a.nombre == adicional.nombre);
                                      
                                      return Container(
                                        margin: const EdgeInsets.only(bottom: 8),
                                        decoration: BoxDecoration(
                                          color: isSelected ? colorSecundario.withOpacity(0.1) : Colors.white,
                                          borderRadius: BorderRadius.circular(12),
                                          border: Border.all(
                                            color: isSelected ? colorSecundario : Colors.grey[300]!,
                                            width: isSelected ? 2 : 1,
                                          ),
                                          boxShadow: isSelected ? [
                                            BoxShadow(
                                              color: colorSecundario.withOpacity(0.2),
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
                                                  color: isSelected ? colorSecundario.withOpacity(0.2) : Colors.grey[100],
                                                  borderRadius: BorderRadius.circular(6),
                                                ),
                                                child: Text(adicional.icono, style: const TextStyle(fontSize: 16)),
                                              ),
                                              const SizedBox(width: 8),
                                              Expanded(
                                                child: Text(
                                                  adicional.nombre,
                                                  style: TextStyle(
                                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                                    color: isSelected ? colorSecundario : Colors.black87,
                                                    fontSize: 13,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                                decoration: BoxDecoration(
                                                  color: isSelected ? colorSecundario : colorAcento,
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                                child: Text(
                                                  '+S/${adicional.precio.toStringAsFixed(0)}',
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
                                            _toggleAdicional(index, adicional);
                                          },
                                          activeColor: colorSecundario,
                                          contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                                        ),
                                      );
                                    }).toList(),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      );
                    },
                  ),
                ),

                // 🔥 FOOTER CON TOTAL Y BOTÓN DE PAGO EN ESPAÑOL
                Container(
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
                              'S/ ${total.toStringAsFixed(2)}',
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
                ),
              ],
            ),
    );
  }

  // 🎨 MÉTODO PARA OBTENER COLOR SEGÚN EL TAMAÑO
  Color _getTamanoColor(String tamano) {
    switch (tamano) {
      case 'Familiar':
        return colorPrimario;
      case 'Personal':
        return colorSecundario;
      case 'Mostrito':
        return Colors.orange;
      case '2 Sabores':
      case '4 Sabores':
        return Colors.purple;
      case 'Combo Broaster':
        return Colors.brown;
      case 'Fusión':
        return Colors.deepPurple;
      default:
        return colorAcento;
    }
  }
}