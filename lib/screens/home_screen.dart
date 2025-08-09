import 'package:flutter/material.dart';
import '../models/models.dart';
import '../data/pizza_data.dart';
import '../widgets/pizza_card.dart';
import 'carrito_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ItemPedido> carrito = [];

  double get totalCarrito {
    return carrito.fold(0.0, (sum, item) => sum + (item.precio * item.cantidad));
  }

  void agregarAlCarrito(String nombre, double precio, String tamano) {
    setState(() {
      // Buscar si ya existe el item
      int index = carrito.indexWhere((item) => 
        item.nombre == nombre && item.tamano == tamano);
      
      if (index != -1) {
        // Si existe, incrementar cantidad
        carrito[index] = ItemPedido(
          nombre: carrito[index].nombre,
          precio: carrito[index].precio,
          cantidad: carrito[index].cantidad + 1,
          tamano: carrito[index].tamano,
        );
      } else {
        // Si no existe, agregar nuevo
        carrito.add(ItemPedido(
          nombre: nombre,
          precio: precio,
          cantidad: 1,
          tamano: tamano,
        ));
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$nombre ($tamano) agregado al carrito'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.local_pizza, color: Colors.red),
            ),
            const SizedBox(width: 10),
            const Text('PIZZA FABICHELO', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
          ],
        ),
        backgroundColor: Colors.red,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart, color: Colors.white),
                onPressed: () => _mostrarCarrito(context),
              ),
              if (carrito.isNotEmpty)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 14,
                      minHeight: 14,
                    ),
                    child: Text(
                      '${carrito.fold(0, (sum, item) => sum + item.cantidad)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header con logo
            Container(
              height: 100,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.red, Colors.orange],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Center(
                child: Text(
                  'LISTA DE SABORES',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            
            // Información de tamaños
            Container(
              color: Colors.green,
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Icon(Icons.local_pizza, color: Colors.white, size: 30),
                      Text('Familiar', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      Text('8 tajadas', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                  SizedBox(width: 2, height: 40, child: ColoredBox(color: Colors.white)),
                  Column(
                    children: [
                      Icon(Icons.local_pizza, color: Colors.white, size: 20),
                      Text('Personal', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      Text('4 tajadas', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ],
              ),
            ),

            // Lista de pizzas
            Container(
              color: Colors.amber[100],
              child: Column(
                children: PizzaData.pizzas.map((pizza) => PizzaCard(
                  pizza: pizza,
                  onAgregarAlCarrito: agregarAlCarrito,
                )).toList(),
              ),
            ),

            // Combo Estrella
            Container(
              margin: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.orange, Colors.red],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(15),
                    child: Text(
                      'Combo Estrella',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.amber[100],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('• Pizza Familiar 2 sabores', style: TextStyle(fontWeight: FontWeight.bold)),
                                  Text('• 6 Bracitos'),
                                  Text('• Porción papas'),
                                  Text('• Pepsi Jumbo'),
                                ],
                              ),
                            ),
                            Container(
                              decoration: const BoxDecoration(
                                color: Colors.black,
                                shape: BoxShape.circle,
                              ),
                              padding: const EdgeInsets.all(15),
                              child: const Text(
                                '42',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () => agregarAlCarrito('Combo Estrella', 42.0, 'Combo'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Agregar Combo'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Información de contacto
            Container(
              color: Colors.red,
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Row(
                    children: [
                      Icon(Icons.delivery_dining, color: Colors.white),
                      SizedBox(width: 10),
                      Text('DELIVERY', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Row(
                    children: [
                      Icon(Icons.phone, color: Colors.green),
                      SizedBox(width: 10),
                      Text('933 214 908', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                  const Row(
                    children: [
                      Icon(Icons.phone, color: Colors.blue),
                      SizedBox(width: 10),
                      Text('01 6723 711', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.white),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'UBICACIÓN: Paradero la posta subiendo una cuadra',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.purple,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text('Yape', style: TextStyle(color: Colors.white)),
                      ),
                      const SizedBox(width: 20),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.teal,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text('Plin', style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _mostrarCarrito(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.8,
          child: CarritoScreen(
            carrito: carrito,
            onActualizar: (nuevoCarrito) {
              setState(() {
                carrito = nuevoCarrito;
              });
            },
          ),
        );
      },
    );
  }
}