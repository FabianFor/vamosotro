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

  // 🎨 COLORES ACTUALIZADOS
  static const Color colorPrimario = Color.fromRGBO(19, 182, 22, 1);
  static const Color colorSecundario = Color(0xFFD4332A);
  static const Color colorEspecial = Colors.purple;

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
          // 🍕 Pizza especial responsive
          ClipRRect(
            borderRadius: BorderRadius.circular(0),
            child: Transform.scale(
              scale: isPortrait ? 1.3 : 1.1,
              child: Transform.translate(
                offset: Offset(screenWidth * -0.04, 0),
                child: Image.asset(
                  pizzaEspecial.imagen,
                  width: imageSize,
                  height: cardHeight,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: imageSize,
                      height: imageSize,
                      color: const Color(0xFFF5F5F5),
                      child: Icon(
                        Icons.star,
                        size: screenWidth * 0.1,
                        color: Colors.purple,
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
                          pizzaEspecial.nombre,
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
                            pizzaEspecial.descripcion,
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
                              'S/ ${pizzaEspecial.precio.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: screenWidth * 0.043,
                                color: Colors.purple,
                              ),
                            ),
                            Text(
                              'Especial',
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
                            colors: [Colors.purple, Colors.deepPurple],
                          ),
                          borderRadius: BorderRadius.circular(screenWidth * 0.025),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.purple.withOpacity(0.3),
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