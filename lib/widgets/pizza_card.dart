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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    
    // Dimensiones responsivas
    final cardHeight = screenHeight * (isPortrait ? 0.18 : 0.35);
    final imageSize = screenWidth * (isPortrait ? 0.28 : 0.2);
    final horizontalMargin = screenWidth * 0.01;
    final verticalMargin = screenHeight * 0.008;
    
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
          // 📸 Pizza responsive
          ClipRRect(
            borderRadius: BorderRadius.circular(0),
            child: Transform.scale(
              scale: isPortrait ? 1.4 : 1.2,
              child: Transform.translate(
                offset: Offset(screenWidth * -0.05, 0),
                child: Image.asset(
                  pizza.imagen,
                  width: imageSize,
                  height: cardHeight,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: imageSize,
                      height: imageSize,
                      color: const Color(0xFFF5F5F5),
                      child: Icon(
                        Icons.local_pizza,
                        size: screenWidth * 0.1,
                        color: colorSecundario,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),

          SizedBox(width: screenWidth * 0.02),

          // 📄 Texto + botón - SIN BADGE
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: screenHeight * 0.015),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título
                  Text(
                    pizza.nombre,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: screenWidth * 0.04,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  SizedBox(height: screenHeight * 0.005),
                  
                  // Ingredientes
                  Expanded(
                    child: Text(
                      pizza.ingredientes,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: screenWidth * 0.03,
                        height: 1.2,
                      ),
                      maxLines: isPortrait ? 3 : 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.01),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // 💰 PRECIO RESPONSIVE
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'S/ ${precio.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: screenWidth * 0.045,
                              color: colorSecundario,
                            ),
                          ),
                          if (tamano == 'Familiar')
                            Text(
                              'Para compartir',
                              style: TextStyle(
                                fontSize: screenWidth * 0.022,
                                color: Colors.grey[500],
                              ),
                            ),
                        ],
                      ),
                      
                      // 🛒 BOTÓN RESPONSIVE
                      Container(
                        margin: EdgeInsets.only(right: screenWidth * 0.02),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              const Color.fromARGB(255, 40, 133, 41), 
                              const Color.fromRGBO(19, 182, 22, 1).withOpacity(0.8)
                            ],
                          ),
                          borderRadius: BorderRadius.circular(screenWidth * 0.03),
                          boxShadow: [
                            BoxShadow(
                              color: colorPrimario.withOpacity(0.3),
                              blurRadius: screenWidth * 0.015,
                              offset: Offset(0, screenHeight * 0.002),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(screenWidth * 0.03),
                            onTap: onAgregarAlCarrito,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.04, 
                                vertical: screenHeight * 0.012,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.add, 
                                    size: screenWidth * 0.04, 
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: screenWidth * 0.01),
                                  Text(
                                    'AGREGAR',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: screenWidth * 0.028,
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