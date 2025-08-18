import 'package:flutter/material.dart';
import '../models/models.dart';
import '../data/pizza_data.dart'; 
import '../widgets/pizza_card.dart';
import '../widgets/combo_card.dart';
import '../widgets/mostrito_card.dart';
import '../widgets/pizza_especial_card.dart';
import '../widgets/oferta_miercoles_card.dart';
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
  static const Color colorPrimario = Color(0xFFD4332A); 
  static const Color colorSecundario = Color(0xFF2C5F2D);
  static const Color colorAcento = Color(0xFFF4B942); 
  static const Color colorFondo = Color(0xFFF8F9FA);
  static const Color colorTarjeta = Colors.white;
  static const Color colorOfertaMiercoles = Color.fromARGB(255, 255, 0, 0);

  // 🔥 VERIFICAR SI HOY ES MIÉRCOLES - FORZADO PARA TESTING
bool get esMiercoles => DateTime.now().weekday == DateTime.wednesday;
  // 🔥 OFERTAS ESPECIALES MIÉRCOLES
  static final List<Map<String, dynamic>> ofertasMiercoles = [
    {
      'nombre': 'Combo familiar',
      'descripcionOriginal': 'Americana + pepsi 750ml + 3 porciones de pan al ajo',
      'precioOriginal': 29.0,
      'precioOferta': 26.0,
      'imagen': 'assets/images/combos/combo_familiar_pizza.png',
      'descuento': '10%',
    },
    {
      'nombre': 'Combo brother',
      'descripcionOriginal': '3 pizzas personales pepperoni, hawaiana y americana + pepsi 750ml',
      'precioOriginal': 32.0,
      'precioOferta': 28.0,
      'imagen': 'assets/images/combos/combo_brother.png',
      'descuento': '13%',
    },
        {
      'nombre': 'Familiar + broaster',
      'descripcionOriginal': 'Pizza familiar + 6 brazitos de pollo + Pepsi 750ml',
      'precioOriginal': 35.0,
      'precioOferta': 31.0,
      'imagen': 'assets/images/combos/familiar_broaster.png',
      'descuento': '11%',
    },
    {
      'nombre': 'Combo estrella',
      'descripcionOriginal': 'Pizza familiar 2 sabores + 6 Bracitos + Porción de papas + Pepsi 750ml',
      'precioOriginal': 42.0,
      'precioOferta': 38.0,
      'imagen': 'assets/images/combos/combo_estrella.png',
      'descuento': '10%',
    },
  ];

  // 🔥 CATEGORÍAS DINÁMICAS SIMPLIFICADAS
  List<Map<String, dynamic>> get categoriasDinamicas {
    List<Map<String, dynamic>> cats = [
      // 🔥 CATEGORÍA ESPECIAL DE MIÉRCOLES (SOLO LOS MIÉRCOLES)
      if (esMiercoles) {
        'nombre': 'Ofertas los Miércoles',
        'icono': Icons.local_fire_department,
        'esEspecial': true,
        'color': colorOfertaMiercoles,
      },
      
      // CATEGORÍAS NORMALES
      {'nombre': 'Pizza Personal', 'icono': Icons.local_pizza_outlined},
      {'nombre': 'Pizza Familiar', 'icono': Icons.local_pizza},
      {'nombre': 'Pizza Extra Grande', 'icono': Icons.local_pizza},
      {'nombre': 'Combo Pizza', 'icono': Icons.local_pizza},
      {'nombre': 'Pizza 2 sabores', 'icono': Icons.star},
      {'nombre': 'Fusión', 'icono': Icons.auto_awesome},
      {'nombre': 'Combo Broaster', 'icono': Icons.restaurant},
      {'nombre': 'Mostritos', 'icono': Icons.restaurant_menu}, 
    ];

    return cats;
  }

  int _totalItems = 0;

  void _recalcularTotalItems() {
    _totalItems = carrito.fold(0, (sum, item) => sum + item.cantidad);
  }

  void agregarAlCarrito(String nombre, double precio, String tamano, String imagen) {
    setState(() {
      // 🔥 VERIFICAR SI YA EXISTE EL ITEM EXACTO
      int index = carrito.indexWhere((item) => 
        item.nombre == nombre && item.tamano == tamano && item.adicionales.isEmpty);
      
      if (index != -1) {
        carrito[index] = carrito[index].copyWith(cantidad: carrito[index].cantidad + 1);
      } else {
        // 🔥 CREAR NUEVO ITEM CON LÓGICAS ESPECIALES
        bool tienePrimeraGaseosa = PizzaData.puedeSerPrimeraGaseosa(nombre, tamano);
        
        carrito.add(ItemPedido(
          nombre: nombre,
          precio: precio,
          cantidad: 1,
          tamano: tamano,
          imagen: imagen,
          tienePrimeraGaseosa: tienePrimeraGaseosa,
        ));
      }
      _recalcularTotalItems(); 
    });

    // 🔥 MENSAJE ESPECIAL PARA OFERTAS DE MIÉRCOLES
    String mensaje = '✅ $nombre agregado';
    Color colorMensaje = const Color.fromARGB(255, 41, 114, 41);
    
    if (esMiercoles && _esOfertaMiercoles(nombre)) {
      mensaje = 'Oferta Miércoles agregada $nombre';
      colorMensaje = const Color.fromARGB(255, 255, 0, 0);
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(mensaje),
          duration: const Duration(milliseconds: 2000),
          backgroundColor: colorMensaje,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  // 🔥 VERIFICAR SI UN PRODUCTO ES OFERTA DE MIÉRCOLES
  bool _esOfertaMiercoles(String nombre) {
    return ofertasMiercoles.any((oferta) => 
      nombre.toLowerCase().contains(oferta['nombre'].toLowerCase()));
  }

  // 🔥 FILTRAR COMBOS NORMALES EN MIÉRCOLES
  List<Combo> _filtrarCombosSiEsMiercoles(List<Combo> combos) {
    if (!esMiercoles) return combos;
    
    // Remover combos que están en oferta especial
    return combos.where((combo) => 
      !ofertasMiercoles.any((oferta) => 
        combo.nombre.toLowerCase().contains(oferta['nombre'].toLowerCase()))).toList();
  }

  @override
  void initState() {
    super.initState();
    _recalcularTotalItems();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaler: const TextScaler.linear(1.0), 
        devicePixelRatio: MediaQuery.of(context).devicePixelRatio,
      ),
      child: Scaffold(
        backgroundColor: colorFondo,
        body: CustomScrollView(
          slivers: [
            _buildSliverAppBar(),
            _buildSliverCategorias(),
            ..._buildContenidoPorCategoria(), 
            _buildSliverFooter(),
          ],
        ),
      ),
    );
  }

