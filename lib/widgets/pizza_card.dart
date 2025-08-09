import 'package:flutter/material.dart';
import '../models/models.dart';

class PizzaCard extends StatelessWidget {
  final Pizza pizza;
  final Function(String, double, String) onAgregarAlCarrito;

  PizzaCard({
    required this.pizza,
    required this.onAgregarAlCarrito,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.amber[50],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.orange, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            pizza.nombre,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
            ),
          ),
          Text(
            pizza.ingredientes,
            style: TextStyle(fontSize: 12, color: Colors.black87),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Botón Familiar
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(right: 5),
                  child: ElevatedButton(
                    onPressed: () => onAgregarAlCarrito(pizza.nombre, pizza.precioFamiliar, 'Familiar'),
                    child: Column(
                      children: [
                        Text('Familiar'),
                        Text('S/ ${pizza.precioFamiliar.toStringAsFixed(0)}', 
                             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      ],
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ),
              ),
              // Botón Personal
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: 5),
                  child: ElevatedButton(
                    onPressed: () => onAgregarAlCarrito(pizza.nombre, pizza.precioPersonal, 'Personal'),
                    child: Column(
                      children: [
                        Text('Personal'),
                        Text('S/ ${pizza.precioPersonal.toStringAsFixed(0)}', 
                             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      ],
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}