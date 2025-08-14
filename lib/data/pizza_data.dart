import '../models/models.dart';

class PizzaData {
  // 🍕 PIZZAS EXISTENTES CON NUEVO PRECIO EXTRA GRANDE
  static final List<Pizza> pizzas = [
    Pizza(
      nombre: 'Americana',
      ingredientes: 'Queso mozzarella, jamón, salchichón',
      precioFamiliar: 26.0,
      precioPersonal: 10.0,
      precioExtraGrande: 48.0,
      imagen: 'assets/images/pizzas/americana.png',
    ),
    Pizza(
      nombre: 'Hawaiana',
      ingredientes: 'Queso mozzarella, jamón, piña',
      precioFamiliar: 28.0,
      precioPersonal: 11.0,
      precioExtraGrande: 50.0,
      imagen: 'assets/images/pizzas/hawaiana.png',
    ),
    Pizza(
      nombre: 'Pepperoni',
      ingredientes: 'Queso mozzarella, pepperoni',
      precioFamiliar: 30.0,
      precioPersonal: 13.0,
      precioExtraGrande: 54.0,
      imagen: 'assets/images/pizzas/pepperoni.png',
    ),
    Pizza(
      nombre: 'Extremo',
      ingredientes: 'Mozzarella, tocino, pepperoni, jamon, chorizon, cabanossi',
      precioFamiliar: 32.0,
      precioPersonal: 13.0,
      precioExtraGrande: 55.0,
      imagen: 'assets/images/pizzas/extremo.png',
    ),
    Pizza(
      nombre: 'Tocino',
      ingredientes: 'Queso mozzarella, tocino, jamón',
      precioFamiliar: 29.0,
      precioPersonal: 12.0,
      precioExtraGrande: 52.0,
      imagen: 'assets/images/pizzas/tocino.png',
    ),
    Pizza(
      nombre: 'Africana',
      ingredientes: 'Mozzarella, salchichón, jamón, pepperoni, tocino. (En tiras)',
      precioFamiliar: 30.0,
      precioPersonal: 13.0,
      precioExtraGrande: 55.0,  
      imagen: 'assets/images/pizzas/africana.png',
    ),
  ];

  // 🍕 PIZZAS ESPECIALES 2 SABORES
  static final List<PizzaEspecial> pizzasEspeciales = [
    PizzaEspecial(
      nombre: 'Americana y pepperoni',
      descripcion: 'Mitad americana + mitad pepperoni + gaseosa 750ml',
      precio: 35.0,
      imagen: 'assets/images/pizzas/americana_pepperoni.png',
      tipo: '2 Sabores',
    ),
    PizzaEspecial(
      nombre: 'Hawaiana y pepperoni',
      descripcion: 'Mitad hawaiana + mitad pepperoni + gaseosa 750ml',
      precio: 35.0,
      imagen: 'assets/images/pizzas/hawaiana_pepperoni.png',
      tipo: '2 Sabores',
    ),
    PizzaEspecial(
      nombre: 'Americana y tocino',
      descripcion: 'Mitad americana + mitad tocino + gaseosa 750ml',
      precio: 36.0,
      imagen: 'assets/images/pizzas/americana_tocino.png',
      tipo: '2 Sabores',
    ),
    PizzaEspecial(
      nombre: 'Hawaiana y tocino',
      descripcion: 'Mitad hawaiana + mitad tocino + gaseosa 750ml',
      precio: 36.0,
      imagen: 'assets/images/pizzas/hawaiana_tocino.png',
      tipo: '2 Sabores',
    ),
    PizzaEspecial(
      nombre: 'Pepperoni y tocino',
      descripcion: 'Mitad pepperoni + mitad tocino + gaseosa 750ml',
      precio: 37.0,
      imagen: 'assets/images/pizzas/pepperoni_tocino.png',
      tipo: '2 Sabores',
    ),
    PizzaEspecial(
      nombre: 'Dúo 4 sabores',
      descripcion: '2 pizzas familiares una mitad hawaiana + americana y otra mitad pepperoni + tocino.',
      precio: 55.0,
      imagen: 'assets/images/pizzas/duo_4_sabores.png',
      tipo: '4 Sabores',
    ),
  ];

