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

  static const Color colorPrimario = Color(0xFFD4332A);
  static const Color colorMostrito = Colors.orange;

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
        height: 140, // Altura fija igual que PizzaCard
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
            // Imagen sin cortar, tamaño fijo como PizzaCard
            Container(
              width: 130,
              height: 130,
              padding: const EdgeInsets.all(6),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  mostrito.imagen,
                  fit: BoxFit.contain, // Imagen completa sin recorte
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: const Color(0xFFF5F5F5),
                      child: const Icon(
                        Icons.fastfood,
                        size: 40,
                        color: colorMostrito,
                      ),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(width: 2),

            // Contenido texto expandido
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Título (nombre)
                    Text(
                      mostrito.nombre,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 0),

                    // Descripción sin Expanded para controlar mejor altura
                    Expanded(
                      child: Text(
                        mostrito.descripcion.replaceAll(' + ', ' • '),
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                          height: 1.4,
                        ),
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Precio y botón
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'S/ ${mostrito.precio.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: colorPrimario,
                          ),
                        ),

                        Container(
                          margin: const EdgeInsets.only(right: 8),
                          height: 34,
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
                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.add,
                                      size: 16,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 6),
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
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
