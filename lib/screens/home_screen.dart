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
  String categoriaSeleccionada = 'Pizza Familiar'; // 🔥 CATEGORÍA POR DEFECTO

  // 🔥 LISTA DE CATEGORÍAS SEPARADAS
  final List<Map<String, dynamic>> categorias = [
    {'nombre': 'Pizza Familiar', 'icono': Icons.local_pizza},
    {'nombre': 'Pizza Personal', 'icono': Icons.local_pizza_outlined},
    {'nombre': 'Combos', 'icono': Icons.restaurant_menu},
  ];

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
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFFF6B35),
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.local_pizza, color: Color(0xFFFF6B35)),
            ),
            const SizedBox(width: 10),
            const Text(
              'PIZZA FABICHELO',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ],
        ),
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
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '${carrito.fold(0, (sum, item) => sum + item.cantidad)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
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
          // 🔥 HEADER CON INFORMACIÓN DE DELIVERY
          Container(
            color: const Color(0xFFFF6B35),
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
            child: Row(
              children: [
                const Icon(Icons.delivery_dining, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                const Text(
                  'DELIVERY',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.location_on, color: Colors.white, size: 14),
                      SizedBox(width: 4),
                      Text(
                        'La Posta',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 🔥 CATEGORÍAS HORIZONTALES SEPARADAS
          Container(
            color: Colors.white,
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: categorias.length,
              itemBuilder: (context, index) {
                final categoria = categorias[index];
                final isSelected = categoriaSeleccionada == categoria['nombre'];
                
                return GestureDetector(
                  onTap: () => setState(() => categoriaSeleccionada = categoria['nombre']),
                  child: Container(
                    margin: const EdgeInsets.only(right: 16, top: 16, bottom: 16),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFFFF6B35) : Colors.grey[100],
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: isSelected ? [
                        BoxShadow(
                          color: const Color(0xFFFF6B35).withOpacity(0.3),
                          spreadRadius: 1,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ] : null,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          categoria['icono'],
                          color: isSelected ? Colors.white : Colors.grey[600],
                          size: 24,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          categoria['nombre'],
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.grey[700],
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // 🔥 CONTENIDO SEGÚN CATEGORÍA SELECCIONADA
          Expanded(
            child: _buildContenidoPorCategoria(),
          ),

          // Footer con información
          _buildFooter(),
        ],
      ),
    );
  }

  // 🔥 CONSTRUIR CONTENIDO SEGÚN CATEGORÍA
  Widget _buildContenidoPorCategoria() {
    switch (categoriaSeleccionada) {
      case 'Pizza Familiar':
        return _buildPizzasFamiliares();
      case 'Pizza Personal':
        return _buildPizzasPersonales();
      case 'Combos':
        return _buildCombos();
      default:
        return _buildPizzasFamiliares();
    }
  }

  // 🔥 SECCIÓN DE PIZZAS FAMILIARES
  Widget _buildPizzasFamiliares() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 🔥 TÍTULO DE SECCIÓN
        Container(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
          child: Row(
            children: [
              const Icon(Icons.local_pizza, color: Color(0xFFFF6B35), size: 24),
              const SizedBox(width: 10),
              const Text(
                'Pizzas Familiares',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${PizzaData.pizzas.length} opciones',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.green[800],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        
        // 🔥 LISTA DE PIZZAS FAMILIARES
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 12),
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
          ),
        ),
      ],
    );
  }

  // 🔥 SECCIÓN DE PIZZAS PERSONALES
  Widget _buildPizzasPersonales() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 🔥 TÍTULO DE SECCIÓN
        Container(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
          child: Row(
            children: [
              const Icon(Icons.local_pizza_outlined, color: Color(0xFFFF6B35), size: 24),
              const SizedBox(width: 10),
              const Text(
                'Pizzas Personales',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${PizzaData.pizzas.length} opciones',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.blue[800],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        
        // 🔥 LISTA DE PIZZAS PERSONALES
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 12),
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
          ),
        ),
      ],
    );
  }

  // 🔥 SECCIÓN DE COMBOS
  Widget _buildCombos() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 🔥 TÍTULO DE SECCIÓN
        Container(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
          child: Row(
            children: [
              const Icon(Icons.restaurant_menu, color: Color(0xFFFF6B35), size: 24),
              const SizedBox(width: 10),
              const Text(
                'Combos Especiales',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.orange[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${PizzaData.combos.length} combo${PizzaData.combos.length != 1 ? 's' : ''}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.orange[800],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        
        // 🔥 LISTA DE COMBOS
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 12),
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
          ),
        ),
      ],
    );
  }

  // 🔥 FOOTER CON INFORMACIÓN
  Widget _buildFooter() {
    return Container(
      color: const Color(0xFFFF6B35),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Row(
            children: [
              Icon(Icons.phone, color: Colors.green),
              SizedBox(width: 10),
              Text('933 214 908', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
                  'Paradero la posta subiendo una cuadra',
                  style: TextStyle(color: Colors.white, fontSize: 13),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.purple,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text('Yape', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 20),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.teal,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text('Plin', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.8,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
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