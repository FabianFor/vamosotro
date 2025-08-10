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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Mi Carrito', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFFFF6B35),
        iconTheme: const IconThemeData(color: Colors.white),
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
                      final esPersonalizable = item.tamano != 'Combo'; // 🔥 SOLO PIZZAS SON PERSONALIZABLES

                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            // 🔥 INFORMACIÓN PRINCIPAL DEL ITEM
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  // 🔥 IMAGEN CIRCULAR DEL PRODUCTO
                                  Container(
                                    width: 60,
                                    height: 60,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                    ),
                                    child: ClipOval(
                                      child: Image.asset(
                                        item.imagen,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Container(
                                            decoration: const BoxDecoration(
                                              color: Color(0xFFF5F5F5),
                                              shape: BoxShape.circle,
                                            ),
                                            child: Icon(
                                              item.tamano == 'Combo' ? Icons.restaurant_menu : Icons.local_pizza,
                                              size: 30,
                                              color: const Color(0xFFFF6B35),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),

                                  const SizedBox(width: 12),

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
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '${item.tamano} - S/${item.precioTotal.toStringAsFixed(2)}',
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 14,
                                          ),
                                        ),
                                        if (item.adicionales.isNotEmpty) ...[
                                          const SizedBox(height: 4),
                                          Wrap(
                                            children: item.adicionales.map((adicional) {
                                              return Container(
                                                margin: const EdgeInsets.only(right: 8, bottom: 4),
                                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                                decoration: BoxDecoration(
                                                  color: Colors.green[100],
                                                  borderRadius: BorderRadius.circular(12),
                                                  border: Border.all(color: Colors.green[300]!),
                                                ),
                                                child: Text(
                                                  '${adicional.icono} ${adicional.nombre}',
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    color: Colors.green[800],
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

                                  // 🔥 CONTROLES DE CANTIDAD
                                  Column(
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            icon: Icon(
                                              item.cantidad > 1 ? Icons.remove_circle : Icons.delete,
                                              color: Colors.red,
                                            ),
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
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: Colors.grey[100],
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              '${item.cantidad}',
                                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.add_circle, color: Colors.green),
                                            onPressed: () {
                                              setState(() {
                                                carritoLocal[index] = item.copyWith(cantidad: item.cantidad + 1);
                                                widget.onActualizar(carritoLocal);
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                      
                                      // 🔥 BOTÓN PERSONALIZAR EN ESPAÑOL
                                      if (esPersonalizable)
                                        TextButton.icon(
                                          onPressed: () {
                                            setState(() {
                                              if (isExpanded) {
                                                itemsExpandidos.remove(index);
                                              } else {
                                                itemsExpandidos.add(index);
                                              }
                                            });
                                          },
                                          icon: Icon(
                                            isExpanded ? Icons.expand_less : Icons.expand_more,
                                            color: const Color(0xFFFF6B35),
                                          ),
                                          label: Text(
                                            isExpanded ? 'Ocultar' : 'Personalizar',
                                            style: const TextStyle(color: Color(0xFFFF6B35), fontSize: 12),
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
                                color: const Color(0xFFFFF3E0),
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(Icons.restaurant, color: Color(0xFFFF6B35), size: 20),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Personaliza tu ${item.nombre}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFFFF6B35),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    
                                    // 🔥 LISTA DE ADICIONALES DISPONIBLES
                                    ...PizzaData.adicionalesDisponibles.map((adicional) {
                                      final isSelected = item.adicionales.any((a) => a.nombre == adicional.nombre);
                                      
                                      return Container(
                                        margin: const EdgeInsets.only(bottom: 8),
                                        decoration: BoxDecoration(
                                          color: isSelected ? Colors.green[100] : Colors.white,
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(
                                            color: isSelected ? Colors.green : Colors.grey[300]!,
                                          ),
                                        ),
                                        child: CheckboxListTile(
                                          title: Row(
                                            children: [
                                              Text(adicional.icono, style: const TextStyle(fontSize: 18)),
                                              const SizedBox(width: 8),
                                              Expanded(
                                                child: Text(
                                                  adicional.nombre,
                                                  style: const TextStyle(fontWeight: FontWeight.w500),
                                                ),
                                              ),
                                              Text(
                                                '+S/${adicional.precio.toStringAsFixed(0)}',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.green,
                                                ),
                                              ),
                                            ],
                                          ),
                                          value: isSelected,
                                          onChanged: (bool? value) {
                                            _toggleAdicional(index, adicional);
                                          },
                                          activeColor: Colors.green,
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
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 10,
                        offset: const Offset(0, -3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          Text('S/ ${total.toStringAsFixed(2)}',
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFFFF6B35))),
                        ],
                      ),
                      const SizedBox(height: 15),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: carritoLocal.isEmpty ? null : () => _procederAlPago(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF6B35),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text(
                            'PROCEDER AL PAGO', 
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
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
}