Widget _buildSliverAppBar() {
  return SliverAppBar(
    expandedHeight: 90,
    floating: false,
    pinned: true,
    backgroundColor: const Color(0xFFD4332A), // 🔥 mismo rojo que abajo,
    elevation: 0,
    automaticallyImplyLeading: false,
    toolbarHeight: 90,

    title: Container(
      height: 70,
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        children: [
          // 🍕 LOGO DE IMAGEN MÁS COMPACTO
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 6,
                  offset: const Offset(0, 1),
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
                    size: 20,
                  );
                },
              ),
            ),
          ),
          const SizedBox(width: 10),
          
          // 📝 INFORMACIÓN MÁS COMPACTA CON INDICADOR DE MIÉRCOLES
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    const Text(
                      'FABICHELO',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 16,
                        letterSpacing: 0.8,
                      ),
                    ),
                    // 🔥 INDICADOR ESPECIAL MIÉRCOLES (SIN ANIMACIÓN)
                    if (esMiercoles) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 0, 0, 0),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          '🔥 OFERTAS',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 1),
                Text(
                  esMiercoles 
                    ? '¡Miércoles de ofertas especiales!'
                    : 'Deliciosas pizzas artesanales',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 10,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
          
          // 🛒 CARRITO MEJORADO
          GestureDetector(
            onTap: () => _mostrarCarrito(context),
            behavior: HitTestBehavior.opaque,
            child: Container(
              width: 65,
              height: 65,
              padding: const EdgeInsets.all(10),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: const Icon(
                      Icons.shopping_cart, 
                      color: Colors.white, 
                      size: 24
                    ),
                  ),
                  
                  if (_totalItems > 0)
                    Positioned(
                      right: 5,
                      top: 5,
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 40, 180, 43),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 22,
                          minHeight: 22,
                        ),
                        child: Text(
                          _totalItems > 99 ? '99+' : '$_totalItems',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            height: 1.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
    flexibleSpace: Container(
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
    ),
  );
}

