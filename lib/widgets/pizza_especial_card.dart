// lib/widgets/pizza_especial_card.dart
import 'package:flutter/material.dart';
import '../models/models.dart';
import '../utils/responsive_helper.dart';

class PizzaEspecialCard extends StatelessWidget {
  final PizzaEspecial pizzaEspecial;
  final VoidCallback onAgregarAlCarrito;

  const PizzaEspecialCard({
    super.key,
    required this.pizzaEspecial,
    required this.onAgregarAlCarrito,
  });

  // 🎨 COLORES ACTUALIZADOS IGUAL QUE EN PIZZA_CARD
  static const Color colorPrimario = Color.fromRGBO(19, 182, 22, 1);
  static const Color colorSecundario = Color(0xFFD4332A);
  static const Color colorEspecial = Colors.purple; // Color especial para pizzas especiales

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
          // 🍕 Pizza especial - RESPONSIVA COMO PIZZA_CARD
          ClipRRect(
            borderRadius: BorderRadius.circular(0),
            child: Transform.scale(
              scale: ResponsiveHelper.isSmallScreen() 
                  ? ResponsiveHelper.getImageScale() * 0.9
                  : ResponsiveHelper.getImageScale(),
              child: Transform.translate(
                offset: ResponsiveHelper.isSmallScreen() 
                    ? const Offset(-12, 0) 
                    : ResponsiveHelper.getImageOffset(),
                child: Image.asset(
                  pizzaEspecial.imagen,
                  width: ResponsiveHelper.getImageWidth(),
                  height: ResponsiveHelper.getCardHeight(),
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: ResponsiveHelper.getImageWidth(),
                      height: ResponsiveHelper.getImageWidth(),
                      color: const Color(0xFFF5F5F5),
                      child: Icon(
                        Icons.star,
                        size: ResponsiveHelper.getProportionateScreenWidth(40),
                        color: Colors.purple,
                      ),
                    );
                  },
                ),
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
                        // 🏷️ BADGE DE TIPO - RESPONSIVO
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: ResponsiveHelper.getProportionateScreenWidth(6),
                            vertical: ResponsiveHelper.getProportionateScreenHeight(1),
                          ),
                          decoration: BoxDecoration(
                            color: colorEspecial.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: colorEspecial.withOpacity(0.3),
                            ),
                          ),
                          child: Text(
                            pizzaEspecial.tipo,
                            style: TextStyle(
                              fontSize: ResponsiveHelper.getFontSize(9),
                              color: colorEspecial,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        
                        SizedBox(height: ResponsiveHelper.getProportionateScreenHeight(4)),
                        
                        // 🏷️ TÍTULO - RESPONSIVO
                        Text(
                          pizzaEspecial.nombre,
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
                            pizzaEspecial.descripcion,
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
                              'S/ ${pizzaEspecial.precio.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: ResponsiveHelper.getFontSize(17),
                                color: Colors.purple,
                              ),
                            ),
                            Text(
                              'Especial',
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
                            colors: [Colors.purple, Colors.deepPurple],
                          ),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.purple.withOpacity(0.3),
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