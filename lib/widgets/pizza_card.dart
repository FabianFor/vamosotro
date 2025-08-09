import 'package:flutter/material.dart';
import '../models/models.dart';

class PizzaCard extends StatelessWidget {
  final Pizza pizza;
  final Function(String, double, String) onAgregarAlCarrito;

  const PizzaCard({
    super.key,
    required this.pizza,
    required this.onAgregarAlCarrito,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      padding: const EdgeInsets.all(15),
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
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
            ),
          ),
          Text(
            pizza.ingredientes,
            style: const TextStyle(fontSize: 12, color: Colors.black87),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Botón Familiar
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(right: 5),
                  child: ElevatedButton(
                    onPressed: () => onAgregarAlCarrito(pizza.nombre, pizza.precioFamiliar, 'Familiar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('Familiar'),
                        Text('S/ ${pizza.precioFamiliar.toStringAsFixed(0)}', 
                             style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      ],
                    ),
                  ),
                ),
              ),
              // Botón Personal
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(left: 5),
                  child: ElevatedButton(
                    onPressed: () => onAgregarAlCarrito(pizza.nombre, pizza.precioPersonal, 'Personal'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('Personal'),
                        Text('S/ ${pizza.precioPersonal.toStringAsFixed(0)}', 
                             style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      ],
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