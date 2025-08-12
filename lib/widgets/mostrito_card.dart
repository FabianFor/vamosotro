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
  static const Color colorPrimario = Color(0xFFD4332A);
  static const Color colorSecundario = Color(0xFF2C5F2D);
  static const Color colorMostrito = Colors.orange;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    
    // Dimensiones responsivas
    final cardHeight = screenHeight * (isPortrait ? 0.18 : 0.35);
    final imageWidth = screenWidth * (isPortrait ? 0.35 : 0.23);
    final horizontalMargin = screenWidth * 0.04;
    final verticalMargin = screenHeight * 0.012;
    
    return Container(
      margin: EdgeInsets.symmetric(horizontal: horizontalMargin, vertical: verticalMargin),
      height: cardHeight,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(screenWidth * 0.04),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: screenWidth * 0.025,
            offset: Offset(0, screenHeight * 0.005),
          ),
        ],
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          // 🍗 IMAGEN DEL MOSTRITO RESPONSIVE
          Container(
            width: imageWidth,
            height: cardHeight,
            padding: EdgeInsets.all(screenWidth * 0.01),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(screenWidth * 0.03),
              child: Image.asset(
                mostrito.imagen,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[200],
                    child: Icon(
                      Icons.fastfood,
                      size: screenWidth * 0.12,
                      color: Colors.orange,
                    ),
                  );
                },
              ),
            ),
          ),

          SizedBox(width: screenWidth * 0.02),

          // 📄 Texto + botón - SIN BADGE
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: screenHeight * 0.012),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🔝 PARTE SUPERIOR (Título + Descripción)
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 🏷️ TÍTULO RESPONSIVE
                        Text(
                          mostrito.nombre,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: screenWidth * 0.038,
                            color: Colors.black87,
                            height: 1.1,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        
                        SizedBox(height: screenHeight * 0.005),
                        
                        // 📝 DESCRIPCIÓN RESPONSIVE
                        Expanded(
                          child: Text(
                            mostrito.descripcion.replaceAll(' + ', ' • '),
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: screenWidth * 0.028,
                              height: 1.25,
                            ),
                            maxLines: isPortrait ? 4 : 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 🔽 PARTE INFERIOR (Precio + Botón)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // 💰 PRECIO RESPONSIVE
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'S/ ${mostrito.precio.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: screenWidth * 0.043,
                                color: Colors.orange,
                              ),
                            ),
                            Text(
                              'Con bebida',
                              style: TextStyle(
                                fontSize: screenWidth * 0.02,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // 🛒 BOTÓN AGREGAR RESPONSIVE
                      Container(
                        margin: EdgeInsets.only(right: screenWidth * 0.015),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Colors.orange, Colors.deepOrange],
                          ),
                          borderRadius: BorderRadius.circular(screenWidth * 0.025),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.orange.withOpacity(0.3),
                              blurRadius: screenWidth * 0.015,
                              offset: Offset(0, screenHeight * 0.002),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(screenWidth * 0.025),
                            onTap: onAgregarAlCarrito,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.03, 
                                vertical: screenHeight * 0.01,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.add, 
                                    size: screenWidth * 0.035, 
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: screenWidth * 0.008),
                                  Text(
                                    'AGREGAR',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: screenWidth * 0.025,
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