  // COMBOS BROASTER
  static final List<Combo> combosBroaster = [
    Combo(
      nombre: 'Combo 1',
      descripcion: '2 alitas + papas fritas + cremas + gaseosa 355ml',
      precio: 11.0,
      imagen: 'assets/images/combos/combo_1.png',
    ),
    Combo(
      nombre: 'Combo 2',
      descripcion: '2 piezas de pollo + papas fritas + cremas + gaseosa 355ml',
      precio: 13.0,
      imagen: 'assets/images/combos/combo_2.png',
    ),
    Combo(
      nombre: 'Combo 3',
      descripcion: '4 piezas de pollo + papas fritas + cremas + gaseosa 750ml',
      precio: 25.0,
      imagen: 'assets/images/combos/combo_3.png',
    ),
    Combo(
      nombre: 'Combo 4',
      descripcion: '6 piezas de pollo + papas fritas + cremas + gaseosa 750ml',
      precio: 35.0,
      imagen: 'assets/images/combos/combo_4.png',
    ),
    Combo(
      nombre: 'Combo 5',
      descripcion: '8 piezas de pollo + papas fritas + cremas + 2 gaseosa 750ml',
      precio: 48.0,
      imagen: 'assets/images/combos/combo_5.png',
    ),
  ];

  // 🍕 COMBOS PIZZA
  static final List<Combo> combosPizza = [
    Combo(
      nombre: 'Combo clásico',
      descripcion: 'Mitad Americana + mitad Hawaiana + pepsi 750ml + 3 porciones de pan al ajo',
      precio: 32.0,
      imagen: 'assets/images/combos/combo_clasico.png',
    ),
    Combo(
      nombre: 'Combo compartir',
      descripcion: '2 pizzas americanas, tamaño familiar y personal',
      precio: 34.0,
      imagen: 'assets/images/combos/combo_compartir.png',
    ),
    Combo(
      nombre: 'Combo brother',
      descripcion: '3 pizzas personales pepperoni, hawaiana y americana + pepsi 750ml',
      precio: 32.0,
      imagen: 'assets/images/combos/combo_brother.png',
    ),
    Combo(
      nombre: 'Combo familiar',
      descripcion: 'Americana + pepsi 750ml + 3 porciones de pan al ajo',
      precio: 29.0,
      imagen: 'assets/images/combos/combo_familiar_pizza.png',
    ),
    Combo(
      nombre: 'Oferta dúo',
      descripcion: '2 pizzas familiares hawaiana + americana',
      precio: 50.0,
      imagen: 'assets/images/combos/oferta_duo.png',
    ),
  ];

  static final List<Combo> fusiones = [
    Combo(
      nombre: 'Fusión junior',
      descripcion: 'Pizza personal+Pepsi 750ml+2 broaster+papas fritas+2 panes al ajo',
      precio: 28.0,
      imagen: 'assets/images/combos/fusion_junior.png',
    ),
    Combo(
      nombre: 'Familiar + broaster',
      descripcion: 'Pizza familiar + 6 brazitos de pollo + Pepsi 750ml',
      precio: 35.0,
      imagen: 'assets/images/combos/familiar_broaster.png',
    ),
    Combo(
      nombre: 'Combo estrella',
      descripcion: 'Pizza familiar 2 sabores + 6 Bracitos + Porción de papas + Pepsi 750ml',
      precio: 42.0,
      imagen: 'assets/images/combos/combo_estrella.png',
    ),
    Combo(
      nombre: 'Fusión familiar',
      descripcion: 'Pizza familiar + 4 broaster + papas + 2 Pepsi 750 ml + 4 panes de ajo.',
      precio: 50.0,
      imagen: 'assets/images/combos/fusion_familiar.png',
    ),
  ];

