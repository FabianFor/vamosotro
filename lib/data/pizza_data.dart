import '../models/models.dart';

class PizzaData {
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

  // 🔥 TODOS LOS COMBOS DE LAS IMÁGENES
  static final List<Combo> combos = [
    // COMBOS DE PIZZAS
    Combo(
      nombre: 'Combo Clásico',
      descripcion: 'Mitad Americana & Mitad Hawaiana + Pepsi + 3 pan al ajo',
      precio: 32.0,
      imagen: 'assets/images/combos/combo_clasico.png',
    ),
    Combo(
      nombre: 'Combo Compartir',
      descripcion: '2 pizzas americanas (Familiar & Personal)',
      precio: 34.0,
      imagen: 'assets/images/combos/combo_compartir.png',
    ),
    Combo(
      nombre: 'Combo Brother',
      descripcion: '3 pizzas personales (Pepperoni, Hawaiana y Americana) + Pepsi',
      precio: 32.0,
      imagen: 'assets/images/combos/combo_brother.png',
    ),
    Combo(
      nombre: 'Oferta Duo',
      descripcion: '2 pizzas familiares (Hawaiana & Americana)',
      precio: 50.0,
      imagen: 'assets/images/combos/oferta_duo.png',
    ),
    Combo(
      nombre: 'Combo Familiar',
      descripcion: 'Americana + Pepsi & Pan al ajo (3 Porciones)',
      precio: 29.0,
      imagen: 'assets/images/combos/combo_familiar.png',
    ),
    Combo(
      nombre: 'Duo 4 Sabores',
      descripcion: 'Hawaiana & Americana + Pepperoni & Tocino',
      precio: 55.0,
      imagen: 'assets/images/combos/duo_4_sabores.png',
    ),

    // COMBOS DE POLLO BROASTER
    Combo(
      nombre: 'Crispy Combo 1',
      descripcion: '2 alitas + papas + cremas + gaseosa 355 ML',
      precio: 11.0,
      imagen: 'assets/images/combos/crispy_combo_1.png',
    ),
    Combo(
      nombre: 'Crispy Combo 2',
      descripcion: '2 piezas de pollo + papas + cremas + gaseosa 355 ML',
      precio: 13.0,
      imagen: 'assets/images/combos/crispy_combo_2.png',
    ),
    Combo(
      nombre: 'Crispy Combo 3',
      descripcion: '4 piezas de pollo + papas + cremas + gaseosa 750 ML',
      precio: 25.0,
      imagen: 'assets/images/combos/crispy_combo_3.png',
    ),
    Combo(
      nombre: 'Crispy Combo 4',
      descripcion: '6 piezas de pollo + papas + cremas + gaseosa 750 ML',
      precio: 35.0,
      imagen: 'assets/images/combos/crispy_combo_4.png',
    ),
    Combo(
      nombre: 'Crispy Combo 5',
      descripcion: '8 piezas de pollo + papas + cremas + gaseosa 750 ML',
      precio: 48.0,
      imagen: 'assets/images/combos/crispy_combo_5.png',
    ),

    // PIZZAS FAMILIAR 2 SABORES
    Combo(
      nombre: 'Americana y Pepperoni',
      descripcion: 'Pizza familiar mitad Americana mitad Pepperoni + bebida',
      precio: 35.0,
      imagen: 'assets/images/combos/americana_pepperoni.png',
    ),
    Combo(
      nombre: 'Hawaiana y Pepperoni',
      descripcion: 'Pizza familiar mitad Hawaiana mitad Pepperoni + bebida',
      precio: 35.0,
      imagen: 'assets/images/combos/hawaiana_pepperoni.png',
    ),
    Combo(
      nombre: 'Americana y Tocino',
      descripcion: 'Pizza familiar mitad Americana mitad Tocino + bebida',
      precio: 36.0,
      imagen: 'assets/images/combos/americana_tocino.png',
    ),
    Combo(
      nombre: 'Hawaiana y Tocino',
      descripcion: 'Pizza familiar mitad Hawaiana mitad Tocino + bebida',
      precio: 36.0,
      imagen: 'assets/images/combos/hawaiana_tocino.png',
    ),
    Combo(
      nombre: 'Pepperoni y Tocino',
      descripcion: 'Pizza familiar mitad Pepperoni mitad Tocino + bebida',
      precio: 37.0,
      imagen: 'assets/images/combos/pepperoni_tocino.png',
    ),
  ];

  // 🔥 LISTA DE ADICIONALES DISPONIBLES
  static final List<Adicional> adicionalesDisponibles = [
    Adicional(
      nombre: 'Queso Extra',
      precio: 3.0,
      icono: '🧀',
    ),
    //Adicional(
    //  nombre: 'Doble Carne',
    //  precio: 5.0,
    //  icono: '🥩',
   // ),
    //Adicional(
    //  nombre: 'Champiñones',
    //  precio: 4.0,
    //  icono: '🍄',
    //),
    //Adicional(
    //  nombre: 'Aceitunas',
    //  precio: 3.0,
    //  icono: '🫒',
    //),
    //Adicional(
    //  nombre: 'Pepperoni Extra',
    //  precio: 4.0,
    //  icono: '🌶️',
    //),
  ];
}