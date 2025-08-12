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

  // 🎨 COLORES ACTUALIZADOS IGUAL QUE EN HOME SCREEN
  static const Color colorPrimario = Color.fromRGBO(19, 182, 22, 1);
  static const Color colorSecundario = Color(0xFFD4332A);
  static const Color colorAcento = Color(0xFFF4B942);

  @override
  Widget build(BuildContext context) {
    // Inicializar responsive helper
    ResponsiveHelper().init(context);
    
    // 🔧 DEBUG: Descomenta para ver info de responsive
    // ResponsiveHelper.printDebugInfo();
    
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.getHorizontalPadding() * 0.25,
        vertical: ResponsiveHelper.getProportionateScreenHeight(0.7), // 0.7% de altura
      ),
      height: ResponsiveHelper.getCardHeight(),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
          // 📸 Pizza - SISTEMA PORCENTUAL MEJORADO
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
                        size: ResponsiveHelper.getProportionateScreenWidth(10), // 10% del ancho
                        color: colorSecundario,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),

          SizedBox(width: ResponsiveHelper.getProportionateScreenWidth(2)), // 2% del ancho

          // 📄 Texto + botón - PORCENTUAL
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: ResponsiveHelper.getProportionateScreenHeight(1.5), // 1.5% de altura
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🏷️ BADGE DE TAMAÑO - PORCENTUAL
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveHelper.getProportionateScreenWidth(2), // 2% del ancho
                      vertical: ResponsiveHelper.getProportionateScreenHeight(0.25), // 0.25% de altura
                    ),
                    decoration: BoxDecoration(
                      color: tamano == 'Familiar' 
                          ? const Color.fromARGB(192, 36, 145, 38).withOpacity(0.1)
                          : colorSecundario.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
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
                  
                  SizedBox(height: ResponsiveHelper.getProportionateScreenHeight(0.7)), // 0.7% de altura
                  
                  Text(
                    pizza.nombre,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: ResponsiveHelper.getFontSize(16),
                      color: Colors.black87,
                    ),
                  ),
                  
                  SizedBox(height: ResponsiveHelper.getProportionateScreenHeight(0.4)), // 0.4% de altura
                  
                  Text(
                    pizza.ingredientes,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: ResponsiveHelper.getFontSize(12),
                      height: 1.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  SizedBox(height: ResponsiveHelper.getProportionateScreenHeight(1.2)), // 1.2% de altura

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // 💰 PRECIO - PORCENTUAL
                      Column(
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
                      
                      // 🛒 BOTÓN AGREGAR - PORCENTUAL
                      Container(
                        margin: EdgeInsets.only(
                          right: ResponsiveHelper.getProportionateScreenWidth(2), // 2% del ancho
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              const Color.fromARGB(255, 40, 133, 41), 
                              const Color.fromRGBO(19, 182, 22, 1).withOpacity(0.8)
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
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
                            borderRadius: BorderRadius.circular(12),
                            onTap: onAgregarAlCarrito,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: ResponsiveHelper.getProportionateScreenWidth(4), // 4% del ancho
                                vertical: ResponsiveHelper.getProportionateScreenHeight(1.2), // 1.2% de altura
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.add, 
                                    size: ResponsiveHelper.getFontSize(16), 
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: ResponsiveHelper.getProportionateScreenWidth(1)), // 1% del ancho
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