  // 🔥 MÉTODO PARA CREAR ADICIONALES BÁSICOS ORDENADOS POR PRECIO
  static List<Adicional> _crearAdicionalesBase({
    bool incluirPrimeraGaseosa = false, 
    double precioQueso = 6.0,
    bool incluirQueso = true,
  }) {
    List<Adicional> adicionales = [];

    // 🔥 PRIMERA GASEOSA (SI SE REQUIERE)
    if (incluirPrimeraGaseosa) {
      adicionales.add(Adicional(
        nombre: 'Pepsi 350ml (primera)',
        precio: 1.0,
        icono: '🥤',
        imagen: 'assets/images/adicionales/pepsi_350_primera.png',
      ));
    }
    
    // 🥤 GASEOSAS NORMALES
    adicionales.addAll([
      Adicional(
        nombre: 'Pepsi 350ml', 
        precio: 2.0, 
        icono: '🥤',
        imagen: 'assets/images/adicionales/pepsi_350.png'
      ),
      Adicional(
        nombre: 'Pepsi 750ml', 
        precio: 4.0, 
        icono: '🥤',
        imagen: 'assets/images/adicionales/pepsi_750.png'
      ),
    ]);

    // 🧀 QUESO ADICIONAL (SI SE INCLUYE)
    if (incluirQueso) {
      adicionales.add(Adicional(
        nombre: 'Queso adicional',
        precio: precioQueso,
        icono: '🧀',
        imagen: 'assets/images/adicionales/queso_extra.png',
      ));
    }
    
    // 🍞 PANES AL AJO Y OTROS
    adicionales.addAll([
      Adicional(
        nombre: '5 panes al ajo clásico', 
        precio: 5.0, 
        icono: '🍞',
        imagen: 'assets/images/adicionales/pan_ajo_clasico_5.png'
      ),
      Adicional(
        nombre: 'papa adicional', 
        precio: 7.0, 
        icono: '🍟',
        imagen: 'assets/images/adicionales/papa_extra.png'
      ),
      Adicional(
        nombre: '5 panes al ajo con queso', 
        precio: 8.0, 
        icono: '🧄',
        imagen: 'assets/images/adicionales/pan_ajo_queso_5.png'
      ),
      Adicional(
        nombre: '2 alas adicionales', 
        precio: 9.0, 
        icono: '🍗',
        imagen: 'assets/images/adicionales/alas_extra.png'
      ),
      Adicional(
        nombre: '10 panes al ajo clásico', 
        precio: 9.0, 
        icono: '🍞',
        imagen: 'assets/images/adicionales/pan_ajo_clasico_10.png'
      ),
      Adicional(
        nombre: '10 panes al ajo con queso', 
        precio: 15.0, 
        icono: '🧄',
        imagen: 'assets/images/adicionales/pan_ajo_queso_10.png'
      ),
    ]);

    // 🔥 ORDENAR POR PRECIO
    adicionales.sort((a, b) => a.precio.compareTo(b.precio));
    return adicionales;
  }

