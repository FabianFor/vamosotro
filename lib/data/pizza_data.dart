import '../models/models.dart';

class PizzaData {
  // 🍕 PIZZAS EXISTENTES
  static final List<Pizza> pizzas = [
    Pizza(
      nombre: 'Americana',
      ingredientes: 'queso mozzarella, jamón, salchichón',
      precioFamiliar: 26.0,
      precioPersonal: 11.0,
      imagen: 'assets/images/pizzas/americana.png',
    ),
    Pizza(
      nombre: 'Hawaiana',
      ingredientes: 'queso mozzarella, jamón, piña',
      precioFamiliar: 28.0,
      precioPersonal: 12.0,
      imagen: 'assets/images/pizzas/hawaiana.png',
    ),
    Pizza(
      nombre: 'Pepperoni',
      ingredientes: 'queso mozzarella, pepperoni',
      precioFamiliar: 30.0,
      precioPersonal: 14.0,
      imagen: 'assets/images/pizzas/pepperoni.png',
    ),
    Pizza(
      nombre: 'Extremo',
      ingredientes: 'queso mozzarella, salami, jamón, tocino, pepperoni, chorizo español',
      precioFamiliar: 32.0,
      precioPersonal: 14.0,
      imagen: 'assets/images/pizzas/extremo.png',
    ),
    Pizza(
      nombre: 'Tocino',
      ingredientes: 'queso mozzarella, tocino, jamón',
      precioFamiliar: 29.0,
      precioPersonal: 13.0,
      imagen: 'assets/images/pizzas/tocino.png',
    ),
    Pizza(
      nombre: 'Africana',
      ingredientes: 'queso mozzarella, salami, salchichón, jamón, pepperoni, chorizo español',
      precioFamiliar: 30.0,
      precioPersonal: 14.0,
      imagen: 'assets/images/pizzas/africana.png',
    ),
  ];

  // 🍗 MOSTRITOS (BROASTER + ACOMPAÑAMIENTOS)
  static final List<Mostrito> mostritos = [
    Mostrito(
      nombre: 'Mostrito Ala',
      descripcion: 'Broaster Ala + Chaufa + Papas Fritas + Gaseosa',
      precio: 11.0,
      imagen: 'assets/images/mostritos/mostrito_ala.png',
    ),
    Mostrito(
      nombre: 'Mostrito Pecho',
      descripcion: 'Broaster Pecho + Chaufa + Papas Fritas + Gaseosa',
      precio: 14.0,
      imagen: 'assets/images/mostritos/mostrito_pecho.png',
    ),
    Mostrito(
      nombre: 'Mostrito Pierna',
      descripcion: 'Broaster Pierna + Chaufa + Papas Fritas + Gaseosa',
      precio: 12.0,
      imagen: 'assets/images/mostritos/mostrito_pierna.png',
    ),
  ];

  // 🍕 PIZZAS FAMILIARES ESPECIALES (2 Y 4 SABORES)
  static final List<PizzaEspecial> pizzasEspeciales = [
    PizzaEspecial(
      nombre: 'Pizza Familiar 2 Sabores',
      descripcion: 'Elige 2 sabores de nuestras pizzas disponibles',
      precio: 35.0,
      imagen: 'assets/images/pizzas/familiar_2_sabores.png',
      tipo: '2 Sabores',
    ),
    PizzaEspecial(
      nombre: 'Pizza Familiar 4 Sabores',
      descripcion: 'Elige 4 sabores de nuestras pizzas disponibles',
      precio: 45.0,
      imagen: 'assets/images/pizzas/familiar_4_sabores.png',
      tipo: '4 Sabores',
    ),
  ];

  // 🍕 COMBOS PIZZA (ordenados por precio)
  static final List<Combo> combosPizza = [
    Combo(
      nombre: 'Fusión Junior',
      descripcion: 'Personal + Pepsi jumbo + 2 Broaster + Papas + 2 Pan al ajo',
      precio: 28.0,
      imagen: 'assets/images/combos/fusion_junior.png',
    ),
    Combo(
      nombre: 'Familiar + Broaster',
      descripcion: 'Familiar + 6 Brazitos + 1 Jumbo Pepsi',
      precio: 35.0,
      imagen: 'assets/images/combos/familiar_broaster.png',
    ),
    Combo(
      nombre: 'Fusión Familiar',
      descripcion: 'Familiar + 4 Broaster + papas + 2 pepsis + 4 pan al ajo',
      precio: 50.0,
      imagen: 'assets/images/combos/fusion_familiar.png',
    ),
  ];

