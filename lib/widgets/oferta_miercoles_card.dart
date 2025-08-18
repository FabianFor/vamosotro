import 'package:flutter/material.dart';

class OfertaMiercolesCard extends StatelessWidget {
  final String nombre;
  final String descripcion;
  final double precioOriginal;
  final double precioOferta;
  final String imagen;
  final String descuento;
  final VoidCallback onAgregarAlCarrito;

  const OfertaMiercolesCard({
    super.key,
    required this.nombre,
    required this.descripcion,
    required this.precioOriginal,
    required this.precioOferta,
    required this.imagen,
    required this.descuento,
    required this.onAgregarAlCarrito,
  });

  static const Color colorOferta = Color.fromARGB(255, 255, 0, 0); // Naranja vibrante
  static const Color colorDescuento = Color(0xFFE60026); // Rojo intenso

  @override
  Widget build(BuildContext context) {
    final ahorro = precioOriginal - precioOferta;
    
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        height: 160, // Un poco más alto que las cards normales
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18), // Más redondeado
          boxShadow: [
            BoxShadow(
              color: colorOferta.withOpacity(0.2),
              blurRadius: 12,
              offset: const Offset(0, 4),
              spreadRadius: 1,
            ),
          ],
          border: Border.all(
            color: colorOferta.withOpacity(0.3), 
            width: 2
          ),
        ),
        child: Stack(
          children: [
            // 🔥 BADGE "OFERTA" EN LA ESQUINA
            Positioned(
              top: 0,
              left: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [colorDescuento, Colors.red.shade700],
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: colorDescuento.withOpacity(0.4),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.local_fire_department,
                      color: Colors.white,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'OFERTA',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 🔥 BADGE AHORRO EN LA PARTE SUPERIOR (MOVIDO AQUÍ)
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.withOpacity(0.4),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  'Ahorras S/${ahorro.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            // CONTENIDO PRINCIPAL
            Padding(
              padding: const EdgeInsets.only(top: 17), // Espacio para los badges
              child: Row(
                children: [
                  // IMAGEN
                  Container(
                    width: 130,
                    height: 120,
                    padding: const EdgeInsets.all(6),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        imagen,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: const Color(0xFFF5F5F5),
                            child: Icon(
                              Icons.local_offer,
                              size: 40,
                              color: colorOferta,
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  const SizedBox(width: 2),

                  // CONTENIDO TEXTO
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // NOMBRE
                          Text(
                            nombre,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),

                          const SizedBox(height: 1),

                          // DESCRIPCIÓN
                          Expanded(
                            child: Text(
                              descripcion,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                                height: 1.3,
                              ),
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),

                          const SizedBox(height: 1),

                          // PRECIO Y BOTÓN - REORGANIZADO
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              // PRECIOS - MÁS COMPACTOS
                              Expanded(
                                flex: 2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // PRECIO ORIGINAL TACHADO
                                    Text(
                                      'S/ ${precioOriginal.toStringAsFixed(2)}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[500],
                                        decoration: TextDecoration.lineThrough,
                                        decorationColor: Colors.red,
                                        decorationThickness: 2,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    // PRECIO OFERTA
                                    Text(
                                      'S/ ${precioOferta.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: colorDescuento,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // BOTÓN ESPECIAL DE OFERTA - MÁS COMPACTO
                              Expanded(
                                flex: 2,
                                child: Container(
                                  margin: const EdgeInsets.only(right: 4),
                                  height: 36,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        const Color.fromARGB(255, 255, 0, 0),
                                        colorDescuento,
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color.fromARGB(255, 255, 53, 53).withOpacity(0.4),
                                        blurRadius: 8,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(20),
                                      onTap: onAgregarAlCarrito,
                                      child: const Center(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.local_fire_department,
                                              size: 14,
                                              color: Colors.white,
                                            ),
                                            SizedBox(width: 4),
                                            Text(
                                              '¡AGREGAR!',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10,
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
          ],
        ),
      ),
    );
  }
}