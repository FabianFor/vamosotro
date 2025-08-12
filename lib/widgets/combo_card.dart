// lib/widgets/combo_card.dart
import 'package:flutter/material.dart';
import '../models/models.dart';
import '../utils/responsive_helper.dart';

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
    ResponsiveHelper().init(context);
    
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.getHorizontalPadding() * 0.25,
        vertical: ResponsiveHelper.getProportionateScreenHeight(6),
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
          // 🍗 IMAGEN DEL COMBO - RESPONSIVA
          Container(
            width: ResponsiveHelper.isSmallScreen() 
                ? ResponsiveHelper.getProportionateScreenWidth(130)
                : ResponsiveHelper.getProportionateScreenWidth(150),
            height: ResponsiveHelper.getCardHeight(),
            padding: EdgeInsets.all(ResponsiveHelper.getProportionateScreenWidth(8)),
            child: Image.asset(
              combo.imagen,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[200],
                  child: Icon(
                    Icons.restaurant_menu,
                    size: ResponsiveHelper.getProportionateScreenWidth(50),
                    color: Colors.brown,
                  ),
                );
              },
            ),
          ),

          SizedBox(width: ResponsiveHelper.getProportionateScreenWidth(2)),

          // 📄 Texto + botón - RESPONSIVO
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: ResponsiveHelper.getProportionateScreenHeight(14),
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
                        // 🏷️ BADGE DE COMBO - RESPONSIVO
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: ResponsiveHelper.getProportionateScreenWidth(6),
                            vertical: ResponsiveHelper.getProportionateScreenHeight(1),
                          ),
                          decoration: BoxDecoration(
                            color: colorCombo.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: colorCombo.withOpacity(0.3),
                            ),
                          ),
                          child: Text(
                            'Combo',
                            style: TextStyle(
                              fontSize: ResponsiveHelper.getFontSize(9),
                              color: colorCombo,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        
                        SizedBox(height: ResponsiveHelper.getProportionateScreenHeight(4)),
                        
                        // 🏷️ TÍTULO - RESPONSIVO
                        Text(
                          combo.nombre,
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
                            combo.descripcion.replaceAll(' + ', ' • '),
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
                              'S/ ${combo.precio.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: ResponsiveHelper.getFontSize(17),
                                color: Colors.brown,
                              ),
                            ),
                            Text(
                              'Completo',
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
                          right: ResponsiveHelper.getProportionateScreenWidth(10),
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.brown, Colors.brown.withOpacity(0.8)],
                          ),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.brown.withOpacity(0.3),
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
                                horizontal: ResponsiveHelper.getProportionateScreenWidth(16),
                                vertical: ResponsiveHelper.getProportionateScreenHeight(10),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.add, 
                                    size: ResponsiveHelper.getFontSize(16), 
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: ResponsiveHelper.getProportionateScreenWidth(4)),
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