  // 🍗 COMBOS BROASTER (ordenados por precio)
  static final List<Combo> combosBroaster = [
    Combo(
      nombre: 'Combo Broaster Básico',
      descripcion: '4 piezas de broaster + papas + gaseosa',
      precio: 25.0,
      imagen: 'assets/images/combos/broaster_basico.png',
    ),
    Combo(
      nombre: 'Combo Broaster Familiar',
      descripcion: '8 piezas de broaster + papas grandes + 2 gaseosas',
      precio: 45.0,
      imagen: 'assets/images/combos/broaster_familiar.png',
    ),
  ];

  // 🔥 FUSIONES (PIZZA + BROASTER) - ordenados por precio
  static final List<Combo> fusiones = [
    Combo(
      nombre: 'Fusión Junior',
      descripcion: 'Pizza Personal + 2 Broaster + Papas + Pan al ajo + Pepsi',
      precio: 28.0,
      imagen: 'assets/images/combos/fusion_junior.png',
    ),
    Combo(
      nombre: 'Fusión Familiar',
      descripcion: 'Pizza Familiar + 4 Broaster + Papas + 4 Pan al ajo + 2 Pepsis',
      precio: 50.0,
      imagen: 'assets/images/combos/fusion_familiar.png',
    ),
  ];

  // 🔥 LISTA DE ADICIONALES DISPONIBLES
  static final List<Adicional> adicionalesDisponibles = [
    Adicional(
      nombre: 'Queso Extra',
      precio: 3.0,
      icono: '🧀',
    ),
    Adicional(
      nombre: 'Doble Carne',
      precio: 5.0,
      icono: '🥩',
    ),
    Adicional(
      nombre: 'Champiñones',
      precio: 4.0,
      icono: '🍄',
    ),
    Adicional(
      nombre: 'Aceitunas',
      precio: 3.0,
      icono: '🫒',
    ),
    Adicional(
      nombre: 'Pepperoni Extra',
      precio: 4.0,
      icono: '🌶️',
    ),
  ];

  // 🎯 MÉTODOS PARA OBTENER LISTAS ORDENADAS POR PRECIO
  
  static List<Pizza> get pizzasFamiliaresOrdenadas {
    List<Pizza> lista = List.from(pizzas);
    lista.sort((a, b) => a.precioFamiliar.compareTo(b.precioFamiliar));
    return lista;
  }

  static List<Pizza> get pizzasPersonalesOrdenadas {
    List<Pizza> lista = List.from(pizzas);
    lista.sort((a, b) => a.precioPersonal.compareTo(b.precioPersonal));
    return lista;
  }

  static List<Mostrito> get mostritosOrdenados {
    List<Mostrito> lista = List.from(mostritos);
    lista.sort((a, b) => a.precio.compareTo(b.precio));
    return lista;
  }

  static List<PizzaEspecial> get pizzasEspecialesOrdenadas {
    List<PizzaEspecial> lista = List.from(pizzasEspeciales);
    lista.sort((a, b) => a.precio.compareTo(b.precio));
    return lista;
  }

  static List<Combo> get combosPizzaOrdenados {
    List<Combo> lista = List.from(combosPizza);
    lista.sort((a, b) => a.precio.compareTo(b.precio));
    return lista;
  }

  static List<Combo> get combosBroasterOrdenados {
    List<Combo> lista = List.from(combosBroaster);
    lista.sort((a, b) => a.precio.compareTo(b.precio));
    return lista;
  }

  static List<Combo> get fusionesOrdenadas {
    List<Combo> lista = List.from(fusiones);
    lista.sort((a, b) => a.precio.compareTo(b.precio));
    return lista;
  }
}