// 🔥 CATEGORÍAS SIMPLIFICADAS - BADGE "HOY" ARRIBA CENTRADO VISIBLE
Widget _buildSliverCategorias() {
  return SliverToBoxAdapter(
    child: Container(
      color: colorTarjeta,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: SizedBox(
        height: 85, // ⬅️ más alto para que el badge no se corte
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: categoriasDinamicas.length,
          itemBuilder: (context, index) {
            final categoria = categoriasDinamicas[index];
            final isSelected = categoriaSeleccionada == categoria['nombre'];
            final esEspecial = categoria['esEspecial'] == true;

            return GestureDetector(
              onTap: () => setState(() => categoriaSeleccionada = categoria['nombre']),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // Contenedor principal de la categoría
                  Container(
                    margin: const EdgeInsets.only(right: 10, top: 10), // ⬅️ bajamos un poco para que quede espacio arriba
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    width: esEspecial ? 110 : 90,
                    decoration: BoxDecoration(
                      gradient: isSelected
                          ? (esEspecial
                              ? LinearGradient(
                                  colors: [
                                    const Color.fromARGB(255, 255, 0, 0),
                                    const Color.fromARGB(255, 255, 0, 0).withOpacity(0.8)
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                )
                              : LinearGradient(
                                  colors: [colorPrimario, colorPrimario.withOpacity(0.8)],
                                ))
                          : null,
                      color: isSelected
                          ? null
                          : (esEspecial
                              ? const Color.fromARGB(255, 255, 0, 0).withOpacity(0.1)
                              : Colors.grey[100]),
                      borderRadius: BorderRadius.circular(esEspecial ? 18 : 14),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: (esEspecial ? colorOfertaMiercoles : colorPrimario)
                                    .withOpacity(0.4),
                                spreadRadius: 2,
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ]
                          : null,
                      border: !isSelected
                          ? Border.all(
                              color: esEspecial
                                  ? const Color.fromARGB(255, 255, 0, 0).withOpacity(0.3)
                                  : Colors.grey[300]!,
                              width: esEspecial ? 2 : 1,
                            )
                          : null,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          categoria['icono'],
                          color: isSelected
                              ? Colors.white
                              : (esEspecial ? const Color.fromARGB(255, 255, 0, 0) : colorPrimario),
                          size: esEspecial ? 24 : 20,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          categoria['nombre'],
                          style: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : (esEspecial ? const Color.fromARGB(255, 255, 0, 0) : colorPrimario),
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : (esEspecial ? FontWeight.bold : FontWeight.w500),
                            fontSize: esEspecial ? 10 : 9,
                            height: 1.1,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),

                  // BADGE "HOY" arriba centrado
                  if (esEspecial)
                    Positioned(
                      top: 3,
                      left: -8,
                      right: 0,
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.white : const Color.fromARGB(255, 255, 0, 0),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.25),
                                blurRadius: 4,
                                offset: const Offset(0, 0),
                              ),
                            ],
                          ),
                          child: Text(
                            'HOY',
                            style: TextStyle(
                              color: isSelected ? const Color.fromARGB(255, 255, 0, 0) : Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    ),
  );
}



  // 🔥 MÉTODO ACTUALIZADO PARA CONTENIDO POR CATEGORÍA
  List<Widget> _buildContenidoPorCategoria() {
    switch (categoriaSeleccionada) {
      case 'Ofertas los Miércoles':
        return _buildOfertasMiercoles();
      case 'Pizza Personal':
        return _buildPizzasPersonales();
      case 'Pizza Familiar':
        return _buildPizzasFamiliares();
      case 'Pizza Extra Grande': 
        return _buildPizzasExtraGrandes();
      case 'Combo Pizza':
        return _buildCombosPizza();
      case 'Pizza 2 sabores':
        return _buildPizzasEspeciales();
      case 'Fusión':
        return _buildFusiones();
      case 'Combo Broaster':
        return _buildCombosBroaster();
      case 'Mostritos':
        return _buildMostritos();
      default:
        return _buildPizzasFamiliares();
    }
  }

  // 🔥 NUEVO MÉTODO PARA OFERTAS DE MIÉRCOLES
  List<Widget> _buildOfertasMiercoles() {
    return [
      _buildSliverOfertasHeader(),
      
      SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final oferta = ofertasMiercoles[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: OfertaMiercolesCard(
                nombre: oferta['nombre'],
                descripcion: oferta['descripcionOriginal'],
                precioOriginal: oferta['precioOriginal'],
                precioOferta: oferta['precioOferta'],
                imagen: oferta['imagen'],
                descuento: oferta['descuento'],
                onAgregarAlCarrito: () => agregarAlCarrito(
                  oferta['nombre'],
                  oferta['precioOferta'],
                  'Oferta Miércoles',
                  oferta['imagen'],
                ),
              ),
            );
          },
          childCount: ofertasMiercoles.length,
        ),
      ),
    ];
  }

  // 🔥 HEADER ESPECIAL PARA OFERTAS DE MIÉRCOLES - SIN ANIMACIONES