  // 🔥 NUEVO MÉTODO PARA CREAR ADICIONALES ESPECÍFICOS PARA COMBOS MÚLTIPLES
  static List<Adicional> _crearAdicionalesParaComboMultiple(String nombre, double precioQuesoBase) {
    List<Adicional> adicionales = [];
    
    // 🔥 OBTENER PIZZAS ESPECÍFICAS DEL COMBO
    List<String> pizzasEnCombo = getPizzasEnCombo(nombre);
    
    // 🥤 GASEOSAS NORMALES PRIMERO
    adicionales.addAll([
      Adicional(
        nombre: 'Pepsi 350ml', 
        precio: 2.0, 
        icono: '🥤',
        imagen: 'assets/images/adicionales/pepsi_350.png'
      ),
      Adicional(
        nombre: 'Pepsi 750ml', 
        precio: 4.0, 
        icono: '🥤',
        imagen: 'assets/images/adicionales/pepsi_750.png'
      ),
    ]);
    
    // 🧀 QUESO ADICIONAL ESPECÍFICO PARA CADA PIZZA
    for (int i = 0; i < pizzasEnCombo.length; i++) {
      String pizzaNombre = pizzasEnCombo[i];
      String nombreCorto = _obtenerNombreCorto(pizzaNombre);
      
      // 🔥 DETERMINAR PRECIO SEGÚN EL TAMAÑO DE LA PIZZA ESPECÍFICA
      double precioQueso = _obtenerPrecioQuesoPorPizza(pizzaNombre, precioQuesoBase);
      
      adicionales.add(Adicional(
        nombre: 'Queso adicional - $nombreCorto',
        precio: precioQueso,
        icono: '🧀',
        imagen: 'assets/images/adicionales/queso_extra.png',
      ));
    }
    
    // 🍞 PANES AL AJO Y OTROS
    adicionales.addAll([
      Adicional(
        nombre: '5 panes al ajo clásico', 
        precio: 5.0, 
        icono: '🍞',
        imagen: 'assets/images/adicionales/pan_ajo_clasico_5.png'
      ),
      Adicional(
        nombre: 'papa adicional', 
        precio: 7.0, 
        icono: '🍟',
        imagen: 'assets/images/adicionales/papa_extra.png'
      ),
      Adicional(
        nombre: '5 panes al ajo con queso', 
        precio: 8.0, 
        icono: '🧄',
        imagen: 'assets/images/adicionales/pan_ajo_queso_5.png'
      ),
      Adicional(
        nombre: '2 alas adicionales', 
        precio: 9.0, 
        icono: '🍗',
        imagen: 'assets/images/adicionales/alas_extra.png'
      ),
      Adicional(
        nombre: '10 panes al ajo clásico', 
        precio: 9.0, 
        icono: '🍞',
        imagen: 'assets/images/adicionales/pan_ajo_clasico_10.png'
      ),
      Adicional(
        nombre: '10 panes al ajo con queso', 
        precio: 15.0, 
        icono: '🧄',
        imagen: 'assets/images/adicionales/pan_ajo_queso_10.png'
      ),
    ]);
    
    // 🔥 ORDENAR POR PRECIO
    adicionales.sort((a, b) => a.precio.compareTo(b.precio));
    return adicionales;
  }

  // 🔥 OBTENER NOMBRE CORTO PARA MOSTRAR EN ADICIONALES
  static String _obtenerNombreCorto(String pizzaNombre) {
    if (pizzaNombre.contains('Pizza 1: Hawaiana + Americana')) return 'Pizza 1 (Hawaiana + Americana)';
    if (pizzaNombre.contains('Pizza 2: Pepperoni + Tocino')) return 'Pizza 2 (Pepperoni + Tocino)';
    if (pizzaNombre.contains('Americana')) return 'Americana';
    if (pizzaNombre.contains('Hawaiana')) return 'Hawaiana';
    if (pizzaNombre.contains('Pepperoni')) return 'Pepperoni';
    if (pizzaNombre.contains('Tocino')) return 'Tocino';
    if (pizzaNombre.contains('Personal')) return 'Personal';
    if (pizzaNombre.contains('Familiar')) return 'Familiar';
    if (pizzaNombre.contains('Pizza 1')) return 'Pizza 1';
    if (pizzaNombre.contains('Pizza 2')) return 'Pizza 2';
    return 'Pizza';
  }

