// lib/widgets/mostrito_card.dart
import 'package:flutter/material.dart';
import '../models/models.dart';
import '../utils/responsive_helper.dart';

class MostritoCard extends StatelessWidget {
  final Mostrito mostrito;
  final VoidCallback onAgregarAlCarrito;

  const MostritoCard({
    super.key,
    required this.mostrito,
    required this.onAgregarAlCarrito,
  });

  // 🎨 COLORES
  static const Color colorPrimario = Color(0xFFD4332A); // Rojo
  static const Color colorSecundario = Color(0xFF2C5F2D); // Verde
  static const Color colorMostrito = Colors.orange; // Color especial para mostritos

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper().init(context);
    
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.getHorizontalPadding(),
        vertical: ResponsiveHelper.getProportionateScreenHeight(10),
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
          // 🍗 IMAGEN DEL MOSTRITO RESPONSIVA
          Container(
            width: ResponsiveHelper.isSmallScreen() 
                ? ResponsiveHelper.getProportionateScreenWidth(120)
                : ResponsiveHelper.getProportionateScreenWidth(130),
            height: ResponsiveHelper.getCardHeight(),
            padding: EdgeInsets.all(ResponsiveHelper.getProportionateScreenWidth(4)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                mostrito.imagen,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[200],
                    child: Icon(
                      Icons.fastfood,
                      size: ResponsiveHelper.getProportionateScreenWidth(50),
                      color: Colors.orange,
                    ),
                  );
                },
              ),
            ),
          ),

          SizedBox(width: ResponsiveHelper.getProportionateScreenWidth(8)),

          // 📄 Texto + botón - RESPONSIVO
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: ResponsiveHelper.getProportionateScreenHeight(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🔝 PARTE SUPERIOR - RESPONSIVA
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 🏷️ BADGE DE MOSTRITO - RESPONSIVO
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: ResponsiveHelper.getProportionateScreenWidth(6),
                            vertical: ResponsiveHelper.getProportionateScreenHeight(1),
                          ),
                          decoration: BoxDecoration(
                            color: colorMostrito.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: colorMostrito.withOpacity(0.3),
                            ),
                          ),
                          child: Text(
                            'Mostrito',
                            style: TextStyle(
                              fontSize: ResponsiveHelper.getFontSize(9),
                              color: colorMostrito,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        
                        SizedBox(height: ResponsiveHelper.getProportionateScreenHeight(4)),
                        
                        // 🏷️ TÍTULO - RESPONSIVO
                        Text(
                          mostrito.nombre,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: ResponsiveHelper.getFontSize(15),
                            color: Colors.black87,
                            height: 1.1,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        
                        SizedBox(height: ResponsiveHelper.getProportionateScreenHeight(2)),
                        
                        // 📝 DESCRIPCIÓN - RESPONSIVA
                        Expanded(
                          child: Text(
                            mostrito.descripcion.replaceAll(' + ', ' • '),
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: ResponsiveHelper.getFontSize(10.5),
                              height: 1.25,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 🔽 PARTE INFERIOR - RESPONSIVA
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // 💰 PRECIO - RESPONSIVO
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'S/ ${mostrito.precio.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: ResponsiveHelper.getFontSize(17),
                                color: Colors.orange,
                              ),
                            ),
                            Text(
                              'Con bebida',
                              style: TextStyle(
                                fontSize: ResponsiveHelper.getFontSize(8),
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // 🛒 BOTÓN AGREGAR - RESPONSIVO
                      Container(
                        margin: EdgeInsets.only(
                          right: ResponsiveHelper.getProportionateScreenWidth(6),
                        ),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Colors.orange, Colors.deepOrange],
                          ),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.orange.withOpacity(0.3),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(10),
                            onTap: onAgregarAlCarrito,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: ResponsiveHelper.getProportionateScreenWidth(12),
                                vertical: ResponsiveHelper.getProportionateScreenHeight(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.add, 
                                    size: ResponsiveHelper.getFontSize(14), 
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: ResponsiveHelper.getProportionateScreenWidth(3)),
                                  Text(
                                    'AGREGAR',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: ResponsiveHelper.getFontSize(10),
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