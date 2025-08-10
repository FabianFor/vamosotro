import 'package:flutter/material.dart';
import '../models/models.dart';

class PizzaCard extends StatelessWidget {
  final Pizza pizza;
  final String tamano;
  final double precio;
  final VoidCallback onAgregarAlCarrito;

  const PizzaCard({
    super.key,
    required this.pizza,
    required this.tamano,
    required this.precio,
    required this.onAgregarAlCarrito,
  });

  // 🎨 COLORES ACTUALIZADOS IGUAL QUE EN HOME SCREEN
  static const Color colorPrimario = Color.fromARGB(255, 0, 255, 4);
  static const Color colorSecundario = Color(0xFFD4332A);
  static const Color colorAcento = Color(0xFFF4B942);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 6), // Reducir margen para pegar más las imágenes
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
          // 📸 Pizza sin borde blanco y pegada más cerca
          ClipRRect(
            borderRadius: BorderRadius.circular(0), // Eliminar el borde
            child: Transform.scale(
              scale: 1.4,
              child: Transform.translate(
                offset: const Offset(-20, 0), // Mover un poco a la izquierda
                child: Image.asset(
                  pizza.imagen,
                  width: 110,  // Tamaño ajustado para que sobresalga más
                  height: 140, // Tamaño ajustado para que sobresalga más
                  fit: BoxFit.contain, // Cambiado a BoxFit.contain
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 110,
                      height: 110,
                      color: const Color(0xFFF5F5F5),
                      child: Icon(
                        Icons.local_pizza,
                        size: 40,
                        color: colorSecundario,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),

          const SizedBox(width: 8), // Reducir el espacio entre las imágenes

          // 📄 Texto + botón (MEJORADO CON NUEVOS COLORES)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🏷️ BADGE DE TAMAÑO
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: tamano == 'Familiar' 
                          ? colorPrimario.withOpacity(0.1)
                          : colorSecundario.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: tamano == 'Familiar' 
                            ? colorPrimario.withOpacity(0.3)
                            : colorSecundario.withOpacity(0.3),
                      ),
                    ),
                    child: Text(
                      tamano,
                      style: TextStyle(
                        fontSize: 10,
                        color: tamano == 'Familiar' ? const Color.fromARGB(255, 51, 148, 52) : colorSecundario,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 6),
                  
                  Text(
                    pizza.nombre,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  
                  const SizedBox(height: 3),
                  
                  Text(
                    pizza.ingredientes,
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
                      // 💰 PRECIO CON MEJOR DISEÑO
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'S/ ${precio.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: colorSecundario,
                            ),
                          ),
                          if (tamano == 'Familiar')
                            Text(
                              'Para compartir',
                              style: TextStyle(
                                fontSize: 9,
                                color: Colors.grey[500],
                              ),
                            ),
                        ],
                      ),
                      
                      // 🛒 BOTÓN AGREGAR MEJORADO
                      Container(
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [const Color.fromARGB(255, 5, 255, 10), const Color.fromARGB(255, 0, 255, 4).withOpacity(0.8)],
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