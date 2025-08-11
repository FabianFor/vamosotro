import 'package:flutter/material.dart';
import '../models/models.dart';

class MostritoCard extends StatelessWidget {
  final Mostrito mostrito;
  final VoidCallback onAgregarAlCarrito;

  const MostritoCard({
    super.key,
    required this.mostrito,
    required this.onAgregarAlCarrito,
  });

  // 🎨 COLORES
  static const Color colorPrimario = Color(0xFFD4332A); // Rojo
  static const Color colorSecundario = Color(0xFF2C5F2D); // Verde
  static const Color colorMostrito = Colors.orange; // Color especial para mostritos

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
          // 🍗 IMAGEN DEL MOSTRITO - SIN MARCO, IMAGEN COMPLETA VISIBLE
          Container(
            width: 120,
            height: 120,
            padding: const EdgeInsets.all(8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                mostrito.imagen,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[200],
                    child: const Icon(
                      Icons.fastfood,
                      size: 50,
                      color: Colors.orange,
                    ),
                  );
                },
              ),
            ),
          ),

          const SizedBox(width: 12), // Espacio normal

          // 📄 Texto + botón (igual estructura que pizza)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8), // Menos espacio vertical
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🏷️ BADGE DE MOSTRITO (igual que badge de tamaño en pizza)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: colorMostrito.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: colorMostrito.withOpacity(0.3),
                      ),
                    ),
                    child: Text(
                      'Mostrito',
                      style: TextStyle(
                        fontSize: 10,
                        color: colorMostrito,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 4),
                  
                  Text(
                    mostrito.nombre,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15, // Reducir un poco
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const SizedBox(height: 3),
                  
                  // 📝 DESCRIPCIÓN SIMPLE Y COMPACTA
                  Text(
                    mostrito.descripcion.replaceAll(' + ', ' • '),
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 11,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 8),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // 💰 PRECIO CON MEJOR DISEÑO (igual que pizza)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'S/ ${mostrito.precio.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.orange,
                            ),
                          ),
                          Text(
                            'Con bebida',
                            style: TextStyle(
                              fontSize: 9,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                      
                      // 🛒 BOTÓN AGREGAR (igual estilo que pizza pero color naranja)
                      Container(
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Colors.orange, Colors.deepOrange],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.orange.withOpacity(0.3),
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