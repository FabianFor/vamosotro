// lib/widgets/pizza_card.dart
import 'package:flutter/material.dart';
import '../models/models.dart';
import '../utils/responsive_helper.dart';

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

  // 🎨 COLORES FIJOS
  static const Color colorPrimario = Color.fromRGBO(19, 182, 22, 1);
  static const Color colorSecundario = Color(0xFFD4332A);

  @override
  Widget build(BuildContext context) {
    // Inicializar responsive helper
    ResponsiveHelper().init(context);
    
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.getHorizontalPadding() * 0.5,
        vertical: ResponsiveHelper.getSmallVerticalSpacing(),
      ),
      height: ResponsiveHelper.getCardHeight(),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ResponsiveHelper.getBorderRadius()),
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
          // 🖼️ IMAGEN DE LA PIZZA - DIMENSIONES FIJAS
          ClipRRect(
            borderRadius: BorderRadius.circular(0),
            child: Transform.scale(
              scale: ResponsiveHelper.getImageScale(),
              child: Transform.translate(
                offset: ResponsiveHelper.getImageOffset(),
                child: Image.asset(
                  pizza.imagen,
                  width: ResponsiveHelper.getImageWidth(),
                  height: ResponsiveHelper.getCardHeight(),
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: ResponsiveHelper.getImageWidth(),
                      height: ResponsiveHelper.getImageWidth(),
                      color: const Color(0xFFF5F5F5),
                      child: Icon(
                        Icons.local_pizza,
                        size: ResponsiveHelper.getIconSize('large'),
                        color: colorSecundario,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),

          SizedBox(width: ResponsiveHelper.getSmallHorizontalSpacing()),

          // 📝 CONTENIDO DE TEXTO - ESPACIADO FIJO
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: ResponsiveHelper.getMediumVerticalSpacing(),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🏷️ BADGE DE TAMAÑO - DIMENSIONES FIJAS
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveHelper.getSmallHorizontalSpacing(),
                      vertical: 2.0, // Fijo
                    ),
                    decoration: BoxDecoration(
                      color: tamano == 'Familiar' 
                          ? const Color.fromARGB(192, 36, 145, 38).withOpacity(0.1)
                          : colorSecundario.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(ResponsiveHelper.getBorderRadius() - 2),
                      border: Border.all(
                        color: tamano == 'Familiar' 
                            ? const Color.fromARGB(255, 32, 131, 33).withOpacity(0.3)
                            : colorSecundario.withOpacity(0.3),
                      ),
                    ),
                    child: Text(
                      tamano,
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getFontSize(10),
                        color: tamano == 'Familiar' 
                            ? const Color.fromARGB(255, 51, 148, 52) 
                            : colorSecundario,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  
                  SizedBox(height: ResponsiveHelper.getSmallVerticalSpacing()),
                  
                  // 🏷️ TÍTULO - TAMAÑO FIJO
                  Text(
                    pizza.nombre,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: ResponsiveHelper.getFontSize(16),
                      color: Colors.black87,
                      height: 1.1, // Line height fijo
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  SizedBox(height: ResponsiveHelper.getSmallVerticalSpacing()),
                  
                  // 📝 INGREDIENTES - TAMAÑO FIJO
                  Expanded(
                    child: Text(
                      pizza.ingredientes,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: ResponsiveHelper.getFontSize(12),
                        height: 1.2, // Line height fijo
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  SizedBox(height: ResponsiveHelper.getSmallVerticalSpacing()),

                  // 💰 PRECIO Y BOTÓN - DIMENSIONES FIJAS
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // 💰 PRECIO
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'S/ ${precio.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: ResponsiveHelper.getFontSize(18),
                                color: colorSecundario,
                              ),
                            ),
                            if (tamano == 'Familiar')
                              Text(
                                'Para compartir',
                                style: TextStyle(
                                  fontSize: ResponsiveHelper.getFontSize(9),
                                  color: Colors.grey[500],
                                ),
                              ),
                          ],
                        ),
                      ),
                      
                      // 🛒 BOTÓN AGREGAR - DIMENSIONES FIJAS
                      Container(
                        margin: EdgeInsets.only(
                          right: ResponsiveHelper.getSmallHorizontalSpacing(),
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              const Color.fromARGB(255, 40, 133, 41), 
                              colorPrimario.withOpacity(0.8)
                            ],
                          ),
                          borderRadius: BorderRadius.circular(ResponsiveHelper.getBorderRadius()),
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
                            borderRadius: BorderRadius.circular(ResponsiveHelper.getBorderRadius()),
                            onTap: onAgregarAlCarrito,
                            child: Padding(
                              padding: ResponsiveHelper.getButtonPadding(),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.add, 
                                    size: ResponsiveHelper.getIconSize('medium'), 
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: ResponsiveHelper.getSmallHorizontalSpacing()),
                                  Text(
                                    'AGREGAR',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: ResponsiveHelper.getFontSize(11),
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