import 'package:flutter/material.dart';
import '../models/models.dart';

class PizzaEspecialCard extends StatelessWidget {
  final PizzaEspecial pizzaEspecial;
  final VoidCallback onAgregarAlCarrito;

  const PizzaEspecialCard({
    super.key,
    required this.pizzaEspecial,
    required this.onAgregarAlCarrito,
  });

  // 🎨 COLORES
  static const Color colorPrimario = Color(0xFFD4332A); // Rojo
  static const Color colorEspecial = Colors.purple; // Color especial para pizzas especiales

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // 🍕 IMAGEN DE LA PIZZA ESPECIAL
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  pizzaEspecial.imagen,
                  fit: BoxFit.cover,
                  width: 100,
                  height: 100,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[200],
                      child: const Icon(
                        Icons.star,
                        size: 50,
                        color: Colors.purple,
                      ),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(width: 16),

            // 📄 CONTENIDO DE LA PIZZA ESPECIAL
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🏷️ ETIQUETA ESPECIAL
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: colorEspecial.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: colorEspecial.withOpacity(0.3)),
                    ),
                    child: Text(
                      '⭐ ${pizzaEspecial.tipo}',
                      style: TextStyle(
                        fontSize: 10,
                        color: colorEspecial.withOpacity(0.8),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  const SizedBox(height: 6),

                  // 🏆 NOMBRE DE LA PIZZA
                  Text(
                    pizzaEspecial.nombre,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.black87,
                      height: 1.2,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 8),

                  // 📝 DESCRIPCIÓN
                  Text(
                    pizzaEspecial.descripcion,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 12),

                  // 💰 PRECIO Y BOTÓN
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // 💵 PRECIO
                      Text(
                        'S/ ${pizzaEspecial.precio.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.purple,
                        ),
                      ),

                      // 🛒 BOTÓN AGREGAR
                      Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Colors.purple,
                              Colors.deepPurple,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.purple.withOpacity(0.4),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: onAgregarAlCarrito,
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.add_shopping_cart, size: 18, color: Colors.white),
                                  SizedBox(width: 6),
                                  Text(
                                    'AGREGAR',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
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
          ],
        ),
      ),
    );
  }
}