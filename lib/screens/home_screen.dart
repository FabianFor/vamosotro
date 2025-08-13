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

  // 🏷️ CATEGORÍAS ACTUALIZADAS - CACHED
  static const List<Map<String, dynamic>> categorias = [
    {'nombre': 'Pizza Familiar', 'icono': Icons.local_pizza},
    {'nombre': 'Pizza Personal', 'icono': Icons.local_pizza_outlined},
    {'nombre': 'Combo Pizza', 'icono': Icons.local_pizza},
    {'nombre': 'Combo Broaster', 'icono': Icons.restaurant},
    {'nombre': 'Pizza Especial', 'icono': Icons.star},
    {'nombre': 'Fusión', 'icono': Icons.auto_awesome},
    {'nombre': 'Mostritos', 'icono': Icons.restaurant_menu}, // 🔥 ICONO DE MENÚ/COMIDA
  ];

  // 🔥 CACHE PARA EVITAR RECALCULAR TOTALES
  int _totalItems = 0;

  void _recalcularTotalItems() {
    _totalItems = carrito.fold(0, (sum, item) => sum + item.cantidad);
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
      _recalcularTotalItems(); // 🔥 SOLO RECALCULAR ITEMS, NO RECREAR UI COMPLETA
    });

    // 🔥 SNACKBAR MÁS LIGERO
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$nombre agregado'),
          duration: const Duration(milliseconds: 800),
          backgroundColor: colorPrimario,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _recalcularTotalItems();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      // 🔥 FORZAR TEXTO FIJO INDEPENDIENTE DE CONFIGURACIÓN DEL USUARIO
      data: MediaQuery.of(context).copyWith(
        textScaleFactor: 1.0, // Texto siempre al 100%
        devicePixelRatio: MediaQuery.of(context).devicePixelRatio,
      ),
      child: Scaffold(
        backgroundColor: colorFondo,
        // 🚀 OPTIMIZACIÓN: UN SOLO CUSTOM SCROLL VIEW CON SLIVERS
        body: CustomScrollView(
          // 🔥 MEJORA DE PERFORMANCE PARA LISTAS LARGAS
          cacheExtent: 500, // Cache items fuera de pantalla
          slivers: [
            _buildSliverAppBar(),
            _buildSliverCategorias(),
            ..._buildContenidoPorCategoria(), // 🔥 DEVUELVE MÚLTIPLES SLIVERS
            _buildSliverFooter(),
          ],
        ),
      ),
    );
  }

  // 🎨 SLIVER APP BAR OPTIMIZADO
  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 100,
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
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      // 🍕 LOGO DE IMAGEN
                      Container(
                        width: 45,
                        height: 45,
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
                                size: 24,
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
                                fontSize: 18,
                                letterSpacing: 1,
                              ),
                            ),
                            Text(
                              'Deliciosas pizzas artesanales',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 11,
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
        _buildCarritoButton(), // 🔥 WIDGET SEPARADO PARA OPTIMIZAR
      ],
    );
  }

  // 🛒 BOTÓN DE CARRITO OPTIMIZADO
  Widget _buildCarritoButton() {
    return Container(
      margin: const EdgeInsets.only(right: 15, top: 8, bottom: 8),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.shopping_cart, color: Colors.white, size: 22),
              onPressed: () => _mostrarCarrito(context),
            ),
          ),
          if (_totalItems > 0) // 🔥 USAR CACHE EN VEZ DE RECALCULAR
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
                  '$_totalItems',
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
    );
  }

  // 🏷️ CATEGORÍAS COMO SLIVER
  Widget _buildSliverCategorias() {
    return SliverToBoxAdapter(
      child: Container(
        color: colorTarjeta,
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: SizedBox(
          height: 70,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: categorias.length,
            // 🔥 CACHE PARA PERFORMANCE
            addAutomaticKeepAlives: true,
            itemBuilder: (context, index) {
              final categoria = categorias[index];
              final isSelected = categoriaSeleccionada == categoria['nombre'];
              
              return GestureDetector(
                onTap: () => setState(() => categoriaSeleccionada = categoria['nombre']),
                child: Container(
                  margin: const EdgeInsets.only(right: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  width: 90,
                  decoration: BoxDecoration(
                    gradient: isSelected ? LinearGradient(
                      colors: [colorPrimario, colorPrimario.withOpacity(0.8)],
                    ) : null,
                    color: isSelected ? null : Colors.grey[100],
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: isSelected ? [
                      BoxShadow(
                        color: colorPrimario.withOpacity(0.3),
                        spreadRadius: 1,
                        blurRadius: 6,
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
                        size: 20,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        categoria['nombre'],
                        style: TextStyle(
                          color: isSelected ? Colors.white : colorPrimario,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                          fontSize: 9,
                          height: 1.1,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
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
    );
  }

  // 🚀 DEVOLVER SLIVERS EN VEZ DE WIDGET ÚNICO
  List<Widget> _buildContenidoPorCategoria() {
    switch (categoriaSeleccionada) {
      case 'Pizza Familiar':
        return _buildPizzasFamiliares();
      case 'Pizza Personal':
        return _buildPizzasPersonales();
      case 'Combo Pizza':
        return _buildCombosPizza();
      case 'Combo Broaster':
        return _buildCombosBroaster();
      case 'Pizza Especial':
        return _buildPizzasEspeciales();
      case 'Fusión':
        return _buildFusiones();
      case 'Mostritos':
        return _buildMostritos();
      default:
        return _buildPizzasFamiliares();
    }
  }

  // 🍕 PIZZAS FAMILIARES CON SLIVER LIST
  List<Widget> _buildPizzasFamiliares() {
    return [
      _buildSliverSectionHeader(
        'Familiares',
        'Porque en familia sabe mejor',
        Icons.local_pizza,
        colorPrimario,
        PizzaData.pizzasFamiliaresOrdenadas.length,
      ),
      
      SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final pizza = PizzaData.pizzasFamiliaresOrdenadas[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: PizzaCard(
                pizza: pizza,
                tamano: 'Familiar',
                precio: pizza.precioFamiliar,
                onAgregarAlCarrito: () => agregarAlCarrito(
                  pizza.nombre,
                  pizza.precioFamiliar,
                  'Familiar',
                  pizza.imagen,
                ),
              ),
            );
          },
          childCount: PizzaData.pizzasFamiliaresOrdenadas.length,
          addAutomaticKeepAlives: true, // 🔥 MANTENER WIDGETS EN MEMORIA
        ),
      ),
    ];
  }

  List<Widget> _buildPizzasPersonales() {
    return [
      _buildSliverSectionHeader(
        'Personales',
        'Ideales para disfrutar solo',
        Icons.local_pizza_outlined,
        colorSecundario,
        PizzaData.pizzasPersonalesOrdenadas.length,
      ),
      
      SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final pizza = PizzaData.pizzasPersonalesOrdenadas[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: PizzaCard(
                pizza: pizza,
                tamano: 'Personal',
                precio: pizza.precioPersonal,
                onAgregarAlCarrito: () => agregarAlCarrito(
                  pizza.nombre,
                  pizza.precioPersonal,
                  'Personal',
                  pizza.imagen,
                ),
              ),
            );
          },
          childCount: PizzaData.pizzasPersonalesOrdenadas.length,
          addAutomaticKeepAlives: true,
        ),
      ),
    ];
  }

  List<Widget> _buildMostritos() {
    return [
      _buildSliverSectionHeader(
        'Mostritos',
        'Un mostrito que no asusta',
        Icons.fastfood,
        Colors.orange,
        PizzaData.mostritosOrdenados.length,
      ),
      
      SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final mostrito = PizzaData.mostritosOrdenados[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: MostritoCard(
                mostrito: mostrito,
                onAgregarAlCarrito: () => agregarAlCarrito(
                  mostrito.nombre,
                  mostrito.precio,
                  'Mostrito',
                  mostrito.imagen,
                ),
              ),
            );
          },
          childCount: PizzaData.mostritosOrdenados.length,
          addAutomaticKeepAlives: true,
        ),
      ),
    ];
  }

  List<Widget> _buildPizzasEspeciales() {
    return [
      _buildSliverSectionHeader(
        'Especiales',
        'Múltiples sabores en una pizza',
        Icons.star,
        Colors.purple,
        PizzaData.pizzasEspecialesOrdenadas.length,
      ),
      
      SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final pizzaEspecial = PizzaData.pizzasEspecialesOrdenadas[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: PizzaEspecialCard(
                pizzaEspecial: pizzaEspecial,
                onAgregarAlCarrito: () => agregarAlCarrito(
                  pizzaEspecial.nombre,
                  pizzaEspecial.precio,
                  pizzaEspecial.tipo,
                  pizzaEspecial.imagen,
                ),
              ),
            );
          },
          childCount: PizzaData.pizzasEspecialesOrdenadas.length,
          addAutomaticKeepAlives: true,
        ),
      ),
    ];
  }

  List<Widget> _buildCombosBroaster() {
    return [
      _buildSliverSectionHeader(
        'Combo Broaster',
        'Sabor crujiente que conquista',
        Icons.restaurant,
        Colors.brown,
        PizzaData.combosBroasterOrdenados.length,
      ),
      
      SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final combo = PizzaData.combosBroasterOrdenados[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ComboCard(
                combo: combo,
                onAgregarAlCarrito: () => agregarAlCarrito(
                  combo.nombre,
                  combo.precio,
                  'Combo Broaster',
                  combo.imagen,
                ),
              ),
            );
          },
          childCount: PizzaData.combosBroasterOrdenados.length,
          addAutomaticKeepAlives: true,
        ),
      ),
    ];
  }

  List<Widget> _buildFusiones() {
    return [
      _buildSliverSectionHeader(
        'Fusiones',
        'Pizza y broaster juntos',
        Icons.auto_awesome,
        Colors.deepPurple,
        PizzaData.fusionesOrdenadas.length,
      ),
      
      SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final fusion = PizzaData.fusionesOrdenadas[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ComboCard(
                combo: fusion,
                onAgregarAlCarrito: () => agregarAlCarrito(
                  fusion.nombre,
                  fusion.precio,
                  'Fusión',
                  fusion.imagen,
                ),
              ),
            );
          },
          childCount: PizzaData.fusionesOrdenadas.length,
          addAutomaticKeepAlives: true,
        ),
      ),
    ];
  }

  List<Widget> _buildCombosPizza() {
    return [
      _buildSliverSectionHeader(
        'Combo Pizza',
        'Combinaciones especiales',
        Icons.local_pizza,
        Colors.indigo,
        PizzaData.combosPizzaOrdenados.length,
      ),
      
      SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final comboPizza = PizzaData.combosPizzaOrdenados[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ComboCard(
                combo: comboPizza,
                onAgregarAlCarrito: () => agregarAlCarrito(
                  comboPizza.nombre,
                  comboPizza.precio,
                  'Combo Pizza',
                  comboPizza.imagen,
                ),
              ),
            );
          },
          childCount: PizzaData.combosPizzaOrdenados.length,
          addAutomaticKeepAlives: true,
        ),
      ),
    ];
  }

  // 🎨 HEADER DE SECCIÓN COMO SLIVER
  Widget _buildSliverSectionHeader(String titulo, String subtitulo, IconData icono, Color color, int cantidad) {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.fromLTRB(20, 16, 20, 12),
        padding: const EdgeInsets.all(12),
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
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icono, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitulo,
                    style: const TextStyle(
                      fontSize: 11,
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
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: colorAcento.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '$cantidad opciones',
                style: TextStyle(
                  fontSize: 9,
                  color: colorAcento.withOpacity(0.8),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 📞 FOOTER COMO SLIVER
  Widget _buildSliverFooter() {
    return SliverToBoxAdapter(
      child: Container(
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
                        Icon(Icons.phone, color: Colors.white, size: 18),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            '933 214 908 | 01 6723 711',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.white, size: 18),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Paradero la posta subiendo una cuadra',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.purple,
                            borderRadius: BorderRadius.circular(18),
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
                              fontSize: 11,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.teal,
                            borderRadius: BorderRadius.circular(18),
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
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),
              
              Text(
                '© 2024 Pizza Fabichelo',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 11,
                ),
              ),
            ],
          ),
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
                _recalcularTotalItems(); // 🔥 ACTUALIZAR CACHE
              });
            },
          ),
        );
      },
    );
  }
}