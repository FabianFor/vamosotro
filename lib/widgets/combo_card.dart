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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    
    // Dimensiones responsivas basadas en el ancho de pantalla
    final cardHeight = screenHeight * (isPortrait ? 0.18 : 0.35);
    final imageWidth = screenWidth * (isPortrait ? 0.38 : 0.25);
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
          // 🍗 IMAGEN DEL COMBO - RESPONSIVE
          Container(
            width: imageWidth,
            height: cardHeight,
            padding: EdgeInsets.all(screenWidth * 0.02),
            child: Image.asset(
              combo.imagen,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[200],
                  child: Icon(
                    Icons.restaurant_menu,
                    size: screenWidth * 0.12,
                    color: Colors.brown,
                  ),
                );
              },
            ),
          ),

          SizedBox(width: screenWidth * 0.01),

          // 📄 Texto + botón - RESPONSIVE
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: screenHeight * 0.015),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🔝 PARTE SUPERIOR (Título + Descripción) - SIN BADGE
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 🏷️ TÍTULO - RESPONSIVE
                        Text(
                          combo.nombre,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: screenWidth * 0.038, // Responsive font size
                            color: Colors.black87,
                            height: 1.1,
                          ),
                          maxLines: isPortrait ? 1 : 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        
                        SizedBox(height: screenHeight * 0.005),
                        
                        // 📝 DESCRIPCIÓN - RESPONSIVE
                        Expanded(
                          child: Text(
                            combo.descripcion.replaceAll(' + ', ' • '),
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: screenWidth * 0.028, // Responsive font size
                              height: 1.25,
                            ),
                            maxLines: isPortrait ? 4 : 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 🔽 PARTE INFERIOR (Precio + Botón) - RESPONSIVE
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // 💰 PRECIO - RESPONSIVE
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'S/ ${combo.precio.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: screenWidth * 0.045, // Responsive font size
                                color: Colors.brown,
                              ),
                            ),
                            Text(
                              'Completo',
                              style: TextStyle(
                                fontSize: screenWidth * 0.022, // Responsive font size
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // 🛒 BOTÓN AGREGAR - RESPONSIVE
                      Container(
                        margin: EdgeInsets.only(right: screenWidth * 0.025),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.brown, Colors.brown.withOpacity(0.8)],
                          ),
                          borderRadius: BorderRadius.circular(screenWidth * 0.025),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.brown.withOpacity(0.3),
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
                                      fontSize: screenWidth * 0.028, // Responsive font size
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