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
      ));
    }
    
    // 🥤 GASEOSAS NORMALES
    adicionales.addAll([
      Adicional(nombre: 'Pepsi 350ml', precio: 2.0, icono: '🥤'),
      Adicional(nombre: 'Pepsi 750ml', precio: 4.0, icono: '🥤'),
    ]);

    // 🧀 QUESO ADICIONAL (SI SE INCLUYE)
    if (incluirQueso) {
      adicionales.add(Adicional(
        nombre: 'Queso adicional',
        precio: precioQueso,
        icono: '🧀',
      ));
    }
    
    // 🍞 PANES AL AJO Y OTROS
    adicionales.addAll([
      Adicional(nombre: '5 panes al ajo clásico', precio: 5.0, icono: '🍞'),
      Adicional(nombre: 'papa adicional', precio: 7.0, icono: '🍟'),
      Adicional(nombre: '5 panes al ajo con queso', precio: 8.0, icono: '🧄'),
      Adicional(nombre: '2 alas adicionales', precio: 9.0, icono: '🍗'),
      Adicional(nombre: '10 panes al ajo clásico', precio: 9.0, icono: '🍞'),
      Adicional(nombre: '10 panes al ajo con queso', precio: 15.0, icono: '🧄'),
    ]);

    // 🔥 ORDENAR POR PRECIO
    adicionales.sort((a, b) => a.precio.compareTo(b.precio));
    return adicionales;
  }

  // 🔥 OBTENER LISTAS ORDENADAS
  static List<Pizza> get pizzasFamiliaresOrdenadas => pizzas;
  static List<Pizza> get pizzasPersonalesOrdenadas => pizzas;
  static List<Pizza> get pizzasExtraGrandesOrdenadas => pizzas;
  static List<Mostrito> get mostritosOrdenados => mostritos;
  static List<PizzaEspecial> get pizzasEspecialesOrdenadas => pizzasEspeciales;
  static List<Combo> get combosBroasterOrdenados => combosBroaster;
  static List<Combo> get combosPizzaOrdenados => combosPizza;
  static List<Combo> get fusionesOrdenadas => fusiones;

  // 🔥 MÉTODO PRINCIPAL PARA OBTENER ADICIONALES SEGÚN EL ITEM
  static List<Adicional> getAdicionalesParaItem(String nombre, String tamano) {
    final nombreLower = nombre.toLowerCase();
    
    // 🔥 DETECTAR SI ES COMBO CON PIZZAS Y OBTENER PRECIO ESPECÍFICO
    if (_esComboConPizzas(nombreLower)) {
      double precioQuesoCombo = _obtenerPrecioQuesoCombo(nombreLower);
      
      // Si es combo especial, agregar opciones gratuitas
      if (esComboEspecial(nombre)) {
        List<Adicional> adicionales = _crearAdicionalesBase(precioQueso: precioQuesoCombo);
        // Agregar opción gratuita al inicio
        adicionales.insert(0, Adicional(
          nombre: 'Solo Americana',
          precio: 0.0,
          icono: '🔄',
        ));
        adicionales.sort((a, b) => a.precio.compareTo(b.precio));
        return adicionales;
      }
      
      return _crearAdicionalesBase(precioQueso: precioQuesoCombo);
    }
    
    // 🔥 LÓGICA NORMAL PARA OTROS PRODUCTOS
    return getAdicionalesDisponibles(tamano);
  }

  // 🔥 DETECTAR SI ES COMBO CON PIZZAS
  static bool _esComboConPizzas(String nombreLower) {
    return nombreLower.contains('combo clásico') ||
           nombreLower.contains('combo compartir') ||
           nombreLower.contains('combo brother') ||
           nombreLower.contains('combo familiar') ||
           nombreLower.contains('oferta dúo') ||
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
           nombreLower.contains('dúo 4 sabores');
  }

  // 🔥 VERIFICAR SI ES COMBO ESPECIAL CON OPCIONES GRATUITAS
  static bool esComboEspecial(String nombre) {
    final nombreLower = nombre.toLowerCase();
    return nombreLower.contains('estrella') || 
           nombreLower.contains('oferta dúo');
  }

  // 🔥 OBTENER PIZZAS ESPECÍFICAS DE UN COMBO
  static List<String> getPizzasEnCombo(String nombre) {
    final nombreLower = nombre.toLowerCase();
    
    if (nombreLower.contains('combo brother')) {
      return ['Pizza Pepperoni (Personal)', 'Pizza Hawaiana (Personal)', 'Pizza Americana (Personal)'];
    }
    
    if (nombreLower.contains('combo compartir')) {
      return ['Pizza Americana (Familiar)', 'Pizza Americana (Personal)'];
    }
    
    if (nombreLower.contains('combo clásico')) {
      return ['Mitad Americana + Mitad Hawaiana (Familiar)'];
    }
    
    if (nombreLower.contains('combo familiar')) {
      return ['Pizza Americana (Familiar)'];
    }
    
    if (nombreLower.contains('oferta dúo')) {
      return ['Pizza Hawaiana (Familiar)', 'Pizza Americana (Familiar)'];
    }
    
    if (nombreLower.contains('fusión junior')) {
      return ['Pizza Personal (Sabor a elegir)'];
    }
    
    if (nombreLower.contains('familiar + broaster')) {
      return ['Pizza Familiar (Sabor a elegir)'];
    }
    
    if (nombreLower.contains('estrella')) {
      return ['Pizza Familiar 2 Sabores (Sabores a elegir)'];
    }
    
    if (nombreLower.contains('fusión familiar')) {
      return ['Pizza Familiar (Sabor a elegir)'];
    }
    
    if (nombreLower.contains('dúo 4 sabores')) {
      return ['Pizza 1: Mitad Hawaiana + Mitad Americana', 'Pizza 2: Mitad Pepperoni + Mitad Tocino'];
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
           nombreAdicional.contains('(primera)');
  }

  // 🔥 OBTENER COLOR ESPECIAL PARA ADICIONAL
  static String getColorEspecialAdicional(String nombreAdicional) {
    if (nombreAdicional.contains('primera')) return 'green';
    if (nombreAdicional.contains('Cambiar a')) return 'blue';
    if (nombreAdicional.contains('Gratis') || nombreAdicional.contains('0.0')) return 'green';
    return 'normal';
  }
}