Widget _buildSliverOfertasHeader() {
  return SliverToBoxAdapter(
    child: Container(
      margin: const EdgeInsets.fromLTRB(16, 20, 16, 16),
      child: Column(
        children: [
          // 🔥 HEADER PRINCIPAL MÁS COMPACTO
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color.fromARGB(255, 255, 0, 0),
                  const Color.fromARGB(255, 255, 0, 0).withOpacity(0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: colorOfertaMiercoles.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                // ICONO LLAMATIVO
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.local_fire_department,
                    color: const Color.fromARGB(255, 255, 0, 0),
                    size: 24,
                  ),
                ),
                
                const SizedBox(width: 16),
                
                // TEXTO PRINCIPAL
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'OFERTAS DE MIERCOLES',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
Text(
  'Solo los miércoles - Descuentos increíbles',
  style: TextStyle(
    fontSize: 13,
    color: Colors.white.withOpacity(0.9),
    height: 1.2,
  ),
),

                    ],
                  ),
                ),
                
              ],
            ),
          ),
          
          const SizedBox(height: 12),
          
          // 🎯 BANNER INFORMATIVO MÁS ELEGANTE
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color.fromARGB(255, 255, 0, 0),
                width: 1.5,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.access_time,
                  color: Colors.red.shade600,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Text(
                  'Válido solo por 24 horas - ¡No te lo pierdas!',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.red.shade700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

  // 🔥 COMBOS PIZZA FILTRADOS (SIN LOS QUE ESTÁN EN OFERTA)
  List<Widget> _buildCombosPizza() {
    final combosFiltrados = _filtrarCombosSiEsMiercoles(PizzaData.combosPizzaOrdenados);
    
    return [
      _buildSliverSectionHeader(
        'Combo Pizza',
        esMiercoles ? 'Otras combinaciones disponibles' : 'Combinaciones especiales',
        Icons.local_pizza,
        Colors.indigo,
        combosFiltrados.length,
      ),
      
      if (combosFiltrados.isNotEmpty)
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final comboPizza = combosFiltrados[index];
              String tamanoEspecial = 'Combo';
              if (comboPizza.nombre.toLowerCase().contains('oferta dúo')) {
                tamanoEspecial = 'Oferta Dúo';
              }
              
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ComboCard(
                  combo: comboPizza,
                  onAgregarAlCarrito: () => agregarAlCarrito(
                    comboPizza.nombre,
                    comboPizza.precio,
                    tamanoEspecial,
                    comboPizza.imagen,
                  ),
                ),
              );
            },
            childCount: combosFiltrados.length,
          ),
        )
      else
        SliverToBoxAdapter(
          child: Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.orange.withOpacity(0.3)),
            ),
            child: const Text(
              '🔥 Todos los combos están en ofertas especiales hoy.\n¡Ve a la sección "Ofertas Miércoles"!',
              style: TextStyle(
                color: Color.fromARGB(255, 255, 0, 0),
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
    ];
  }

  List<Widget> _buildFusiones() {
    final fusionesFiltradas = _filtrarCombosSiEsMiercoles(PizzaData.fusionesOrdenadas);
    
    return [
      _buildSliverSectionHeader(
        'Fusiones',
        esMiercoles ? 'Otras fusiones disponibles' : 'Pizza y broaster juntos',
        Icons.auto_awesome,
        Colors.deepPurple,
        fusionesFiltradas.length,
      ),
      
      if (fusionesFiltradas.isNotEmpty)
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final fusion = fusionesFiltradas[index];
              String tamanoEspecial = 'Fusión';
              if (fusion.nombre.toLowerCase().contains('combo estrella')) {
                tamanoEspecial = 'Estrella';
              }
              
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ComboCard(
                  combo: fusion,
                  onAgregarAlCarrito: () => agregarAlCarrito(
                    fusion.nombre,
                    fusion.precio,
                    tamanoEspecial,
                    fusion.imagen,
                  ),
                ),
              );
            },
            childCount: fusionesFiltradas.length,
          ),
        )
      else
        SliverToBoxAdapter(
          child: Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.orange.withOpacity(0.3)),
            ),
            child: const Text(
              '🔥 Algunas fusiones están en ofertas especiales hoy.\n¡Revisa "Ofertas Miércoles"!',
              style: TextStyle(
                color: Colors.orange,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
    ];
  }

  List<Widget> _buildPizzasFamiliares() {
    return [
      _buildSliverSectionHeader(
        'Familiares (30cm)',
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
        ),
      ),
    ];
  }

  List<Widget> _buildPizzasPersonales() {
    return [
      _buildSliverSectionHeader(
        'Personales (18cm)',
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
        ),
      ),
    ];
  }

  List<Widget> _buildPizzasExtraGrandes() {
    return [
      _buildSliverSectionHeader(
        'Extra Grandes(45cm)',
        'Lista para conquistar tu hambre',
        Icons.local_pizza,
        const Color.fromARGB(255, 255, 191, 0),
        PizzaData.pizzasExtraGrandesOrdenadas.length,
      ),
      
      SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final pizza = PizzaData.pizzasExtraGrandesOrdenadas[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: PizzaCard(
                pizza: pizza,
                tamano: 'Extra Grande',
                precio: pizza.precioExtraGrande,
                onAgregarAlCarrito: () => agregarAlCarrito(
                  pizza.nombre,
                  pizza.precioExtraGrande,
                  'Extra Grande',
                  pizza.imagen,
                ),
              ),
            );
          },
          childCount: PizzaData.pizzasExtraGrandesOrdenadas.length,
        ),
      ),
    ];
  }

  List<Widget> _buildMostritos() {
    return [
      _buildSliverSectionHeader(
        'Mostritos',
        'Un mostrito que no asusta',
        Icons.restaurant_menu,
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
                  'Broaster',
                  combo.imagen,
                ),
              ),
            );
          },
          childCount: PizzaData.combosBroasterOrdenados.length,
        ),
      ),
    ];
  }

  // HEADER DE SECCIÓN SIMPLE SIN ANIMACIONES
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

  // FOOTER SIMPLE SIN EFECTOS
  Widget _buildSliverFooter() {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.only(top: 20),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: const BoxDecoration(
          color: Color(0xFFD4332A),
          borderRadius: BorderRadius.zero,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 📍 UBICACIÓN
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.location_on, color: Colors.black87, size: 16),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    "A media cuadra de la curva",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      height: 1.3,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // 🌐 FACEBOOK CON ICONO
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.facebook, color: Colors.blueAccent, size: 16),
                const SizedBox(width: 6),
                const Text(
                  "facebook.com/pizzafabichelo",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // 📞 TELÉFONOS
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.phone, color: Colors.greenAccent, size: 16),
                const SizedBox(width: 4),
                const Text(
                  "933 214 908",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 16),
                const Icon(Icons.phone_in_talk, color: Colors.blueAccent, size: 16),
                const SizedBox(width: 4),
                const Text(
                  "01 6723 711",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Copyright
            const SizedBox(height: 8),
            RichText(
              text: const TextSpan(
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
                children: [
                  TextSpan(text: "© 2024 "),
                  TextSpan(
                    text: "Pizza Fabichelo",
                    style: TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.bold,
                    ),
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
                _recalcularTotalItems(); 
              });
            },
          ),
        );
      },
    );
  }
}