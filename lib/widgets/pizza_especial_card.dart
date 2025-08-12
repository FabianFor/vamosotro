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
          // 🍕 Pizza especial - IGUAL QUE PIZZA_CARD PERO CON TAMAÑO OPTIMIZADO
          ClipRRect(
            borderRadius: BorderRadius.circular(0),
            child: Transform.scale(
              scale: 1.3, // 🔧 LIGERAMENTE MÁS PEQUEÑA PARA DAR ESPACIO AL TEXTO
              child: Transform.translate(
                offset: const Offset(-15, 0), // 🔧 MENOS DESPLAZAMIENTO
                child: Image.asset(
                  pizzaEspecial.imagen,
                  width: 110,
                  height: 150, // 🔧 AJUSTADO A LA NUEVA ALTURA
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 110,
                      height: 120,
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

          const SizedBox(width: 8),

          // 📄 Texto + botón - OPTIMIZADO PARA TEXTO COMPLETO
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10), // 🔧 PADDING OPTIMIZADO
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🔝 PARTE SUPERIOR (Badge + Título + Descripción) - MÁS ESPACIO
                  Expanded(
                    flex: 3, // 🔧 MÁS ESPACIO PARA EL CONTENIDO
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 🏷️ BADGE DE TIPO - MÁS COMPACTO
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                          decoration: BoxDecoration(
                            color: colorEspecial.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: colorEspecial.withOpacity(0.3),
                            ),
                          ),
                          child: Text(
                            pizzaEspecial.tipo,
                            style: TextStyle(
                              fontSize: 9, // 🔧 MÁS PEQUEÑO
                              color: colorEspecial,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 4), // 🔧 MENOS ESPACIO
                        
                        // 🏷️ TÍTULO - MÁS COMPACTO
                        Text(
                          pizzaEspecial.nombre,
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
                            pizzaEspecial.descripcion,
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
                              'S/ ${pizzaEspecial.precio.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17, // 🔧 LIGERAMENTE MÁS PEQUEÑO
                                color: Colors.purple,
                              ),
                            ),
                            Text(
                              'Especial',
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
                        margin: const EdgeInsets.only(right: 6),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Colors.purple, Colors.deepPurple],
                          ),
                          borderRadius: BorderRadius.circular(10),
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
                            borderRadius: BorderRadius.circular(10),
                            onTap: onAgregarAlCarrito,
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8), // 🔧 MÁS COMPACTO
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.add, size: 14, color: Colors.white), // 🔧 ÍCONO MÁS PEQUEÑO
                                  SizedBox(width: 3),
                                  Text(
                                    'AGREGAR',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10, // 🔧 TEXTO MÁS PEQUEÑO
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