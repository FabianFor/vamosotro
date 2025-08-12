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

  static const Color colorPrimario = Color.fromRGBO(19, 182, 22, 1);
  static const Color colorSecundario = Color(0xFFD4332A);
  static const Color colorEspecial = Colors.purple;

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
            // Imagen tamaño fijo igual que PizzaCard, sin recortar ni zoom, con padding para que no quede pegada
            Container(
              width: 130,
              height: 130,
              padding: const EdgeInsets.all(6),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  pizzaEspecial.imagen,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
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

            const SizedBox(width: 2),

            // Contenido texto expandido
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Título máximo 2 líneas, tamaño fijo 16
                    Text(
                      pizzaEspecial.nombre,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black87,
                        height: 1.1,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 4),

                    // Descripción tamaño 12, max 3 líneas para evitar que estire mucho
                    Text(
                      pizzaEspecial.descripcion,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                        height: 1.3,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const Spacer(),

                    // Fila precio y botón con medidas y estilo similares a PizzaCard
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'S/ ${pizzaEspecial.precio.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: colorEspecial,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          margin: const EdgeInsets.only(right: 8),
                          height: 34,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Colors.purple,
                                Colors.deepPurple,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.deepPurple.withOpacity(0.3),
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
                                    Flexible(
                                      child: Text(
                                        'AGREGAR',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 0.5,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
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
}