  // 🔥 OBTENER PRECIO DE QUESO SEGÚN EL TAMAÑO ESPECÍFICO DE CADA PIZZA
  static double _obtenerPrecioQuesoPorPizza(String pizzaNombre, double precioBase) {
    // Si la pizza es personal = 4 soles
    if (pizzaNombre.toLowerCase().contains('personal')) {
      return 4.0;
    }
    // Si la pizza es familiar = 8 soles
    if (pizzaNombre.toLowerCase().contains('familiar')) {
      return 8.0;
    }
    
    // 🔥 LÓGICA ESPECIAL PARA COMBOS ESPECÍFICOS
    String pizzaLower = pizzaNombre.toLowerCase();
    
    // Combo brother tiene 3 pizzas personales
    if (pizzaLower.contains('pepperoni') || pizzaLower.contains('hawaiana') || pizzaLower.contains('americana')) {
      if (pizzaLower.contains('personal')) return 4.0;
      if (pizzaLower.contains('familiar')) return 8.0;
    }
    
    // Por defecto usar precio base
    return precioBase;
  }

  // 🔥 OBTENER LISTAS ORDENADAS POR PRECIO DE MENOR A MAYOR
  static List<Pizza> get pizzasFamiliaresOrdenadas {
    List<Pizza> pizzasOrdenadas = List.from(pizzas);
    pizzasOrdenadas.sort((a, b) => a.precioFamiliar.compareTo(b.precioFamiliar));
    return pizzasOrdenadas;
  }

  static List<Pizza> get pizzasPersonalesOrdenadas {
    List<Pizza> pizzasOrdenadas = List.from(pizzas);
    pizzasOrdenadas.sort((a, b) => a.precioPersonal.compareTo(b.precioPersonal));
    return pizzasOrdenadas;
  }

  static List<Pizza> get pizzasExtraGrandesOrdenadas {
    List<Pizza> pizzasOrdenadas = List.from(pizzas);
    pizzasOrdenadas.sort((a, b) => a.precioExtraGrande.compareTo(b.precioExtraGrande));
    return pizzasOrdenadas;
  }

  static List<Mostrito> get mostritosOrdenados {
    List<Mostrito> mostritosOrdenados = List.from(mostritos);
    mostritosOrdenados.sort((a, b) => a.precio.compareTo(b.precio));
    return mostritosOrdenados;
  }

  static List<PizzaEspecial> get pizzasEspecialesOrdenadas {
    List<PizzaEspecial> pizzasOrdenadas = List.from(pizzasEspeciales);
    pizzasOrdenadas.sort((a, b) => a.precio.compareTo(b.precio));
    return pizzasOrdenadas;
  }

  static List<Combo> get combosBroasterOrdenados {
    List<Combo> combosOrdenados = List.from(combosBroaster);
    combosOrdenados.sort((a, b) => a.precio.compareTo(b.precio));
    return combosOrdenados;
  }

  static List<Combo> get combosPizzaOrdenados {
    List<Combo> combosOrdenados = List.from(combosPizza);
    combosOrdenados.sort((a, b) => a.precio.compareTo(b.precio));
    return combosOrdenados;
  }

  static List<Combo> get fusionesOrdenadas {
    List<Combo> fusionesOrdenadas = List.from(fusiones);
    fusionesOrdenadas.sort((a, b) => a.precio.compareTo(b.precio));
    return fusionesOrdenadas;
  }

static List<Adicional> getAdicionalesParaItem(String nombre, String tamano) {
  final nombreLower = nombre.toLowerCase();

  // 🔥 Detectar si es mostrito (para mostrar sus adicionales especiales)
  if (nombreLower.contains('mostrito')) {
    return _crearAdicionalesMostrito();
  }

  // 🔥 Detectar si es combo con pizzas y obtener precio específico
  if (_esComboConPizzas(nombreLower)) {
    double precioQuesoCombo = _obtenerPrecioQuesoCombo(nombreLower);

    // 🔥 Nueva lógica: Si es combo con múltiples pizzas, crear adicionales específicos
    if (esComboMultiplePizzas(nombre)) {
      return _crearAdicionalesParaComboMultiple(nombre, precioQuesoCombo);
    }

    // Si es combo especial, agregar opciones gratuitas
    if (esComboEspecial(nombre)) {
      List<Adicional> adicionales = _crearAdicionalesBase(precioQueso: precioQuesoCombo);
      // Agregar opción gratuita al inicio
      adicionales.insert(0, Adicional(
        nombre: 'Solo Americana',
        precio: 0.0,
        icono: '🔄',
        imagen: 'assets/images/adicionales/cambio_americana.png',
      ));
      adicionales.sort((a, b) => a.precio.compareTo(b.precio));
      return adicionales;
    }

    return _crearAdicionalesBase(precioQueso: precioQuesoCombo);
  }

  // 🔥 Lógica normal para otros productos
  return getAdicionalesDisponibles(tamano);
}

