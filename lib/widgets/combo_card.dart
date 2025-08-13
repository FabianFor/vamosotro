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

  static const Color colorPrimario = Color(0xFFD4332A); // Rojo
  static const Color colorSecundario = Color(0xFF2C5F2D); // Verde

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
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
            // Imagen sin zoom ni recorte, ajustada para que se muestre completa
            Container(
              width: 130,
              height: 130,
              padding: const EdgeInsets.all(6), // espacio para que no toque el borde
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  combo.imagen,
                  fit: BoxFit.contain, // Ajusta la imagen para que se vea completa sin cortar
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: const Color(0xFFF5F5F5),
                      child: const Icon(
                        Icons.restaurant_menu,
                        size: 40,
                        color: colorSecundario,
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
                    // Nombre combo (Título)
                    Text(
                      combo.nombre,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 0),

                    // Descripción combo (mostrando + original)
                    Expanded(
                      child: Text(
                        combo.descripcion,
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

                    // Fila precio y botón
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // Precio
                        Text(
                          'S/ ${combo.precio.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: colorPrimario,
                          ),
                        ),

                        // Botón agregar
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
