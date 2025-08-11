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

  // 🎨 COLORES ACTUALIZADOS IGUAL QUE EN PIZZA_CARD
  static const Color colorPrimario = Color.fromRGBO(19, 182, 22, 1);
  static const Color colorSecundario = Color(0xFFD4332A);
  static const Color colorEspecial = Colors.purple; // Color especial para pizzas especiales

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 6), // Mismo margen que pizza_card
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
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          // 🍕 Pizza especial sin borde blanco y pegada más cerca (EXACTAMENTE IGUAL QUE PIZZA_CARD)
          ClipRRect(
            borderRadius: BorderRadius.circular(0), // Eliminar el borde
            child: Transform.scale(
              scale: 1.4,
              child: Transform.translate(
                offset: const Offset(-20, 0), // Mover un poco a la izquierda
                child: Image.asset(
                  pizzaEspecial.imagen,
                  width: 110,  // Tamaño ajustado para que sobresalga más
                  height: 140, // Tamaño ajustado para que sobresalga más
                  fit: BoxFit.contain, // Cambiado a BoxFit.contain
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 110,
                      height: 110,
                      color: const Color(0xFFF5F5F5),
                      child: const Icon(
                        Icons.star,
                        size: 40,
                        color: Colors.purple,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),

          const SizedBox(width: 8), // Reducir el espacio entre las imágenes

          // 📄 Texto + botón (EXACTAMENTE IGUAL QUE PIZZA_CARD)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🏷️ BADGE DE TIPO (igual que badge de tamaño en pizza)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: colorEspecial.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: colorEspecial.withOpacity(0.3),
                      ),
                    ),
                    child: Text(
                      pizzaEspecial.tipo,
                      style: TextStyle(
                        fontSize: 10,
                        color: colorEspecial,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 6),
                  
                  Text(
                    pizzaEspecial.nombre,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  
                  const SizedBox(height: 3),
                  
                  Text(
                    pizzaEspecial.descripcion,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                      height: 1.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 10),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // 💰 PRECIO CON MEJOR DISEÑO (igual que pizza)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'S/ ${pizzaEspecial.precio.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.purple,
                            ),
                          ),
                          Text(
                            'Especial',
                            style: TextStyle(
                              fontSize: 9,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                      
                      // 🛒 BOTÓN AGREGAR (igual estilo que pizza pero color púrpura)
                      Container(
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Colors.purple, Colors.deepPurple],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.purple.withOpacity(0.3),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: onAgregarAlCarrito,
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.add, size: 16, color: Colors.white),
                                  SizedBox(width: 4),
                                  Text(
                                    'AGREGAR',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
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
          ),
        ],
      ),
    );
  }
}