  // 🔥 DETECTAR SI ES COMBO CON PIZZAS
  static bool _esComboConPizzas(String nombreLower) {
    return nombreLower.contains('combo clásico') ||
           nombreLower.contains('combo clasico') ||
           nombreLower.contains('combo compartir') ||
           nombreLower.contains('combo brother') ||
           nombreLower.contains('combo familiar') ||
           nombreLower.contains('oferta dúo') ||
           nombreLower.contains('dúo 4 sabores') ||
           nombreLower.contains('duo 4 sabores') ||
           nombreLower.contains('fusión junior') ||
           nombreLower.contains('familiar + broaster') ||
           nombreLower.contains('estrella') ||
           nombreLower.contains('fusión familiar');
  }

  // 🔥 OBTENER PRECIO ESPECÍFICO DE QUESO SEGÚN EL COMBO
  static double _obtenerPrecioQuesoCombo(String nombreLower) {
    // COMBOS CON PIZZAS PERSONALES = 4 SOLES
    if (nombreLower.contains('combo brother') ||    // 3 pizzas personales
        nombreLower.contains('fusión junior')) {    // pizza personal
      return 4.0;
    }
    
    // COMBOS CON PIZZAS FAMILIARES = 8 SOLES  
    if (nombreLower.contains('combo clásico') ||      // pizza familiar
        nombreLower.contains('combo familiar') ||     // pizza familiar
        nombreLower.contains('oferta dúo') ||         // 2 pizzas familiares
        nombreLower.contains('familiar + broaster') ||// pizza familiar
        nombreLower.contains('estrella') ||     // pizza familiar
        nombreLower.contains('fusión familiar')) {    // pizza familiar
      return 8.0;
    }
    
    // COMBO COMPARTIR (familiar + personal) = 8 SOLES (precio más alto)
    if (nombreLower.contains('combo compartir')) {
      return 8.0;
    }
    
    return 8.0; // Por defecto familiar
  }

  // 🍗 MOSTRITOS
  static final List<Mostrito> mostritos = [
    Mostrito(
      nombre: 'Mostrito ala',
      descripcion: 'Broaster ala + chaufa + papas fritas + gaseosa 355ml',
      precio: 11.0,
      imagen: 'assets/images/mostritos/mostrito_ala.png',
    ),
    Mostrito(
      nombre: 'Mostrito pecho',
      descripcion: 'Broaster pecho + chaufa + papas fritas + gaseosa 355ml',
      precio: 14.0,
      imagen: 'assets/images/mostritos/mostrito_pecho.png',
    ),
    Mostrito(
      nombre: 'Mostrito pierna',
      descripcion: 'Broaster pierna + chaufa + papas fritas + gaseosa 355ml',
      precio: 12.0,
      imagen: 'assets/images/mostritos/mostrito_pierna.png',
    ),
  ];

  // 🔥 MÉTODO PARA OBTENER ADICIONALES SEGÚN TAMAÑO
  static List<Adicional> getAdicionalesDisponibles(String tamano) {
    switch (tamano.toLowerCase()) {
      case 'personal':
        return _crearAdicionalesBase(incluirPrimeraGaseosa: true, precioQueso: 4.0);
      case 'familiar':
        return _crearAdicionalesBase(precioQueso: 8.0);
      case 'extra grande':
        return _crearAdicionalesBase(precioQueso: 15.0);
      case 'mostrito':
      return _crearAdicionalesMostrito();
      case 'broaster':
      case 'combo broaster':
        return _crearAdicionalesBase(incluirQueso: false); // Sin queso
      case '2 sabores':
      case '4 sabores':
        return _crearAdicionalesBase(precioQueso: 8.0); // Son familiares
      default:
        return _crearAdicionalesBase(precioQueso: 6.0);
    }
  }

