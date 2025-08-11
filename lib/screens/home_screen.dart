import 'package:flutter/material.dart';
import '../models/models.dart';
import '../data/pizza_data.dart';
import '../widgets/pizza_card.dart';
import '../widgets/combo_card.dart';
import '../widgets/mostrito_card.dart';
import '../widgets/pizza_especial_card.dart';
import 'carrito_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ItemPedido> carrito = [];
  String categoriaSeleccionada = 'Pizza Familiar';

  // 🎨 PALETA DE COLORES INSPIRADA EN EL LOGO  
  static const Color colorPrimario = Color(0xFFD4332A); // Rojo del logo
  static const Color colorSecundario = Color(0xFF2C5F2D); // Verde del logo 
  static const Color colorAcento = Color(0xFFF4B942); // Amarillo/dorado
  static const Color colorFondo = Color(0xFFF8F9FA);
  static const Color colorTarjeta = Colors.white;

  // 🏷️ CATEGORÍAS ACTUALIZADAS
  final List<Map<String, dynamic>> categorias = [
    {'nombre': 'Pizza Familiar', 'icono': Icons.local_pizza},
    {'nombre': 'Pizza Personal', 'icono': Icons.local_pizza_outlined},
    {'nombre': 'Mostritos', 'icono': Icons.fastfood},
    {'nombre': 'Pizza Especial', 'icono': Icons.star},
    {'nombre': 'Combo Broaster', 'icono': Icons.restaurant},
    {'nombre': 'Fusión', 'icono': Icons.auto_awesome},
  ];

  double get totalCarrito {
    return carrito.fold(0.0, (sum, item) => sum + (item.precioTotal * item.cantidad));
  }

  void agregarAlCarrito(String nombre, double precio, String tamano, String imagen) {
    setState(() {
      int index = carrito.indexWhere((item) => 
        item.nombre == nombre && item.tamano == tamano && item.adicionales.isEmpty);
      
      if (index != -1) {
        carrito[index] = carrito[index].copyWith(cantidad: carrito[index].cantidad + 1);
      } else {
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
        backgroundColor: colorPrimario,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorFondo,
      body: CustomScrollView(
        slivers: [
          // 🎨 SLIVER APP BAR
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            backgroundColor: colorPrimario,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      colorPrimario,
                      colorPrimario.withOpacity(0.8),
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            // 🍕 LOGO DE IMAGEN
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: ClipOval(
                                child: Image.asset(
                                  'assets/images/logo/pizza_fabichelo_logo.png',
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(
                                      Icons.local_pizza,
                                      color: colorSecundario,
                                      size: 28,
                                    );
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'FABICHELO',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 20,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                  Text(
                                    'Deliciosas pizzas artesanales',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            actions: [
              // 🛒 CARRITO DE COMPRAS
              Container(
                margin: const EdgeInsets.only(right: 15, top: 8, bottom: 8),
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.shopping_cart, color: Colors.white),
                        onPressed: () => _mostrarCarrito(context),
                      ),
                    ),
                    if (carrito.isNotEmpty)
                      Positioned(
                        right: 4,
                        top: 4,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: colorSecundario,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: colorSecundario.withOpacity(0.3),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 18,
                            minHeight: 18,
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
              ),
            ],
          ),

          // 🏷️ CATEGORÍAS HORIZONTALES MEJORADAS
          SliverToBoxAdapter(
            child: Container(
              color: colorTarjeta,
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: SizedBox(
                height: 85, // Aumentado para mejor visual
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: categorias.length,
                  itemBuilder: (context, index) {
                    final categoria = categorias[index];
                    final isSelected = categoriaSeleccionada == categoria['nombre'];
                    
                    return GestureDetector(
                      onTap: () => setState(() => categoriaSeleccionada = categoria['nombre']),
                      child: Container(
                        margin: const EdgeInsets.only(right: 12), // Reducido para mejor spacing
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), // Ajustado
                        width: 95, // Ancho fijo para evitar problemas de texto cortado
                        decoration: BoxDecoration(
                          gradient: isSelected ? LinearGradient(
                            colors: [colorPrimario, colorPrimario.withOpacity(0.8)],
                          ) : null,
                          color: isSelected ? null : Colors.grey[100],
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: isSelected ? [
                            BoxShadow(
                              color: colorPrimario.withOpacity(0.3),
                              spreadRadius: 1,
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ] : null,
                          border: !isSelected ? Border.all(color: Colors.grey[300]!) : null,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              categoria['icono'],
                              color: isSelected ? Colors.white : colorPrimario,
                              size: 24,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              categoria['nombre'],
                              style: TextStyle(
                                color: isSelected ? Colors.white : colorPrimario,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                fontSize: 10,
                                height: 1.1,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 2, // Permitir 2 líneas
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),

          // 📱 CONTENIDO PRINCIPAL
          SliverToBoxAdapter(
            child: _buildContenidoPorCategoria(),
          ),

          // 📞 FOOTER
          SliverToBoxAdapter(
            child: _buildFooter(),
          ),
        ],
      ),
    );
  }

  Widget _buildContenidoPorCategoria() {
    switch (categoriaSeleccionada) {
      case 'Pizza Familiar':
        return _buildPizzasFamiliares();
      case 'Pizza Personal':
        return _buildPizzasPersonales();
      case 'Mostritos':
        return _buildMostritos();
      case 'Pizza Especial':
        return _buildPizzasEspeciales();
      case 'Combo Broaster':
        return _buildCombosBroaster();
      case 'Fusión':
        return _buildFusiones();
      default:
        return _buildPizzasFamiliares();
    }
  }

  Widget _buildPizzasFamiliares() {
    return Column(
      children: [
        _buildSectionHeader(
          'Familiares',
          'Perfectas para compartir en familia',
          Icons.local_pizza,
          colorPrimario,
          PizzaData.pizzasFamiliaresOrdenadas.length,
          etiquetasExtra: ['30cm', '8 tajadas'],
        ),
        
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: PizzaData.pizzasFamiliaresOrdenadas.length,
          itemBuilder: (context, index) {
            final pizza = PizzaData.pizzasFamiliaresOrdenadas[index];
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
      ],
    );
  }

  Widget _buildPizzasPersonales() {
    return Column(
      children: [
        _buildSectionHeader(
          'Personales',
          'Ideales para disfrutar solo',
          Icons.local_pizza_outlined,
          colorSecundario,
          PizzaData.pizzasPersonalesOrdenadas.length,
          etiquetasExtra: ['18cm', '4 tajadas'],
        ),
        
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: PizzaData.pizzasPersonalesOrdenadas.length,
          itemBuilder: (context, index) {
            final pizza = PizzaData.pizzasPersonalesOrdenadas[index];
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
      ],
    );
  }

  Widget _buildMostritos() {
    return Column(
      children: [
        _buildSectionHeader(
          'Mostritos',
          'Broaster con acompañamientos deliciosos',
          Icons.fastfood,
          Colors.orange,
          PizzaData.mostritosOrdenados.length,
        ),
        
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: PizzaData.mostritosOrdenados.length,
          itemBuilder: (context, index) {
            final mostrito = PizzaData.mostritosOrdenados[index];
            return MostritoCard(
              mostrito: mostrito,
              onAgregarAlCarrito: () => agregarAlCarrito(
                mostrito.nombre,
                mostrito.precio,
                'Mostrito',
                mostrito.imagen,
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildPizzasEspeciales() {
    return Column(
      children: [
        _buildSectionHeader(
          'Especiales',
          'Múltiples sabores en una pizza',
          Icons.star,
          Colors.purple,
          PizzaData.pizzasEspecialesOrdenadas.length,
          etiquetasExtra: ['Familiar'],
        ),
        
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: PizzaData.pizzasEspecialesOrdenadas.length,
          itemBuilder: (context, index) {
            final pizzaEspecial = PizzaData.pizzasEspecialesOrdenadas[index];
            return PizzaEspecialCard(
              pizzaEspecial: pizzaEspecial,
              onAgregarAlCarrito: () => agregarAlCarrito(
                pizzaEspecial.nombre,
                pizzaEspecial.precio,
                pizzaEspecial.tipo,
                pizzaEspecial.imagen,
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildCombosBroaster() {
    return Column(
      children: [
        _buildSectionHeader(
          'Combo Broaster',
          'Pollo broaster crispy con acompañamientos',
          Icons.restaurant,
          Colors.brown,
          PizzaData.combosBroasterOrdenados.length,
        ),
        
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: PizzaData.combosBroasterOrdenados.length,
          itemBuilder: (context, index) {
            final combo = PizzaData.combosBroasterOrdenados[index];
            return ComboCard(
              combo: combo,
              onAgregarAlCarrito: () => agregarAlCarrito(
                combo.nombre,
                combo.precio,
                'Combo Broaster',
                combo.imagen,
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildFusiones() {
    return Column(
      children: [
        _buildSectionHeader(
          'Fusiones',
          'Lo mejor de pizza y broaster juntos',
          Icons.auto_awesome,
          Colors.deepPurple,
          PizzaData.fusionesOrdenadas.length,
          etiquetasExtra: ['Pizza + Pollo'],
        ),
        
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: PizzaData.fusionesOrdenadas.length,
          itemBuilder: (context, index) {
            final fusion = PizzaData.fusionesOrdenadas[index];
            return ComboCard(
              combo: fusion,
              onAgregarAlCarrito: () => agregarAlCarrito(
                fusion.nombre,
                fusion.precio,
                'Fusión',
                fusion.imagen,
              ),
            );
          },
        ),
      ],
    );
  }

  // 🎨 MÉTODO PARA CREAR HEADER DE SECCIÓN CON ETIQUETAS MEJORADAS
  Widget _buildSectionHeader(String titulo, String subtitulo, IconData icono, Color color, int cantidad, {List<String>? etiquetasExtra}) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 20, 20, 15),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.1), Colors.transparent],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icono, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        titulo,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    // ETIQUETAS EXTRAS MEJORADAS
                    if (etiquetasExtra != null) ...[
                      const SizedBox(width: 8),
                      Flexible(
                        child: Wrap(
                          spacing: 4,
                          children: etiquetasExtra.map((etiqueta) {
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: color.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: color.withOpacity(0.3)),
                              ),
                              child: Text(
                                etiqueta,
                                style: TextStyle(
                                  fontSize: 9,
                                  color: color,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  subtitulo,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: colorAcento.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '$cantidad opciones',
              style: TextStyle(
                fontSize: 10,
                color: colorAcento.withOpacity(0.8),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      margin: const EdgeInsets.only(top: 30),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            colorPrimario,
            colorPrimario.withOpacity(0.9),
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // 📱 INFORMACIÓN DE CONTACTO
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withOpacity(0.2)),
              ),
              child: Column(
                children: [
                  const Row(
                    children: [
                      Icon(Icons.phone, color: Colors.white, size: 20),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          '933 214 908 | 01 6723 711',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.white, size: 20),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Paradero la posta subiendo una cuadra',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // 💳 MÉTODOS DE PAGO
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.purple,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.purple.withOpacity(0.3),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Text(
                          'Yape',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.teal,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.teal.withOpacity(0.3),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Text(
                          'Plin',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // 🍕 MARCA
            Text(
              '© 2024 Pizza Fabichelo',
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 12,
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