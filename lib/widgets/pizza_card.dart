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

  // 🎨 COLORES ACTUALIZADOS
  static const Color colorPrimario = Color.fromRGBO(19, 182, 22, 1);
  static const Color colorSecundario = Color(0xFFD4332A);

  @override
  Widget build(BuildContext context) {  
    return MediaQuery(
      // 🔥 FORZAR TEXTO FIJO
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
        height: 140, // ALTURA FIJA
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(color: Colors.grey.withOpacity(0.1)),
        ),
        child: Row(
          children: [
            // 📸 IMAGEN PIZZA - TAMAÑO FIJO con recorte
            Container(
              width: 130, // ANCHO FIJO
              height: 130, // ALTURA FIJA
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16), // recortar con bordes redondeados
                child: Transform.scale(
                  scale: 1.3,
                  child: Transform.translate(
                    offset: const Offset(-25, 0),
                    child: Image.asset(
                      pizza.imagen,
                      fit: BoxFit.cover, // recorta la imagen para llenar el espacio
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: const Color(0xFFF5F5F5),
                          child: const Icon(
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
            ),

            const SizedBox(width: 2),

            // 📄 CONTENIDO TEXTO - EXPANDIDO
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // TÍTULO - TAMAÑO FIJO
                    Text(
                      pizza.nombre,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16, // TAMAÑO FIJO
                        color: Colors.black87,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    const SizedBox(height: 0),
                    
                    // INGREDIENTES - TAMAÑO FIJO
                    Expanded(
                      child: Text(
                        pizza.ingredientes,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12, // TAMAÑO FIJO
                          height: 1.4,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    // 🔥 INFORMACIÓN ESPECIAL SEGÚN TAMAÑO
                    if (tamano == 'Personal')
                      Container(
                        margin: const EdgeInsets.only(top: 4),
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.green.withOpacity(0.3)),
                        ),
                        child: const Text(
                          '🥤 Primera gaseosa 350ml solo +S/1',
                          style: TextStyle(
                            fontSize: 9,
                            color: Colors.green,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                    const SizedBox(height: 8),

                    // FILA PRECIO Y BOTÓN
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // 💰 PRECIO - TAMAÑO FIJO
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'S/ ${precio.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18, // TAMAÑO FIJO
                                color: colorSecundario,
                              ),
                            ),
                            // 🔥 DESCRIPCIÓN ESPECIAL SEGÚN TAMAÑO
                            Text(
                              _getDescripcionTamano(tamano),
                              style: TextStyle(
                                fontSize: 9, // TAMAÑO FIJO MÁS PEQUEÑO
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                        
                        // 🛒 BOTÓN - TAMAÑO FIJO
                        Container(
                          margin: const EdgeInsets.only(right: 8),
                          height: 34, // ALTURA FIJA
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color.fromARGB(255, 40, 133, 41), 
                                Color.fromRGBO(19, 182, 22, 1)
                              ],
                            ),
                            borderRadius: BorderRadius.circular(18),
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
                              borderRadius: BorderRadius.circular(18),
                              onTap: onAgregarAlCarrito,
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8, 
                                  vertical: 8,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.add, 
                                      size: 16, // TAMAÑO FIJO
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 6),
                                    Text(
                                      'AGREGAR',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 11, // TAMAÑO FIJO
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
      ),
    );
  }

  // 🔥 MÉTODO PARA OBTENER DESCRIPCIÓN SEGÚN TAMAÑO
  String _getDescripcionTamano(String tamano) {
    switch (tamano) {
      case 'Personal':
        return '4 tajadas - 18cm';
      case 'Familiar':
        return '8 tajadas - 30cm';
      case 'Extra Grande':
        return '12 tajadas - 45cm';
      default:
        return 'Para compartir';
    }
  }
}