  // 🔥 VERIFICAR SI UN PRODUCTO PUEDE TENER PRIMERA GASEOSA
  static bool puedeSerPrimeraGaseosa(String nombre, String tamano) {
    return tamano.toLowerCase() == 'personal';
  }

  // 🔥 VERIFICAR SI ES COMBO CON MÚLTIPLES PIZZAS
  static bool esComboMultiplePizzas(String nombre) {
    final nombreLower = nombre.toLowerCase();
    return nombreLower.contains('brother') || 
           nombreLower.contains('compartir') || 
           nombreLower.contains('oferta dúo') ||
           nombreLower.contains('dúo 4 sabores') ||
           nombreLower.contains('duo 4 sabores') ||
           nombreLower.contains('combo clásico') ||
           nombreLower.contains('combo clasico'); // Por si no tiene tilde
  }

// 🔥 ADICIONALES ESPECÍFICOS PARA MOSTRITO - COMPLETADO
static List<Adicional> _crearAdicionalesMostrito() {
  List<Adicional> adicionales = [];

  // 🥤 Gaseosas
  adicionales.addAll([
    Adicional(
      nombre: 'Pepsi 350ml', 
      precio: 2.0, 
      icono: '🥤',
      imagen: 'assets/images/adicionales/pepsi_350.png'
    ),
    Adicional(
      nombre: 'Pepsi 750ml', 
      precio: 4.0, 
      icono: '🥤',
      imagen: 'assets/images/adicionales/pepsi_750.png'
    ),
  ]);

  // 🍞 Panes al ajo - AGREGADO PARA MOSTRITO
  adicionales.addAll([
    Adicional(
      nombre: '3 panes al ajo clásico', 
      precio: 3.0, 
      icono: '🍞',
      imagen: 'assets/images/adicionales/pan_ajo_clasico_3.png'
    ),
    Adicional(
      nombre: '5 panes al ajo clásico', 
      precio: 5.0, 
      icono: '🍞',
      imagen: 'assets/images/adicionales/pan_ajo_clasico_5.png'
    ),
    Adicional(
      nombre: '3 panes al ajo con queso', 
      precio: 5.0, 
      icono: '🧄',
      imagen: 'assets/images/adicionales/pan_ajo_queso_3.png'
    ),
  ]);

  // 🍟 Papas extra
  adicionales.add(
    Adicional(
      nombre: 'Papa adicional', 
      precio: 7.0, 
      icono: '🍟',
      imagen: 'assets/images/adicionales/papa_extra.png'
    ),
  );

  // 🍞 Más panes al ajo
  adicionales.addAll([
    Adicional(
      nombre: '5 panes al ajo con queso', 
      precio: 8.0, 
      icono: '🧄',
      imagen: 'assets/images/adicionales/pan_ajo_queso_5.png'
    ),
    Adicional(
      nombre: '10 panes al ajo clásico', 
      precio: 9.0, 
      icono: '🍞',
      imagen: 'assets/images/adicionales/pan_ajo_clasico_10.png'
    ),
  ]);

  // 🍗 Pollo adicional
  adicionales.addAll([
    Adicional(
      nombre: '2 alas adicionales', 
      precio: 9.0, 
      icono: '🍗',
      imagen: 'assets/images/adicionales/alas_extra.png'
    ),
    Adicional(
      nombre: '1 pieza de pollo extra', 
      precio: 10.0, 
      icono: '🍗',
      imagen: 'assets/images/adicionales/pollo_extra.png'
    ),
  ]);

  // 🍞 Panes al ajo grandes
  adicionales.add(
    Adicional(
      nombre: '10 panes al ajo con queso', 
      precio: 15.0, 
      icono: '🧄',
      imagen: 'assets/images/adicionales/pan_ajo_queso_10.png'
    ),
  );

  // Ordenar por precio
  adicionales.sort((a, b) => a.precio.compareTo(b.precio));
  return adicionales;
}

