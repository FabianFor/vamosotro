import 'package:flutter/material.dart';
import '../models/models.dart';

class ComboCard extends StatelessWidget {
  final Combo combo;
  final VoidCallback onAgregarAlCarrito;

  const ComboCard({
    super.key,
    required this.combo,
    required this.onAgregarAlCarrito,
  });

  // 🎨 COLORES ACTUALIZADOS
  static const Color colorPrimario = Color(0xFFD4332A); // Rojo como principal
  static const Color colorSecundario = Color(0xFF2C5F2D); // Verde
  static const Color colorAcento = Color(0xFFF4B942);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        // 🌟 SIN MARCO, MÁS TRANSPARENTE PARA VER TODO EL CONTENIDO
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
            // 🍕 IMAGEN DEL COMBO SIN MARCO NI BORDES
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12), // Bordes redondeados
                child: Image.asset(
                  combo.imagen,
                  fit: BoxFit.cover, // Asegura que la imagen cubra todo el espacio sin distorsionarse
                  width: 100,
                  height: 100,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[200], // Color de fondo si hay error
                      child: Icon(
                        Icons.restaurant_menu,
                        size: 50,
                        color: colorAcento,
                      ),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(width: 16),

            // 📄 CONTENIDO DEL COMBO
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🏆 NOMBRE DEL COMBO
                  Text(
                    combo.nombre,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.black87,
                      height: 1.2,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 4),

                  // 🏷️ ETIQUETA COMBO MÁS PEQUEÑA
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: colorAcento.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '⭐ Combo',
                      style: TextStyle(
                        fontSize: 10,
                        color: colorAcento.withOpacity(0.8),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // 📝 DESCRIPCIÓN CON MEJOR FORMATO
                  Text(
                    combo.descripcion,
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
                      // 💵 PRECIO SIMPLE SIN ETIQUETA "AHORRA"
                      Text(
                        'S/ ${combo.precio.toStringAsFixed(0)}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: colorPrimario,
                        ),
                      ),

                      // 🛒 BOTÓN AGREGAR VERDE
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              colorSecundario,
                              colorSecundario.withOpacity(0.8)
                            ], // Verde
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: colorSecundario.withOpacity(0.4),
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
