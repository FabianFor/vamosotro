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
  static const Color colorCombo = Colors.brown; // Color para combos

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
      height: 150, // 🔧 ALTURA AUMENTADA PARA MÁS ESPACIO DE TEXTO
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
          // 🍗 IMAGEN DEL COMBO - SIN MARCO PARA EVITAR CORTE
          Container(
            width: 150,
            height: 150,
            padding: const EdgeInsets.all(8),
            child: Image.asset(
              combo.imagen,
              fit: BoxFit.contain, // 🔧 CONTAIN PARA VER IMAGEN COMPLETA
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[200],
                  child: const Icon(
                    Icons.restaurant_menu,
                    size: 50,
                    color: Colors.brown,
                  ),
                );
              },
            ),
          ),

          const SizedBox(width: 2), // 🔧 SEPARACIÓN NORMAL

          // 📄 Texto + botón - OPTIMIZADO PARA TEXTO COMPLETO
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 14), // 🔧 PADDING OPTIMIZADO
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🔝 PARTE SUPERIOR (Badge + Título + Descripción) - MÁS ESPACIO
                  Expanded(
                    flex: 3, // 🔧 MÁS ESPACIO PARA EL CONTENIDO
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 🏷️ BADGE DE COMBO - MÁS COMPACTO
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                          decoration: BoxDecoration(
                            color: colorCombo.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: colorCombo.withOpacity(0.3),
                            ),
                          ),
                          child: Text(
                            'Combo',
                            style: TextStyle(
                              fontSize: 9, // 🔧 MÁS PEQUEÑO
                              color: colorCombo,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 4), // 🔧 MENOS ESPACIO
                        
                        // 🏷️ TÍTULO - MÁS COMPACTO
                        Text(
                          combo.nombre,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15, // 🔧 LIGERAMENTE MÁS PEQUEÑO
                            color: Colors.black87,
                            height: 1.1, // 🔧 ALTURA DE LÍNEA MÁS COMPACTA
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        
                        const SizedBox(height: 2), // 🔧 MENOS ESPACIO
                        
                        // 📝 DESCRIPCIÓN - MÁS LÍNEAS Y MEJOR AJUSTE
                        Expanded(
                          child: Text(
                            combo.descripcion.replaceAll(' + ', ' • '),
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 10.5, // 🔧 TAMAÑO OPTIMIZADO
                              height: 1.25, // 🔧 ALTURA DE LÍNEA COMPACTA
                            ),
                            maxLines: 3, // 🔧 HASTA 3 LÍNEAS
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 🔽 PARTE INFERIOR (Precio + Botón) - MÁS COMPACTO
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // 💰 PRECIO - MÁS COMPACTO
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'S/ ${combo.precio.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17, // 🔧 LIGERAMENTE MÁS PEQUEÑO
                                color: Colors.brown,
                              ),
                            ),
                            Text(
                              'Completo',
                              style: TextStyle(
                                fontSize: 8, // 🔧 MÁS PEQUEÑO
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // 🛒 BOTÓN AGREGAR - MÁS COMPACTO
                      Container(
                        margin: const EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.brown, Colors.brown.withOpacity(0.8)],
                          ),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.brown.withOpacity(0.3),
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
                              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10), // 🔧 MÁS COMPACTO
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.add, size: 16, color: Colors.white), // 🔧 ÍCONO MÁS PEQUEÑO
                                  SizedBox(width: 4),
                                  Text(
                                    'AGREGAR',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 11, // 🔧 TEXTO MÁS PEQUEÑO
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