  // 🔥 VERIFICAR SI ES COMBO ESPECIAL CON OPCIONES GRATUITAS
  static bool esComboEspecial(String nombre) {
    final nombreLower = nombre.toLowerCase();
    return nombreLower.contains('estrella') || 
           nombreLower.contains('oferta dúo');
  }

  // 🔥 MÉTODO MEJORADO PARA OBTENER PIZZAS ESPECÍFICAS DE UN COMBO
  static List<String> getPizzasEnCombo(String nombre) {
    final nombreLower = nombre.toLowerCase();
    
    if (nombreLower.contains('combo brother')) {
      return ['Pizza Pepperoni (Personal)', 'Pizza Hawaiana (Personal)', 'Pizza Americana (Personal)'];
    }
    
    if (nombreLower.contains('combo compartir')) {
      return ['Pizza Americana (Familiar)', 'Pizza Americana (Personal)'];
    }
    
    if (nombreLower.contains('combo clásico')) {
      return ['Pizza Familiar (Mitad Americana + Mitad Hawaiana)'];
    }
    
    if (nombreLower.contains('combo familiar')) {
      return ['Pizza Americana (Familiar)'];
    }
    
    if (nombreLower.contains('oferta dúo')) {
      return ['Pizza Hawaiana (Familiar)', 'Pizza Americana (Familiar)'];
    }
    
    if (nombreLower.contains('dúo 4 sabores') || nombreLower.contains('duo 4 sabores')) {
      return ['Pizza 1: Hawaiana + Americana (Familiar)', 'Pizza 2: Pepperoni + Tocino (Familiar)'];
    }
    
    if (nombreLower.contains('fusión junior')) {
      return ['Pizza Personal (A elegir)'];
    }
    
    if (nombreLower.contains('familiar + broaster')) {
      return ['Pizza Familiar (A elegir)'];
    }
    
    if (nombreLower.contains('estrella')) {
      return ['Pizza Familiar 2 Sabores (A elegir)'];
    }
    
    if (nombreLower.contains('fusión familiar')) {
      return ['Pizza Familiar (A elegir)'];
    }
    
    if (nombreLower.contains(' y ')) {
      return ['Pizza Familiar de 2 Sabores'];
    }
    
    return ['Pizza no identificada'];
  }

  // 🔥 OBTENER MENSAJE ESPECIAL PARA SNACKBAR
  static String getMensajeEspecial(String nombre, String tamano) {
    if (tamano.toLowerCase() == 'personal') {
      return ' (Primera gaseosa 350ml solo +S/1)';
    }
    
    final nombreLower = nombre.toLowerCase();
    if (nombreLower.contains('estrella')) {
      return ' (Cambio gratis a solo Americana)';
    }
    if (nombreLower.contains('oferta dúo')) {
      return ' (Cambio gratis a 2 Americanas)';
    }
    
    return '';
  }

  // 🔥 VERIFICAR SI UN ADICIONAL ES ESPECIAL
  static bool esAdicionalEspecial(String nombreAdicional) {
    return nombreAdicional.contains('primera') || 
           nombreAdicional.contains('Cambiar a') ||
           nombreAdicional.contains('(primera)') ||
           nombreAdicional.contains('Solo Americana');
  }

  // 🔥 OBTENER COLOR ESPECIAL PARA ADICIONAL
  static String getColorEspecialAdicional(String nombreAdicional) {
    if (nombreAdicional.contains('primera')) return 'green';
    if (nombreAdicional.contains('Cambiar a')) return 'blue';
    if (nombreAdicional.contains('Solo Americana')) return 'blue';
    if (nombreAdicional.contains('Gratis') || nombreAdicional.contains('0.0')) return 'green';
    return 'normal';
  }
}