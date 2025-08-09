import 'package:flutter/material.dart';
import '../models/models.dart';
import '../data/pizza_data.dart';
import '../widgets/pizza_card.dart';
import '../widgets/combo_card.dart';
import 'carrito_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ItemPedido> carrito = [];
  int selectedTabIndex = 0; // 🔥 ÍNDICE DE TAB SELECCIONADO

  double get totalCarrito {
    return carrito.fold(0.0, (sum, item) => sum + (item.precioTotal * item.cantidad));
  }

  void agregarAlCarrito(String nombre, double precio, String tamano, String imagen) {
    setState(() {
      // Buscar si ya existe el item
      int index = carrito.indexWhere((item) => 
        item.nombre == nombre && item.tamano == tamano && item.adicionales.isEmpty);
      
      if (index != -1) {
        // Si existe, incrementar cantidad
        carrito[index] = carrito[index].copyWith(cantidad: carrito[index].cantidad + 1);
      } else {
        // Si no existe, agregar nuevo
        carrito.add(ItemPedido(
          nombre: nombre,
          precio: precio,
          cantidad: 1,
          tamano: tamano,
          imagen: imagen,
        ));
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$nombre ($tamano) agregado al carrito'),
        duration: const Duration(seconds: 1),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
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
      body: Column(
        children: [
          // 🔥 TABS PARA NAVEGAR ENTRE SECCIONES
          Container(
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => selectedTabIndex = 0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      decoration: BoxDecoration(
                        color: selectedTabIndex == 0 ? Colors.red : Colors.white,
                        border: Border(
                          bottom: BorderSide(
                            color: selectedTabIndex == 0 ? Colors.red : Colors.grey[300]!,
                            width: 2,
                          ),
                        ),
                      ),
                      child: Text(
                        'Pizzas Familiares',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: selectedTabIndex == 0 ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => selectedTabIndex = 1),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      decoration: BoxDecoration(
                        color: selectedTabIndex == 1 ? Colors.red : Colors.white,
                        border: Border(
                          bottom: BorderSide(
                            color: selectedTabIndex == 1 ? Colors.red : Colors.grey[300]!,
                            width: 2,
                          ),
                        ),
                      ),
                      child: Text(
                        'Pizzas Personales',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: selectedTabIndex == 1 ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => selectedTabIndex = 2),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      decoration: BoxDecoration(
                        color: selectedTabIndex == 2 ? Colors.red : Colors.white,
                        border: Border(
                          bottom: BorderSide(
                            color: selectedTabIndex == 2 ? Colors.red : Colors.grey[300]!,
                            width: 2,
                          ),
                        ),
                      ),
                      child: Text(
                        'Combos',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: selectedTabIndex == 2 ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 🔥 CONTENIDO SEGÚN TAB SELECCIONADO
          Expanded(
            child: IndexedStack(
              index: selectedTabIndex,
              children: [
                // Tab 0: Pizzas Familiares
                _buildPizzasFamiliares(),
                
                // Tab 1: Pizzas Personales
                _buildPizzasPersonales(),
                
                // Tab 2: Combos
                _buildCombos(),
              ],
            ),
          ),

          // Footer con información (siempre visible)
          _buildFooter(),
        ],
      ),
    );
  }

  // 🔥 SECCIÓN DE PIZZAS FAMILIARES
  Widget _buildPizzasFamiliares() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: PizzaData.pizzas.length,
      itemBuilder: (context, index) {
        final pizza = PizzaData.pizzas[index];
        return PizzaCard(
          pizza: pizza,
          tamano: 'Familiar',
          precio: pizza.precioFamiliar,
          onAgregarAlCarrito: () => agregarAlCarrito(
            pizza.nombre,
            pizza.precioFamiliar,
            'Familiar',
            pizza.imagen,
          ),
        );
      },
    );
  }

  // 🔥 SECCIÓN DE PIZZAS PERSONALES
  Widget _buildPizzasPersonales() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: PizzaData.pizzas.length,
      itemBuilder: (context, index) {
        final pizza = PizzaData.pizzas[index];
        return PizzaCard(
          pizza: pizza,
          tamano: 'Personal',
          precio: pizza.precioPersonal,
          onAgregarAlCarrito: () => agregarAlCarrito(
            pizza.nombre,
            pizza.precioPersonal,
            'Personal',
            pizza.imagen,
          ),
        );
      },
    );
  }

  // 🔥 SECCIÓN DE COMBOS
  Widget _buildCombos() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: PizzaData.combos.length,
      itemBuilder: (context, index) {
        final combo = PizzaData.combos[index];
        return ComboCard(
          combo: combo,
          onAgregarAlCarrito: () => agregarAlCarrito(
            combo.nombre,
            combo.precio,
            'Combo',
            combo.imagen,
          ),
        );
      },
    );
  }

  // 🔥 FOOTER CON INFORMACIÓN
  Widget _buildFooter() {
    return Container(
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